"""AuditIA · PG3 v1.3 · Análisis de requerimientos nuevos (ingesta).

Cierra el paso que en PG2 se hacía a mano: pasar del texto de un requerimiento a las premisas que usan las reglas.

  1. PROPONER   El LLM (o, sin LLM, un analizador léxico determinístico) lee el texto y propone premisas por criterio
                (SM1), por par comparado (SM2) y el contexto de priorización (SM3), citando fragmentos literales.
  2. CONFIRMAR  El analista revisa y corrige las premisas en la miniapp. Nada se escribe sin su confirmación
                (valoracion_confirmada = true), igual que en los casos construidos de PG2.
  3. INFERIR    Se escriben los nodos del caso en Neo4j y se ejecutan las MISMAS reglas: 08_inferencia_casos_nuevos.cypher
                (generalización de 03 con IDs derivados del caso), 04_difusa.cypher acotado al lote y 06_informes.cypher.
  4. CONSULTAR  El caso queda en el grafo: SM1, SM2, SM3 y el orquestador lo responden como a cualquier otro.

El LLM nunca decide estados, prioridades ni grados: solo propone premisas que el analista confirma (GL05).
"""
from __future__ import annotations

import json
import os
import re
import time
import unicodedata
import urllib.error
import urllib.request
from copy import deepcopy
from pathlib import Path
from typing import Any, Callable

from .config import RAIZ, ConfigGeneral
from .llm_gemini import ClienteGemini, usa_gemini

DIR_SCRIPTS = RAIZ / "base_conocimiento" / "scripts"
DIR_PROMPTS = Path(__file__).resolve().parent / "prompts"
VERSION_INGESTA = "PG3-1.3"

CRITERIOS = ["atomicidad", "ambiguedad", "verificabilidad", "completitud"]
CODIGO_CRITERIO = {"atomicidad": "ATO", "ambiguedad": "AMB", "verificabilidad": "VER", "completitud": "COM"}
SEVERIDADES = ("baja", "media", "alta")
CRITICIDADES = ("baja", "media", "alta")
ESCENARIOS = ("coincidentes", "parciales", "excluyentes")

# Reglas catalogadas en PG1 que este flujo pone en ejecución (texto literal del catálogo de PG1 §6.4 y §6.5).
REGLAS_NUEVAS = {
    "EVI-HC01": "SI hay dos o más obligaciones aceptables por separado y no se confirma una unidad de aceptación ENTONCES atomicidad incumple.",
    "EVI-HC03": "SI una aceptación o referencia accesible elimina las alternativas de un aspecto ENTONCES ese aspecto queda resuelto.",
    "EVI-HC05": "SI con información aplicable identificada se demuestra al menos una omisión indispensable ENTONCES completitud incumple.",
    "EVI-HC06": "SI acciones o condiciones forman una única unidad de aceptación ENTONCES se registra excepción de atomicidad.",
    "EVI-HC07": "SI se demuestra que el método y contexto fijados no discriminan cumplimiento ENTONCES verificabilidad incumple.",
    "ACC-RD04": "SI una excepción o precedencia explícita concilia el par ENTONCES sin hallazgo por contradicción.",
    "ACC-RD06": "SI el solapamiento es parcial con región común definida e incompatible ENTONCES Hallazgo(contradiccion_en_region).",
    "ACC-RD18": "SI los escenarios coinciden y los resultados pueden satisfacerse a la vez ENTONCES sin hallazgo.",
    "ACC-RD19": "SI hay región común definida y los resultados coexisten ENTONCES sin hallazgo en esa región.",
}

# Severidad base candidata por tipo de defecto (EVI-HC11 / ACC-HC04). El analista la puede cambiar o dejar en null.
SEVERIDAD_BASE = {"ambiguedad": ("media", 5.0), "atomicidad": ("baja", 3.0), "verificabilidad": ("media", 5.0),
                  "completitud": ("media", 6.0), "comparacion": ("alta", 9.0)}
GRADO_CRITICIDAD = {"baja": 2.0, "media": 5.0, "alta": 9.0}


class ErrorIngesta(Exception):
    pass


# ============================================================================================
# 1. Analizador léxico determinístico (borrador rápido y respaldo del LLM)
# ============================================================================================
def _sin_tildes(texto: str) -> str:
    return "".join(c for c in unicodedata.normalize("NFD", texto) if unicodedata.category(c) != "Mn")


_VAGOS = [
    r"r[aá]pid[oa]s?", r"r[aá]pidamente", r"[aá]gil(?:es|mente)?", r"eficien(?:te|tes|temente)", r"f[aá]cil(?:es|mente)?",
    r"sencill[oa]s?", r"intuitiv[oa]s?", r"amigable(?:s)?", r"adecuad[oa]s?(?:mente)?", r"apropiad[oa]s?(?:mente)?",
    r"suficientes?(?:mente)?", r"razonables?(?:mente)?", r"[oó]ptim[oa]s?", r"flexibles?", r"robust[oa]s?",
    r"moderno?s?", r"aproximadamente", r"varios", r"varias", r"algun[oa]s", r"lo antes posible", r"en lo posible",
    r"normalmente", r"en tiempo real", r"alta disponibilidad", r"buen rendimiento", r"user[- ]friendly", r"c[oó]mod[oa]s?",
    r"claramente", r"correctamente", r"oportun[oa]s?(?:mente)?", r"pronto", r"agradables?", r"atractiv[oa]s?",
    r"seguro de usar", r"m[ií]nimo posible", r"lo m[aá]s", r"peque[nñ][oa]s?", r"grandes?", r"muchos?", r"pocos?",
]
_PATRON_VAGO = re.compile(r"\b(" + "|".join(_VAGOS) + r")\b", re.IGNORECASE)
_PATRON_MEDIBLE = re.compile(
    r"(?:(?:como\s+m[aá]ximo|como\s+m[ií]nimo|no\s+m[aá]s\s+de|al\s+menos|menos\s+de|m[aá]s\s+de|hasta|en|dentro\s+de|"
    r"inferior\s+a|superior\s+a|menor\s+a|mayor\s+a)\s+)?\d+(?:[.,]\d+)?\s*"
    r"(?:ms|milisegundos?|s\b|seg(?:undos?)?|minutos?|min\b|horas?|h\b|d[ií]as?|%|por\s+ciento|usuarios?|"
    r"intentos?|caracteres|mb|gb|kb|registros?|transacciones?|solicitudes?|peticiones?|veces)",
    re.IGNORECASE)
_PATRON_FORMATO = re.compile(r"\b(?:formato|en)\s+(?:pdf|csv|xlsx|json|xml|docx)\b", re.IGNORECASE)
_PATRON_ABIERTO = re.compile(r"\b(etc\.?|entre otr[oa]s|y dem[aá]s|u otr[oa]s|a definir|por definir|tbd|seg[uú]n corresponda|"
                             r"y similares|o similares)\b|\.\.\.", re.IGNORECASE)
_PATRON_MODAL = re.compile(r"\b(debe(?:r[aá])?|deber[aá]n|tiene que|tendr[aá] que|permitir[aá]?|permite|ha de|se debe|"
                           r"no debe(?:r[aá])?|no podr[aá]|podr[aá])\b", re.IGNORECASE)
_NO_VERBOS = {"lugar", "mejor", "mayor", "menor", "anterior", "posterior", "particular", "regular", "popular", "similar",
              "familiar", "militar", "solar", "titular", "valor", "color", "error", "exterior", "interior", "superior",
              "inferior", "par", "mar", "bar", "ser", "estar", "car", "per", "ver", "hogar", "nivel", "por", "sir", "dolar",
              "dólar", "auxiliar", "escolar", "celular", "modular", "tabular", "circular", "lunar", "polar", "nuclear",
              "vehicular", "singular", "estelar", "molecular", "secular", "cliente", "taller", "alquiler", "mujer",
              "placer", "poder", "deber", "saber", "ayer", "cualquier", "primer", "tercer", "tener", "haber"}
_PATRON_INFINITIVO = re.compile(r"\b([a-záéíóúñ]{3,}(?:ar|er|ir))(?:se|lo|la|los|las|le|les)?\b", re.IGNORECASE)
_PATRON_EXCEPCION = re.compile(r"\b(salvo|excepto|a menos que|con excepci[oó]n|prevalece|tiene prioridad|prima sobre)\b",
                               re.IGNORECASE)
_PATRON_NEGACION = re.compile(r"\b(no|nunca|ning[uú]n[oa]?|sin|prohib\w*|jam[aá]s|ni)\b", re.IGNORECASE)
_PATRON_CONDICION = re.compile(r"\b(?:cuando|al|si|durante|antes de|despu[eé]s de|en (?:el|la|los|las|cada)|para (?:el|la|cada))\b"
                               r"([^,.;]{3,80})", re.IGNORECASE)
_PATRON_CONDICION_INICIAL = re.compile(r"^\s*(?:en|para|durante|cuando|si|al)\s+(?:un|una|el|la|los|las|cada|todo|toda)?\s*[^,.;]{3,60}?(?=,|\s+(?:se|el|la|los|las)\s+(?:debe|deber[aá]|tiene|podr[aá]|permit)|\s+(?:se\s+)?debe)", re.IGNORECASE)
_STOP = {"el", "la", "los", "las", "un", "una", "unos", "unas", "de", "del", "al", "a", "en", "y", "o", "que", "se", "por",
         "para", "con", "su", "sus", "debe", "deberá", "debera", "sistema", "es", "ser", "lo", "le", "les", "como", "cada",
         "todo", "toda", "todos", "todas", "este", "esta", "esto", "ese", "esa", "sobre", "entre", "sin", "no", "mas", "más"}


def raices(texto: str) -> set[str]:
    palabras = re.findall(r"[a-záéíóúñü]{3,}", (texto or "").lower())
    return {_sin_tildes(p)[:5] for p in palabras if p not in _STOP and _sin_tildes(p) not in _STOP}


def _clausula_modal(texto: str) -> str:
    m = _PATRON_MODAL.search(texto)
    return texto[m.end():] if m else texto


def _infinitivos(fragmento: str) -> list[str]:
    vistos: list[str] = []
    for m in _PATRON_INFINITIVO.finditer(fragmento):
        palabra = m.group(1).lower()
        if palabra in _NO_VERBOS or _sin_tildes(palabra) in _NO_VERBOS:
            continue
        if palabra not in vistos:
            vistos.append(palabra)
    return vistos


def extraer_heuristico(texto: str, contexto: str = "") -> dict:
    """Mismo esquema de salida que el LLM, obtenido con patrones léxicos (reproducible, sin red)."""
    texto = (texto or "").strip()
    clausula = _clausula_modal(texto)
    verbos = _infinitivos(clausula)
    # Obligaciones independientes: verbos coordinados en la cláusula modal ("registrar ... y notificar ...").
    partes = [p.strip() for p in re.split(r",\s*|\s+y\s+(?=[a-záéíóúñ]+(?:ar|er|ir)(?:se|lo|la|los|las|le|les)?\b)|\s+as[ií] como\s+|"
                                           r"\s+adem[aá]s de\s+|\s+e\s+(?=[a-záéíóúñ]+(?:ar|er|ir)\b)", clausula) if p.strip()]
    obligaciones = [p for p in partes if _infinitivos(p)] or [clausula.strip(" .")]
    if len(verbos) <= 1:
        obligaciones = [clausula.strip(" .")]
    vagos = list(dict.fromkeys(m.group(1) for m in _PATRON_VAGO.finditer(texto)))
    medible_txt = _PATRON_MEDIBLE.search(texto) or _PATRON_FORMATO.search(texto)
    medible_ctx = _PATRON_MEDIBLE.search(contexto or "") or _PATRON_FORMATO.search(contexto or "")
    medible = medible_txt.group(0) if medible_txt else (medible_ctx.group(0) if medible_ctx else "")
    abiertos = list(dict.fromkeys(m.group(0) for m in _PATRON_ABIERTO.finditer(texto)))
    sujeto = texto[:_PATRON_MODAL.search(texto).start()].strip(" ,") if _PATRON_MODAL.search(texto) else "El sistema"
    accion = verbos[0] if verbos else ""
    objeto = ""
    if accion:
        resto = clausula[clausula.lower().find(accion) + len(accion):]
        objeto = re.split(r"[,.;]|\s+y\s+|\s+cuando\s+|\s+si\s+|\s+al\s+", resto.strip(), maxsplit=1)[0].strip()
    cond = _PATRON_CONDICION_INICIAL.search(texto) or _PATRON_CONDICION.search(texto)
    if vagos:
        termino = vagos[0]
        lecturas = [f"Se aprueba si el resultado se percibe como «{termino}» por quien lo usa.",
                    f"Se aprueba solo si «{termino}» se mide contra un umbral acordado"
                    + (f" ({medible})." if medible else " que el texto no fija.")]
    else:
        lecturas = ["Lectura única: la obligación se aprueba comprobando el resultado descrito."]
    omisiones = [f"Enumeración o valor abierto: «{a}»" for a in abiertos]
    return {
        "sujeto": sujeto or "El sistema", "accion": accion, "objeto": objeto, "resultado": objeto,
        "condicion": cond.group(0).strip() if cond else "",
        "obligaciones": obligaciones, "unidad_aceptacion_unica": len(obligaciones) <= 1,
        "terminos_vagos": vagos, "lecturas": lecturas, "criterio_medible": medible, "omisiones": omisiones,
        "justificacion": "Borrador léxico: " + ", ".join(filter(None, [
            f"{len(obligaciones)} obligación(es)", f"términos vagos: {', '.join(vagos)}" if vagos else "sin términos vagos",
            f"criterio medible: {medible}" if medible else "sin criterio medible",
            f"enumeración abierta: {', '.join(abiertos)}" if abiertos else ""])) + ".",
    }


def _palabras_comunes(texto: str, raices_comunes: set[str]) -> str:
    vistas = []
    for p in re.findall(r"[a-záéíóúñü]{3,}", texto.lower()):
        if _sin_tildes(p)[:5] in raices_comunes and p not in vistas and p not in _STOP:
            vistas.append(p)
    return " ".join(vistas)[:120]


def comparar_heuristico(ext_a: dict, ext_b: dict, texto_a: str, texto_b: str) -> dict:
    comunes = raices(" ".join([ext_a.get("objeto", ""), ext_a.get("condicion", ""), texto_a])) & \
        raices(" ".join([ext_b.get("objeto", ""), ext_b.get("condicion", ""), texto_b]))
    base = min(len(raices(texto_a)), len(raices(texto_b))) or 1
    solape = len(comunes) / base
    neg_a, neg_b = bool(_PATRON_NEGACION.search(texto_a)), bool(_PATRON_NEGACION.search(texto_b))
    nums_a = set(re.findall(r"\d+(?:[.,]\d+)?", texto_a))
    nums_b = set(re.findall(r"\d+(?:[.,]\d+)?", texto_b))
    incompatibles = (neg_a != neg_b) or (bool(nums_a) and bool(nums_b) and nums_a != nums_b)
    cond_a, cond_b = ext_a.get("condicion", ""), ext_b.get("condicion", "")
    if solape >= 0.4:
        escenarios = "coincidentes" if (not cond_a or not cond_b or raices(cond_a) & raices(cond_b)) else "parciales"
    elif solape >= 0.2:
        escenarios = "parciales"
    else:
        escenarios = "excluyentes"
    excepcion = bool(_PATRON_EXCEPCION.search(texto_a) or _PATRON_EXCEPCION.search(texto_b))
    return {
        "escenarios": escenarios,
        "region_comun": _palabras_comunes(texto_a, comunes) if escenarios != "excluyentes" else "",
        "resultados_incompatibles": bool(incompatibles and escenarios != "excluyentes"),
        "excepcion_explicita": excepcion,
        "solapamiento": round(solape, 2),
        "justificacion": f"Borrador léxico: solapamiento de términos {solape:.0%}; "
                         + ("polaridad o valores distintos." if incompatibles else "resultados compatibles."),
    }


# ============================================================================================
# 2. Extracción con el LLM (Ollama, temperatura 0, semilla 42, salida JSON con esquema)
# ============================================================================================
LOTE_LLM = 4                     # requerimientos por llamada: respuestas cortas, sin pasar el tope de tiempo
_ESQ_RQ = {
    "type": "object",
    "properties": {
        "n": {"type": "integer"}, "accion": {"type": "string"}, "objeto": {"type": "string"},
        "condicion": {"type": "string"},
        "obligaciones": {"type": "array", "items": {"type": "string"}},
        "una_sola_prueba": {"type": "boolean"},
        "vagos": {"type": "array", "items": {"type": "string"}},
        "medible": {"type": "string"},
        "faltantes": {"type": "array", "items": {"type": "string"}},
    },
    "required": ["n", "accion", "objeto", "condicion", "obligaciones", "una_sola_prueba", "vagos", "medible", "faltantes"],
}
ESQUEMA_LLM = {"type": "object", "properties": {"requerimientos": {"type": "array", "items": _ESQ_RQ}},
               "required": ["requerimientos"]}
ESQUEMA_PARES = {
    "type": "object",
    "properties": {"pares": {"type": "array", "items": {
        "type": "object",
        "properties": {"par": {"type": "integer"}, "escenarios": {"type": "string", "enum": list(ESCENARIOS)},
                       "incompatibles": {"type": "boolean"}, "excepcion": {"type": "boolean"}, "region": {"type": "string"}},
        "required": ["par", "escenarios", "incompatibles", "excepcion", "region"]}}},
    "required": ["pares"],
}


def modelo_ingesta(cfg: ConfigGeneral) -> str:
    """OLLAMA_MODEL_INGESTA permite leer documentos con un modelo más chico (p. ej. qwen2.5:3b) sin cambiar el del asistente."""
    return os.environ.get("OLLAMA_MODEL_INGESTA") or cfg.modelo


def _llm_chat(cfg: ConfigGeneral, sistema: str, usuario: str, esquema: dict, max_tokens: int = 700,
              timeout: int = 900) -> tuple[str, dict]:
    if usa_gemini():   # LLM_PROVEEDOR=gemini: misma llamada (temperatura 0, JSON con esquema) contra la API de Gemini
        return ClienteGemini(None, ErrorIngesta, timeout_s=timeout).chat(sistema, usuario, 0.0, esquema, max_tokens)
    cuerpo: dict[str, Any] = {
        "model": modelo_ingesta(cfg), "stream": False, "keep_alive": "15m", "format": esquema,
        "messages": [{"role": "system", "content": sistema}, {"role": "user", "content": usuario}],
        "options": {"temperature": 0.0, "seed": 42, "num_ctx": 4096, "num_predict": max_tokens},
    }
    if cfg.hilos:
        cuerpo["options"]["num_thread"] = cfg.hilos
    req = urllib.request.Request(cfg.ollama_url.rstrip("/") + "/api/chat", data=json.dumps(cuerpo).encode("utf-8"),
                                 headers={"Content-Type": "application/json"})
    t0 = time.perf_counter()
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            datos = json.loads(resp.read().decode("utf-8"))
    except (urllib.error.URLError, TimeoutError, ConnectionError) as e:
        raise ErrorIngesta(f"No se pudo usar Ollama en {cfg.ollama_url}: {e}") from e
    meta = {"modelo": datos.get("model", cfg.modelo), "segundos": round(time.perf_counter() - t0, 1),
            "tokens_entrada": datos.get("prompt_eval_count"), "tokens_salida": datos.get("eval_count")}
    return datos.get("message", {}).get("content", ""), meta


def _sistema() -> str:
    return (DIR_PROMPTS / "system_prompt_ingesta.txt").read_text(encoding="utf-8")


def _desde_compacto(c: dict, texto: str, contexto: str) -> dict:
    """Formato compacto del LLM → mismo esquema que el analizador léxico (las lecturas se derivan sin LLM)."""
    base = extraer_heuristico(texto, contexto)
    vagos = [v for v in (c.get("vagos") or []) if isinstance(v, str) and v.strip()]
    medible = (c.get("medible") or "").strip()
    obligaciones = [o for o in (c.get("obligaciones") or []) if isinstance(o, str) and o.strip()] or [texto]
    if vagos:
        lecturas = [f"Se aprueba si el resultado se percibe como «{vagos[0]}» por quien lo usa.",
                    f"Se aprueba solo si «{vagos[0]}» se mide contra un umbral acordado"
                    + (f" ({medible})." if medible else " que el texto no fija.")]
    else:
        lecturas = ["Lectura única: la obligación se aprueba comprobando el resultado descrito."]
    return {
        "sujeto": base["sujeto"], "accion": (c.get("accion") or base["accion"]).strip(),
        "objeto": (c.get("objeto") or base["objeto"]).strip(), "resultado": (c.get("objeto") or base["resultado"]).strip(),
        "condicion": (c.get("condicion") or "").strip(), "obligaciones": obligaciones,
        "unidad_aceptacion_unica": bool(c.get("una_sola_prueba", len(obligaciones) <= 1)),
        "terminos_vagos": vagos, "lecturas": lecturas, "criterio_medible": medible,
        "omisiones": [o for o in (c.get("faltantes") or []) if isinstance(o, str) and o.strip()],
        "justificacion": "Lectura del LLM.",
    }


def extraer_llm(cfg: ConfigGeneral, textos: list[str], contexto: str) -> tuple[list[dict], dict]:
    """Un lote de hasta LOTE_LLM requerimientos en una llamada con salida compacta."""
    partes = [f"{i + 1}. {t}" for i, t in enumerate(textos)]
    if contexto.strip():
        partes.append(f"Contexto del analista: {contexto.strip()}")
    partes.append(f"Devolvé {len(textos)} elemento(s) en 'requerimientos', con n = 1..{len(textos)} en el mismo orden.")
    crudo, meta = _llm_chat(cfg, _sistema(), "\n".join(partes), ESQUEMA_LLM, max_tokens=160 * len(textos) + 80)
    try:
        lista = json.loads(crudo)["requerimientos"]
    except (json.JSONDecodeError, KeyError, TypeError) as e:
        raise ErrorIngesta(f"El LLM no devolvió JSON válido: {crudo[:160]}") from e
    if len(lista) != len(textos):
        raise ErrorIngesta(f"El LLM devolvió {len(lista)} elementos para {len(textos)} requerimientos.")
    meta["respuesta_cruda"] = crudo
    return [_desde_compacto(c, textos[i], contexto) for i, c in enumerate(lista)], meta


def comparar_llm(cfg: ConfigGeneral, pares: list[tuple[str, str]]) -> tuple[list[dict], dict]:
    partes = [f"Par {k + 1}:\n  A: {a}\n  B: {b}" for k, (a, b) in enumerate(pares)]
    partes.append(f"Compará cada par y devolvé {len(pares)} elemento(s) en 'pares', con par = 1..{len(pares)}.")
    crudo, meta = _llm_chat(cfg, _sistema(), "\n".join(partes), ESQUEMA_PARES, max_tokens=60 * len(pares) + 60)
    try:
        lista = json.loads(crudo)["pares"]
    except (json.JSONDecodeError, KeyError, TypeError) as e:
        raise ErrorIngesta(f"El LLM no devolvió JSON válido al comparar: {crudo[:160]}") from e
    if len(lista) != len(pares):
        raise ErrorIngesta("El LLM no devolvió un resultado por par.")
    salida = [{"escenarios": c.get("escenarios") if c.get("escenarios") in ESCENARIOS else "excluyentes",
               "region_comun": (c.get("region") or "").strip(), "resultados_incompatibles": bool(c.get("incompatibles")),
               "excepcion_explicita": bool(c.get("excepcion")), "justificacion": "Comparación leída por el LLM."}
              for c in lista]
    return salida, meta


def _fiel(fragmento: str, texto: str) -> bool:
    """GL05: un término que el LLM dice citar debe aparecer en el texto (comparación sin tildes ni mayúsculas)."""
    return _sin_tildes(fragmento.lower()).strip(" «»\"'") in _sin_tildes(texto.lower())


def controlar_extraccion(ext: dict, texto: str, contexto: str) -> list[str]:
    """Descarta del LLM los fragmentos que no figuran en el texto (no se aceptan citas inventadas)."""
    avisos = []
    vagos = [v for v in ext.get("terminos_vagos", []) if v and _fiel(v, texto)]
    if len(vagos) != len(ext.get("terminos_vagos", [])):
        avisos.append("Se descartaron términos vagos que no figuran literalmente en el texto (GL05).")
    ext["terminos_vagos"] = vagos
    medible = ext.get("criterio_medible", "") or ""
    if medible and not (_fiel(medible, texto) or _fiel(medible, contexto)):
        avisos.append(f"Se descartó el criterio medible «{medible}»: no figura en el texto ni en el contexto (GL05).")
        ext["criterio_medible"] = ""
    if not ext.get("obligaciones"):
        ext["obligaciones"] = [texto]
    return avisos


# ============================================================================================
# 3. De la extracción a las premisas de las reglas (determinístico)
# ============================================================================================
def premisas_requerimiento(ext: dict, texto: str, contexto: str = "") -> dict:
    vagos = ext.get("terminos_vagos") or []
    medible = ext.get("criterio_medible") or ""
    n_obl = max(1, len(ext.get("obligaciones") or [texto]))
    unidad = bool(ext.get("unidad_aceptacion_unica", n_obl == 1))
    omisiones = ext.get("omisiones") or []
    lecturas = ext.get("lecturas") or []
    hay_vago = bool(vagos)
    comun = {"revision_semantica_completa": True, "info_necesaria_identificada": True, "info_disponible": True,
             "contexto_suficiente": True}
    sev = {c: SEVERIDAD_BASE[c] for c in CRITERIOS}
    criterios = {
        "atomicidad": {**comun, "obligaciones_independientes": n_obl, "unidad_aceptacion_confirmada": unidad if n_obl > 1 else True,
                       "justificacion": (f"{n_obl} obligaciones aceptables por separado: " + "; ".join(ext.get("obligaciones", [])[:4])
                                         if n_obl > 1 else "Una obligación evaluable con unidad de aceptación."),
                       "fragmentos": ext.get("obligaciones", [])[:4]},
        "ambiguedad": {**comun, "lecturas_residuales": 2 if hay_vago else 1,
                       "delimitacion_confirmada": bool(medible) if hay_vago else True,
                       "aceptacion_delimita": bool(medible) if hay_vago else False,
                       "divergencia_lecturas": 8.5 if hay_vago and not medible else (5.0 if hay_vago else 1.5),
                       "delimitacion_contexto": 1.0 if hay_vago and not medible else 8.5,
                       "lecturas": lecturas[:3],
                       "justificacion": (f"Persisten dos lecturas por «{vagos[0]}»"
                                         + (f"; el criterio «{medible}» las delimita." if medible else "; ningún criterio las delimita.")
                                         if hay_vago else "Queda una sola lectura relevante tras revisar el alcance."),
                       "fragmentos": vagos[:4]},
        "verificabilidad": {**comun, "aceptacion_necesaria": not bool(medible) and hay_vago,
                            "aceptacion_disponible": bool(medible) or not hay_vago,
                            "comprobacion_definida": bool(medible) or not hay_vago, "metodo_discrimina": True,
                            "metodo": medible or ("Prueba funcional observable del resultado descrito" if not hay_vago else ""),
                            "justificacion": (f"La condición «{medible}» fija una aprobación observable." if medible else
                                              "La aceptación necesaria no fue recibida; no se puede fijar una condición de aprobación."
                                              if hay_vago else "El resultado descrito se comprueba con una prueba funcional observable."),
                            "fragmentos": [medible] if medible else []},
        "completitud": {**comun, "informacion_aplicable_identificada": True, "omisiones_demostradas": len(omisiones),
                        "omisiones": omisiones[:4],
                        "justificacion": ("Omisión indispensable: " + "; ".join(omisiones[:3]) if omisiones else
                                          "La información aplicable está identificada y no hay omisiones demostradas."),
                        "fragmentos": omisiones[:4]},
    }
    for c in CRITERIOS:
        criterios[c]["severidad_propuesta"], criterios[c]["puntuacion_severidad_propuesta"] = sev[c]
    return {
        "obligacion": {"sujeto": ext.get("sujeto") or "El sistema", "accion": ext.get("accion") or "",
                       "objeto": ext.get("objeto") or "", "resultado": ext.get("resultado") or ext.get("objeto") or "",
                       "modalidad": "obligacion"},
        "escenario": {"actor": ext.get("sujeto") or "El sistema", "objeto": ext.get("objeto") or "",
                      "estado": ext.get("condicion") or "sin condición declarada"},
        "criterios": criterios,
        "prioridad": {"criticidad_valor": None, "grado_criticidad": None, "fundamento_criticidad": "",
                      "obligacion_esencial_indefinida": False, "bloqueo_sustantivo_confirmado": False,
                      "hito_acordado": False, "diferimiento_aceptado": False, "impacto_acotado": False},
    }


def premisas_comparacion(cmp: dict) -> dict:
    esc = cmp.get("escenarios") if cmp.get("escenarios") in ESCENARIOS else "excluyentes"
    incomp = bool(cmp.get("resultados_incompatibles"))
    region = (cmp.get("region_comun") or "").strip()
    sev, punt = SEVERIDAD_BASE["comparacion"]
    return {
        "escenarios": esc, "resultados_incompatibles": incomp, "excepcion_resuelve": bool(cmp.get("excepcion_explicita")),
        "region_comun_definida": bool(region) if esc == "parciales" else esc == "coincidentes",
        "ambito_comun": region, "interpretacion_cerrada": True, "datos_controlados": True,
        "solapamiento_escenario": {"coincidentes": 9.5, "parciales": 5.0, "excluyentes": 1.0}[esc],
        "incompatibilidad_resultados": 9.0 if incomp else 1.5,
        "severidad_propuesta": sev, "puntuacion_severidad_propuesta": punt,
        "justificacion": cmp.get("justificacion") or "",
    }


MAX_REQUERIMIENTOS = 26          # claves A..Z
MAX_COMPARACIONES = 8


def pares_candidatos(extracciones: list[dict], textos: list[str]) -> list[tuple[int, int, dict]]:
    """Con más de dos requerimientos, se proponen para SM2 los pares que comparten objeto y acción
    (criterio de ACC-HC01: 'SI dos obligaciones comparten objeto y acción ENTONCES proponer el par')."""
    pares = []
    for i in range(len(textos)):
        for k in range(i + 1, len(textos)):
            acc_i = {_sin_tildes(v)[:5] for v in _infinitivos(extracciones[i].get("accion") or "") or [extracciones[i].get("accion") or ""] if v}
            acc_k = {_sin_tildes(v)[:5] for v in _infinitivos(extracciones[k].get("accion") or "") or [extracciones[k].get("accion") or ""] if v}
            if not (acc_i & acc_k):
                continue
            cmp = comparar_heuristico(extracciones[i], extracciones[k], textos[i], textos[k])
            if cmp["escenarios"] != "excluyentes" and cmp.get("solapamiento", 0) >= 0.5:
                pares.append((i, k, cmp))
    pares.sort(key=lambda t: (-t[2]["resultados_incompatibles"], -t[2].get("solapamiento", 0)))
    return pares[:MAX_COMPARACIONES]


def proponer(textos: list[str] | list[dict], contexto: str = "", usar_llm: bool = True, cfg: ConfigGeneral | None = None,
             progreso: Callable[[str, str], None] | None = None, documento: str = "") -> dict:
    """textos: cadenas o dicts {texto, ubicacion, id_documento} (los que vienen de un documento cargado)."""
    items = [t if isinstance(t, dict) else {"texto": t} for t in textos]
    items = [dict(t, texto=str(t.get("texto", "")).strip()) for t in items if str(t.get("texto", "")).strip()]
    if not 1 <= len(items) <= MAX_REQUERIMIENTOS:
        raise ErrorIngesta(f"Ingresá entre 1 y {MAX_REQUERIMIENTOS} requerimientos.")
    textos = [t["texto"] for t in items]
    cfg = cfg or ConfigGeneral()
    avisar = progreso or (lambda e, d: None)
    t0 = time.perf_counter()
    fuente, meta, avisos = "heuristica", None, []
    extracciones = [extraer_heuristico(t, contexto) for t in textos]
    if len(textos) == 2:
        pares = [(0, 1, comparar_heuristico(extracciones[0], extracciones[1], textos[0], textos[1]))]
    else:
        pares = pares_candidatos(extracciones, textos)
    llamadas: list[dict] = []
    if usar_llm:
        leidos = 0
        nuevos = list(extracciones)
        for inicio in range(0, len(textos), LOTE_LLM):
            tramo = textos[inicio:inicio + LOTE_LLM]
            avisar("llm", f"La IA está leyendo los requerimientos {inicio + 1} a {inicio + len(tramo)} "
                          f"de {len(textos)}…")
            try:
                exts, m = extraer_llm(cfg, tramo, contexto)
                for k, ext in enumerate(exts):
                    avisos += [f"{chr(65 + inicio + k)}: {a}" for a in controlar_extraccion(ext, tramo[k], contexto)]
                    nuevos[inicio + k] = ext
                leidos += len(tramo)
                llamadas.append({k2: v for k2, v in m.items() if k2 != "respuesta_cruda"})
            except ErrorIngesta as e:
                avisos.append(f"Requerimientos {inicio + 1} a {inicio + len(tramo)}: se usó el borrador léxico porque el LLM falló ({e}).")
        extracciones = nuevos
        if leidos:
            fuente = "llm" if leidos == len(textos) else "mixta"
            pares = ([(0, 1, comparar_heuristico(extracciones[0], extracciones[1], textos[0], textos[1]))]
                     if len(textos) == 2 else pares_candidatos(extracciones, textos))
            if pares:
                avisar("llm", f"La IA está comparando {len(pares)} par(es) de requerimientos…")
                try:
                    cmps, m = comparar_llm(cfg, [(textos[i], textos[k]) for i, k, _ in pares])
                    pares = [(i, k, dict(c, solapamiento=h.get("solapamiento"))) for (i, k, h), c in zip(pares, cmps)]
                    llamadas.append({k2: v for k2, v in m.items() if k2 != "respuesta_cruda"})
                except ErrorIngesta as e:
                    avisos.append(f"Comparaciones: se usó el borrador léxico porque el LLM falló ({e}).")
            meta = {"modelo": modelo_ingesta(cfg), "segundos": round(sum(c["segundos"] for c in llamadas), 1),
                    "llamadas": len(llamadas), "tokens_salida": sum(c.get("tokens_salida") or 0 for c in llamadas)}
    avisar("premisas", "Traduciendo la extracción a premisas de las reglas…")
    propuesta = {
        "version": VERSION_INGESTA, "fuente": fuente, "contexto": contexto, "avisos": avisos, "documento": documento,
        "segundos": round(time.perf_counter() - t0, 1), "llm": {k: v for k, v in (meta or {}).items() if k != "respuesta_cruda"},
        "requerimientos": [{"clave": chr(65 + i), "texto": t["texto"], "tipo": "funcional",
                            "ubicacion": t.get("ubicacion") or "", "id_documento": t.get("id_documento") or "",
                            "extraccion": extracciones[i], "premisas": premisas_requerimiento(extracciones[i], t["texto"], contexto)}
                           for i, t in enumerate(items)],
        "comparaciones": [{"a": chr(65 + i), "b": chr(65 + k), "extraccion": cmp, "premisas": premisas_comparacion(cmp)}
                          for i, k, cmp in pares],
    }
    return propuesta


# ============================================================================================
# 4. Normalización de lo confirmado por el analista (tipos y rangos)
# ============================================================================================
def _bool(v: Any) -> bool:
    if isinstance(v, str):
        return v.strip().lower() in ("true", "1", "si", "sí", "on", "yes")
    return bool(v)


def _num(v: Any, lo: float = 0.0, hi: float = 10.0, entero: bool = False) -> float | int | None:
    if v is None or v == "":
        return None
    try:
        x = float(str(v).replace(",", "."))
    except ValueError as e:
        raise ErrorIngesta(f"Valor numérico inválido: {v}") from e
    if not lo <= x <= hi:
        raise ErrorIngesta(f"Valor fuera de rango [{lo}, {hi}]: {v}")
    return int(round(x)) if entero else round(x, 2)


def _texto(v: Any, maximo: int = 600) -> str:
    return re.sub(r"\s+", " ", str(v or "")).strip()[:maximo]


def _lista(v: Any) -> list[str]:
    if isinstance(v, str):
        v = v.splitlines()
    return [_texto(x, 300) for x in (v or []) if _texto(x, 300)][:6]


def normalizar(propuesta: dict) -> dict:
    p = deepcopy(propuesta)
    rqs = p.get("requerimientos") or []
    if not 1 <= len(rqs) <= MAX_REQUERIMIENTOS:
        raise ErrorIngesta(f"La propuesta debe tener entre 1 y {MAX_REQUERIMIENTOS} requerimientos.")
    claves = set()
    for i, rq in enumerate(rqs):
        rq["clave"] = rq.get("clave") if re.fullmatch(r"[A-Z]", str(rq.get("clave") or "")) else chr(65 + i)
        if rq["clave"] in claves:
            raise ErrorIngesta("Hay dos requerimientos con la misma clave.")
        claves.add(rq["clave"])
        rq["ubicacion"] = _texto(rq.get("ubicacion"), 80)
        rq["id_documento"] = _texto(rq.get("id_documento"), 40)
    for rq in rqs:
        rq["texto"] = _texto(rq.get("texto"), 1000)
        if len(rq["texto"]) < 8:
            raise ErrorIngesta("El texto de un requerimiento es demasiado corto.")
        rq["tipo"] = rq.get("tipo") if rq.get("tipo") in ("funcional", "no_funcional") else "funcional"
        pr = rq["premisas"]
        for clave in ("obligacion", "escenario"):
            pr[clave] = {k: _texto(v, 200) for k, v in (pr.get(clave) or {}).items()}
        crit = pr["criterios"]
        for c in CRITERIOS:
            j = crit[c]
            for k in ("revision_semantica_completa", "info_necesaria_identificada", "info_disponible", "contexto_suficiente",
                      "unidad_aceptacion_confirmada", "delimitacion_confirmada", "aceptacion_delimita", "aceptacion_necesaria",
                      "aceptacion_disponible", "comprobacion_definida", "metodo_discrimina",
                      "informacion_aplicable_identificada"):
                if k in j:
                    j[k] = _bool(j[k])
            for k, hi in (("obligaciones_independientes", 20), ("lecturas_residuales", 10), ("omisiones_demostradas", 20)):
                if k in j:
                    j[k] = _num(j[k], 0, hi, entero=True)
            for k in ("divergencia_lecturas", "delimitacion_contexto"):
                if k in j:
                    j[k] = _num(j[k])
            j["severidad_propuesta"] = j.get("severidad_propuesta") if j.get("severidad_propuesta") in SEVERIDADES else None
            j["puntuacion_severidad_propuesta"] = _num(j.get("puntuacion_severidad_propuesta")) if j["severidad_propuesta"] else None
            j["justificacion"] = _texto(j.get("justificacion")) or f"Premisas de {c} confirmadas por el analista."
            for k in ("lecturas", "omisiones", "fragmentos"):
                if k in j:
                    j[k] = _lista(j[k])
            j["metodo"] = _texto(j.get("metodo"), 200)
        prio = pr["prioridad"]
        prio["criticidad_valor"] = prio.get("criticidad_valor") if prio.get("criticidad_valor") in CRITICIDADES else None
        prio["grado_criticidad"] = (_num(prio.get("grado_criticidad")) if prio.get("grado_criticidad") not in (None, "")
                                    else GRADO_CRITICIDAD.get(prio["criticidad_valor"])) if prio["criticidad_valor"] else None
        for k in ("obligacion_esencial_indefinida", "bloqueo_sustantivo_confirmado", "hito_acordado", "diferimiento_aceptado",
                  "impacto_acotado"):
            prio[k] = _bool(prio.get(k))
        prio["fundamento_criticidad"] = _texto(prio.get("fundamento_criticidad"), 300)
    comps = p.get("comparaciones")
    if comps is None and p.get("comparacion"):
        comps = [dict(p["comparacion"], a="A", b="B")]
    p.pop("comparacion", None)
    normalizadas = []
    for cmp in (comps or [])[:MAX_COMPARACIONES]:
        if cmp.get("a") not in claves or cmp.get("b") not in claves or cmp.get("a") == cmp.get("b"):
            continue
        if cmp.get("incluir") is False:
            continue
        c = cmp["premisas"]
        c["escenarios"] = c.get("escenarios") if c.get("escenarios") in ESCENARIOS else "excluyentes"
        for k in ("resultados_incompatibles", "excepcion_resuelve", "region_comun_definida", "interpretacion_cerrada",
                  "datos_controlados"):
            c[k] = _bool(c.get(k))
        c["solapamiento_escenario"] = _num(c.get("solapamiento_escenario"))
        c["incompatibilidad_resultados"] = _num(c.get("incompatibilidad_resultados"))
        c["severidad_propuesta"] = c.get("severidad_propuesta") if c.get("severidad_propuesta") in SEVERIDADES else None
        c["puntuacion_severidad_propuesta"] = _num(c.get("puntuacion_severidad_propuesta")) if c["severidad_propuesta"] else None
        c["justificacion"] = _texto(c.get("justificacion")) or "Comparación confirmada por el analista."
        c["ambito_comun"] = _texto(c.get("ambito_comun"), 200)
        c["dato_faltante"] = _texto(c.get("dato_faltante"), 200) or None
        a, b = sorted([cmp["a"], cmp["b"]])
        normalizadas.append({"a": a, "b": b, "extraccion": cmp.get("extraccion") or {}, "premisas": c})
    p["comparaciones"] = normalizadas
    p["documento"] = _texto(p.get("documento"), 160)
    p["analista"] = _texto(p.get("analista"), 80) or "Analista"
    return p


# ============================================================================================
# 5. Escritura en Neo4j, inferencia con las reglas del grafo y lectura del resultado
# ============================================================================================
def sentencias(texto: str):
    """Separador de sentencias Cypher (mismo criterio que el ejecutor de PG2: respeta cadenas y comentarios)."""
    buf: list[str] = []
    comilla, escape, comentario, i = None, False, False, 0
    while i < len(texto):
        ch = texto[i]
        if comentario:
            if ch == "\n":
                comentario = False
                buf.append(ch)
        elif comilla:
            buf.append(ch)
            if escape:
                escape = False
            elif ch == "\\":
                escape = True
            elif ch == comilla:
                comilla = None
        elif ch in "'\"`":
            comilla = ch
            buf.append(ch)
        elif ch == "/" and i + 1 < len(texto) and texto[i + 1] == "/":
            comentario = True
            i += 1
        elif ch == ";":
            if "".join(buf).strip():
                yield "".join(buf).strip()
            buf = []
        else:
            buf.append(ch)
        i += 1
    if "".join(buf).strip():
        yield "".join(buf).strip()


# Acotamiento de 04_difusa.cypher al lote: se reemplazan solo los patrones de selección; los cálculos no cambian.
ACOTAR_04 = [
    ("(ev:AuditIA_PG2:EvaluacionIndividual {entrada_valida:true})",
     "(ev:AuditIA_PG2:EvaluacionIndividual {entrada_valida:true,lote:$lote})"),
    ("(n:AuditIA_PG2:EvaluacionCruzada {entrada_valida:true,tipo_analisis:'comparacion'})",
     "(n:AuditIA_PG2:EvaluacionCruzada {entrada_valida:true,tipo_analisis:'comparacion',lote:$lote})"),
    ("(n:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]", "(n:AuditIA_PG2:DecisionPrioridad {lote:$lote})-[:PRIORIZA]"),
    ("MATCH (n:AuditIA_PG2) WHERE n.banda_difusa", "MATCH (n:AuditIA_PG2 {lote:$lote}) WHERE n.banda_difusa"),
    ("(ev:AuditIA_PG2:Evaluacion {publicado:false})", "(ev:AuditIA_PG2:Evaluacion {publicado:false,lote:$lote})"),
]


def difusa_acotada() -> list[str]:
    texto = (DIR_SCRIPTS / "04_difusa.cypher").read_text(encoding="utf-8")
    for viejo, nuevo in ACOTAR_04:
        if texto.count(viejo) != 1:
            raise ErrorIngesta(f"04_difusa.cypher cambió: no se encontró una única vez «{viejo}».")
        texto = texto.replace(viejo, nuevo)
    return list(sentencias(texto))


_ESCRIBIR_DOC = """
MERGE (s:AuditIA_PG2 {id:'S-ANALISTA'})
ON CREATE SET s:Fuente, s.nombre='Requerimientos ingresados por el analista en la miniapp', s.tipo='analista',
 s.validez='Premisas confirmadas por el analista; sin validación experta', s.contacto='Analista de requerimientos',
 s.estado='consultada'
CREATE (doc:AuditIA_PG2:DocumentoVersion {id:$doc_id, documento_id:$doc_logico, version:'1', lote:$lote, origen:'analista',
 titulo:CASE WHEN $documento <> '' THEN $documento ELSE 'Requerimientos ingresados por el analista · lote ' + $lote END,
 archivo_origen:$documento, fecha:datetime(),
 materiales_disponibles:['Texto ingresado por el analista'] + CASE WHEN $contexto <> '' THEN ['Contexto del analista'] ELSE [] END,
 referencias_no_disponibles:[], contexto_analista:$contexto, analista:$analista, fuente_propuesta:$fuente})
MERGE (doc)-[:CITA_FUENTE]->(s)
"""

_ESCRIBIR_RQ = """
MATCH (doc:AuditIA_PG2:DocumentoVersion {id:$doc_id})
CREATE (rq:AuditIA_PG2:Requerimiento {id:$rq_id, id_logico:$rq_logico, texto_original:$texto, tipo:$tipo,
 localizador:CASE WHEN $ubicacion <> '' THEN $ubicacion ELSE $rq_id END, id_documento:$id_documento, ubicacion:$ubicacion,
 entrada_valida:true, lote:$lote, origen:'analista'})
SET rq += $prioridad
CREATE (ctx:AuditIA_PG2:ContextoRequerimiento {id:'CTX-'+$rq_id, referencias_disponibles:[], alcance_controlado:true,
 lote:$lote, origen:'analista'})
CREATE (frag:AuditIA_PG2:Evidencia {id:'E-'+$rq_id, tipo:'fragmento', contenido:$texto,
 localizador:CASE WHEN $ubicacion <> '' THEN $documento + ' · ' + $ubicacion ELSE $rq_id END,
 naturaleza:'ingresado_por_analista', autor_registro:$analista, fecha:datetime(), documento_version:$doc_id,
 lote:$lote, origen:'analista'})
CREATE (ob:AuditIA_PG2:Obligacion {id:'O-'+$rq_id, lote:$lote, origen:'analista', aceptable_por_separado:true})
SET ob += $obligacion
CREATE (es:AuditIA_PG2:Escenario {id:'ESC-'+$rq_id, lote:$lote, origen:'analista'})
SET es += $escenario
MERGE (doc)-[:CONTIENE]->(rq) MERGE (rq)-[:SE_INTERPRETA_CON]->(ctx) MERGE (rq)-[:EXPRESA]->(ob)
MERGE (ob)-[:APLICA_EN]->(es)
CREATE (ev:AuditIA_PG2:Evaluacion:EvaluacionIndividual {id:$ev_id, fecha:datetime(), entrada_valida:true, publicado:false,
 estado:'en_revision', modulo_origen:'evaluacion_individual', lote:$lote, origen:'analista'})
CREATE (eev:AuditIA_PG2:Evidencia {id:'E-'+$ev_id, tipo:'analisis', contenido:$resumen_premisas, localizador:$ev_id,
 naturaleza:'premisas_confirmadas_por_analista', autor_registro:$analista, fecha:datetime(), lote:$lote, origen:'analista'})
MERGE (ev)-[:REVISA_DOCUMENTO]->(doc) MERGE (ev)-[:EVALUA]->(rq) MERGE (ev)-[:SE_SUSTENTA_EN]->(eev)
WITH ev, frag
UNWIND $juicios AS jd
MATCH (cq:AuditIA_PG2:CriterioCalidad {nombre:jd.criterio})
CREATE (j:AuditIA_PG2:JuicioCriterio {id:jd.id, fecha:datetime(), lote:$lote, origen:'analista',
 valoracion_confirmada:true, alcance_valoracion_revisado:true})
SET j += jd.props
CREATE (ej:AuditIA_PG2:Evidencia {id:'E-'+jd.id, tipo:'analisis', contenido:jd.evidencia, localizador:jd.id,
 naturaleza:'premisas_confirmadas_por_analista', autor_registro:$analista, fecha:datetime(), lote:$lote, origen:'analista'})
MERGE (ev)-[:CONTIENE_JUICIO]->(j) MERGE (j)-[:APLICA_CRITERIO]->(cq)
MERGE (j)-[:SE_SUSTENTA_EN]->(frag) MERGE (j)-[:SE_SUSTENTA_EN]->(ej)
"""

_ESCRIBIR_CMP = """
MATCH (doc:AuditIA_PG2:DocumentoVersion {id:$doc_id}), (a:AuditIA_PG2:Requerimiento {id:$a}), (b:AuditIA_PG2:Requerimiento {id:$b})
CREATE (ev:AuditIA_PG2:Evaluacion:EvaluacionCruzada {id:$ev_id, fecha:datetime(), entrada_valida:true, publicado:false,
 estado:'en_revision', tipo_analisis:'comparacion', modulo_origen:'analisis_cruzado', dato_necesario_faltante:false,
 valoracion_confirmada:true, validacion_operativa:'candidata', lote:$lote, origen:'analista'})
SET ev += $props
CREATE (e:AuditIA_PG2:Evidencia {id:'E-'+$ev_id, tipo:'analisis', contenido:$evidencia, localizador:$ev_id,
 naturaleza:'premisas_confirmadas_por_analista', autor_registro:$analista, fecha:datetime(), lote:$lote, origen:'analista'})
MERGE (ev)-[:REVISA_DOCUMENTO]->(doc) MERGE (ev)-[:COMPARA]->(a) MERGE (ev)-[:COMPARA]->(b) MERGE (ev)-[:SE_SUSTENTA_EN]->(e)
"""

_RESUMEN = """
MATCH (doc:AuditIA_PG2:DocumentoVersion {lote:$lote})
OPTIONAL MATCH (infa:InformeAuditoria)-[:CONSOLIDA]->(doc)
RETURN {
 lote: $lote, documento_id: doc.id, analista: doc.analista, fuente_propuesta: doc.fuente_propuesta,
 fecha: toString(doc.fecha), contexto: doc.contexto_analista, documento: doc.archivo_origen,
 informe: CASE WHEN infa IS NULL THEN null ELSE {id: infa.id, hallazgos: infa.hallazgos_demostrados,
   completitud_auditoria: infa.completitud_auditoria, calidad_observada: infa.calidad_observada,
   confianza: infa.confianza_auditoria} END,
 requerimientos: [(doc)-[:CONTIENE]->(rq:Requerimiento) | {
   id: rq.id, id_logico: rq.id_logico, texto: rq.texto_original, criticidad: rq.criticidad_valor,
   id_documento: rq.id_documento, ubicacion: rq.ubicacion,
   grado_criticidad: rq.grado_criticidad,
   evaluacion: head([(ev:EvaluacionIndividual)-[:EVALUA]->(rq) | {
     id: ev.id, estado: ev.estado, publicado: ev.publicado, reglas: [(ev)-[:APLICA_REGLA]->(r:Regla) | r.id],
     juicios: [(ev)-[:CONTIENE_JUICIO]->(j)-[:APLICA_CRITERIO]->(c) | {
       criterio: c.nombre, id: j.id, estado: j.estado, justificacion: j.justificacion,
       reglas: [(j)-[:APLICA_REGLA]->(r:Regla) | {id: r.id, descripcion: r.descripcion}],
       grado_ambiguedad: j.grado_ambiguedad, banda: j.banda_difusa, revision_senior: j.revision_senior_requerida}]}])}],
 comparaciones: COLLECT { MATCH (ev:AuditIA_PG2:EvaluacionCruzada {lote:$lote}) WITH ev ORDER BY ev.id RETURN {
   id: ev.id, estado: ev.estado, escenarios: ev.escenarios, justificacion: ev.justificacion,
   reglas: [(ev)-[:APLICA_REGLA]->(r:Regla) | {id: r.id, descripcion: r.descripcion}],
   grado_contradiccion: ev.grado_contradiccion, banda: ev.banda_difusa, revision_senior: ev.revision_senior_requerida,
   requerimientos: [(ev)-[:COMPARA]->(r:Requerimiento) | r.id]} },
 observaciones: [(ev:Evaluacion {lote:$lote})-[:GENERA]->(o:ResultadoAnalisis) | {
   id: o.id, clase: CASE WHEN o:Hallazgo THEN 'Hallazgo' WHEN o:Pendiente THEN 'Pendiente' ELSE 'Resultado' END,
   origen: ev.id, juicio_id: head([(o)-[:DERIVA_DE_JUICIO]->(j:JuicioCriterio) | j.id]),
   modulo: o.modulo_origen, tipo_defecto: o.tipo_defecto, motivo_pendiente: o.motivo_pendiente,
   dato_faltante: o.dato_faltante, descripcion: o.descripcion,
   reglas: [(o)-[:APLICA_REGLA]->(r:Regla) | r.id],
   severidad: head([(o)-[:TIENE_SEVERIDAD]->(sv) | {valor: sv.valor, grado: sv.grado_severidad}]),
   decision: head([(d:DecisionPrioridad)-[:PRIORIZA]->(o) | {
     id: d.id, prioridad: d.prioridad, motivo: d.motivo, categoria_matriz: d.categoria_matriz,
     reglas: [(d)-[:APLICA_REGLA]->(r:Regla) | r.id], grado_urgencia: d.grado_urgencia, banda: d.banda_difusa,
     criticidad: head([(o)-[:AFECTA_REQUERIMIENTO]->(:Requerimiento)-[:TIENE_CRITICIDAD]->(cr:Criticidad) WHERE cr.id = d.criticidad_id | {valor: cr.valor, grado: cr.grado_criticidad}]),
     estado_resolucion: head([(d)-[:TIENE_ESTADO]->(er) | er.valor])}])}]
} AS resumen
"""


class Ingesta:
    def __init__(self, cfg: ConfigGeneral | None = None):
        from neo4j import GraphDatabase
        self.cfg = cfg or ConfigGeneral()
        try:   # sin avisos de "propiedad inexistente" la primera vez que se usa `lote`
            self.driver = GraphDatabase.driver(self.cfg.neo4j_uri, auth=(self.cfg.neo4j_usuario, self.cfg.neo4j_password),
                                               notifications_min_severity="OFF")
        except (TypeError, ValueError):
            self.driver = GraphDatabase.driver(self.cfg.neo4j_uri, auth=(self.cfg.neo4j_usuario, self.cfg.neo4j_password))
        self._preparada = False

    def cerrar(self) -> None:
        self.driver.close()

    def _q(self, cypher: str, **params) -> list[dict]:
        with self.driver.session(database=self.cfg.neo4j_database) as s:
            return [r.data() for r in s.run(cypher, **params)]

    # ---------------------------------------------------------------- preparación (idempotente)
    def asegurar_preparacion(self) -> dict:
        filas = self._q("""
            UNWIND $reglas AS r
            MATCH (n:AuditIA_PG2:Regla {id:r.id})
            SET n.descripcion = coalesce(n.descripcion, r.descripcion),
                n.fuente = coalesce(n.fuente, 'PG1 §6'),
                n.ejecucion = 'implementada', n.implementada_en = 'PG3-1.3 · 08_inferencia_casos_nuevos.cypher'
            RETURN count(n) AS n""", reglas=[{"id": k, "descripcion": v} for k, v in REGLAS_NUEVAS.items()])
        conteo = self._q("MATCH (r:AuditIA_PG2:Regla) RETURN r.ejecucion AS ejecucion, count(*) AS n")
        self._preparada = True
        return {"reglas_activadas": filas[0]["n"] if filas else 0,
                "reglas": {c["ejecucion"] or "sin_dato": c["n"] for c in conteo}}

    # ---------------------------------------------------------------- lotes
    def siguiente_lote(self, prefijo: str = "L") -> str:
        filas = self._q("MATCH (d:AuditIA_PG2:DocumentoVersion {origen:'analista'}) WHERE d.lote STARTS WITH $p "
                        "RETURN collect(d.lote) AS lotes", p=prefijo)
        usados = [int(m.group(1)) for x in (filas[0]["lotes"] if filas else []) if (m := re.fullmatch(prefijo + r"(\d+)", x))]
        return f"{prefijo}{(max(usados) + 1) if usados else 1:02d}"

    def listar(self) -> list[dict]:
        return self._q("""
            MATCH (doc:AuditIA_PG2:DocumentoVersion {origen:'analista'})
            OPTIONAL MATCH (doc)-[:CONTIENE]->(rq:Requerimiento)
            OPTIONAL MATCH (ev:Evaluacion {lote:doc.lote})-[:GENERA]->(o:ResultadoAnalisis)
            RETURN doc.lote AS lote, toString(doc.fecha) AS fecha, doc.analista AS analista,
                   collect(DISTINCT {id: rq.id, texto: rq.texto_original}) AS requerimientos,
                   collect(DISTINCT o.id) AS observaciones
            ORDER BY fecha DESC""")

    def borrar(self, lote: str) -> int:
        if not re.fullmatch(r"[LT]\d{2,3}", lote or ""):
            raise ErrorIngesta("Lote inválido.")
        filas = self._q("""
            MATCH (doc:AuditIA_PG2:DocumentoVersion {lote:$lote, origen:'analista'})
            OPTIONAL MATCH (infa:InformeAuditoria)-[:CONSOLIDA]->(doc)
            WITH collect(DISTINCT infa) AS informes
            MATCH (n:AuditIA_PG2 {lote:$lote, origen:'analista'})
            WITH informes, collect(n) AS nodos
            FOREACH (x IN informes | DETACH DELETE x)
            FOREACH (x IN nodos | DETACH DELETE x)
            RETURN size(nodos) + size(informes) AS borrados""", lote=lote)
        return filas[0]["borrados"] if filas else 0

    # ---------------------------------------------------------------- registro + inferencia
    def registrar(self, propuesta: dict, prefijo: str = "L") -> dict:
        p = normalizar(propuesta)
        if not self._preparada:
            self.asegurar_preparacion()
        t0 = time.perf_counter()
        lote = self.siguiente_lote(prefijo)
        doc_id = f"DOC-{lote}-v1"
        ids = {}
        with self.driver.session(database=self.cfg.neo4j_database) as s:
            def tx_escritura(tx):
                tx.run(_ESCRIBIR_DOC, doc_id=doc_id, doc_logico=f"DOC-{lote}", lote=lote, contexto=p.get("contexto") or "",
                       analista=p["analista"], fuente=p.get("fuente") or "manual", documento=p.get("documento") or "").consume()
                for rq in p["requerimientos"]:
                    clave = rq["clave"]
                    rq_logico = f"RQ-{lote}-{clave}"
                    rq_id, ev_id = f"{rq_logico}-v1", f"EV-{lote}-{clave}"
                    ids[clave] = rq_id
                    pr = rq["premisas"]
                    juicios = []
                    for c in CRITERIOS:
                        props = {k: v for k, v in pr["criterios"][c].items()
                                 if k not in ("fragmentos", "omisiones", "metodo") and v is not None}
                        if c == "ambiguedad":
                            props["lecturas"] = pr["criterios"][c].get("lecturas") or []
                        frag = pr["criterios"][c].get("fragmentos") or []
                        extra = pr["criterios"][c].get("omisiones") or []
                        metodo = pr["criterios"][c].get("metodo") or ""
                        evidencia = props["justificacion"] + (" Fragmentos: " + " | ".join(frag) if frag else "") + \
                            (" Omisiones: " + " | ".join(extra) if extra else "") + (f" Método: {metodo}" if metodo else "")
                        juicios.append({"id": f"J-{ev_id}-{c}", "criterio": c, "props": props, "evidencia": evidencia})
                    resumen = (f"Premisas de {rq_id} propuestas por {'el LLM' if p.get('fuente') == 'llm' else 'el borrador léxico'} "
                               f"y confirmadas por {p['analista']}: " +
                               "; ".join(f"{c}: {pr['criterios'][c]['justificacion']}" for c in CRITERIOS))
                    prioridad = {k: v for k, v in pr["prioridad"].items() if v is not None and v != ""}
                    tx.run(_ESCRIBIR_RQ, doc_id=doc_id, rq_id=rq_id, rq_logico=rq_logico, texto=rq["texto"], tipo=rq["tipo"],
                           ubicacion=rq.get("ubicacion") or "", id_documento=rq.get("id_documento") or "",
                           documento=p.get("documento") or "documento",
                           lote=lote, analista=p["analista"], prioridad=prioridad,
                           obligacion={k: v for k, v in pr["obligacion"].items() if v},
                           escenario={k: v for k, v in pr["escenario"].items() if v},
                           ev_id=ev_id, resumen_premisas=resumen[:1500], juicios=juicios).consume()
                for cmp in p.get("comparaciones") or []:
                    c = cmp["premisas"]
                    ra, rb = ids[cmp["a"]], ids[cmp["b"]]
                    props = {k: v for k, v in c.items() if v is not None and k != "dato_faltante"}
                    if c.get("dato_faltante"):
                        props["dato_faltante"] = c["dato_faltante"]
                    evid = (f"{ra} frente a {rb}: escenarios {c['escenarios']}"
                            + (f" (región común: {c['ambito_comun']})" if c.get("ambito_comun") else "")
                            + f"; resultados {'incompatibles' if c['resultados_incompatibles'] else 'compatibles'}"
                            + ("; una excepción explícita concilia el par" if c["excepcion_resuelve"] else "")
                            + f". {c['justificacion']}")
                    tx.run(_ESCRIBIR_CMP, doc_id=doc_id, a=ra, b=rb, ev_id=f"EV-{lote}-{cmp['a']}{cmp['b']}", lote=lote,
                           props=props, evidencia=evid, analista=p["analista"]).consume()
            s.execute_write(tx_escritura)
            t_escritura = time.perf_counter() - t0
            etapas = []
            for nombre, lista in (("08_inferencia_casos_nuevos", list(sentencias(
                    (DIR_SCRIPTS / "08_inferencia_casos_nuevos.cypher").read_text(encoding="utf-8")))),
                                  ("04_difusa (acotado al lote)", difusa_acotada()),
                                  ("06_informes", list(sentencias((DIR_SCRIPTS / "06_informes.cypher").read_text(encoding="utf-8"))))):
                t1 = time.perf_counter()
                for sentencia in lista:
                    s.run(sentencia, lote=lote).consume()
                etapas.append({"script": nombre, "sentencias": len(lista), "segundos": round(time.perf_counter() - t1, 2)})
        resumen = self.resumen(lote)
        resumen["tiempos"] = {"escritura_s": round(t_escritura, 2), "etapas": etapas,
                              "total_s": round(time.perf_counter() - t0, 2)}
        resumen["controles"] = self.controles()
        resumen["consultas_sugeridas"] = consultas_sugeridas(resumen)
        return resumen

    def resumen(self, lote: str) -> dict:
        filas = self._q(_RESUMEN, lote=lote)
        if not filas:
            raise ErrorIngesta(f"No existe el lote {lote}.")
        res = filas[0]["resumen"]
        res["comparacion"] = (res.get("comparaciones") or [None])[0]   # compatibilidad: primer par
        return res

    def controles(self) -> dict:
        """07_controles.cypher de PG2 sobre toda la base: cada conteo debe ser cero."""
        res = {}
        for sentencia in sentencias((DIR_SCRIPTS / "07_controles.cypher").read_text(encoding="utf-8")):
            fila = self._q(sentencia)
            if fila:
                res.update(fila[0])
        return {"conteos": res, "todos_en_cero": all(v == 0 for v in res.values())}


def consultas_sugeridas(resumen: dict) -> list[str]:
    sugeridas = []
    rqs = resumen.get("requerimientos") or []
    for rq in rqs:
        sugeridas.append(f"¿Qué problemas de calidad tiene {rq['id']}?")
    obs = resumen.get("observaciones") or []
    if obs:
        sugeridas.append(f"¿Qué prioridad tiene {obs[0]['id']} y por qué?")
    comps = resumen.get("comparaciones") or []
    obs_ids = {o["id"] for o in obs}
    comp = next((c for c in comps if c.get("estado") == "observado"), comps[0] if comps else None)
    if comp:
        a, b = (sorted(comp.get("requerimientos") or ["", ""]) + ["", ""])[:2]
        sugeridas.append(f"¿{a} y {b} se contradicen?")
    del obs_ids
    hallazgos = [o for o in obs if o["clase"] == "Hallazgo"]
    if hallazgos:
        sugeridas.append(f"¿Por qué {hallazgos[0]['id']} es un hallazgo y qué hay que preguntarle al cliente para resolverlo?")
    return sugeridas[:5]
