#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
AuditIA · PI4 · Submódulo SM1 (Evaluación de calidad individual)
Integración de un LLM local (Ollama) con la base de conocimiento de PG2 en Neo4j.

Patrón sándwich:
  texto del usuario -> LLM de extracción (JSON estricto) -> consulta Cypher parametrizada de solo lectura
  -> resultado estructurado de Neo4j -> LLM de explicación -> verificador de fidelidad (GL05) -> respuesta.

Autor: Costa, Juan Pablo · Grupo 10 · Inteligencia Artificial · UTN FRM · 2026

Uso rápido:
  python pi4_sm1_asistente.py --verificar          # comprueba Neo4j, Ollama y archivos
  python pi4_sm1_asistente.py --preparar           # (una vez) incorpora el texto de las reglas de PG1 al grafo
  python pi4_sm1_asistente.py                      # modo interactivo
  python pi4_sm1_asistente.py -p "¿Qué tan ambiguo es ...?"
  python pi4_sm1_asistente.py --casos              # ejecuta la batería de casos de prueba

Configuración por variables de entorno o argumentos:
  NEO4J_URI (bolt://localhost:7687), NEO4J_USER (neo4j), NEO4J_PASSWORD, NEO4J_DATABASE (neo4j),
  OLLAMA_URL (http://localhost:11434), OLLAMA_MODEL (qwen2.5:7b)
"""
from __future__ import annotations

import argparse
import datetime as dt
import getpass
import hashlib
import json
import logging
import os
import re
import sys
import textwrap
import time
import unicodedata
import urllib.error
import urllib.request
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

VERSION_PROTOTIPO = "PI4-SM1-1.0"
# Las notificaciones informativas del servidor (por ejemplo, nulos ignorados por count) no son errores.
logging.getLogger("neo4j.notifications").setLevel(logging.ERROR)
logging.getLogger("neo4j").setLevel(logging.ERROR)
BASE = Path(__file__).resolve().parent
DIR_CONSULTAS = BASE / "consultas"
DIR_PROMPTS = BASE / "prompts"
DIR_EJECUCIONES = BASE / "ejecuciones"

CRITERIOS = ("atomicidad", "ambiguedad", "verificabilidad", "completitud")
INTENCIONES_CONSULTA = ("diagnostico_requerimiento", "grado_ambiguedad", "listar_juicios",
                        "seguimiento_observacion", "historial_requerimiento")
INTENCIONES_CONTROL = ("otro_submodulo", "fuera_de_dominio", "requiere_aclaracion")

# Patrón de identificadores del grafo PG2 (requerimientos, evaluaciones, juicios, observaciones, reglas, etc.).
PATRON_ID = re.compile(
    r"\bGL\d{2}\b|\b(?:RQ|EV|J|H|P|R|D|ER|E|IE|DOC|MD|AMB|URG|CONTR|EVI|PRC|ACC|Q|A|INF|SV|X|CR|CA|CTX|S|REV|RET|RESP|CQ)"
    r"-[A-Za-z0-9](?:[A-Za-z0-9.]|-(?=[A-Za-z0-9]))*"
)
PATRON_REGLA = re.compile(r"^(?:GL\d{2}|EVI-(?:RD|HC)\d{2}|PRC-(?:RD|HC)\d{2}|ACC-(?:RD|HC)\d{2})$")
PATRON_DECIMAL = re.compile(r"(?<![\w.,])(\d+[.,]\d+)(?![\w])")


# --------------------------------------------------------------------------------------------
# Presentación en terminal
# --------------------------------------------------------------------------------------------
class T:
    activo = True
    AZUL, CIAN, VERDE, AMARILLO, ROJO, GRIS, NEGRITA, FIN = (
        "\033[34m", "\033[36m", "\033[32m", "\033[33m", "\033[31m", "\033[90m", "\033[1m", "\033[0m")

    @classmethod
    def c(cls, color: str, texto: str) -> str:
        return f"{color}{texto}{cls.FIN}" if cls.activo else texto


def preparar_terminal(sin_color: bool) -> None:
    for flujo in (sys.stdout, sys.stderr):
        try:
            flujo.reconfigure(encoding="utf-8")
        except (AttributeError, ValueError):
            pass
    if os.name == "nt":
        os.system("")  # habilita secuencias ANSI en la consola de Windows
    T.activo = not sin_color and sys.stdout.isatty()


def titulo_etapa(numero: str, nombre: str, detalle: str = "") -> None:
    linea = f"[{numero}] {nombre}"
    if detalle:
        linea += T.c(T.GRIS, f"  · {detalle}")
    print(T.c(T.NEGRITA + T.AZUL, linea))


def json_por_clave(obj: dict) -> str:
    """Una línea por clave de primer nivel: legible en una captura de terminal."""
    claves = list(obj.items())
    lineas = []
    for i, (k, v) in enumerate(claves):
        cierre = "}" if i == len(claves) - 1 else ","
        apertura = "{" if i == 0 else " "
        lineas.append(f"    {apertura}{json.dumps(k)}: {json.dumps(v, ensure_ascii=False)}{cierre}")
    return "\n".join(lineas)


def json_compacto(obj: Any, ancho: int = 110) -> str:
    texto = json.dumps(obj, ensure_ascii=False, indent=2)
    return "\n".join("    " + l if len(l) <= ancho else "    " + l[:ancho - 3] + "..." for l in texto.splitlines())


# --------------------------------------------------------------------------------------------
# Configuración
# --------------------------------------------------------------------------------------------
@dataclass
class Config:
    neo4j_uri: str = os.environ.get("NEO4J_URI", "bolt://localhost:7687")
    neo4j_usuario: str = os.environ.get("NEO4J_USER", "neo4j")
    neo4j_password: str | None = os.environ.get("NEO4J_PASSWORD")
    neo4j_database: str = os.environ.get("NEO4J_DATABASE", "neo4j")
    ollama_url: str = os.environ.get("OLLAMA_URL", "http://localhost:11434")
    modelo: str = os.environ.get("OLLAMA_MODEL", "qwen2.5:7b")
    temperatura_extraccion: float = 0.0
    temperatura_explicacion: float = 0.0
    semilla: int = 42
    contexto_tokens: int = 8192
    timeout_s: int = 600
    hilos: int | None = None  # num_thread de Ollama; limitarlo reduce la carga térmica del equipo
    detalle: bool = False


# --------------------------------------------------------------------------------------------
# Archivos de prompts y consultas (una sola fuente de verdad, también adjunta al informe)
# --------------------------------------------------------------------------------------------
def leer_texto(ruta: Path) -> str:
    if not ruta.exists():
        raise FileNotFoundError(f"No se encontró {ruta.relative_to(BASE)}")
    return ruta.read_text(encoding="utf-8")


def cargar_prompts() -> dict[str, Any]:
    extraccion = leer_texto(DIR_PROMPTS / "system_prompt_extraccion.txt")
    explicacion = leer_texto(DIR_PROMPTS / "system_prompt_explicacion.txt")
    esquema = json.loads(leer_texto(DIR_PROMPTS / "esquema_extraccion.json"))
    huella = hashlib.sha256((extraccion + explicacion).encode("utf-8")).hexdigest()[:12]
    return {"extraccion": extraccion, "explicacion": explicacion, "esquema": esquema, "huella": huella}


def cargar_consulta(nombre: str) -> str:
    return leer_texto(DIR_CONSULTAS / f"{nombre}.cypher").strip().rstrip(";")


_ESCRITURA = re.compile(r"\b(CREATE|MERGE|SET|DELETE|DETACH|REMOVE|DROP|FOREACH|LOAD\s+CSV)\b|\bCALL\s+(?:db|dbms|apoc)\.",
                        re.IGNORECASE)


def es_solo_lectura(cypher: str) -> bool:
    sin_comentarios = "\n".join(l.split("//", 1)[0] for l in cypher.splitlines())
    sin_literales = re.sub(r"'[^']*'", "''", sin_comentarios)
    return _ESCRITURA.search(sin_literales) is None


# --------------------------------------------------------------------------------------------
# Cliente del LLM (Ollama, API HTTP local; solo biblioteca estándar)
# --------------------------------------------------------------------------------------------
class ErrorLLM(RuntimeError):
    pass


class ClienteOllama:
    def __init__(self, cfg: Config):
        self.cfg = cfg

    def _post(self, ruta: str, cuerpo: dict) -> dict:
        datos = json.dumps(cuerpo).encode("utf-8")
        req = urllib.request.Request(self.cfg.ollama_url.rstrip("/") + ruta, data=datos,
                                     headers={"Content-Type": "application/json"})
        try:
            with urllib.request.urlopen(req, timeout=self.cfg.timeout_s) as resp:
                return json.loads(resp.read().decode("utf-8"))
        except urllib.error.HTTPError as e:
            raise ErrorLLM(f"Ollama respondió {e.code}: {e.read().decode('utf-8', 'replace')[:300]}") from e
        except (urllib.error.URLError, TimeoutError, ConnectionError) as e:
            raise ErrorLLM(f"No se pudo contactar a Ollama en {self.cfg.ollama_url}: {e}") from e

    def modelos_disponibles(self) -> list[str]:
        req = urllib.request.Request(self.cfg.ollama_url.rstrip("/") + "/api/tags")
        try:
            with urllib.request.urlopen(req, timeout=15) as resp:
                return [m["name"] for m in json.loads(resp.read().decode("utf-8")).get("models", [])]
        except (urllib.error.URLError, TimeoutError, ConnectionError) as e:
            raise ErrorLLM(f"No se pudo contactar a Ollama en {self.cfg.ollama_url}: {e}") from e

    def chat(self, sistema: str, usuario: str, temperatura: float, formato: Any = None,
             max_tokens: int = 700) -> tuple[str, dict]:
        cuerpo = {
            "model": self.cfg.modelo,
            "messages": [{"role": "system", "content": sistema}, {"role": "user", "content": usuario}],
            "stream": False,
            "keep_alive": "15m",
            "options": {"temperature": temperatura, "seed": self.cfg.semilla,
                        "num_ctx": self.cfg.contexto_tokens, "num_predict": max_tokens},
        }
        if self.cfg.hilos:
            cuerpo["options"]["num_thread"] = self.cfg.hilos
        if formato is not None:
            cuerpo["format"] = formato
        t0 = time.perf_counter()
        resp = self._post("/api/chat", cuerpo)
        meta = {"modelo": resp.get("model", self.cfg.modelo), "segundos": round(time.perf_counter() - t0, 2),
                "tokens_entrada": resp.get("prompt_eval_count"), "tokens_salida": resp.get("eval_count")}
        return resp.get("message", {}).get("content", ""), meta


# --------------------------------------------------------------------------------------------
# Base de conocimiento (Neo4j, transacciones de lectura)
# --------------------------------------------------------------------------------------------
class ErrorBase(RuntimeError):
    pass


class BaseConocimiento:
    def __init__(self, cfg: Config):
        try:
            from neo4j import GraphDatabase, RoutingControl
            from neo4j.exceptions import Neo4jError, ServiceUnavailable, AuthError
        except ImportError as e:
            raise ErrorBase("Falta el driver oficial de Neo4j. Instalar con: pip install neo4j") from e
        self._RoutingControl = RoutingControl
        self._errores = (Neo4jError, ServiceUnavailable, AuthError)
        self.cfg = cfg
        try:
            try:
                self.driver = GraphDatabase.driver(cfg.neo4j_uri, auth=(cfg.neo4j_usuario, cfg.neo4j_password or ""),
                                                   notifications_min_severity="OFF")
            except TypeError:  # drivers anteriores a 5.7
                self.driver = GraphDatabase.driver(cfg.neo4j_uri, auth=(cfg.neo4j_usuario, cfg.neo4j_password or ""))
            self.driver.verify_connectivity()
        except self._errores as e:
            raise ErrorBase(f"No se pudo conectar a Neo4j en {cfg.neo4j_uri}: {e}") from e

    def cerrar(self) -> None:
        self.driver.close()

    def leer(self, nombre: str, parametros: dict | None = None) -> list[dict]:
        cypher = cargar_consulta(nombre)
        if not es_solo_lectura(cypher):
            raise ErrorBase(f"La consulta {nombre} contiene cláusulas de escritura y no se ejecuta.")
        try:
            resultado = self.driver.execute_query(cypher, parameters_=parametros or {},
                                                  database_=self.cfg.neo4j_database,
                                                  routing_=self._RoutingControl.READ)
        except self._errores as e:
            raise ErrorBase(f"Neo4j rechazó la consulta {nombre}: {e}") from e
        return [r.data() for r in resultado.records]

    def escribir_preparacion(self) -> int:
        cypher = cargar_consulta("P0_enriquecer_reglas")
        resultado = self.driver.execute_query(cypher, database_=self.cfg.neo4j_database,
                                              routing_=self._RoutingControl.WRITE)
        return resultado.records[0]["reglas_documentadas"] if resultado.records else 0


# --------------------------------------------------------------------------------------------
# Etapa 1. Validación determinística de la entrada
# --------------------------------------------------------------------------------------------
def validar_entrada(texto: str) -> str | None:
    """Devuelve un motivo de rechazo o None si la entrada puede enviarse al LLM."""
    limpio = texto.strip()
    if not limpio:
        return "La consulta está vacía."
    if len(limpio) > 400:
        return "La consulta supera los 400 caracteres. Formulá una pregunta por vez."
    letras = sum(ch.isalpha() for ch in limpio)
    palabras = re.findall(r"[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]{2,}", limpio)
    if letras < 6 or len(palabras) < 2 or letras / max(len(limpio), 1) < 0.5:
        return "No reconozco una pregunta en el texto ingresado."
    if re.search(r"(.)\1{7,}", limpio):
        return "El texto contiene repeticiones que no forman una pregunta."
    return None


# --------------------------------------------------------------------------------------------
# Etapa 2. Extracción con LLM y validación del JSON (GL05: el LLM propone, el sistema controla)
# --------------------------------------------------------------------------------------------
def _validar_contra_esquema(valor: Any, esquema: dict, ruta: str = "$") -> list[str]:
    errores: list[str] = []
    if "anyOf" in esquema:
        if all(_validar_contra_esquema(valor, alt, ruta) for alt in esquema["anyOf"]):
            errores.append(f"{ruta}: tipo o valor no permitido ({valor!r})")
        return errores
    tipo = esquema.get("type")
    tipos = {"object": dict, "array": list, "string": str, "integer": int, "null": type(None)}
    if tipo == "integer" and isinstance(valor, bool):
        return [f"{ruta}: se esperaba integer"]
    if tipo and not isinstance(valor, tipos[tipo]):
        return [f"{ruta}: se esperaba {tipo}"]
    if "enum" in esquema and valor not in esquema["enum"]:
        errores.append(f"{ruta}: {valor!r} no está en {esquema['enum']}")
    if tipo == "object":
        for req in esquema.get("required", []):
            if req not in valor:
                errores.append(f"{ruta}.{req}: falta la clave")
        for clave in valor:
            if clave not in esquema.get("properties", {}):
                errores.append(f"{ruta}.{clave}: clave no permitida")
        for clave, sub in esquema.get("properties", {}).items():
            if clave in valor:
                errores.extend(_validar_contra_esquema(valor[clave], sub, f"{ruta}.{clave}"))
    if tipo == "array":
        for i, item in enumerate(valor):
            errores.extend(_validar_contra_esquema(item, esquema.get("items", {}), f"{ruta}[{i}]"))
    return errores


_PATRON_ID_SIN_MAYUSCULAS = re.compile(PATRON_ID.pattern, re.IGNORECASE)


def canonizar_id(ident: str) -> str:
    """Restituye la grafía de los IDs de PG2: prefijos en mayúscula, versión vN y criterio en minúscula."""
    partes = []
    for parte in ident.strip().rstrip(".").split("-"):
        if parte.lower() in CRITERIOS:
            partes.append(parte.lower())
        elif re.fullmatch(r"[vV]\d+", parte):
            partes.append("v" + parte[1:])
        else:
            partes.append(parte.upper())
    return "-".join(partes)


def _ids_literales(texto_usuario: str) -> set[str]:
    return {canonizar_id(m.group(0)) for m in _PATRON_ID_SIN_MAYUSCULAS.finditer(texto_usuario)}


def normalizar_extraccion(ext: dict, texto_usuario: str) -> tuple[dict, list[str]]:
    """Controles posteriores al esquema. Descarta IDs que no estén literalmente en la consulta."""
    notas: list[str] = []
    literales = _ids_literales(texto_usuario)
    ent = ext["entidades"]
    for clave in ("requerimiento_id", "observacion_id", "evaluacion_id"):
        valor = ent.get(clave)
        if valor is None:
            continue
        valor = canonizar_id(valor)
        if valor not in literales:
            notas.append(f"GL05: se descartó {clave}={valor!r} porque no aparece en la consulta del usuario.")
            ent[clave] = None
        else:
            ent[clave] = valor
    if ent.get("requerimiento_texto") is not None and not ent["requerimiento_texto"].strip():
        ent["requerimiento_texto"] = None
    version = ext["condiciones"].get("version")
    if version is not None and not (1 <= version <= 99):
        notas.append(f"Versión {version} fuera de rango; se ignora.")
        ext["condiciones"]["version"] = None
    return ext, notas


def extraer(llm: ClienteOllama, prompts: dict, texto: str) -> tuple[dict | None, dict]:
    traza: dict[str, Any] = {"intentos": []}
    mensaje = f"Consulta: {texto}\nJSON:"
    for intento in (1, 2):
        crudo, meta = llm.chat(prompts["extraccion"], mensaje, llm.cfg.temperatura_extraccion,
                               formato=prompts["esquema"], max_tokens=350)
        registro = {"intento": intento, "salida_cruda": crudo, **meta}
        try:
            datos = json.loads(crudo)
            errores = _validar_contra_esquema(datos, prompts["esquema"])
        except json.JSONDecodeError as e:
            datos, errores = None, [f"JSON inválido: {e.msg}"]
        registro["errores_esquema"] = errores
        traza["intentos"].append(registro)
        if not errores:
            datos, notas = normalizar_extraccion(datos, texto)
            traza["notas"] = notas
            return datos, traza
        mensaje = (f"Consulta: {texto}\nTu salida anterior fue rechazada por el validador: {'; '.join(errores[:4])}. "
                   f"Devolvé solo el objeto JSON con la forma indicada.\nJSON:")
    return None, traza


# --------------------------------------------------------------------------------------------
# Etapa 3. Resolución determinística de entidades (el LLM nunca elige un ID del grafo)
# --------------------------------------------------------------------------------------------
_VACIAS = set("""a al algo ante cada como con cual cuales de del donde dice el ella en entre es esa ese eso esta este esto
fue ha hay la las le lo los mas me mi no o para pero por que qué se ser si sin sobre su sus tan te tiene un una uno y ya
sistema debe deben debera requerimiento requerimientos requisito requisitos dice dicen version versiones problema problemas
calidad ambiguo ambigua ambiguedad grado observacion observaciones evaluacion juicio juicios cambio cambiaron
""".split())


def normalizar(texto: str) -> str:
    sin_tildes = "".join(c for c in unicodedata.normalize("NFD", texto.lower()) if unicodedata.category(c) != "Mn")
    return re.sub(r"[^a-z0-9 ]+", " ", sin_tildes)


def raices(texto: str) -> set[str]:
    return {p[:6] for p in normalizar(texto).split() if len(p) > 2 and p not in _VACIAS}


@dataclass
class Resolucion:
    estado: str                      # ok | sin_referencia | sin_coincidencia | ambiguo | version_inexistente
    requerimiento: dict | None = None
    alternativas: list[dict] = field(default_factory=list)
    puntaje: float | None = None
    catalogo: list[dict] = field(default_factory=list)


def resolver_requerimiento(catalogo: list[dict], ext: dict) -> Resolucion:
    ent, cond = ext["entidades"], ext["condiciones"]
    version = cond.get("version")

    def elegir_version(grupo: list[dict]) -> Resolucion:
        grupo = sorted(grupo, key=lambda r: r["version"])
        if version is not None:
            exacta = [r for r in grupo if r["version"] == version]
            if not exacta:
                return Resolucion("version_inexistente", alternativas=grupo, catalogo=catalogo)
            return Resolucion("ok", exacta[0], catalogo=catalogo)
        elegido = grupo[0] if cond.get("alcance") == "original" else grupo[-1]
        return Resolucion("ok", elegido, alternativas=[r for r in grupo if r is not elegido], catalogo=catalogo)

    if ent.get("requerimiento_id"):
        rid = ent["requerimiento_id"]
        exacto = [r for r in catalogo if r["requerimiento_id"] == rid]
        if exacto:
            if version is not None and exacto[0]["version"] != version:
                return elegir_version([r for r in catalogo if r["id_logico"] == exacto[0]["id_logico"]])
            return Resolucion("ok", exacto[0], catalogo=catalogo)
        logico = [r for r in catalogo if r["id_logico"] == rid]
        if logico:
            return elegir_version(logico)
        return Resolucion("sin_coincidencia", catalogo=catalogo)

    if not ent.get("requerimiento_texto"):
        return Resolucion("sin_referencia", catalogo=catalogo)

    buscadas = raices(ent["requerimiento_texto"])
    if not buscadas:
        return Resolucion("sin_coincidencia", catalogo=catalogo)
    puntuados = []
    for r in catalogo:
        propias = raices(r["texto"] or "")
        comunes = buscadas & propias
        puntuados.append((len(comunes) / len(buscadas), len(comunes), r))
    mejor = max(p[0] for p in puntuados)
    if mejor < 0.5:
        return Resolucion("sin_coincidencia", puntaje=round(mejor, 2), catalogo=catalogo)
    tope = [p for p in puntuados if p[0] == mejor]
    logicos = {p[2]["id_logico"] for p in tope}
    if len(logicos) > 1:
        return Resolucion("ambiguo", alternativas=[p[2] for p in tope], puntaje=round(mejor, 2), catalogo=catalogo)
    id_logico = logicos.pop()
    grupo = [r for r in catalogo if r["id_logico"] == id_logico]
    # Si una versión coincide mejor que las demás (por ejemplo, conserva la palabra "rápidamente"),
    # se respeta esa versión salvo que el usuario indique otra.
    mejores_versiones = [p[2] for p in tope]
    if version is None and len(mejores_versiones) == 1 and len(grupo) > 1:
        elegido = mejores_versiones[0]
        return Resolucion("ok", elegido, alternativas=[r for r in grupo if r is not elegido],
                          puntaje=round(mejor, 2), catalogo=catalogo)
    res = elegir_version(grupo)
    res.puntaje = round(mejor, 2)
    return res


# --------------------------------------------------------------------------------------------
# Etapa 4. Recuperación: plantillas Cypher fijas por intención (el LLM no genera Cypher)
# --------------------------------------------------------------------------------------------
@dataclass
class Recuperacion:
    paquete: dict | None = None
    consultas: list[dict] = field(default_factory=list)
    aclaracion: str | None = None
    tipo_cierre: str | None = None


def _ejecutar(kb: BaseConocimiento, rec: Recuperacion, nombre: str, parametros: dict) -> list[dict]:
    t0 = time.perf_counter()
    filas = kb.leer(nombre, parametros)
    rec.consultas.append({"consulta": nombre, "parametros": parametros, "filas": len(filas),
                          "milisegundos": round((time.perf_counter() - t0) * 1000, 1)})
    return filas


def _reglas_citadas(obj: Any) -> list[str]:
    encontrados: set[str] = set()

    def recorrer(x: Any) -> None:
        if isinstance(x, dict):
            for v in x.values():
                recorrer(v)
        elif isinstance(x, list):
            for v in x:
                recorrer(v)
        elif isinstance(x, str) and PATRON_REGLA.match(x):
            encontrados.add(x)
    recorrer(obj)
    return sorted(encontrados)


def _resumen_requerimiento(r: dict | None) -> dict | None:
    if not r:
        return None
    return {"requerimiento_id": r["requerimiento_id"], "id_logico": r["id_logico"], "texto": r["texto"],
            "documento_id": r["documento_id"], "version": r["version"]}


def recuperar(kb: BaseConocimiento, ext: dict, texto: str) -> tuple[Recuperacion, Resolucion | None]:
    rec = Recuperacion()
    intencion = ext["intencion"]
    criterio = ext["conceptos"]["criterio"]
    resolucion: Resolucion | None = None
    paquete: dict[str, Any] = {"intencion": intencion, "consulta_usuario": texto,
                               "fuente": "Neo4j · base AuditIA_PG2 (PG2, Grupo 10)"}

    necesita_requerimiento = intencion in ("diagnostico_requerimiento", "grado_ambiguedad", "historial_requerimiento") or (
        intencion == "seguimiento_observacion" and not ext["entidades"]["observacion_id"])
    if necesita_requerimiento:
        catalogo = _ejecutar(kb, rec, "Q0_candidatos", {})
        resolucion = resolver_requerimiento(catalogo, ext)
        if resolucion.estado != "ok":
            rec.aclaracion, rec.tipo_cierre = mensaje_resolucion(resolucion, ext), "aclaracion_resolucion"
            return rec, resolucion
        paquete["requerimiento_consultado"] = _resumen_requerimiento(resolucion.requerimiento)
        otras = [_resumen_requerimiento(a) for a in resolucion.alternativas]
        if otras:
            paquete["otras_versiones_del_requerimiento"] = otras

    if intencion == "diagnostico_requerimiento":
        req = resolucion.requerimiento
        filas = [f["evaluacion"] for f in _ejecutar(kb, rec, "Q1_diagnostico",
                                                    {"requerimiento_id": req["requerimiento_id"], "criterio": criterio})]
        if ext["entidades"]["evaluacion_id"]:
            filas = [f for f in filas if f["evaluacion_id"] == ext["entidades"]["evaluacion_id"]]
        vigentes = [f for f in filas if f["vigente"]]
        if len(vigentes) > 1 and not ext["entidades"]["evaluacion_id"]:
            ids = ", ".join(f["evaluacion_id"] for f in vigentes)
            rec.aclaracion = (f"El requerimiento {req['requerimiento_id']} tiene {len(vigentes)} evaluaciones vigentes de SM1 "
                              f"en la misma versión ({ids}). Indicá cuál querés consultar escribiendo su ID.")
            rec.tipo_cierre = "aclaracion_multiples_evaluaciones"
            return rec, resolucion
        if not filas:
            rec.aclaracion, rec.tipo_cierre = "La base no registra evaluaciones de SM1 para ese requerimiento.", "sin_resultados"
            return rec, resolucion
        for f in filas:
            f["juicios"] = sorted(f["juicios"], key=lambda j: CRITERIOS.index(j["criterio"]) if j["criterio"] in CRITERIOS else 9)
        if criterio:
            paquete["criterio_consultado"] = criterio
        paquete["evaluaciones"] = filas

    elif intencion == "grado_ambiguedad":
        req = resolucion.requerimiento
        filas = [f["grado"] for f in _ejecutar(kb, rec, "Q2_grado_ambiguedad", {"requerimiento_id": req["requerimiento_id"]})]
        if ext["entidades"]["evaluacion_id"]:
            filas = [f for f in filas if f["evaluacion_id"] == ext["entidades"]["evaluacion_id"]]
        vigentes = [f for f in filas if f["vigente"]]
        if len(vigentes) > 1 and not ext["entidades"]["evaluacion_id"]:
            ids = ", ".join(f["evaluacion_id"] for f in vigentes)
            rec.aclaracion = (f"El requerimiento {req['requerimiento_id']} tiene {len(vigentes)} juicios de ambigüedad vigentes "
                              f"({ids}). Indicá cuál querés consultar escribiendo el ID de la evaluación.")
            rec.tipo_cierre = "aclaracion_multiples_evaluaciones"
            return rec, resolucion
        if not filas:
            rec.aclaracion, rec.tipo_cierre = "La base no registra un juicio de ambigüedad para ese requerimiento.", "sin_resultados"
            return rec, resolucion
        paquete["juicios_de_ambiguedad"] = filas

    elif intencion == "listar_juicios":
        filtros = ext["filtros"]
        parametros = {"criterio": criterio, "estado": filtros["estado_juicio"], "banda": filtros["banda_ambiguedad"],
                      "solo_vigentes": ext["condiciones"]["alcance"] != "todas"}
        if not any((criterio, filtros["estado_juicio"], filtros["banda_ambiguedad"])):
            rec.aclaracion = ("Para listar juicios necesito al menos un filtro: un criterio (atomicidad, ambigüedad, "
                              "verificabilidad o completitud), un estado (cumple, incumple o pendiente) o una banda de ambigüedad.")
            rec.tipo_cierre = "aclaracion_filtros"
            return rec, None
        filas = [f["juicio"] for f in _ejecutar(kb, rec, "Q3_listado_juicios", parametros)]
        if not filas:
            rec.aclaracion = "La base no registra juicios de SM1 que cumplan esos filtros."
            rec.tipo_cierre = "sin_resultados"
            return rec, None
        paquete["filtros_aplicados"] = parametros
        paquete["total_juicios"] = len(filas)
        paquete["juicios"] = filas[:15]
        if len(filas) > 15:
            paquete["nota_de_recorte"] = f"Se muestran 15 de {len(filas)} juicios recuperados."

    elif intencion == "seguimiento_observacion":
        if ext["entidades"]["observacion_id"]:
            observaciones = [ext["entidades"]["observacion_id"]]
        else:
            req = resolucion.requerimiento
            filas = _ejecutar(kb, rec, "Q4a_observaciones_requerimiento", {"id_logico": req["id_logico"], "criterio": criterio})
            observaciones = [f["observacion_id"] for f in filas]
            if not observaciones:
                rec.aclaracion = (f"La base no registra observaciones de SM1 (hallazgos o pendientes) para "
                                  f"{req['id_logico']}{' en ' + criterio if criterio else ''}.")
                rec.tipo_cierre = "sin_resultados"
                return rec, resolucion
            if len(observaciones) > 4:
                rec.aclaracion = (f"Hay {len(observaciones)} observaciones para ese requerimiento ({', '.join(observaciones)}). "
                                  f"Indicá un criterio o el ID de la observación.")
                rec.tipo_cierre = "aclaracion_multiples_observaciones"
                return rec, resolucion
        paquetes = []
        for oid in observaciones:
            filas = _ejecutar(kb, rec, "Q4_seguimiento_pg2", {"observacion_id": oid})
            paquetes.extend(f["paquete"] for f in filas)
        if not paquetes:
            rec.aclaracion = (f"No encontré en la base una observación con decisión de seguimiento para "
                              f"{', '.join(observaciones)}. Revisá el ID (por ejemplo H-CAT-B).")
            rec.tipo_cierre = "sin_resultados"
            return rec, resolucion
        ajenos = [p for p in paquetes if p.get("modulo_origen") != "evaluacion_individual"]
        if ajenos and len(ajenos) == len(paquetes):
            modulo = ajenos[0].get("modulo_origen")
            rec.aclaracion = (f"La observación {ajenos[0]['observacion_id']} fue emitida por el módulo {modulo}, no por SM1. "
                              f"Su explicación corresponde al asistente de ese submódulo.")
            rec.tipo_cierre = "otro_submodulo"
            return rec, resolucion
        paquete["seguimiento"] = [p for p in paquetes if p.get("modulo_origen") == "evaluacion_individual"]

    elif intencion == "historial_requerimiento":
        req = resolucion.requerimiento
        filas = [f["version_evaluada"] for f in _ejecutar(kb, rec, "Q5_historial", {"id_logico": req["id_logico"]})]
        if not filas:
            rec.aclaracion, rec.tipo_cierre = "La base no registra evaluaciones de SM1 para ese requerimiento.", "sin_resultados"
            return rec, resolucion
        paquete["historial"] = filas

    ids_reglas = _reglas_citadas(paquete)
    if ids_reglas:
        paquete["reglas"] = _ejecutar(kb, rec, "Q6_reglas", {"ids": ids_reglas})
    rec.paquete = paquete
    return rec, resolucion


# --------------------------------------------------------------------------------------------
# Mensajes de aclaración determinísticos (no pasan por el LLM: no hay nada que explicar)
# --------------------------------------------------------------------------------------------
def _lista_catalogo(catalogo: list[dict]) -> str:
    vistos, lineas = set(), []
    for r in catalogo:
        if r["requerimiento_id"] in vistos:
            continue
        vistos.add(r["requerimiento_id"])
        lineas.append(f"  - {r['requerimiento_id']}: «{r['texto']}»")
    return "\n".join(lineas)


def mensaje_resolucion(res: Resolucion, ext: dict) -> str:
    if res.estado == "sin_referencia":
        return ("No identifiqué a qué requerimiento te referís. Podés nombrarlo por su ID o citar parte de su texto. "
                "Requerimientos evaluados por SM1 en la base:\n" + _lista_catalogo(res.catalogo))
    if res.estado == "sin_coincidencia":
        ref = ext["entidades"].get("requerimiento_id") or ext["entidades"].get("requerimiento_texto")
        return (f"No encontré en la base de conocimiento un requerimiento evaluado por SM1 que coincida con «{ref}». "
                "No voy a suponer uno. Requerimientos disponibles:\n" + _lista_catalogo(res.catalogo))
    if res.estado == "ambiguo":
        return ("Tu descripción coincide con más de un requerimiento. Indicá cuál querés consultar:\n"
                + _lista_catalogo(res.alternativas))
    if res.estado == "version_inexistente":
        versiones = ", ".join(str(r["version"]) for r in res.alternativas)
        return (f"La versión {ext['condiciones']['version']} no existe para {res.alternativas[0]['id_logico']}. "
                f"Versiones registradas: {versiones}.")
    return "No pude resolver la referencia del requerimiento."


MENSAJES_CONTROL = {
    "fuera_de_dominio": ("Soy el asistente de SM1 de AuditIA y solo respondo consultas sobre la evaluación de calidad "
                         "individual de requerimientos registrada en la base de conocimiento (atomicidad, ambigüedad, "
                         "verificabilidad y completitud). No puedo modificar resultados ni responder otros temas. "
                         "Ejemplo: «¿Qué problemas tiene el requerimiento de cargar rápidamente el catálogo?»"),
    "otro_submodulo": ("Esa consulta corresponde a otro submódulo de AuditIA: las contradicciones, dependencias y "
                       "coberturas las analiza SM2, y la prioridad, criticidad y urgencia las decide SM3. Desde SM1 puedo "
                       "explicarte los juicios locales de un requerimiento."),
    "requiere_aclaracion": ("Necesito un poco más de información para consultar la base. Indicá el requerimiento "
                            "(por ID o con parte de su texto) y qué querés saber: su diagnóstico, su grado de ambigüedad, "
                            "el seguimiento de una observación o su historial de versiones."),
}


# --------------------------------------------------------------------------------------------
# Etapa 5. Explicación con LLM y Etapa 6. Verificador de fidelidad (implementación de GL05)
# --------------------------------------------------------------------------------------------
def _valores(obj: Any) -> tuple[set[str], list[float]]:
    textos: set[str] = set()
    numeros: list[float] = []

    def recorrer(x: Any) -> None:
        if isinstance(x, dict):
            for k, v in x.items():
                textos.add(str(k))
                recorrer(v)
        elif isinstance(x, list):
            for v in x:
                recorrer(v)
        elif isinstance(x, bool) or x is None:
            return
        elif isinstance(x, (int, float)):
            numeros.append(float(x))
        else:
            s = str(x)
            textos.add(s)
            for m in PATRON_DECIMAL.finditer(s):
                numeros.append(float(m.group(1).replace(",", ".")))
            for m in re.finditer(r"\d+", s):
                numeros.append(float(m.group(0)))
    recorrer(obj)
    return textos, numeros


def ids_del_paquete(paquete: dict) -> set[str]:
    textos, _ = _valores(paquete)
    ids: set[str] = set()
    for t in textos:
        ids.update(m.group(0) for m in PATRON_ID.finditer(t))
    return ids


def verificar_respuesta(respuesta: str, paquete: dict) -> list[str]:
    violaciones: list[str] = []
    ids_validos = ids_del_paquete(paquete)
    for m in PATRON_ID.finditer(respuesta):
        ident = m.group(0).rstrip(".")
        if ident not in ids_validos:
            violaciones.append(f"ID no respaldado por el paquete: {ident}")
    for cita in re.findall(r"\[([^\]]+)\]", respuesta):
        for parte in re.split(r"[,;]\s*", cita):
            parte = parte.strip()
            if parte and PATRON_ID.fullmatch(parte) is None:
                violaciones.append(f"Cita con formato inválido: [{parte}]")
    _, numeros = _valores(paquete)
    for m in PATRON_DECIMAL.finditer(respuesta):
        texto_num = m.group(1).replace(",", ".")
        valor = float(texto_num)
        decimales = len(texto_num.split(".")[1])
        tolerancia = 0.5 * 10 ** (-decimales) + 1e-9
        if not any(abs(valor - n) <= tolerancia for n in numeros):
            violaciones.append(f"Número no respaldado por el paquete: {m.group(1)}")
    palabras = len(respuesta.split())
    if palabras < 15:
        violaciones.append("Respuesta demasiado breve para justificar la conclusión.")
    if palabras > 300:
        violaciones.append(f"Respuesta demasiado extensa ({palabras} palabras).")
    return sorted(set(violaciones))


def _n(x: Any, nd: int = 3) -> str:
    return "null" if x is None else (f"{x:.{nd}f}" if isinstance(x, float) else str(x))


def _lista(xs: Any) -> str:
    return ", ".join(xs) if xs else "ninguna"


def hechos_verificables(paquete: dict) -> tuple[list[str], dict]:
    """Lectura determinística del paquete: frases cortas construidas solo con valores recuperados de Neo4j.
    Devuelve también lo que la respuesta debe cubrir (IDs y estados) para el control de cobertura."""
    hechos: list[str] = []
    ids_req: list[str] = []
    estados_req: list[str] = []
    for ev in paquete.get("evaluaciones", []):
        hechos.append(f"Requerimiento {ev['requerimiento_id']} («{ev['texto_requerimiento']}»), documento {ev['documento_id']}: "
                      f"la evaluación {ev['evaluacion_id']} quedó {ev['estado']} por la regla {_lista(ev['reglas_evaluacion'])}.")
        ids_req.append(ev["evaluacion_id"])
        estados_req.append(ev["estado"])
        if not ev["vigente"] and ev["reevaluada_por"]:
            hechos.append(f"La evaluación {ev['evaluacion_id']} fue reevaluada por {_lista(ev['reevaluada_por'])}: su resultado se conserva "
                          f"como historia de la versión {ev['version']} y no es el estado vigente.")
        for inc in ev.get("incidencias", []):
            hechos.append(f"Incidencia {inc['id']}: causa {inc['causa']} ({inc['descripcion']}); acción: {inc['accion_correccion']}; "
                          f"regla {_lista(inc['reglas'])}. No se emitieron juicios de calidad.")
            ids_req.append(inc["id"])
        for j in ev.get("juicios", []):
            frase = (f"Criterio {j['criterio']}: {j['estado']} [{j['juicio_id']}] por la regla {_lista(j['reglas'])}. "
                     f"Justificación registrada: «{j['justificacion']}».")
            if j.get("grado_ambiguedad") is not None:
                frase += f" Grado de ambigüedad {_n(j['grado_ambiguedad'])}, banda {j['banda_difusa']}."
            for r in j.get("resultados", []):
                frase += f" Genera {r['clase']} {r['id']}"
                if r.get("dato_faltante"):
                    frase += f" (dato faltante: {r['dato_faltante']})"
                if r.get("severidad"):
                    frase += f" con severidad propuesta {r['severidad']}"
                frase += "."
            hechos.append(frase)
            estados_req.append(j["estado"])
    for g in paquete.get("juicios_de_ambiguedad", []):
        hechos.append(f"Juicio {g['juicio_id']} del requerimiento {g['requerimiento_id']} («{g['texto_requerimiento']}»): estado "
                      f"{g['estado_juicio']} por la regla {_lista(g['reglas_juicio'])}. Justificación registrada: «{g['justificacion']}».")
        ids_req.append(g["juicio_id"])
        estados_req.append(g["estado_juicio"])
        if g.get("grado_ambiguedad") is None:
            hechos.append(f"No hay grado de ambigüedad calculado para {g['juicio_id']}: la base no registra una valoración confirmada "
                          f"de divergencia y delimitación (valoracion_confirmada = {_n(g.get('valoracion_confirmada'))}). No debe estimarse.")
        else:
            entradas = [e for e in g.get("etiquetas", []) if e.get("pertenencia_entrada") is not None and e["pertenencia_entrada"] >= 0.01]
            pert = "; ".join(f"{e['variable']} {e['etiqueta']} {_n(e['pertenencia_entrada'])}" for e in entradas)
            hechos.append(f"Entradas valoradas: Divergencia_Lecturas = {g['divergencia_lecturas']} y Delimitacion_Contexto = "
                          f"{g['delimitacion_contexto']}. Pertenencias relevantes: {pert}.")
            reglas = {r["id"]: r for r in g.get("reglas_difusas", [])}
            acts = sorted(zip(g.get("reglas_difusas_activadas") or [], g.get("activaciones") or []), key=lambda a: -a[1])
            hechos.append("Activación de las reglas difusas: " + "; ".join(
                f"{rid} {_n(a)} (antecedente {reglas.get(rid, {}).get('antecedente')}, salida {reglas.get(rid, {}).get('salida')})"
                for rid, a in acts) + f". La regla dominante es {acts[0][0]}." if acts else "")
            hechos.append(f"Resultado: grado {_n(g['grado_ambiguedad'])}, banda {g['banda_difusa']}, calculado con {g['modelo_id']} "
                          f"({g['modelo_metodo']}), modelo en estado {g['modelo_estado_validacion']}, fuente {g['fuente_modelo']}. "
                          "El grado mide intensidad y no cambia el estado del juicio.")
            asociadas = sorted({r.get("regla_crisp") for r in g.get("reglas_difusas", []) if r.get("regla_crisp")})
            if asociadas:
                hechos.append(f"Las reglas difusas citan como antecedente crisp a {_lista(asociadas)}; esa referencia documenta su "
                              f"origen y no es la regla que decidió el estado del juicio ({_lista(g['reglas_juicio'])}).")
            if g.get("revision_senior_requerida"):
                hechos.append("La banda media marca un caso de frontera: revision_senior_requerida = true.")
    for j in paquete.get("juicios", []):
        grado = (f"grado {_n(j['grado_ambiguedad'])}, banda {j['banda_difusa']}" if j.get("grado_ambiguedad") is not None
                 else "sin grado calculado")
        hechos.append(f"{j['juicio_id']}: requerimiento {j['requerimiento_id']} («{j['texto_requerimiento']}»), criterio "
                      f"{j['criterio']}, estado {j['estado']} por {_lista(j['reglas'])}; {grado}.")
        ids_req.append(j["juicio_id"])
    for sg in paquete.get("seguimiento", []):
        hechos.append(f"Observación {sg['observacion_id']} emitida por {sg['modulo_origen']} en {sg['evaluacion_origen_id']} sobre "
                      f"{sg['documento_origen_id']} (reglas {_lista(sg['reglas_origen'])}). Descripción histórica: «{sg['descripcion']}».")
        hechos.append(f"Decisión vigente {sg['decision_id']}: prioridad {sg['prioridad']}, motivo {sg['motivo']}, seguimiento "
                      f"{sg['estado']} (regla {_lista(sg['reglas_decision'])}); provisional = {str(sg['provisional']).lower()}, "
                      f"emitible = {str(sg['emitible']).lower()}, tratamiento activo = {str(sg['tratamiento_activo']).lower()}.")
        hechos.append(f"Evaluación vigente {sg['evaluacion_id']} sobre {sg['documento_id']}: {sg['estado_evaluacion_vigente']}. "
                      f"Grado de ambigüedad de origen {_n(sg.get('grado_ambiguedad_origen'))} y vigente {_n(sg.get('grado_ambiguedad'))}.")
        ids_req.extend([sg["observacion_id"], sg["evaluacion_origen_id"], sg["evaluacion_id"]])
        estados_req.append(sg["estado"])
    for h in paquete.get("historial", []):
        juicios = ", ".join(f"{j['criterio']} {j['estado']}" for j in h.get("juicios", []))
        frase = (f"Versión {h['version']} ({h['requerimiento_id']}, «{h['texto_requerimiento']}»): evaluación {h['evaluacion_id']} "
                 f"{h['estado']} por {_lista(h['reglas_evaluacion'])}; juicios: {juicios}.")
        if h.get("reevalua_a"):
            frase += (f" REEVALUA a {h['reevalua_a']} (evento {h['evento_retorno']}, resultado {h['resultado_reevaluacion']}).")
        for a in h.get("respuestas_consideradas", []):
            frase += f" Respuesta considerada {a['id']} ({a['estado_validacion']}): «{a['contenido']}»."
        for ca in h.get("criterio_aceptacion", []):
            frase += f" Criterio de aceptación {ca['id']}: {ca['condicion_aprobacion']} ({ca['metodo']})."
        hechos.append(frase)
        ids_req.append(h["evaluacion_id"])
        vistas: set[str] = set()
        for o in h.get("observaciones", []):
            for q in o.get("preguntas", []):
                for a in q.get("respuestas", []):
                    if a["id"] not in vistas:
                        vistas.add(a["id"])
                        hechos.append(f"Pregunta {q['id']} («{q['texto']}»): respuesta {a['id']} con estado {a['estado_validacion']}, «{a['contenido']}».")
            estados = ", ".join(f"{d['decision_id']} {d['estado']}" for d in o.get("seguimiento", []))
            if estados:
                hechos.append(f"{o['clase']} {o['id']} de la versión {h['version']}: decisiones {estados}.")
    for r in paquete.get("reglas", []):
        if r.get("descripcion"):
            hechos.append(f"Regla {r['id']} (estado {r['estado_validacion']}, {r.get('fuente') or 'PG1'}): {r['descripcion']}")
    textos, _ = _valores(paquete)
    if "candidata" in textos or any(sg.get("provisional") for sg in paquete.get("seguimiento", [])):
        hechos.append("Las reglas y modelos citados tienen estado candidata: el resultado es provisional, del prototipo académico, "
                      "sin validación experta. La respuesta debe decirlo con la palabra «provisional».")
    ids_obligatorios = list(dict.fromkeys(ids_req))[:12]
    permitidos = sorted(_estados_del_paquete(paquete))
    prohibidos = [e for e in ESTADOS_DOMINIO if e not in permitidos]
    if ids_obligatorios:
        hechos.append(f"La respuesta debe mencionar estos IDs: {_lista(ids_obligatorios)}.")
    hechos.append(f"Estados que figuran en el paquete: {_lista(permitidos) if permitidos else 'ninguno'}. Las descripciones de las "
                  "reglas son condiciones generales, no conclusiones sobre este caso: no escribas las palabras "
                  f"{_lista(['«' + e + '»' for e in prohibidos])} en la respuesta.")
    return [h for h in hechos if h], {"ids": ids_obligatorios, "estados": sorted(set(estados_req))}


ESTADOS_DOMINIO = ("cumple", "incumple", "pendiente", "observado", "sin hallazgo", "no evaluable", "resuelto", "por consultar")


def _estados_del_paquete(paquete: dict, con_reglas: bool = False) -> set[str]:
    textos, _ = _valores(paquete)
    estados = {t.replace("_", " ").lower() for t in textos if t.replace("_", " ").lower() in ESTADOS_DOMINIO}
    if con_reglas:
        # Citar la condición de una regla recuperada del grafo es legítimo: sus palabras de estado no se tratan como inventadas.
        for r in paquete.get("reglas", []):
            descripcion = (r.get("descripcion") or "").lower()
            estados |= {e for e in ESTADOS_DOMINIO if re.search(r"\b" + re.escape(e) + r"\b", descripcion)}
    return estados


def controles_criterios_pg2(respuesta: str, paquete: dict) -> list[str]:
    """Criterios de aceptación de PG2 §4.3 y segunda mitad de GL05 (el LLM no altera conclusiones)."""
    violaciones: list[str] = []
    texto = respuesta.replace("_", " ").lower()
    permitidos = _estados_del_paquete(paquete, con_reglas=True)
    for estado in ESTADOS_DOMINIO:
        if re.search(rf"\b{estado}\b", texto) and estado not in permitidos:
            violaciones.append(f"Usa el estado «{estado}», que no figura en el paquete (alteraría una conclusión)")
    textos, _ = _valores(paquete)
    candidato = "candidata" in textos or any(
        isinstance(sg, dict) and sg.get("provisional") for sg in paquete.get("seguimiento", []))
    if candidato and not re.search(r"provisional|candidat|validaci[oó]n experta", texto):
        violaciones.append("No aclara que el resultado es provisional o candidato, sin validación experta")
    return violaciones


def _cobertura(respuesta: str, requisitos: dict) -> list[str]:
    texto = respuesta.replace("_", " ").lower()
    faltan = [f"No menciona {i}" for i in requisitos.get("ids", []) if i not in respuesta]
    faltan += [f"No menciona el estado «{e}»" for e in requisitos.get("estados", []) if e and e.replace("_", " ").lower() not in texto]
    return faltan


def _limpiar_formato(texto: str) -> str:
    texto = texto.replace("—", "-").replace("–", "-")
    texto = re.sub(r"^\s*#+\s*", "", texto, flags=re.MULTILINE)
    texto = texto.replace("**", "")
    return texto.strip()


def explicar(llm: ClienteOllama, prompts: dict, texto: str, paquete: dict) -> tuple[str, dict]:
    hechos, requisitos = hechos_verificables(paquete)
    traza: dict[str, Any] = {"intentos": [], "hechos_verificables": hechos, "cobertura_requerida": requisitos}
    base = (f"CONSULTA DEL USUARIO:\n{texto}\n\nHECHOS VERIFICABLES (lectura del paquete, en orden):\n"
            + "\n".join(f"- {h}" for h in hechos)
            + f"\n\nPAQUETE DE EVIDENCIA (JSON recuperado de Neo4j):\n{json.dumps(paquete, ensure_ascii=False, indent=1)}")
    mensaje = base
    for intento in (1, 2, 3):
        crudo, meta = llm.chat(prompts["explicacion"], mensaje, llm.cfg.temperatura_explicacion, max_tokens=650)
        respuesta = _limpiar_formato(crudo)
        violaciones = (verificar_respuesta(respuesta, paquete) + controles_criterios_pg2(respuesta, paquete)
                       + _cobertura(respuesta, requisitos))
        traza["intentos"].append({"intento": intento, "respuesta": respuesta, "violaciones": violaciones, **meta})
        if not violaciones:
            traza["resultado_verificacion"] = "aprobada"
            return respuesta, traza
        mensaje = (base + "\n\nTu respuesta anterior fue rechazada por el verificador de fidelidad (GL05) por: "
                   + "; ".join(violaciones) + ". Reescribila usando solo IDs y números del paquete y cubriendo los hechos indicados.")
    traza["resultado_verificacion"] = "rechazada; se emite la respuesta de respaldo"
    return respuesta_respaldo(paquete), traza


def respuesta_respaldo(paquete: dict) -> str:
    """Explicación determinística mínima cuando el LLM no supera el verificador."""
    partes = ["No pude generar una explicación verificable; resumo los datos recuperados de la base sin interpretarlos. "
              "Son resultados provisionales del prototipo, sin validación experta."]
    for ev in paquete.get("evaluaciones", []):
        juicios = "; ".join(f"{j['criterio']}: {j['estado']} [{j['juicio_id']}]" for j in ev.get("juicios", []))
        partes.append(f"Evaluación {ev['evaluacion_id']} ({ev['estado']}) de {ev['requerimiento_id']}. {juicios}".strip())
    for g in paquete.get("juicios_de_ambiguedad", []):
        partes.append(f"Juicio {g['juicio_id']}: estado {g['estado_juicio']}, grado {g['grado_ambiguedad']}, "
                      f"banda {g['banda_difusa']}.")
    for j in paquete.get("juicios", []):
        partes.append(f"{j['juicio_id']} ({j['requerimiento_id']}): {j['criterio']} {j['estado']}.")
    for s in paquete.get("seguimiento", []):
        partes.append(f"Observación {s['observacion_id']}: seguimiento {s['estado']} en la decisión {s['decision_id']}.")
    for h in paquete.get("historial", []):
        partes.append(f"Versión {h['version']} ({h['requerimiento_id']}): evaluación {h['evaluacion_id']} {h['estado']}.")
    return "\n".join(partes)


# --------------------------------------------------------------------------------------------
# Orquestador
# --------------------------------------------------------------------------------------------
def resumen_resultado(paquete: dict) -> list[str]:
    lineas: list[str] = []
    for ev in paquete.get("evaluaciones", []):
        lineas.append(f"{ev['evaluacion_id']} · {ev['requerimiento_id']} · estado {ev['estado']}"
                      f" · vigente={ev['vigente']} · reglas {ev['reglas_evaluacion']}")
        for inc in ev.get("incidencias", []):
            lineas.append(f"   incidencia {inc['id']}: {inc['causa']} {inc['reglas']}")
        for j in ev.get("juicios", []):
            grado = f" · grado {j['grado_ambiguedad']:.3f} ({j['banda_difusa']})" if j.get("grado_ambiguedad") is not None else ""
            res = ",".join(r["id"] for r in j.get("resultados", []))
            lineas.append(f"   {j['criterio']:<15} {j['estado']:<10} {j['reglas']}{grado}{' -> ' + res if res else ''}")
    for g in paquete.get("juicios_de_ambiguedad", []):
        grado = f"{g['grado_ambiguedad']:.6f}" if g.get("grado_ambiguedad") is not None else "null"
        lineas.append(f"{g['juicio_id']} · estado {g['estado_juicio']} · x={g['divergencia_lecturas']} "
                      f"y={g['delimitacion_contexto']} · grado {grado} · banda {g['banda_difusa']} · "
                      f"cálculo {g['estado_calculo_difuso']} · modelo {g['modelo_id']}")
        if g.get("activaciones"):
            lineas.append(f"   activaciones {dict(zip(g['reglas_difusas_activadas'], g['activaciones']))}")
    for j in paquete.get("juicios", []):
        lineas.append(f"{j['juicio_id']} · {j['estado']} · {j['reglas']} · {j['requerimiento_id']}")
    for s in paquete.get("seguimiento", []):
        lineas.append(f"{s['observacion_id']} · decisión {s['decision_id']} · {s['prioridad']}/{s['motivo']} · "
                      f"seguimiento {s['estado']} · evaluación vigente {s['evaluacion_id']} ({s['estado_evaluacion_vigente']})")
    for h in paquete.get("historial", []):
        lineas.append(f"v{h['version']} · {h['evaluacion_id']} · {h['estado']} · reevalúa a {h['reevalua_a']} · "
                      f"respuestas {[r['id'] for r in h['respuestas_consideradas']]}")
    if paquete.get("reglas"):
        con_texto = sum(1 for r in paquete["reglas"] if r.get("descripcion"))
        lineas.append(f"reglas citadas: {[r['id'] for r in paquete['reglas']]} ({con_texto} con descripción en el grafo)")
    return lineas


class Asistente:
    def __init__(self, cfg: Config):
        self.cfg = cfg
        self.prompts = cargar_prompts()
        self.llm = ClienteOllama(cfg)
        self.kb = BaseConocimiento(cfg)
        DIR_EJECUCIONES.mkdir(exist_ok=True)

    def cerrar(self) -> None:
        self.kb.cerrar()

    def responder(self, texto: str, mostrar: bool = True, etiqueta: str | None = None) -> dict:
        inicio = time.perf_counter()
        traza: dict[str, Any] = {"prototipo": VERSION_PROTOTIPO, "fecha": dt.datetime.now().isoformat(timespec="seconds"),
                                 "modelo": self.cfg.modelo, "huella_prompts": self.prompts["huella"],
                                 "caso": etiqueta, "consulta_usuario": texto}
        if mostrar:
            print()
            print(T.c(T.GRIS, "─" * 100))
            titulo_etapa("1", "ENTRADA DEL USUARIO", etiqueta or "")
            print("    " + texto)

        motivo = validar_entrada(texto)
        if motivo:
            return self._cerrar_con_aclaracion(traza, "entrada_invalida", motivo + " " + MENSAJES_CONTROL["requiere_aclaracion"],
                                               inicio, mostrar, etapa="1")

        ext, traza_ext = extraer(self.llm, self.prompts, texto)
        traza_ext["json_validado"] = ext
        traza["extraccion"] = traza_ext
        if mostrar:
            seg = sum(i["segundos"] for i in traza_ext["intentos"])
            titulo_etapa("2", "EXTRACCIÓN CON LLM", f"prompt de extracción · salida JSON validada · {seg:.1f} s")
            if ext:
                print(json_por_clave(ext))
            for nota in traza_ext.get("notas", []):
                print(T.c(T.AMARILLO, "    " + nota))
        if ext is None:
            return self._cerrar_con_aclaracion(traza, "extraccion_invalida",
                                               "No pude interpretar la consulta con seguridad. " + MENSAJES_CONTROL["requiere_aclaracion"],
                                               inicio, mostrar, etapa="2")
        traza["intencion"] = ext["intencion"]
        if ext["intencion"] in INTENCIONES_CONTROL:
            return self._cerrar_con_aclaracion(traza, ext["intencion"], MENSAJES_CONTROL[ext["intencion"]], inicio, mostrar, etapa="3")

        rec, resolucion = recuperar(self.kb, ext, texto)
        traza["consultas_cypher"] = rec.consultas
        if resolucion:
            traza["resolucion_entidad"] = {"estado": resolucion.estado, "puntaje": resolucion.puntaje,
                                           "requerimiento": _resumen_requerimiento(resolucion.requerimiento)}
        if mostrar:
            titulo_etapa("3", "CONSULTA CYPHER A NEO4J", "plantillas parametrizadas de solo lectura")
            if resolucion:
                r = resolucion.requerimiento
                destino = f"{r['requerimiento_id']} (documento {r['documento_id']})" if r else "sin resolver"
                print(f"    resolución de entidad: {resolucion.estado} -> {destino}"
                      + (f" · coincidencia {resolucion.puntaje}" if resolucion.puntaje is not None else ""))
            for c in rec.consultas:
                print(f"    {T.c(T.CIAN, c['consulta'] + '.cypher')} {json.dumps(c['parametros'], ensure_ascii=False)}"
                      f" -> {c['filas']} fila(s) · {c['milisegundos']} ms")
        if rec.aclaracion:
            return self._cerrar_con_aclaracion(traza, rec.tipo_cierre, rec.aclaracion, inicio, mostrar, etapa="4")

        traza["paquete_evidencia"] = rec.paquete
        if mostrar:
            titulo_etapa("4", "RESULTADO ESTRUCTURADO RECUPERADO", "paquete de evidencia que recibe el LLM")
            for linea in resumen_resultado(rec.paquete):
                print("    " + linea)
            if self.cfg.detalle:
                print(json_compacto(rec.paquete, ancho=160))

        respuesta, traza_exp = explicar(self.llm, self.prompts, texto, rec.paquete)
        traza["explicacion"] = traza_exp
        traza["respuesta_final"] = respuesta
        traza["tipo_salida"] = "explicacion" if traza_exp["resultado_verificacion"] == "aprobada" else "respaldo"
        traza["segundos_totales"] = round(time.perf_counter() - inicio, 2)
        if mostrar:
            seg = sum(i["segundos"] for i in traza_exp["intentos"])
            titulo_etapa("5", "RESPUESTA GENERADA", f"prompt de explicación · {seg:.1f} s")
            for parrafo in respuesta.split("\n"):
                print(textwrap.fill(parrafo, 104, initial_indent="    ", subsequent_indent="    ") if parrafo.strip() else "")
            ultimo = traza_exp["intentos"][-1]
            estado = traza_exp["resultado_verificacion"]
            color = T.VERDE if estado == "aprobada" else T.ROJO
            print(T.c(color, f"    Verificación GL05: {estado} · intentos {len(traza_exp['intentos'])} · "
                             f"violaciones {len(ultimo['violaciones'])}"))
        self._guardar(traza, mostrar)
        return traza

    def _cerrar_con_aclaracion(self, traza: dict, tipo: str, mensaje: str, inicio: float, mostrar: bool, etapa: str) -> dict:
        traza.update({"tipo_salida": "aclaracion", "motivo_cierre": tipo, "respuesta_final": mensaje,
                      "segundos_totales": round(time.perf_counter() - inicio, 2)})
        if mostrar:
            titulo_etapa("5" if etapa != "1" else "2", "MENSAJE DE ACLARACIÓN", f"cierre determinístico: {tipo}")
            for linea in mensaje.split("\n"):
                print(T.c(T.AMARILLO, textwrap.fill(linea, 104, initial_indent="    ", subsequent_indent="      ")))
        self._guardar(traza, mostrar)
        return traza

    def _guardar(self, traza: dict, mostrar: bool) -> None:
        marca = dt.datetime.now().strftime("%Y%m%d_%H%M%S_%f")[:-3]
        nombre = f"{marca}_{traza.get('caso') or 'consulta'}.json"
        ruta = DIR_EJECUCIONES / nombre
        ruta.write_text(json.dumps(traza, ensure_ascii=False, indent=2), encoding="utf-8")
        traza["archivo_traza"] = f"{DIR_EJECUCIONES.name}/{nombre}"
        if mostrar:
            print(T.c(T.GRIS, f"    traza: {traza['archivo_traza']} · {traza['segundos_totales']} s en total"))


# --------------------------------------------------------------------------------------------
# Modos de ejecución
# --------------------------------------------------------------------------------------------
def modo_verificar(cfg: Config) -> int:
    ok = True
    print(T.c(T.NEGRITA, "Verificación del entorno de PI4"))
    try:
        p = cargar_prompts()
        print(T.c(T.VERDE, f"  [ok] prompts y esquema cargados (huella {p['huella']})"))
        for nombre in ("Q0_candidatos", "Q1_diagnostico", "Q2_grado_ambiguedad", "Q3_listado_juicios",
                       "Q4a_observaciones_requerimiento", "Q4_seguimiento_pg2", "Q5_historial", "Q6_reglas", "Q7_verificacion"):
            assert es_solo_lectura(cargar_consulta(nombre)), nombre
        print(T.c(T.VERDE, "  [ok] nueve consultas Cypher de solo lectura"))
    except (FileNotFoundError, AssertionError, json.JSONDecodeError) as e:
        print(T.c(T.ROJO, f"  [error] archivos del prototipo: {e}"))
        ok = False
    try:
        llm = ClienteOllama(cfg)
        modelos = llm.modelos_disponibles()
        if cfg.modelo in modelos or f"{cfg.modelo}:latest" in modelos:
            print(T.c(T.VERDE, f"  [ok] Ollama responde y el modelo {cfg.modelo} está descargado"))
        else:
            print(T.c(T.ROJO, f"  [error] el modelo {cfg.modelo} no está descargado. Ejecutar: ollama pull {cfg.modelo}"))
            print(f"          modelos disponibles: {modelos}")
            ok = False
    except ErrorLLM as e:
        print(T.c(T.ROJO, f"  [error] {e}. ¿Está abierta la aplicación Ollama?"))
        ok = False
    try:
        kb = BaseConocimiento(cfg)
        fila = kb.leer("Q7_verificacion")[0]
        kb.cerrar()
        print(T.c(T.VERDE, f"  [ok] Neo4j {cfg.neo4j_uri} · {fila}"))
        if fila["evaluaciones_sm1"] == 0:
            print(T.c(T.ROJO, "  [error] la base no contiene AuditIA_PG2. Cargar PG2 con ejecutar_pg2.py antes de usar PI4."))
            ok = False
        elif fila["publicadas"] < fila["evaluaciones_sm1"]:
            print(T.c(T.AMARILLO, "  [aviso] hay evaluaciones sin publicar: ¿se ejecutaron todos los scripts de PG2?"))
        if fila["reglas_con_descripcion"] == 0:
            print(T.c(T.AMARILLO, "  [aviso] las reglas no tienen descripción. Ejecutar una vez: python pi4_sm1_asistente.py --preparar"))
    except ErrorBase as e:
        print(T.c(T.ROJO, f"  [error] {e}"))
        ok = False
    print(T.c(T.VERDE if ok else T.ROJO, "Entorno listo." if ok else "Hay problemas que resolver antes de continuar."))
    return 0 if ok else 1


def modo_preparar(cfg: Config, confirmar: bool) -> int:
    print("Se incorporará a los nodos Regla de AuditIA_PG2 el texto SI...ENTONCES de 19 reglas de PG1 (sin sobrescribir).")
    if confirmar and input("¿Continuar? (s/n): ").strip().lower() not in ("s", "si", "sí"):
        print("Cancelado.")
        return 1
    kb = BaseConocimiento(cfg)
    n = kb.escribir_preparacion()
    fila = kb.leer("Q7_verificacion")[0]
    kb.cerrar()
    print(T.c(T.VERDE, f"Reglas documentadas: {n}. Reglas con descripción en el grafo: {fila['reglas_con_descripcion']}."))
    return 0


def evaluar_caso(caso: dict, traza: dict) -> dict:
    esperado = caso["esperado"]
    controles: dict[str, bool] = {}
    if "intencion" in esperado:
        controles["intencion"] = traza.get("intencion") == esperado["intencion"]
    controles["tipo_salida"] = (traza.get("tipo_salida") == esperado["salida"]
                                if esperado["salida"] == "aclaracion" else traza.get("tipo_salida") == "explicacion")
    consultas = [c["consulta"] for c in traza.get("consultas_cypher", [])]
    if "consulta" in esperado:
        controles["consulta_cypher"] = esperado["consulta"] in consultas
    if "requerimiento_id" in esperado:
        req = (traza.get("resolucion_entidad") or {}).get("requerimiento") or {}
        controles["entidad"] = esperado["requerimiento_id"] in (req.get("requerimiento_id"), req.get("id_logico"))
    if "observacion_id" in esperado:
        seguimiento = (traza.get("paquete_evidencia") or {}).get("seguimiento", [])
        controles["observacion"] = any(s.get("observacion_id") == esperado["observacion_id"] for s in seguimiento)
    return {"caso": caso["id"], "consulta": caso["consulta"], "controles": controles, "aprobado": all(controles.values()),
            "intencion": traza.get("intencion"), "tipo_salida": traza.get("tipo_salida"),
            "consultas_cypher": consultas, "segundos": traza.get("segundos_totales"), "traza": traza.get("archivo_traza")}


def modo_casos(asistente: Asistente, filtro: list[str] | None) -> int:
    casos = json.loads(leer_texto(BASE / "casos_prueba.json"))["casos"]
    if filtro:
        casos = [c for c in casos if c["id"] in filtro]
    resultados = []
    for caso in casos:
        traza = asistente.responder(caso["consulta"], mostrar=True, etiqueta=caso["id"])
        resultados.append(evaluar_caso(caso, traza))
    print()
    print(T.c(T.NEGRITA, "Resumen de la batería de casos"))
    for r in resultados:
        marca = T.c(T.VERDE, "PASÓ ") if r["aprobado"] else T.c(T.ROJO, "FALLÓ")
        print(f"  {marca} {r['caso']:<3} intención={r['intencion']} · salida={r['tipo_salida']} · "
              f"{r['controles']} · {r['segundos']} s")
    aprobados = sum(r["aprobado"] for r in resultados)
    print(T.c(T.NEGRITA, f"  {aprobados}/{len(resultados)} casos aprobados"))
    ruta_resumen = DIR_EJECUCIONES / "resumen_casos.json"
    if filtro and ruta_resumen.exists():
        # Corrida parcial: se actualizan solo los casos ejecutados y se conservan los demás.
        nuevos = {r["caso"]: r for r in resultados}
        previos = {r["caso"]: r for r in json.loads(leer_texto(ruta_resumen)).get("resultados", [])}
        previos.update(nuevos)
        orden = [c["id"] for c in json.loads(leer_texto(BASE / "casos_prueba.json"))["casos"]]
        resultados = [previos[i] for i in orden if i in previos]
        aprobados = sum(r["aprobado"] for r in resultados)
    resumen = {"prototipo": VERSION_PROTOTIPO, "fecha": dt.datetime.now().isoformat(timespec="seconds"),
               "modelo": asistente.cfg.modelo, "huella_prompts": asistente.prompts["huella"],
               "aprobados": aprobados, "total": len(resultados), "resultados": resultados}
    ruta_resumen.write_text(json.dumps(resumen, ensure_ascii=False, indent=2), encoding="utf-8")
    print(T.c(T.GRIS, "  resumen guardado en ejecuciones/resumen_casos.json"))
    return 0 if aprobados == len(resultados) else 1


def modo_interactivo(asistente: Asistente) -> int:
    print(T.c(T.NEGRITA + T.AZUL, "AuditIA · SM1 · Asistente de evaluación de calidad individual (PI4)"))
    print(T.c(T.GRIS, f"Modelo {asistente.cfg.modelo} · Neo4j {asistente.cfg.neo4j_uri} · "
                      "escribí 'salir' para terminar o 'catalogo' para ver los requerimientos"))
    while True:
        try:
            texto = input(T.c(T.NEGRITA, "\nConsulta> ")).strip()
        except (EOFError, KeyboardInterrupt):
            print()
            break
        if texto.lower() in ("salir", "exit", "quit"):
            break
        if texto.lower() == "catalogo":
            print(_lista_catalogo(asistente.kb.leer("Q0_candidatos")))
            continue
        try:
            asistente.responder(texto)
        except (ErrorLLM, ErrorBase) as e:
            print(T.c(T.ROJO, f"Error de infraestructura: {e}"))
    return 0


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="AuditIA PI4 · SM1 · LLM + Neo4j (patrón sándwich)")
    ap.add_argument("-p", "--pregunta", help="ejecuta una sola consulta y termina")
    ap.add_argument("--casos", nargs="*", metavar="ID", help="ejecuta la batería de casos (opcionalmente solo algunos IDs)")
    ap.add_argument("--verificar", action="store_true", help="comprueba Neo4j, Ollama y los archivos del prototipo")
    ap.add_argument("--preparar", action="store_true", help="incorpora una vez el texto de las reglas de PG1 al grafo")
    ap.add_argument("--si", action="store_true", help="no pedir confirmación en --preparar")
    ap.add_argument("--uri", help="URI Bolt de Neo4j (por defecto bolt://localhost:7687)")
    ap.add_argument("--usuario", help="usuario de Neo4j (por defecto neo4j)")
    ap.add_argument("--database", help="base de datos de Neo4j (por defecto neo4j)")
    ap.add_argument("--modelo", help="modelo de Ollama (por defecto qwen2.5:7b)")
    ap.add_argument("--ollama-url", help="URL de Ollama (por defecto http://localhost:11434)")
    ap.add_argument("--hilos", type=int, help="hilos de CPU que usa Ollama (num_thread); por defecto, todos")
    ap.add_argument("--detalle", action="store_true", help="muestra el paquete de evidencia completo")
    ap.add_argument("--sin-color", action="store_true", help="desactiva colores ANSI")
    args = ap.parse_args(argv)

    preparar_terminal(args.sin_color)
    cfg = Config()
    cfg.neo4j_uri = args.uri or cfg.neo4j_uri
    cfg.neo4j_usuario = args.usuario or cfg.neo4j_usuario
    cfg.neo4j_database = args.database or cfg.neo4j_database
    cfg.modelo = args.modelo or cfg.modelo
    cfg.ollama_url = args.ollama_url or cfg.ollama_url
    cfg.hilos = args.hilos
    cfg.detalle = args.detalle
    if cfg.neo4j_password is None:
        cfg.neo4j_password = getpass.getpass(f"Contraseña de Neo4j para '{cfg.neo4j_usuario}': ")

    try:
        if args.verificar:
            return modo_verificar(cfg)
        if args.preparar:
            return modo_preparar(cfg, confirmar=not args.si)
        asistente = Asistente(cfg)
        try:
            if args.pregunta:
                asistente.responder(args.pregunta)
                return 0
            if args.casos is not None:
                return modo_casos(asistente, args.casos or None)
            return modo_interactivo(asistente)
        finally:
            asistente.cerrar()
    except (ErrorBase, ErrorLLM, FileNotFoundError) as e:
        print(T.c(T.ROJO, f"Error: {e}"))
        return 2


if __name__ == "__main__":
    sys.exit(main())
