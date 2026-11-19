#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
AuditIA · PI4 · Submódulo SM3 (Priorización y clarificación)
Integración de un LLM local (Ollama) con la base de conocimiento de PG2 en Neo4j.

Patrón sándwich:
  texto del usuario -> LLM de extracción (JSON estricto) -> consulta Cypher parametrizada de solo lectura
  -> resultado estructurado de Neo4j -> LLM de explicación -> verificador de fidelidad (GL05) -> respuesta.

Autor: Lucero, Bruno · Grupo 10 · Inteligencia Artificial · UTN FRM · 2026

Uso rápido:
  python pi4_sm3_asistente.py --verificar          # comprueba Neo4j, Ollama y archivos
  python pi4_sm3_asistente.py --preparar           # (una vez) incorpora el texto de las reglas PRC de PG1 al grafo
  python pi4_sm3_asistente.py                      # modo interactivo
  python pi4_sm3_asistente.py -p "¿Por qué H-DESC es bloqueante?"
  python pi4_sm3_asistente.py --casos C1 --hilos 4 # ejecuta un caso de la batería

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

VERSION_PROTOTIPO = "PI4-SM3-1.0"
# Las notificaciones informativas del servidor (por ejemplo, nulos ignorados por count) no son errores.
logging.getLogger("neo4j.notifications").setLevel(logging.ERROR)
logging.getLogger("neo4j").setLevel(logging.ERROR)
BASE = Path(__file__).resolve().parent
DIR_CONSULTAS = BASE / "consultas"
DIR_PROMPTS = BASE / "prompts"
DIR_EJECUCIONES = BASE / "ejecuciones"

INTENCIONES_CONSULTA = ("listar_prioridades", "fundamento_prioridad", "urgencia_difusa", "clarificacion",
                        "consulta_matriz", "revision_senior", "informe_documento")
INTENCIONES_CONTROL = ("otro_submodulo", "accion_no_permitida", "fuera_de_dominio", "requiere_aclaracion")
CONSULTAS_LECTURA = ("Q0_observaciones", "Q1_listado_prioridades", "Q2_fundamento_decision", "Q3_urgencia_difusa",
                     "Q4_seguimiento_pg2", "Q5_clarificacion", "Q6_matriz_mpr01", "Q7_revision_senior",
                     "Q8_informe_documento", "Q9_reglas", "Q10_verificacion")
MAX_FILAS_LISTADO = 12

# Patrón de identificadores del grafo PG2 (observaciones, decisiones, preguntas, reglas, celdas, modelos, etc.).
PATRON_ID = re.compile(
    r"\bGL\d{2}\b|\b(?:RQ|EV|J|H|P|R|D|ER|E|IE|DOC|MD|MPR|AMB|URG|CONTR|EVI|PRC|ACC|Q|A|INF|SV|X|CR|CA|CTX|S|REV|RET|RESP|CQ)"
    r"-[A-Za-z0-9](?:[A-Za-z0-9.]|-(?=[A-Za-z0-9]))*"
)
PATRON_REGLA = re.compile(r"^(?:GL\d{2}|EVI-(?:RD|HC)\d{2}|PRC-(?:RD|HC)\d{2}|ACC-(?:RD|HC)\d{2})$")
PATRON_DECIMAL = re.compile(r"(?<![\w.,])(\d+[.,]\d+)(?![\w])")
CRITERIOS = ("atomicidad", "ambiguedad", "verificabilidad", "completitud")


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
        cypher = cargar_consulta("P0_reglas_prc")
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
    tipos = {"object": dict, "array": list, "string": str, "integer": int, "boolean": bool, "null": type(None)}
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
    for clave in ("observacion_id", "documento_id"):
        valor = ent.get(clave)
        if valor is None:
            continue
        valor = canonizar_id(valor)
        if valor not in literales:
            notas.append(f"GL05: se descartó {clave}={valor!r} porque no aparece en la consulta del usuario.")
            ent[clave] = None
        else:
            ent[clave] = valor
    if ent.get("observacion_texto") is not None and not ent["observacion_texto"].strip():
        ent["observacion_texto"] = None
    # Una observación puntual no se lista: si el modelo eligió listar con un ID literal, se consulta su fundamento.
    if ext["intencion"] == "listar_prioridades" and ent.get("observacion_id"):
        notas.append(f"Se consulta el fundamento de {ent['observacion_id']}: una observación puntual no se lista.")
        ext["intencion"] = "fundamento_prioridad"
    # Filtros y valores de matriz solo los usa la intención que los consulta; en otra intención se anulan.
    if ext["intencion"] != "listar_prioridades" and (ext["filtros"]["prioridad"] or ext["filtros"]["motivo"]):
        notas.append(f"Se ignoran los filtros de prioridad y motivo: la intención {ext['intencion']} no los usa.")
        ext["filtros"]["prioridad"] = ext["filtros"]["motivo"] = None
    if ext["intencion"] != "consulta_matriz" and (ext["matriz"]["severidad"] or ext["matriz"]["criticidad"]):
        notas.append(f"Se ignoran los valores de matriz: la intención {ext['intencion']} no los usa.")
        ext["matriz"]["severidad"] = ext["matriz"]["criticidad"] = None
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
sistema debe deben requerimiento requerimientos requisito requisitos observacion observaciones hallazgo hallazgos
pendiente pendientes prioridad prioridades decision decisiones problema problemas defecto tema caso quedo queda
bloqueante urgencia pregunta preguntas cliente respuesta
""".split())
# Fragmentos de ID que no describen el tema de una observación (prefijos, versión y rótulos de prueba).
_TOKENS_ID_GENERICOS = {"h", "p", "r", "j", "ev", "d", "doc", "v1", "v2", "prio", "mayor", "menor", "fuera", "rango",
                        "sin", "hito", "dato"}


def normalizar(texto: str) -> str:
    sin_tildes = "".join(c for c in unicodedata.normalize("NFD", texto.lower()) if unicodedata.category(c) != "Mn")
    return re.sub(r"[^a-z0-9 ]+", " ", sin_tildes)


def raices(texto: str) -> set[str]:
    """Raíces de cinco letras: absorben plural y derivación (carga/cargar, descuento/descuentos)."""
    return {p[:5] for p in normalizar(texto).split() if len(p) > 2 and p not in _VACIAS}


def texto_busqueda(obs: dict) -> str:
    tokens_id = [t for t in obs["observacion_id"].lower().split("-") if t not in _TOKENS_ID_GENERICOS]
    partes = [obs.get("descripcion") or "", (obs.get("tipo_defecto") or "").replace("_", " "),
              obs.get("dato_faltante") or "", " ".join(obs.get("textos_requerimiento") or []), " ".join(tokens_id)]
    return " ".join(partes)


@dataclass
class Resolucion:
    estado: str                      # ok | multiple | sin_referencia | sin_coincidencia | sin_decision
    observaciones: list[dict] = field(default_factory=list)
    puntaje: float | None = None
    catalogo: list[dict] = field(default_factory=list)


def resolver_observacion(catalogo: list[dict], ext: dict) -> Resolucion:
    ent = ext["entidades"]
    if ent.get("observacion_id"):
        exacto = [o for o in catalogo if o["observacion_id"] == ent["observacion_id"]]
        if not exacto:
            return Resolucion("sin_coincidencia", catalogo=catalogo)
        if exacto[0]["decision_id"] is None:
            return Resolucion("sin_decision", exacto, catalogo=catalogo)
        return Resolucion("ok", exacto, 1.0, catalogo=catalogo)
    if not ent.get("observacion_texto"):
        return Resolucion("sin_referencia", catalogo=catalogo)
    buscadas = raices(ent["observacion_texto"])
    if not buscadas:
        return Resolucion("sin_coincidencia", catalogo=catalogo)
    puntuados = []
    for o in catalogo:
        comunes = buscadas & raices(texto_busqueda(o))
        puntuados.append((len(comunes) / len(buscadas), o))
    mejor = max(p[0] for p in puntuados)
    if mejor < 0.5:
        return Resolucion("sin_coincidencia", puntaje=round(mejor, 2), catalogo=catalogo)
    tope = [p[1] for p in puntuados if p[0] == mejor]
    if len(tope) == 1:
        estado = "sin_decision" if tope[0]["decision_id"] is None else "ok"
        return Resolucion(estado, tope, round(mejor, 2), catalogo=catalogo)
    return Resolucion("multiple", tope, round(mejor, 2), catalogo=catalogo)


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


def _reglas_citadas(obj: Any, omitir: tuple[str, ...] = ("reglas_modelo",)) -> list[str]:
    encontrados: set[str] = set()

    def recorrer(x: Any) -> None:
        if isinstance(x, dict):
            for k, v in x.items():
                if k not in omitir:
                    recorrer(v)
        elif isinstance(x, list):
            for v in x:
                recorrer(v)
        elif isinstance(x, str) and PATRON_REGLA.match(x):
            encontrados.add(x)
    recorrer(obj)
    return sorted(encontrados)


def _principales(catalogo: list[dict]) -> list[dict]:
    """Observaciones con decisión que no derivan de forma automática de un juicio (R-J-*)."""
    return [o for o in catalogo if o["decision_id"] and not o["observacion_id"].startswith("R-J-")]


def _lista_observaciones(obs: list[dict], tope: int = 8) -> str:
    lineas = []
    for o in obs[:tope]:
        desc = (o.get("descripcion") or "").split(";")[0]
        lineas.append(f"  - {o['observacion_id']} ({o['tipo']}, {o['documento_id']}): «{desc}»")
    if len(obs) > tope:
        lineas.append(f"  ... y {len(obs) - tope} más.")
    return "\n".join(lineas)


def mensaje_resolucion(res: Resolucion, ext: dict) -> str:
    ent = ext["entidades"]
    if res.estado == "sin_referencia":
        return ("No identifiqué a qué observación te referís. Podés nombrarla por su ID o con palabras de su descripción. "
                "Observaciones principales con decisión de SM3 en la base:\n" + _lista_observaciones(_principales(res.catalogo), 14))
    if res.estado == "sin_coincidencia":
        ref = ent.get("observacion_id") or ent.get("observacion_texto")
        return (f"No encontré en la base de conocimiento una observación recibida por SM3 que coincida con «{ref}». "
                "No voy a suponer una ni a fabricar un paquete. Observaciones principales disponibles:\n"
                + _lista_observaciones(_principales(res.catalogo), 14))
    if res.estado == "sin_decision":
        o = res.observaciones[0]
        clase = {"incidencia_entrada": "una IncidenciaEntrada emitida", "hallazgo": "un Hallazgo emitido",
                 "pendiente": "un Pendiente emitido"}.get(o["tipo"], "un resultado emitido")
        return (f"{o['observacion_id']} es {clase} por {o['modulo_origen']} y no tiene decisión de prioridad en la "
                "base: según GL06, una IncidenciaEntrada vuelve al analista y no se prioriza.")
    if res.estado == "multiple":
        return (f"Tu descripción coincide con {len(res.observaciones)} observaciones. Indicá cuál querés consultar "
                "escribiendo su ID:\n" + _lista_observaciones(res.observaciones))
    return "No pude resolver la referencia de la observación."


def recuperar(kb: BaseConocimiento, ext: dict, texto: str) -> tuple[Recuperacion, Resolucion | None]:
    rec = Recuperacion()
    intencion = ext["intencion"]
    ent, filtros, matriz = ext["entidades"], ext["filtros"], ext["matriz"]
    resolucion: Resolucion | None = None
    paquete: dict[str, Any] = {"intencion": intencion, "consulta_usuario": texto,
                               "fuente": "Neo4j · base AuditIA_PG2 (PG2, Grupo 10)"}

    def cerrar(mensaje: str, tipo: str) -> tuple[Recuperacion, Resolucion | None]:
        rec.aclaracion, rec.tipo_cierre = mensaje, tipo
        return rec, resolucion

    necesita_observacion = intencion in ("fundamento_prioridad", "urgencia_difusa", "clarificacion") or (
        intencion == "informe_documento" and not ent.get("documento_id"))
    if necesita_observacion:
        catalogo = _ejecutar(kb, rec, "Q0_observaciones", {})
        resolucion = resolver_observacion(catalogo, ext)
        aceptable = resolucion.estado == "ok" or (
            resolucion.estado == "multiple" and intencion in ("clarificacion", "informe_documento"))
        if not aceptable:
            return cerrar(mensaje_resolucion(resolucion, ext), "aclaracion_resolucion")

    if intencion == "listar_prioridades":
        parametros = {"prioridad": filtros["prioridad"], "motivo": filtros["motivo"],
                      "documento_id": ent.get("documento_id"), "estado": filtros["estado_seguimiento"]}
        filas = _ejecutar(kb, rec, "Q1_listado_prioridades", parametros)
        if not filas:
            return cerrar("La base no registra decisiones vigentes de SM3 que cumplan esos filtros.", "sin_resultados")
        paquete["filtros_aplicados"] = parametros
        paquete["total_decisiones"] = len(filas)
        paquete["decisiones"] = filas[:MAX_FILAS_LISTADO]
        if len(filas) > MAX_FILAS_LISTADO:
            conteo: dict[tuple, int] = {}
            for f in filas:
                clave = (f["prioridad"], f["motivo"], f["estado"])
                conteo[clave] = conteo.get(clave, 0) + 1
            paquete["conteo_por_prioridad_motivo_estado"] = [
                {"prioridad": p, "motivo": m, "estado": e, "cantidad": n} for (p, m, e), n in conteo.items()]
            paquete["nota_de_recorte"] = f"Se muestran {MAX_FILAS_LISTADO} de {len(filas)} decisiones recuperadas."

    elif intencion == "fundamento_prioridad":
        oid = resolucion.observaciones[0]["observacion_id"]
        filas = _ejecutar(kb, rec, "Q2_fundamento_decision", {"observacion_id": oid})
        seguimiento = _ejecutar(kb, rec, "Q4_seguimiento_pg2", {"observacion_id": oid})
        if not filas:
            return cerrar(f"No encontré una decisión vigente para {oid}; no se fabrica un paquete.", "sin_resultados")
        paquete["fundamento"] = filas[0]["fundamento"]
        if seguimiento:
            paquete["seguimiento_pg2"] = seguimiento[0]["paquete"]

    elif intencion == "urgencia_difusa":
        oid = resolucion.observaciones[0]["observacion_id"]
        filas = _ejecutar(kb, rec, "Q3_urgencia_difusa", {"observacion_id": oid})
        if not filas:
            return cerrar(f"No encontré una decisión vigente para {oid}; no se fabrica un paquete.", "sin_resultados")
        paquete["urgencia"] = filas[0]["urgencia"]

    elif intencion == "clarificacion":
        ids = [o["observacion_id"] for o in resolucion.observaciones]
        filas = [f["clarificacion"] for f in _ejecutar(kb, rec, "Q5_clarificacion", {"observaciones": ids})]
        preguntas = {json.dumps(f["pregunta"], sort_keys=True, ensure_ascii=False) for f in filas}
        if len(filas) > 1 and (len(preguntas) != 1 or filas[0]["pregunta"] is None):
            return cerrar(mensaje_resolucion(resolucion, ext), "aclaracion_resolucion")
        paquete["pregunta"] = filas[0]["pregunta"]
        paquete["decisiones_aclaradas"] = [{k: v for k, v in f.items() if k != "pregunta"} for f in filas]

    elif intencion == "consulta_matriz":
        if not (matriz["severidad"] and matriz["criticidad"]):
            return cerrar("Para consultar la matriz MPR-01 necesito la severidad y la criticidad, cada una baja, media o alta. "
                          "La matriz solo se consulta con ambos valores conocidos (PRC-RD03).", "aclaracion_filtros")
        filas = _ejecutar(kb, rec, "Q6_matriz_mpr01", {"severidad": matriz["severidad"], "criticidad": matriz["criticidad"]})
        if not filas:
            return cerrar("La base no registra una celda de MPR-01 para esa combinación.", "sin_resultados")
        paquete["matriz"] = filas[0]["matriz"]

    elif intencion == "revision_senior":
        filas = _ejecutar(kb, rec, "Q7_revision_senior", {})
        if not filas:
            return cerrar("La base no registra recomendaciones abiertas que requieran revisión senior.", "sin_resultados")
        paquete["recomendaciones"] = filas

    elif intencion == "informe_documento":
        if ent.get("documento_id"):
            documentos = [ent["documento_id"]]
        else:
            documentos = sorted({o["documento_id"] for o in resolucion.observaciones})
        if len(documentos) > 1:
            return cerrar("Tu descripción corresponde a más de un documento (" + ", ".join(documentos)
                          + "). Indicá cuál querés consultar escribiendo su ID.", "aclaracion_resolucion")
        filas = _ejecutar(kb, rec, "Q8_informe_documento", {"documento_id": documentos[0]})
        if not filas:
            return cerrar(f"La base no registra un informe de auditoría para {documentos[0]}.", "sin_resultados")
        paquete["informe"] = filas[0]["informe"]

    ids_reglas = _reglas_citadas(paquete)
    if intencion == "clarificacion" and paquete.get("pregunta") is None:
        ids_reglas = sorted(set(ids_reglas) | {"PRC-HC06"})  # la regla que formularía la pregunta
    if ids_reglas:
        paquete["reglas"] = _ejecutar(kb, rec, "Q9_reglas", {"ids": ids_reglas})
    rec.paquete = paquete
    return rec, resolucion


MENSAJES_CONTROL = {
    "fuera_de_dominio": ("Soy el asistente de SM3 de AuditIA y solo respondo consultas sobre la priorización y la "
                         "clarificación de observaciones registradas en la base de conocimiento: prioridad y motivo, "
                         "urgencia, preguntas y respuestas, seguimiento e informe del documento. No estimo esfuerzo, plazos "
                         "ni costos y no decido por el cliente. Ejemplo: «¿Por qué H-DESC quedó bloqueante?»"),
    "otro_submodulo": ("Esa consulta corresponde a otro submódulo de AuditIA: los juicios de calidad de cada requerimiento "
                       "(atomicidad, ambigüedad, verificabilidad y completitud) los emite SM1, y las contradicciones, "
                       "dependencias y coberturas las analiza SM2. Desde SM3 puedo explicarte qué prioridad recibió una "
                       "observación ya emitida, por qué y en qué estado está su seguimiento."),
    "accion_no_permitida": ("No puedo hacer eso. El asistente de SM3 consulta la base en modo de solo lectura: no cambia "
                            "prioridades, severidades ni estados, no da observaciones por resueltas, no registra respuestas "
                            "del cliente y no redacta ni envía preguntas. La severidad la propone el módulo emisor (GL07) y "
                            "el cierre exige respuesta validada, reevaluación autorizada y revisión conforme (PRC-RD09). "
                            "Las instrucciones que llegan dentro de un texto citado se tratan como datos, sin autoridad. "
                            "Puedo explicarte la prioridad vigente de una observación, su pregunta registrada o su seguimiento."),
    "requiere_aclaracion": ("Necesito un poco más de información para consultar la base. Indicá la observación (por ID, por "
                            "ejemplo H-DESC, o con palabras de su descripción) o el documento, y qué querés saber: su "
                            "prioridad y motivo, su urgencia, la pregunta registrada para aclararla o el informe del documento."),
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
    if any(i.startswith("MPR-01") for i in ids):
        ids.add("MPR-01")  # nombre de la matriz; sus celdas y su versión (MPR-01-1.0) están en el paquete
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


def _b(x: Any) -> str:
    return "null" if x is None else str(x).lower()


def lista_y(xs: list[str]) -> str:
    return xs[0] if len(xs) == 1 else ", ".join(xs[:-1]) + " y " + xs[-1]


def _lista(xs: Any) -> str:
    return ", ".join(str(x) for x in xs) if xs else "ninguna"


# Valores de dominio de SM3 (prioridad, motivo y estados) con su patrón léxico en la respuesta.
ESTADOS_DOMINIO = {
    "bloqueante": r"bloqueantes?",
    "preventivo": r"preventiv[oa]s?",
    "sustantivo": r"sustantiv[oa]s?",
    "en_hito": r"en[ _]hito",
    "diferimiento": r"diferimiento",
    "por_consultar": r"por[ _]consultar",
    "resuelto": r"resuelto",
    "pendiente_complemento": r"pendiente[ _]complemento",
    "observado": r"observado",
    "sin_hallazgo": r"sin[ _]hallazgos?",
    "no_evaluable": r"no[ _]evaluable",
}
_NEGACION_PREVIA = re.compile(r"\b(no|ni|sin|nunca|todav[ií]a no|a diferencia de|en lugar de)\b[^.;:]{0,30}$")


def _no_negado(texto: str, inicio: int) -> bool:
    """True si la mención no está precedida por una negación en la misma cláusula."""
    return _NEGACION_PREVIA.search(texto[max(0, inicio - 45):inicio]) is None


def _decisiones_del_paquete(paquete: dict) -> list[dict]:
    """Registros con decisión de SM3 dentro del paquete (para provisionalidad, emisión y estado)."""
    salida = []
    for clave in ("decisiones", "recomendaciones", "decisiones_aclaradas"):
        salida.extend(paquete.get(clave) or [])
    for clave in ("fundamento", "urgencia", "seguimiento_pg2"):
        if paquete.get(clave):
            salida.append(paquete[clave])
    salida.extend((paquete.get("matriz") or {}).get("decisiones") or [])
    if paquete.get("informe"):
        salida.append({"emitible": paquete["informe"].get("emitible")})
        salida.extend(paquete["informe"].get("decisiones") or [])
    return salida


def _estado_decision(d: dict) -> str | None:
    return d.get("estado") or d.get("estado_seguimiento")


def _estados_del_paquete(paquete: dict, con_reglas: bool = False) -> set[str]:
    textos, _ = _valores(paquete)
    estados = {e for e in ESTADOS_DOMINIO if e in textos}
    if con_reglas:
        # Citar la condición de una regla recuperada del grafo es legítimo: sus palabras de estado no se tratan como inventadas.
        for r in paquete.get("reglas", []):
            descripcion = (r.get("descripcion") or "").lower()
            estados |= {e for e, rx in ESTADOS_DOMINIO.items() if re.search(rf"\b{rx}\b", descripcion)}
    return estados


def _menciona(valor: str, texto: str) -> bool:
    rx = ESTADOS_DOMINIO.get(valor, re.escape(valor.replace("_", " ")))
    return re.search(rf"\b{rx}\b", texto) is not None


def _hechos_reglas(paquete: dict) -> list[str]:
    hechos = []
    for r in paquete.get("reglas", []):
        if r.get("descripcion"):
            hechos.append(f"Regla {r['id']} (estado {r['estado_validacion']}, ejecución en PG2: {r['ejecucion']}, "
                          f"{r.get('fuente') or 'PG1'}): {r['descripcion']}")
        else:
            hechos.append(f"Regla {r['id']} (estado {r['estado_validacion']}, ejecución en PG2: {r['ejecucion']}): "
                          "la base no registra su texto.")
    return hechos


def _frase_decision(d: dict, oid: str | None = None) -> str:
    sujeto = f"{oid}: decisión vigente" if oid else "Decisión vigente"
    return (f"{sujeto} {d.get('decision_id') or d.get('decision')}, prioridad {d['prioridad']}, motivo {d['motivo']}, "
            f"regla {d.get('regla') or d.get('regla_decision')}, seguimiento {_estado_decision(d)}; "
            f"provisional = {_b(d.get('provisional'))}, emitible = {_b(d.get('emitible'))}.")


def hechos_verificables(paquete: dict) -> tuple[list[str], dict]:
    """Lectura determinística del paquete: frases cortas construidas solo con valores recuperados de Neo4j.
    Devuelve también lo que la respuesta debe cubrir (IDs y valores) para el control de cobertura."""
    hechos: list[str] = []
    ids_req: list[str] = []
    valores_req: list[str] = []

    if "decisiones" in paquete:  # listado de prioridades
        f = paquete["filtros_aplicados"]
        hechos.append(f"Filtros aplicados: prioridad {_n(f['prioridad'])}, motivo {_n(f['motivo'])}, documento "
                      f"{_n(f['documento_id'])}, estado {f['estado']}. Decisiones vigentes recuperadas: {paquete['total_decisiones']}. "
                      "El orden es el de la consulta: prioridad y, dentro de ella, grado de urgencia descendente.")
        filas = paquete["decisiones"]
        for n, d in enumerate(filas):
            urg = (f"grado_urgencia {_n(d['grado_urgencia'])}, banda {d['banda_urgencia']}" if d.get("grado_urgencia") is not None
                   else "grado_urgencia null (no calculado)")
            hechos.append(f"{d['observacion']} ({d['tipo']}, emitida por {d['modulo_origen']}, documento {d['documento']}; "
                          f"descripción «{d['descripcion']}»): decisión {d['decision']}, prioridad {d['prioridad']}, motivo "
                          f"{d['motivo']}, regla {d['regla']}, severidad {_n(d['severidad'])}, criticidad {_n(d['criticidad'])}, "
                          f"{urg}, seguimiento {d['estado']}; provisional = {_b(d['provisional'])}, emitible = {_b(d['emitible'])}.")
            if n < 6:
                ids_req.append(d["observacion"])
            if len(filas) <= 3:
                ids_req += [d["decision"], d["regla"]]
            valores_req += [d["prioridad"], d["motivo"], d["estado"]]
        if paquete.get("nota_de_recorte"):
            hechos.append(paquete["nota_de_recorte"] + " Conteo por prioridad, motivo y estado: " + "; ".join(
                f"{c['prioridad']} / {c['motivo']} / {c['estado']}: {c['cantidad']}"
                for c in paquete["conteo_por_prioridad_motivo_estado"]) + ".")

    if "fundamento" in paquete:
        f = paquete["fundamento"]
        frase = (f"Observación {f['observacion_id']} ({f['tipo']}) emitida por {f['modulo_origen']} en la evaluación "
                 f"{f['evaluacion_origen_id']}. Descripción registrada: «{f['descripcion_origen']}».")
        if f.get("dato_faltante_origen"):
            frase += f" Dato faltante del origen: {f['dato_faltante_origen']}."
        hechos.append(frase)
        sv = f["severidad"]
        if sv["valor"] is None:
            hechos.append(f"Severidad {sv['id']}: valor null (desconocida), propuesta por {sv['propuesta_por']}. SM3 no la "
                          "completa ni la modifica.")
        else:
            hechos.append(f"Severidad {sv['id']}: {sv['valor']} (grado_severidad {_n(sv['grado_severidad'])}), propuesta por "
                          f"{sv['propuesta_por']}. SM3 no la modifica.")
        cr = f.get("criticidad")
        if not cr or cr.get("valor") is None:
            hechos.append(f"Criticidad {cr['id'] if cr else 'sin nodo'}: valor null (desconocida)"
                          + (f", ámbito «{cr['ambito']}»." if cr and cr.get("ambito") else "."))
        else:
            hechos.append(f"Criticidad {cr['id']}: {cr['valor']} (grado_criticidad {_n(cr['grado_criticidad'])}), ámbito "
                          f"«{cr['ambito']}», fundamento «{cr['fundamento']}», declarada por {_n(cr.get('declarante_rol'))}.")
        if f.get("celda_mpr01"):
            c = f["celda_mpr01"]
            hechos.append(f"Celda de MPR-01: {c['id']}, categoría {c['categoria']}, versión {c['version']}, estado_validacion "
                          f"{c['estado_validacion']}.")
        else:
            hechos.append("celda_mpr01 = null: con severidad o criticidad null la consulta no encuentra una celda de la matriz.")
        x = f["contexto"]
        premisas = "; ".join(f"{k} = {_b(v)}" for k, v in x.items() if k != "id" and v is not None)
        hechos.append(f"Premisas del contexto {x['id']}: {premisas}.")
        hechos.append(_frase_decision(f) + f" revisada_humanamente = {_b(f['revisada_humanamente'])}.")
        if f.get("revision_senior_requerida"):
            hechos.append("La decisión tiene la marca revision_senior_requerida = true.")
        ids_req += [f["observacion_id"], f["decision_id"], f["regla"]]
        valores_req += [f["prioridad"], f["motivo"], f["estado"]]
        if f.get("decision_anterior"):
            p = f["decision_anterior"]
            hechos.append(f"La decisión vigente sustituye a {p['id']} (prioridad {p['prioridad']}, motivo {p['motivo']}, regla "
                          f"{p['regla']}, seguimiento {p['estado']}), que se conserva como historia.")
            ids_req.append(p["id"])
        for r in f.get("reevaluaciones_del_origen") or []:
            if r["decision_se_basa_en_ella"]:
                hechos.append(f"La decisión vigente se basa en la reevaluación {r['id']} sobre {r['documento_id']} "
                              f"(estado {r['estado']}, resultado_reevaluacion {r['resultado_reevaluacion']}).")
            else:
                hechos.append(f"La evaluación {r['id']} sobre {r['documento_id']} REEVALUA a {f['evaluacion_origen_id']} (estado "
                              f"{r['estado']}, resultado_reevaluacion {r['resultado_reevaluacion']}), pero la decisión vigente "
                              f"{f['decision_id']} no se basa en ella: su seguimiento sigue {f['estado']}. No digas que la "
                              "observación quedó resuelta ni cerrada.")
        for e in f.get("evidencia_decision") or []:
            hechos.append(f"Evidencia de la decisión: {e['id']}, «{e['contenido']}» (fuente {e['fuente']}).")
    if "seguimiento_pg2" in paquete:
        s = paquete["seguimiento_pg2"]
        frase = (f"Seguimiento (Q4 de PG2): evaluación vigente {s['evaluacion_id']} sobre {s['documento_id']} con estado "
                 f"{s['estado_evaluacion_vigente']}; tratamiento_activo = {_b(s['tratamiento_activo'])}; reglas del origen "
                 f"{_lista(s['reglas_origen'])}.")
        if s.get("grado_contradiccion") is not None:
            frase += f" Grado de contradicción de la evaluación de origen: {_n(s['grado_contradiccion'])} ({s['modelo_diagnostico']})."
        if s.get("grado_urgencia") is not None:
            frase += f" Grado de urgencia de la decisión: {_n(s['grado_urgencia'])} ({s['modelo_difuso']})."
        hechos.append(frase)
        for e in (s.get("evidencia_origen") or [])[:3]:
            hechos.append(f"Evidencia del origen: {e['id']}, «{e['contenido']}».")

    if "urgencia" in paquete:
        u = paquete["urgencia"]
        hechos.append(_frase_decision(u, f"Observación {u['observacion_id']}"))
        ids_req += [u["observacion_id"], u["decision_id"], u["regla_decision"]]
        valores_req += [u["prioridad"], u["motivo"], u["estado_seguimiento"]]
        if u["estado_calculo_difuso"] == "calculado":
            hechos.append(f"Entradas de {u['modelo_id']}: Severidad_Base x = {u['x_severidad']} (severidad {u['severidad']}, "
                          f"propuesta por {u['severidad_propuesta_por']}; SM3 no la modifica) y Criticidad_Requerimiento "
                          f"y = {u['y_criticidad']} (criticidad {u['criticidad']}, {u['criticidad_id']}).")
            pert = [p for p in u.get("pertenencias", []) if p["mu"] >= 0.01]
            hechos.append("Pertenencias de las entradas: " + "; ".join(
                f"{p['variable']} {p['etiqueta']} {p['mu']}" for p in pert) + ".")
            reglas = {r["id"]: r for r in u.get("reglas_modelo", [])}
            acts = sorted((a for a in u.get("activaciones", []) if a["alfa"] >= 0.001), key=lambda a: -a["alfa"])
            if acts:
                hechos.append("Activación de las reglas difusas: " + "; ".join(
                    f"{a['regla']} {_n(a['alfa'])} (antecedente {reglas.get(a['regla'], {}).get('antecedente')}, salida "
                    f"{reglas.get(a['regla'], {}).get('salida')}, regla crisp de origen {reglas.get(a['regla'], {}).get('regla_crisp')})"
                    for a in acts) + f". La regla dominante es {acts[0]['regla']}.")
                ids_req.append(acts[0]["regla"])
            hechos.append(f"Resultado: grado_urgencia {u['grado_urgencia']}, banda {u['banda_urgencia']}, calculado con "
                          f"{u['modelo_id']} ({u['modelo_metodo']}), modelo en estado {u['modelo_estado_validacion']}, fuente "
                          f"{u['fuente_modelo']} («{u['validez_fuente_modelo']}»); resultado_difuso_provisional = "
                          f"{_b(u['resultado_difuso_provisional'])}. La prioridad registrada en la decisión es {u['prioridad']} "
                          f"({u['regla_decision']}); el grado se informa junto a ella.")
            ids_req.append(u["modelo_id"])
            valores_req.append(u["banda_urgencia"])
        else:
            hechos.append(f"estado_calculo_difuso = {u['estado_calculo_difuso']}: grado_urgencia null y banda null. Severidad "
                          f"{_n(u['severidad'])} (x = {_n(u['x_severidad'])}), criticidad {_n(u['criticidad'])} "
                          f"(y = {_n(u['y_criticidad'])}). No debe estimarse una urgencia.")
        if u.get("revision_senior_requerida"):
            hechos.append("La decisión tiene la marca revision_senior_requerida = true.")

    if "decisiones_aclaradas" in paquete:
        q = paquete.get("pregunta")
        filas = paquete["decisiones_aclaradas"]
        if q:
            resp = q.get("responsable") or {}
            hechos.append(f"Pregunta {q['id']}: «{q['texto']}». dato_clave {q['dato_clave']}; dirigida a {_n(resp.get('id'))} "
                          f"(rol {_n(resp.get('rol'))}, confirmado = {_b(resp.get('confirmado'))}); asignacion = {q['asignacion']}, "
                          f"revision_neutralidad = {q['revision_neutralidad']}, propuesta_aceptada = {_b(q['propuesta_aceptada'])}.")
            hechos.append(f"La pregunta {q['id']} aclara las observaciones {_lista(q['observaciones_que_aclara'])} y se origina en "
                          f"las decisiones {_lista(q['decisiones_de_origen'])}. Una pregunta registrada no prueba que se haya enviado.")
            ids_req.append(q["id"])
            for a in q.get("respuestas", []):
                consid = (f"considerada por la evaluación {a['considerada_por']}" if a.get("considerada_por")
                          else "ninguna evaluación la consideró")
                hechos.append(f"Respuesta {a['id']} ({a['fecha']}), aportada por el rol {_n(a.get('aportada_por'))}: «{a['contenido']}»; "
                              f"estado_validacion {a['estado_validacion']}, datos_suficientes = {_b(a['datos_suficientes'])}, "
                              f"discordancia_confirmada = {_b(a['discordancia_confirmada'])}; {consid}.")
                ids_req.append(a["id"])
                valores_req.append(a["estado_validacion"])
            resp_q = q.get("respuestas", [])
            if len(resp_q) > 1:
                hechos.append("Comparación de las respuestas en orden: " + "; ".join(
                    f"{a['id']} quedó {a['estado_validacion']} con datos_suficientes = {_b(a['datos_suficientes'])}"
                    + (f" y fue considerada por {a['considerada_por']}" if a.get("considerada_por") else " y ninguna evaluación la consideró")
                    for a in resp_q) + ".")
        # Las decisiones con los mismos valores se leen en una sola frase: misma información, menos texto para el modelo.
        grupos: dict[str, list[dict]] = {}
        for d in filas:
            anterior = d.get("decision_anterior") or {}
            firma = json.dumps({k: v for k, v in d.items() if k not in ("observacion_id", "tipo", "decision_id", "decision_anterior",
                                "dato_faltante_origen", "dato_para_resolver")}
                               | {"anterior": [anterior.get("regla"), anterior.get("estado")]},
                               sort_keys=True, ensure_ascii=False, default=str)
            grupos.setdefault(firma, []).append(d)
        for grupo in grupos.values():
            d = grupo[0]
            pares = lista_y([f"{g['observacion_id']} ({g['tipo']}) con la decisión {g['decision_id']}" for g in grupo])
            plural = len(grupo) > 1
            frase = (f"{'Decisiones vigentes' if plural else 'Decisión vigente'}: {pares}. "
                     f"{'Todas tienen' if plural else 'Tiene'} prioridad {d['prioridad']}, motivo {d['motivo']}, regla {d['regla']}, "
                     f"seguimiento {d['estado']}; provisional = {_b(d['provisional'])}, emitible = {_b(d['emitible'])}.")
            if d.get("decision_anterior"):
                p = d["decision_anterior"]
                anteriores = lista_y([g["decision_anterior"]["id"] for g in grupo])
                frase += (f" Sustituye{'n' if plural else ''} a {anteriores} (regla {p['regla']}, seguimiento {p['estado']}), "
                          "que se conserva" + ("n" if plural else "") + " como historia.")
            if d.get("reevaluacion"):
                r = d["reevaluacion"]
                frase += (f" Se basa{'n' if plural else ''} en la reevaluación {r['id']} (estado {r['estado']}, resultado_reevaluacion "
                          f"{r['resultado_reevaluacion']}).")
            if d.get("revision_humana"):
                h = d["revision_humana"]
                frase += (f" Revisión {h['id']}: resultado {h['resultado']}, naturaleza {h['naturaleza']}, realizada por el rol "
                          f"{h['rol']}, alcance «{h['alcance']}».")
            hechos.append(frase)
            for g in grupo:
                ids_req += [g["observacion_id"], g["decision_id"]]
            valores_req.append(d["estado"])
            if d.get("reevaluacion"):
                ids_req.append(d["reevaluacion"]["id"])
        if not q:
            for d in filas:
                hechos.append(f"La base no registra ninguna Pregunta que aclare {d['observacion_id']}. El contexto registra "
                              f"dato_para_resolver = «{d['dato_para_resolver']}». El asistente no redacta preguntas.")

    if "matriz" in paquete:
        m = paquete["matriz"]
        hechos.append(f"Celda {m['celda']} de MPR-01 (versión {m['version']}, estado_validacion {m['estado_validacion']}): "
                      f"severidad {m['severidad']} y criticidad {m['criticidad']} dan la categoría {m['categoria']}.")
        ids_req.append(m["celda"])
        valores_req.append(m["categoria"])
        if not m["decisiones"]:
            hechos.append("Ninguna decisión vigente de la base tiene esa combinación de severidad y criticidad.")
        for d in m["decisiones"]:
            hechos.append(f"{d['observacion_id']}: decisión {d['decision_id']} con categoria_matriz {d['categoria_matriz']}, "
                          f"hito_acordado = {_b(d['hito_acordado'])}, diferimiento_aceptado = {_b(d['diferimiento_aceptado'])}, "
                          f"impacto_acotado = {_b(d['impacto_acotado'])}, bloqueo_sustantivo_confirmado = "
                          f"{_b(d['bloqueo_sustantivo_confirmado'])}; prioridad {d['prioridad']}, motivo {d['motivo']}, regla "
                          f"{d['regla']}, seguimiento {d['estado']}; provisional = {_b(d['provisional'])}, emitible = {_b(d['emitible'])}.")
            ids_req += [d["observacion_id"], d["decision_id"], d["regla"]]
            valores_req += [d["prioridad"], d["motivo"]]
        if m["decisiones"]:
            hechos.append("La categoría es la que propone la celda; la prioridad de cada decisión es la que figura en ella.")

    if "recomendaciones" in paquete:
        for d in paquete["recomendaciones"]:
            urg = f"grado_urgencia {_n(d['grado_urgencia'])}, banda {d['banda_urgencia']}" if d.get("grado_urgencia") is not None else "grado_urgencia null"
            hechos.append(f"{d['observacion']}: decisión {d['decision']}, prioridad {d['prioridad']}, motivo {d['motivo']}, regla "
                          f"{d['regla']}, {urg}, seguimiento {d['estado']}; revision_senior_requerida = "
                          f"{_b(d['revision_senior_requerida'])}; motivo de inclusión {d['motivo_inclusion']}; revisada_humanamente = "
                          f"{_b(d['revisada_humanamente'])}, provisional = {_b(d['provisional'])}, emitible = {_b(d['emitible'])}.")
            if not d["revision_senior_requerida"]:
                hechos.append(f"{d['decision']} no tiene la marca revision_senior_requerida en la base: se incluye porque aplica "
                              f"{d['regla']} con mapeo_alta_bloqueante = {d['mapeo_alta_bloqueante']}. Decí que conviene revisarla, "
                              "no que la base la marque ni que ya fue revisada.")
            ids_req += [d["observacion"], d["decision"]]
            valores_req += [d["prioridad"], d["motivo"], d["estado"]]
        if all(not d["revisada_humanamente"] for d in paquete["recomendaciones"]):
            hechos.append("Ninguna de estas decisiones registra una revisión humana: revisada_humanamente = false en todas.")

    if "informe" in paquete:
        i = paquete["informe"]
        hechos.append(f"Informe {i['informe_id']} del documento {i['documento_id']} (versión {i['version']}): hallazgos_demostrados "
                      f"{i['hallazgos_demostrados']}, calidad_observada {i['calidad_observada']}, unidades concluyentes "
                      f"{i['unidades_concluyentes']} de {i['unidades_aplicables']} aplicables, completitud_auditoria "
                      f"{_n(i['completitud_auditoria'])}, confianza_auditoria {i['confianza_auditoria']}, validacion_experta "
                      f"{i['validacion_experta']}, emitible = {_b(i['emitible'])}.")
        hechos.append("madurez_documento = null y alerta_alcance = null: la base no registra una madurez calculada ni una alerta "
                      "de alcance; no las estimes.")
        hechos.append(f"Decisiones incluidas: {len(i['decisiones'])}; abiertas: {i['decisiones_abiertas']}.")
        ids_req += [i["informe_id"], i["documento_id"]]
        for d in i["decisiones"][:6]:
            hechos.append(f"{d['observacion_id']}: decisión {d['decision_id']}, prioridad {d['prioridad']}, motivo {d['motivo']}, "
                          f"seguimiento {d['estado']}.")
            ids_req += [d["observacion_id"], d["decision_id"]]
            valores_req.append(d["estado"])

    hechos += _hechos_reglas(paquete)
    textos, _ = _valores(paquete)
    decisiones = _decisiones_del_paquete(paquete)
    if "candidata" in textos or any(d.get("provisional") for d in decisiones):
        hechos.append("Las decisiones, reglas, celdas y modelos citados son provisionales o candidatos: resultado del prototipo "
                      "académico, sin validación experta. La respuesta debe decirlo con la palabra «provisional».")
    if any(d.get("emitible") is False for d in decisiones):
        hechos.append("emitible = false: la respuesta debe decir que la recomendación todavía no es emitible.")
    ids_obligatorios = list(dict.fromkeys(i for i in ids_req if i))[:12]
    permitidos = sorted(_estados_del_paquete(paquete))
    prohibidos = [e for e in ESTADOS_DOMINIO if e not in _estados_del_paquete(paquete, con_reglas=True)]
    if ids_obligatorios:
        hechos.append(f"La respuesta debe mencionar estos IDs: {_lista(ids_obligatorios)}. Entre corchetes van solo IDs, por "
                      f"ejemplo [{', '.join(ids_obligatorios[:2])}]; los valores se escriben con palabras, fuera de los corchetes.")
    valores_txt = sorted({v.replace('_', ' ') for v in valores_req if v})
    if valores_txt:
        hechos.append(f"La respuesta debe nombrar con palabras estos valores: {_lista(valores_txt)}.")
    # Oración modelo armada con los valores de la primera decisión del paquete: guía la forma, no agrega datos.
    modelo = next((d for d in decisiones if d.get("prioridad") and (d.get("decision_id") or d.get("decision"))), None)
    if modelo:
        estado_m = (_estado_decision(modelo) or "").replace("_", " ")
        hechos.append(f"La respuesta debe explicar primero el fundamento de cada decisión (premisas, evidencia y regla con su "
                      f"significado) y cerrar cada una con una oración como: «La decisión "
                      f"{modelo.get('decision_id') or modelo.get('decision')} tiene prioridad {modelo['prioridad']}, motivo "
                      f"{modelo['motivo'].replace('_', ' ')} y seguimiento {estado_m}; es provisional y todavía no es emitible.»")
    hechos.append(f"Valores de prioridad, motivo y estado que figuran en el paquete: {_lista(permitidos) if permitidos else 'ninguno'}. "
                  "Las descripciones de las reglas son condiciones generales, no conclusiones sobre este caso"
                  + (f": no escribas {_lista(['«' + e.replace('_', ' ') + '»' for e in prohibidos])} como conclusión." if prohibidos else "."))
    valores = sorted({v for v in valores_req if v})
    return [h for h in hechos if h], {"ids": ids_obligatorios, "valores": valores}


_AFIRMA_CIERRE = re.compile(r"\b(est[aá]n?|qued[oó]|quedaron|queda|quedan|fue|fueron|ha sido|se dio por|figura como|se considera)\s+"
                            r"(resuelt[oa]s?|cerrad[oa]s?)\b")
_AFIRMA_ENVIO = re.compile(r"\b(se|fue|fueron|ya)\s+(le\s+|les\s+)?(envi[oó]|enviad[oa]s?|emiti[oó]|emitid[oa]s?|"
                          r"realiz[oó]|realizad[oa]s?|hizo|entreg[oó]|entregad[oa]s?)\b")
_AFIRMA_EMITIBLE = re.compile(r"\b(es|son|queda|quedan|resulta|est[aá]n?)\s+(emitibles?|habilitad[oa]s? para emitirse)\b")
_AFIRMA_SENIOR = re.compile(r"\b(revisad[oa]s?|validad[oa]s?|aprobad[oa]s?)\s+por\s+(el|un|una|la)\s+(analista\s+)?senior")


def _menciones_afirmativas(patron: re.Pattern, texto: str) -> list[str]:
    return [m.group(0) for m in patron.finditer(texto) if _no_negado(texto, m.start())]


def _reglas_por_entidad(paquete: dict) -> dict[str, set[str]]:
    """Observación o decisión -> reglas de su decisión vigente (y de la anterior, que es historia legítima)."""
    mapa: dict[str, set[str]] = {}
    for d in _decisiones_del_paquete(paquete):
        reglas = {r for r in (d.get("regla"), d.get("regla_decision")) if r}
        reglas |= set(d.get("reglas_decision") or [])
        if isinstance(d.get("decision_anterior"), dict) and d["decision_anterior"].get("regla"):
            reglas.add(d["decision_anterior"]["regla"])
        if not reglas:
            continue
        for clave in ("decision_id", "decision", "observacion_id", "observacion"):
            if d.get(clave):
                mapa.setdefault(d[clave], set()).update(reglas)
        if isinstance(d.get("decision_anterior"), dict) and d["decision_anterior"].get("id"):
            mapa.setdefault(d["decision_anterior"]["id"], set()).update(reglas)
    return mapa


def _atribucion_de_reglas(respuesta: str, paquete: dict) -> list[str]:
    """GL05 (alterar una conclusión): una oración que cita una sola regla de decisión no puede atribuírsela
    a una observación o decisión que se decidió con otra regla."""
    mapa = _reglas_por_entidad(paquete)
    reglas_decision = set().union(*mapa.values()) if mapa else set()
    violaciones = []
    for oracion in re.split(r"(?<=[.;])\s+|\n+", respuesta):
        ids = {m.group(0).rstrip(".") for m in PATRON_ID.finditer(oracion)}
        citadas = ids & reglas_decision
        if len(citadas) != 1:
            continue
        regla = next(iter(citadas))
        for ent in sorted(ids & set(mapa)):
            if regla not in mapa[ent]:
                violaciones.append(f"Atribuye {regla} a {ent}, cuya decisión aplica {_lista(sorted(mapa[ent]))}")
    return sorted(set(violaciones))


def controles_criterios_pg2(respuesta: str, paquete: dict) -> list[str]:
    """Criterios de aceptación de PG2 §4.1 y §4.3 y segunda mitad de GL05 (el LLM no altera conclusiones)."""
    violaciones: list[str] = []
    texto = respuesta.replace("_", " ").lower()
    permitidos = _estados_del_paquete(paquete, con_reglas=True)
    for estado, rx in ESTADOS_DOMINIO.items():
        if estado in permitidos:
            continue
        for m in re.finditer(rf"\b{rx}\b", texto):
            if _no_negado(texto, m.start()):
                violaciones.append(f"Usa «{estado.replace('_', ' ')}», que no figura en el paquete (alteraría una conclusión)")
                break
    textos, _ = _valores(paquete)
    decisiones = _decisiones_del_paquete(paquete)
    if ("candidata" in textos or any(d.get("provisional") for d in decisiones)) and not re.search(
            r"provisional|candidat|validaci[oó]n experta", texto):
        violaciones.append("No aclara que el resultado es provisional o candidato, sin validación experta")
    if any(d.get("emitible") is False for d in decisiones):
        if not re.search(r"emitib|emitir|emisi[oó]n", texto):
            violaciones.append("No aclara que la recomendación no es emitible (PG2 §4.1: emitible es obligatorio)")
        for frase in _menciones_afirmativas(_AFIRMA_EMITIBLE, texto):
            violaciones.append(f"Afirma que es emitible («{frase}») cuando emitible = false")
    for frase in _menciones_afirmativas(_AFIRMA_ENVIO, texto):
        violaciones.append(f"Afirma un envío o una emisión que la base no registra («{frase}»)")
    if decisiones and not any(_estado_decision(d) == "resuelto" for d in decisiones):
        for frase in _menciones_afirmativas(_AFIRMA_CIERRE, texto):
            violaciones.append(f"Afirma un cierre («{frase}») cuando ninguna decisión del paquete está resuelta")
    for frase in _menciones_afirmativas(_AFIRMA_SENIOR, texto):
        violaciones.append(f"Afirma una revisión senior que la base no registra («{frase}»)")
    violaciones += _atribucion_de_reglas(respuesta, paquete)
    unica = paquete.get("fundamento") or paquete.get("urgencia")
    if unica:
        sev = unica["severidad"]["valor"] if isinstance(unica.get("severidad"), dict) else unica.get("severidad")
        if sev is None and not re.search(r"desconocid|\bnull\b|no (se )?(conoce|registra|inform|calcul|sabe)|sin (valor|severidad|calcular|grado)", texto):
            violaciones.append("No dice que la severidad es desconocida (null); un desconocido no se completa (GL07)")
    u = paquete.get("urgencia")
    if u and u.get("grado_urgencia") is not None:
        cerca = False
        for m in PATRON_DECIMAL.finditer(respuesta):
            t = m.group(1).replace(",", ".")
            if abs(float(t) - u["grado_urgencia"]) <= 0.5 * 10 ** (-len(t.split(".")[1])) + 1e-9:
                cerca = True
        if not cerca:
            violaciones.append(f"No informa el grado de urgencia registrado ({u['grado_urgencia']})")
    return violaciones


def _cobertura(respuesta: str, requisitos: dict) -> list[str]:
    texto = respuesta.replace("_", " ").lower()
    faltan = [f"No menciona {i}" for i in requisitos.get("ids", []) if i not in respuesta]
    faltan += [f"No menciona «{v.replace('_', ' ')}»" for v in requisitos.get("valores", []) if not _menciona(v, texto)]
    return faltan


def _limpiar_formato(texto: str) -> str:
    texto = texto.replace("—", "-").replace("–", "-")
    texto = re.sub(r"^\s*#+\s*", "", texto, flags=re.MULTILINE)
    texto = texto.replace("**", "")
    texto = re.sub(r"\[([^\]]+)\]", _separar_cita, texto)
    return texto.strip()


def _separar_cita(m: re.Match) -> str:
    """Los corchetes se reservan para citas de IDs. Si el modelo anota valores dentro de una cita
    (por ejemplo [D-P-TASA, emitible = false]), esos valores pasan a paréntesis sin cambiar una letra:
    siguen a la vista y el verificador los controla igual que el resto del texto."""
    partes = [p.strip() for p in re.split(r"[,;]", m.group(1)) if p.strip()]
    ids = [p for p in partes if PATRON_ID.fullmatch(p)]
    otros = [p for p in partes if not PATRON_ID.fullmatch(p)]
    if not otros:
        return m.group(0)
    cita = f"[{', '.join(ids)}] " if ids else ""
    return f"{cita}({', '.join(otros)})"


def _instrucciones_reintento(violaciones: list[str], requisitos: dict) -> str:
    """Traduce los motivos del rechazo en correcciones concretas (no cambia el criterio del verificador)."""
    pasos: list[str] = []
    if any(v.startswith("Cita con formato") for v in violaciones):
        ejemplo = ", ".join(requisitos.get("ids", [])[:2]) or "ID"
        pasos.append(f"entre corchetes poné solo IDs del paquete separados por comas, por ejemplo [{ejemplo}]; escribí los "
                     "valores (prioridad, motivo, estado, null, emitible) como texto común, fuera de los corchetes")
    if any(v.startswith("No aclara que el resultado es provisional") for v in violaciones):
        pasos.append("agregá una frase que diga que es un resultado provisional, sin validación experta")
    if any(v.startswith("Atribuye ") for v in violaciones):
        pasos.append("en cada oración nombrá la regla que figura en la decisión de cada observación (por ejemplo, observación "
                     "y su regla en la misma frase) y no le atribuyas a una observación la regla de otra")
    if any("no es emitible" in v for v in violaciones):
        pasos.append("agregá que la recomendación todavía no es emitible")
    faltan = [v[len("No menciona "):] for v in violaciones if v.startswith("No menciona ")]
    if faltan:
        pasos.append("mencioná expresamente " + ", ".join(faltan))
    texto = (" Correcciones: " + "; ".join(pasos) + ".") if pasos else ""
    # Recordatorio completo: al corregir un punto, el modelo tiende a perder lo que ya estaba bien.
    todo = list(requisitos.get("ids", [])) + [v.replace("_", " ") for v in requisitos.get("valores", [])]
    return texto + (" Conservá además todo lo que ya estaba bien: " + ", ".join(todo)
                    + ", la aclaración de que es provisional y la de que no es emitible.")


def explicar(llm: ClienteOllama, prompts: dict, texto: str, paquete: dict) -> tuple[str, dict]:
    hechos, requisitos = hechos_verificables(paquete)
    traza: dict[str, Any] = {"intentos": [], "hechos_verificables": hechos, "cobertura_requerida": requisitos}
    base = (f"CONSULTA DEL USUARIO:\n{texto}\n\nHECHOS VERIFICABLES (lectura del paquete, en orden):\n"
            + "\n".join(f"- {h}" for h in hechos)
            + f"\n\nPAQUETE DE EVIDENCIA (JSON recuperado de Neo4j):\n{json.dumps(paquete, ensure_ascii=False, indent=1)}")
    # Los requisitos de cobertura se repiten al final del mensaje, después del JSON, para que no se pierdan.
    requisitos_txt = [h for h in hechos if h.startswith(("La respuesta debe", "emitible = false", "Las decisiones, reglas"))]
    if requisitos_txt:
        base += "\n\nRECORDATORIO FINAL:\n" + "\n".join(f"- {h}" for h in requisitos_txt)
    mensaje = base
    for intento in (1, 2, 3):
        crudo, meta = llm.chat(prompts["explicacion"], mensaje, llm.cfg.temperatura_explicacion, max_tokens=650)
        respuesta = _limpiar_formato(crudo)
        violaciones = (verificar_respuesta(respuesta, paquete) + controles_criterios_pg2(respuesta, paquete)
                       + _cobertura(respuesta, requisitos))
        traza["intentos"].append({"intento": intento, "respuesta": respuesta, "violaciones": violaciones, **meta})
        if violaciones and all(v.startswith("No aclara que el resultado es provisional") for v in violaciones):
            # PG3 v1.3: la única falta es la aclaración obligatoria. Se completa con una frase fija (no agrega datos)
            # y se vuelve a verificar con el mismo criterio.
            completada = respuesta.rstrip() + "\n\nEs un resultado provisional del prototipo, sin validación experta."
            revision = (verificar_respuesta(completada, paquete) + controles_criterios_pg2(completada, paquete)
                        + _cobertura(completada, requisitos))
            traza["intentos"][-1]["completada_aviso_provisional"] = not revision
            if not revision:
                respuesta, violaciones = completada, []
        if not violaciones:
            traza["resultado_verificacion"] = "aprobada"
            return respuesta, traza
        mensaje = (base + "\n\nTu respuesta anterior fue rechazada por el verificador de fidelidad (GL05) por: "
                   + "; ".join(violaciones) + ". Reescribila usando solo IDs y números del paquete y cubriendo los hechos indicados."
                   + _instrucciones_reintento(violaciones, requisitos))
    traza["resultado_verificacion"] = "rechazada; se emite la respuesta de respaldo"
    return respuesta_respaldo(paquete), traza


def respuesta_respaldo(paquete: dict) -> str:
    """Explicación determinística mínima cuando el LLM no supera el verificador."""
    partes = ["No pude generar una explicación verificable; resumo los datos recuperados de la base sin interpretarlos. "
              "Son resultados provisionales del prototipo, sin validación experta, y no emitibles."]
    for d in paquete.get("decisiones", []):
        partes.append(f"{d['observacion']}: {d['prioridad']}/{d['motivo']} por {d['regla']}, seguimiento {d['estado']} [{d['decision']}].")
    if paquete.get("fundamento"):
        f = paquete["fundamento"]
        partes.append(f"{f['observacion_id']}: {f['prioridad']}/{f['motivo']} por {f['regla']}, seguimiento {f['estado']} "
                      f"[{f['decision_id']}]; severidad {_n(f['severidad']['valor'])}.")
    if paquete.get("urgencia"):
        u = paquete["urgencia"]
        partes.append(f"{u['observacion_id']}: grado de urgencia {_n(u['grado_urgencia'], 6)} ({_n(u['banda_urgencia'])}), "
                      f"{u['prioridad']}/{u['motivo']} por {u['regla_decision']} [{u['decision_id']}].")
    if "decisiones_aclaradas" in paquete:
        q = paquete.get("pregunta")
        partes.append(f"Pregunta {q['id']}: «{q['texto']}»." if q else "La base no registra una pregunta para esta observación.")
        for d in paquete["decisiones_aclaradas"]:
            partes.append(f"{d['observacion_id']}: seguimiento {d['estado']} [{d['decision_id']}].")
    if paquete.get("matriz"):
        m = paquete["matriz"]
        partes.append(f"Celda {m['celda']}: categoría {m['categoria']} (candidata).")
    for d in paquete.get("recomendaciones", []):
        partes.append(f"{d['observacion']}: {d['prioridad']}/{d['motivo']} por {d['regla']} [{d['decision']}], {d['motivo_inclusion']}.")
    if paquete.get("informe"):
        i = paquete["informe"]
        partes.append(f"Informe {i['informe_id']}: {i['decisiones_abiertas']} decisiones abiertas; madurez_documento null.")
    return "\n".join(partes)


# --------------------------------------------------------------------------------------------
# Orquestador
# --------------------------------------------------------------------------------------------
def _u(x: Any) -> str:
    return f"{x:.3f}" if isinstance(x, (int, float)) else "null"


def resumen_resultado(paquete: dict) -> list[str]:
    lineas: list[str] = []
    if "decisiones" in paquete:
        lineas.append(f"{paquete['total_decisiones']} decisión(es) vigente(s) · filtros {json.dumps(paquete['filtros_aplicados'], ensure_ascii=False)}")
        for d in paquete["decisiones"]:
            lineas.append(f"   {d['observacion']:<18} {d['decision']:<22} {d['prioridad']}/{d['motivo']:<11} {d['regla']:<9} "
                          f"urgencia {_u(d['grado_urgencia'])} · {d['estado']} · provisional={d['provisional']} emitible={d['emitible']}")
    if "fundamento" in paquete:
        f = paquete["fundamento"]
        cr = f.get("criticidad") or {}
        lineas.append(f"{f['observacion_id']} ({f['tipo']}, {f['modulo_origen']}) · decisión {f['decision_id']} · "
                      f"{f['prioridad']}/{f['motivo']} · {f['regla']} · {f['estado']}")
        lineas.append(f"   severidad {f['severidad']['valor']} ({f['severidad']['grado_severidad']}) · criticidad {cr.get('id')} "
                      f"{cr.get('valor')} ({cr.get('grado_criticidad')}) · celda {(f.get('celda_mpr01') or {}).get('id')}")
        verdaderas = [k for k, v in f["contexto"].items() if v is True]
        lineas.append(f"   contexto {f['contexto']['id']}: verdaderas {verdaderas}")
        if f.get("decision_anterior"):
            lineas.append(f"   sustituye a {f['decision_anterior']['id']} ({f['decision_anterior']['regla']}, {f['decision_anterior']['estado']})")
        for r in f.get("reevaluaciones_del_origen") or []:
            lineas.append(f"   reevaluación {r['id']} ({r['estado']}, {r['resultado_reevaluacion']}) · la decisión se basa en ella: "
                          f"{r['decision_se_basa_en_ella']}")
    if "seguimiento_pg2" in paquete:
        s = paquete["seguimiento_pg2"]
        lineas.append(f"Q4 PG2: evaluación vigente {s['evaluacion_id']} ({s['estado_evaluacion_vigente']}) · "
                      f"tratamiento_activo={s['tratamiento_activo']} · provisional={s['provisional']} emitible={s['emitible']}")
    if "urgencia" in paquete:
        u = paquete["urgencia"]
        lineas.append(f"{u['observacion_id']} · decisión {u['decision_id']} · {u['prioridad']}/{u['motivo']} · {u['regla_decision']} · "
                      f"x={u['x_severidad']} ({u['severidad']}) y={u['y_criticidad']} ({u['criticidad']})")
        lineas.append(f"   cálculo {u['estado_calculo_difuso']} · grado {u['grado_urgencia']} · banda {u['banda_urgencia']} · "
                      f"modelo {u['modelo_id']} ({u['modelo_estado_validacion']})")
        if u.get("activaciones"):
            lineas.append("   activaciones " + ", ".join(f"{a['regla']} {a['alfa']:.3f}" for a in u["activaciones"]))
    if "decisiones_aclaradas" in paquete:
        q = paquete.get("pregunta")
        if q:
            lineas.append(f"pregunta {q['id']} -> {(q.get('responsable') or {}).get('id')} · aclara {q['observaciones_que_aclara']} · "
                          f"neutralidad {q['revision_neutralidad']} · propuesta_aceptada={q['propuesta_aceptada']}")
            for a in q.get("respuestas", []):
                lineas.append(f"   respuesta {a['id']} · {a['estado_validacion']} · suficiente={a['datos_suficientes']} · "
                              f"considerada por {a['considerada_por']} · «{a['contenido'][:60]}»")
        else:
            lineas.append("pregunta: null (la base no registra una pregunta para esta observación)")
        for d in paquete["decisiones_aclaradas"]:
            ant = f" · sustituye a {d['decision_anterior']['id']}" if d.get("decision_anterior") else ""
            lineas.append(f"   {d['observacion_id']:<9} {d['decision_id']:<14} {d['prioridad']}/{d['motivo']} · {d['regla']} · "
                          f"{d['estado']}{ant}")
    if "matriz" in paquete:
        m = paquete["matriz"]
        lineas.append(f"{m['celda']} ({m['version']}, {m['estado_validacion']}): {m['severidad']} x {m['criticidad']} -> {m['categoria']}")
        for d in m["decisiones"]:
            lineas.append(f"   {d['decision_id']:<20} {d['prioridad']}/{d['motivo']:<10} {d['regla']:<9} hito_acordado={d['hito_acordado']}")
    if "recomendaciones" in paquete:
        for d in paquete["recomendaciones"]:
            lineas.append(f"{d['decision']:<20} {d['prioridad']}/{d['motivo']:<10} {d['regla']:<9} urgencia {_u(d['grado_urgencia'])} "
                          f"({d['banda_urgencia']}) · marca senior={d['revision_senior_requerida']} · {d['motivo_inclusion']}")
    if "informe" in paquete:
        i = paquete["informe"]
        lineas.append(f"{i['informe_id']} · {i['calidad_observada']} · completitud {i['completitud_auditoria']} · "
                      f"madurez {i['madurez_documento']} · abiertas {i['decisiones_abiertas']} de {len(i['decisiones'])}")
    if paquete.get("reglas"):
        con_texto = sum(1 for r in paquete["reglas"] if r.get("descripcion"))
        lineas.append(f"reglas citadas: {[r['id'] + ' (' + str(r['ejecucion']) + ')' for r in paquete['reglas']]} "
                      f"({con_texto} con descripción en el grafo)")
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
                                 "modelo": self.cfg.modelo, "hilos": self.cfg.hilos, "huella_prompts": self.prompts["huella"],
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
                                           "observaciones": [o["observacion_id"] for o in resolucion.observaciones]}
        if mostrar:
            titulo_etapa("3", "CONSULTA CYPHER A NEO4J", "plantillas parametrizadas de solo lectura")
            if resolucion:
                destino = ", ".join(o["observacion_id"] for o in resolucion.observaciones[:6]) or "sin resolver"
                if len(resolucion.observaciones) > 6:
                    destino += f" y {len(resolucion.observaciones) - 6} más"
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
    print(T.c(T.NEGRITA, "Verificación del entorno de PI4 · SM3"))
    try:
        p = cargar_prompts()
        print(T.c(T.VERDE, f"  [ok] prompts y esquema cargados (huella {p['huella']})"))
        for nombre in CONSULTAS_LECTURA:
            assert es_solo_lectura(cargar_consulta(nombre)), nombre
        print(T.c(T.VERDE, f"  [ok] {len(CONSULTAS_LECTURA)} consultas Cypher de solo lectura (Q0 a Q10)"))
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
        fila = kb.leer("Q10_verificacion")[0]
        kb.cerrar()
        print(T.c(T.VERDE, f"  [ok] Neo4j {cfg.neo4j_uri} · {fila}"))
        if fila["decisiones"] == 0:
            print(T.c(T.ROJO, "  [error] la base no contiene AuditIA_PG2. Cargar PG2 con ejecutar_pg2.py antes de usar PI4."))
            ok = False
        if fila["reglas_prc_con_descripcion"] < fila["reglas_prc"]:
            print(T.c(T.AMARILLO, "  [aviso] hay reglas PRC sin descripción. Ejecutar una vez: python pi4_sm3_asistente.py --preparar"))
    except ErrorBase as e:
        print(T.c(T.ROJO, f"  [error] {e}"))
        ok = False
    print(T.c(T.VERDE if ok else T.ROJO, "Entorno listo." if ok else "Hay problemas que resolver antes de continuar."))
    return 0 if ok else 1


def modo_preparar(cfg: Config, confirmar: bool) -> int:
    print("Se incorporará a los nodos Regla de AuditIA_PG2 el texto SI...ENTONCES de 18 reglas PRC de PG1 §6.6 "
          "(sin sobrescribir).")
    if confirmar and input("¿Continuar? (s/n): ").strip().lower() not in ("s", "si", "sí"):
        print("Cancelado.")
        return 1
    kb = BaseConocimiento(cfg)
    n = kb.escribir_preparacion()
    fila = kb.leer("Q10_verificacion")[0]
    kb.cerrar()
    print(T.c(T.VERDE, f"Reglas PRC procesadas: {n}. Reglas PRC con descripción en el grafo: "
                       f"{fila['reglas_prc_con_descripcion']} de {fila['reglas_prc']}."))
    return 0


def evaluar_caso(caso: dict, traza: dict) -> dict:
    esperado = caso["esperado"]
    controles: dict[str, bool] = {}
    if "intencion" in esperado:
        validas = esperado["intencion"] if isinstance(esperado["intencion"], list) else [esperado["intencion"]]
        controles["intencion"] = traza.get("intencion") in validas
    controles["tipo_salida"] = (traza.get("tipo_salida") == esperado["salida"]
                                if esperado["salida"] == "aclaracion" else traza.get("tipo_salida") == "explicacion")
    consultas = [c["consulta"] for c in traza.get("consultas_cypher", [])]
    if "consulta" in esperado:
        controles["consulta_cypher"] = esperado["consulta"] in consultas
    if "observacion_id" in esperado:
        resueltas = (traza.get("resolucion_entidad") or {}).get("observaciones") or []
        controles["observacion"] = esperado["observacion_id"] in resueltas
    return {"caso": caso["id"], "consulta": caso["consulta"], "controles": controles, "aprobado": all(controles.values()),
            "intencion": traza.get("intencion"), "tipo_salida": traza.get("tipo_salida"),
            "consultas_cypher": consultas, "segundos": traza.get("segundos_totales"),
            "intentos_verificador": len((traza.get("explicacion") or {}).get("intentos", [])),
            "traza": traza.get("archivo_traza")}


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
               "modelo": asistente.cfg.modelo, "hilos": asistente.cfg.hilos, "huella_prompts": asistente.prompts["huella"],
               "aprobados": aprobados, "total": len(resultados), "resultados": resultados}
    ruta_resumen.write_text(json.dumps(resumen, ensure_ascii=False, indent=2), encoding="utf-8")
    print(T.c(T.GRIS, "  resumen guardado en ejecuciones/resumen_casos.json"))
    return 0 if aprobados == len(resultados) else 1


def modo_interactivo(asistente: Asistente) -> int:
    print(T.c(T.NEGRITA + T.AZUL, "AuditIA · SM3 · Asistente de priorización y clarificación (PI4)"))
    print(T.c(T.GRIS, f"Modelo {asistente.cfg.modelo} · Neo4j {asistente.cfg.neo4j_uri} · "
                      "escribí 'salir' para terminar o 'catalogo' para ver las observaciones"))
    while True:
        try:
            texto = input(T.c(T.NEGRITA, "\nConsulta> ")).strip()
        except (EOFError, KeyboardInterrupt):
            print()
            break
        if texto.lower() in ("salir", "exit", "quit"):
            break
        if texto.lower() == "catalogo":
            print(_lista_observaciones(_principales(asistente.kb.leer("Q0_observaciones")), 40))
            continue
        try:
            asistente.responder(texto)
        except (ErrorLLM, ErrorBase) as e:
            print(T.c(T.ROJO, f"Error de infraestructura: {e}"))
    return 0


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description="AuditIA PI4 · SM3 · LLM + Neo4j (patrón sándwich)")
    ap.add_argument("-p", "--pregunta", help="ejecuta una sola consulta y termina")
    ap.add_argument("--casos", nargs="*", metavar="ID", help="ejecuta la batería de casos (opcionalmente solo algunos IDs)")
    ap.add_argument("--verificar", action="store_true", help="comprueba Neo4j, Ollama y los archivos del prototipo")
    ap.add_argument("--preparar", action="store_true", help="incorpora una vez el texto de las reglas PRC de PG1 al grafo")
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
