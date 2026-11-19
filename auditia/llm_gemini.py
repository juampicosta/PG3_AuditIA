"""AuditIA · Cliente de Gemini (API de Google AI Studio) con la misma interfaz que ClienteOllama.

Se activa con LLM_PROVEEDOR=gemini en .env (por defecto sigue Ollama local). Variables:
  GEMINI_API_KEY   clave gratuita de https://aistudio.google.com/apikey (sin tarjeta)
  GEMINI_MODEL     modelo a usar (por defecto gemini-flash-latest; alternativa con más cupo: gemini-flash-lite-latest)
  GEMINI_RPM       opcional: pedidos por minuto máximos (espacia las llamadas para no chocar con el límite gratuito)

Interfaz idéntica a ClienteOllama: chat(sistema, usuario, temperatura, formato, max_tokens) -> (texto, meta) y
modelos_disponibles(). El LLM sigue cumpliendo el mismo papel: las conclusiones las calcula Neo4j con las reglas.

Robustez:
  - 429/500/503/504 y cortes de red: reintenta con espera (respeta el retryDelay que informa Google).
  - Cupo diario agotado: falla enseguida con un mensaje claro (reintentar no sirve).
  - Si el modelo rechaza la configuración de razonamiento o el esquema JSON, se reintenta sin ese parámetro
    (el esquema pasa al prompt de sistema) y se recuerda para las llamadas siguientes.
Solo biblioteca estándar.
"""
from __future__ import annotations

import json
import os
import re
import threading
import time
import urllib.error
import urllib.request
from typing import Any

URL_BASE = "https://generativelanguage.googleapis.com/v1beta"
MODELO_POR_DEFECTO = "gemini-flash-latest"
MARGEN_TOKENS = 1024   # el razonamiento interno de Gemini consume tokens de salida: se suma este margen al tope


def proveedor() -> str:
    return (os.environ.get("LLM_PROVEEDOR") or "ollama").strip().lower()


def usa_gemini() -> bool:
    return proveedor() == "gemini"


def modelo_gemini() -> str:
    return (os.environ.get("GEMINI_MODEL") or "").strip() or MODELO_POR_DEFECTO


class _Rechazo(Exception):
    """Error 400 de la API (parámetro no admitido por el modelo)."""

    def __init__(self, mensaje: str):
        super().__init__(mensaje)
        self.mensaje = mensaje


# Ritmo compartido entre todos los clientes del proceso (orquestador, submódulos e ingesta usan la misma cuota).
_candado_ritmo = threading.Lock()
_ultimo_pedido = [0.0]
# Ajustes aprendidos por modelo (si rechazó thinkingConfig o el esquema, no se vuelve a mandar).
_ajustes: dict[str, set[str]] = {}


def _esperar_turno() -> None:
    rpm = os.environ.get("GEMINI_RPM", "").strip()
    if not rpm:
        return
    try:
        intervalo = 60.0 / max(float(rpm), 0.1)
    except ValueError:
        return
    with _candado_ritmo:
        espera = _ultimo_pedido[0] + intervalo - time.monotonic()
        if espera > 0:
            time.sleep(espera)
        _ultimo_pedido[0] = time.monotonic()


def _segundos_reintento(detalle: dict) -> float | None:
    for d in (detalle.get("error", {}) or {}).get("details", []) or []:
        if str(d.get("@type", "")).endswith("RetryInfo"):
            m = re.match(r"([\d.]+)s", str(d.get("retryDelay", "")))
            if m:
                return float(m.group(1))
    return None


def _es_cupo_diario(texto: str) -> bool:
    t = texto.lower()
    return "perday" in t or "per_day" in t or "requests per day" in t


def _reparar_escapes(texto: str) -> str:
    """Gemini (sobre todo flash-lite en modo JSON) a veces escribe «ñ» como «\\u0025u00f1», que se decodifica
    como el texto «%u00f1». Se restituye el carácter; solo los no ASCII, para no tocar comillas ni barras del JSON."""
    texto = re.sub(r"\\u0025u([0-9a-fA-F]{4})", r"\\u\1", texto)
    return re.sub(r"%u([0-9a-fA-F]{4})", lambda m: chr(int(m[1], 16)) if int(m[1], 16) >= 0x80 else m[0], texto)


class ClienteGemini:
    def __init__(self, cfg: Any = None, error_cls: type[Exception] = RuntimeError, timeout_s: int | None = None):
        self.cfg = cfg
        self.error = error_cls
        self.modelo = modelo_gemini()
        self.clave = (os.environ.get("GEMINI_API_KEY") or "").strip()
        self.timeout_s = timeout_s or getattr(cfg, "timeout_s", None) or 300
        self.semilla = getattr(cfg, "semilla", 42)
        self.max_reintentos = int(os.environ.get("GEMINI_REINTENTOS", "6"))

    # -- HTTP ----------------------------------------------------------------------------------------
    def _pedir(self, metodo: str, ruta: str, cuerpo: dict | None = None, timeout: int | None = None) -> dict:
        if not self.clave:
            raise self.error("Falta GEMINI_API_KEY en .env (se obtiene gratis en https://aistudio.google.com/apikey).")
        datos = json.dumps(cuerpo).encode("utf-8") if cuerpo is not None else None
        intento = 0
        while True:
            intento += 1
            req = urllib.request.Request(URL_BASE + ruta, data=datos, method=metodo,
                                         headers={"Content-Type": "application/json", "x-goog-api-key": self.clave})
            if metodo == "POST":
                _esperar_turno()
            try:
                with urllib.request.urlopen(req, timeout=timeout or self.timeout_s) as resp:
                    return json.loads(resp.read().decode("utf-8"))
            except urllib.error.HTTPError as e:
                crudo = e.read().decode("utf-8", "replace")
                try:
                    detalle = json.loads(crudo)
                except ValueError:
                    detalle = {}
                mensaje = (detalle.get("error", {}) or {}).get("message") or crudo[:300]
                if e.code == 400:
                    raise _Rechazo(mensaje) from e
                if e.code in (401, 403):
                    raise self.error(f"Gemini rechazó la clave ({e.code}): revisá GEMINI_API_KEY en .env. {mensaje[:200]}") from e
                if e.code == 404:
                    raise self.error(f"Gemini no encuentra el modelo '{self.modelo}': revisá GEMINI_MODEL en .env. "
                                     f"{mensaje[:200]}") from e
                if e.code == 429 and _es_cupo_diario(crudo):
                    raise self.error(f"Se agotó el cupo gratuito diario de Gemini para {self.modelo}. Probá mañana o "
                                     f"cambiá GEMINI_MODEL (por ejemplo gemini-flash-lite-latest).") from e
                if e.code in (429, 500, 502, 503, 504) and intento <= self.max_reintentos:
                    espera = _segundos_reintento(detalle) or min(2 ** intento, 60)
                    time.sleep(min(espera + 1, 90))
                    continue
                raise self.error(f"Gemini respondió {e.code}: {mensaje[:300]}") from e
            except (urllib.error.URLError, TimeoutError, ConnectionError) as e:
                if intento <= min(self.max_reintentos, 3):
                    time.sleep(2 ** intento)
                    continue
                raise self.error(f"No se pudo contactar a Gemini: {e}") from e

    # -- interfaz común ------------------------------------------------------------------------------
    def modelos_disponibles(self) -> list[str]:
        """Comprueba clave y modelo (GET del modelo configurado). Devuelve [modelo] si existe."""
        try:
            self._pedir("GET", f"/models/{self.modelo}", timeout=15)
        except _Rechazo as e:
            raise self.error(f"Gemini rechazó el pedido: {e.mensaje[:300]}") from e
        return [self.modelo]

    def _config_razonamiento(self) -> dict:
        m = self.modelo.lower()
        if "2.5" in m:
            return {"thinkingBudget": 128 if "pro" in m else 0}
        return {"thinkingLevel": "low"}

    def chat(self, sistema: str, usuario: str, temperatura: float, formato: Any = None,
             max_tokens: int = 700) -> tuple[str, dict]:
        ajustes = _ajustes.setdefault(self.modelo, set())
        t0 = time.perf_counter()
        for _ in range(3):
            sistema_final = sistema
            config: dict[str, Any] = {"temperature": temperatura, "seed": self.semilla,
                                      "maxOutputTokens": max_tokens + MARGEN_TOKENS}
            if formato is not None:
                config["responseMimeType"] = "application/json"
                if isinstance(formato, dict):
                    if "esquema_en_prompt" in ajustes:
                        sistema_final = (sistema + "\n\nRespondé únicamente con un objeto JSON válido que cumpla este "
                                         "esquema JSON (sin texto adicional):\n" + json.dumps(formato, ensure_ascii=False))
                    else:
                        config["responseJsonSchema"] = formato
            if "sin_razonamiento_cfg" not in ajustes:
                config["thinkingConfig"] = self._config_razonamiento()
            cuerpo = {"systemInstruction": {"parts": [{"text": sistema_final}]},
                      "contents": [{"role": "user", "parts": [{"text": usuario}]}],
                      "generationConfig": config}
            try:
                resp = self._pedir("POST", f"/models/{self.modelo}:generateContent", cuerpo)
                break
            except _Rechazo as e:
                msg = e.mensaje.lower()
                if "thinking" in msg and "sin_razonamiento_cfg" not in ajustes:
                    ajustes.add("sin_razonamiento_cfg")
                    continue
                if ("schema" in msg or "response_json" in msg) and "esquema_en_prompt" not in ajustes \
                        and isinstance(formato, dict):
                    ajustes.add("esquema_en_prompt")
                    continue
                raise self.error(f"Gemini rechazó el pedido: {e.mensaje[:300]}") from e
        else:
            raise self.error("Gemini rechazó el pedido con todas las configuraciones probadas.")

        candidatos = resp.get("candidates") or []
        if not candidatos:
            motivo = (resp.get("promptFeedback") or {}).get("blockReason", "sin candidatos")
            raise self.error(f"Gemini no devolvió respuesta ({motivo}).")
        partes = (candidatos[0].get("content") or {}).get("parts") or []
        texto = "".join(p.get("text", "") for p in partes if not p.get("thought")).strip()
        if formato is not None:
            texto = re.sub(r"^```(?:json)?\s*|\s*```$", "", texto)
        texto = _reparar_escapes(texto)
        if not texto:
            raise self.error(f"Gemini devolvió una respuesta vacía (finishReason={candidatos[0].get('finishReason')}).")
        uso = resp.get("usageMetadata") or {}
        meta = {"modelo": resp.get("modelVersion") or self.modelo, "proveedor": "gemini",
                "segundos": round(time.perf_counter() - t0, 2),
                "tokens_entrada": uso.get("promptTokenCount"), "tokens_salida": uso.get("candidatesTokenCount")}
        return texto, meta
