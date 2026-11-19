#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
AuditIA · PI4 · Submódulo SM2 (Análisis cruzado y cobertura)
Integración de un LLM local (Ollama) con la base de conocimiento de PG2 en Neo4j.

Patrón sándwich:
  texto del usuario -> LLM de extracción (JSON estricto) -> consulta Cypher parametrizada de solo lectura
  -> resultado estructurado de Neo4j -> LLM de explicación -> verificador de fidelidad (GL05) -> respuesta.

Autor: Isgró, Tomás Valentino · Grupo 10 · Inteligencia Artificial · UTN FRM · 2026

Uso rápido:
  python pi4_sm2_asistente.py --verificar          # comprueba Neo4j, Ollama y archivos
  python pi4_sm2_asistente.py --preparar           # (una vez) incorpora el texto de las reglas ACC de PG1 al grafo
  python pi4_sm2_asistente.py                      # modo interactivo
  python pi4_sm2_asistente.py -p "¿Se contradicen ...?"
  python pi4_sm2_asistente.py --casos              # ejecuta la batería de casos de prueba

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

VERSION_PROTOTIPO = "PI4-SM2-1.0"
# Las notificaciones informativas del servidor (por ejemplo, nulos ignorados por count) no son errores.
logging.getLogger("neo4j.notifications").setLevel(logging.ERROR)
logging.getLogger("neo4j").setLevel(logging.ERROR)
BASE = Path(__file__).resolve().parent
DIR_CONSULTAS = BASE / "consultas"
DIR_PROMPTS = BASE / "prompts"
DIR_EJECUCIONES = BASE / "ejecuciones"

TIPOS_ANALISIS = ("comparacion", "dependencia", "cobertura")
INTENCIONES_CONSULTA = ("comparacion_requerimientos", "grado_contradiccion", "dependencia_requerimiento",
                        "cobertura_categoria", "listar_analisis", "derivacion_observacion")
INTENCIONES_CONTROL = ("otro_submodulo", "fuera_de_dominio", "requiere_aclaracion")
CONSULTAS = ("Q0_candidatos", "Q0a_ids_mencionados", "Q1_comparacion_par", "Q2_grado_contradiccion", "Q3_dependencia",
             "Q4_cobertura_categoria", "Q5_listado_analisis", "Q6_derivacion", "Q7_verificacion", "Q8_reglas")

# Patrón de identificadores del grafo PG2 (requerimientos, documentos, evaluaciones, resultados, reglas, nodos de contexto).
PATRON_ID = re.compile(
    r"\bGL\d{2}\b|\b(?:RQ|EV|H|P|D|ER|E|DOC|MD|CONTR|ACC|CAT|EVI|PRC|URG|AMB|ESC|COND|O|DEP|EN|PERFIL|NFR|SV|CR|X|INF|"
    r"Q|A|R|J|S|IE|CA|CTX|REV|RET|RESP)-[A-Za-z0-9](?:[A-Za-z0-9.]|-(?=[A-Za-z0-9]))*"
)
PATRON_REGLA = re.compile(r"^(?:GL\d{2}|EVI-(?:RD|HC)\d{2}|PRC-(?:RD|HC)\d{2}|ACC-(?:RD|HC)\d{2}|CAT-EX-(?:SEG|PARC))$")
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
    timeout_s: int = 900
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
        cypher = cargar_consulta("P0_documentar_reglas_acc")
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
    if len(re.findall(r"([^\w\s])\1{2,}", limpio)) >= 2:
        return "El texto contiene secuencias de símbolos que no forman una pregunta."
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
    """Restituye la grafía de los IDs de PG2: prefijos y nombres en mayúscula y versión vN en minúscula."""
    partes = []
    for parte in ident.strip().rstrip(".").split("-"):
        if re.fullmatch(r"[vV]\d+", parte):
            partes.append("v" + parte[1:])
        else:
            partes.append(parte.upper())
    return "-".join(partes)


def _ids_literales(texto_usuario: str) -> list[str]:
    return list(dict.fromkeys(canonizar_id(m.group(0)) for m in _PATRON_ID_SIN_MAYUSCULAS.finditer(texto_usuario)))


def normalizar_extraccion(ext: dict, texto_usuario: str) -> tuple[dict, list[str]]:
    """Controles posteriores al esquema. Descarta IDs que no estén literalmente en la consulta."""
    notas: list[str] = []
    literales = set(_ids_literales(texto_usuario))
    ent = ext["entidades"]
    aceptados = []
    for valor in ent.get("requerimiento_ids") or []:
        valor = canonizar_id(valor)
        if valor not in literales:
            notas.append(f"GL05: se descartó requerimiento_ids={valor!r} porque no aparece en la consulta del usuario.")
        elif valor not in aceptados:
            aceptados.append(valor)
    ent["requerimiento_ids"] = aceptados
    for clave in ("documento_id", "evaluacion_id", "observacion_id"):
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
    descartados = any(n.startswith("GL05: se descartó") for n in notas)
    sin_entidad = not (ent["requerimiento_ids"] or ent.get("requerimiento_texto") or ent.get("documento_id")
                       or ent.get("evaluacion_id") or ent.get("observacion_id"))
    if descartados and sin_entidad and ext["intencion"] in INTENCIONES_CONSULTA:
        # El modelo quiso señalar un caso pero inventó su ID: la búsqueda vuelve al texto literal del usuario,
        # que después se contrasta de forma determinística con el grafo (nunca se usa el ID propuesto).
        ent["requerimiento_texto"] = texto_usuario.strip()
        notas.append("Se usa la consulta completa como fragmento de búsqueda para la resolución determinística.")
    texto_norm = normalizar(texto_usuario)
    respaldo_filtros = {"comparacion": r"\b(compar|contradic|par\b|pares\b)", "dependencia": r"\bdepend",
                        "cobertura": r"\b(cobertura|cubiert|cubre|exigib|categor)",
                        "pendiente": r"\b(pendiente|abiert|sin resolver)", "observado": r"\b(hallazgo|observad|defecto)",
                        "sin_hallazgo": r"\bsin hallazgo"}
    for clave in ("tipo_analisis", "estado"):
        valor = ext["filtros"].get(clave)
        if valor and not re.search(respaldo_filtros[valor], texto_norm):
            notas.append(f"GL05: se descartó {clave}={valor!r} porque la consulta no lo pide.")
            ext["filtros"][clave] = None
    if ext["conceptos"].get("categoria") is not None and not ext["conceptos"]["categoria"].strip():
        ext["conceptos"]["categoria"] = None
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
sistema debe deben debera requerimiento requerimientos requisito requisitos dice dicen version versiones caso casos
contradicen contradice contradiccion contradicciones dependencia dependencias depende cobertura cubierta cubierto
analisis cruzado cruzados documento documentos revisado revisados evaluacion evaluaciones par pares
""".split())


def normalizar(texto: str) -> str:
    sin_tildes = "".join(c for c in unicodedata.normalize("NFD", texto.lower()) if unicodedata.category(c) != "Mn")
    return re.sub(r"[^a-z0-9 ]+", " ", sin_tildes)


def raices(texto: str) -> set[str]:
    return {p[:6] for p in normalizar(texto).split() if len(p) > 2 and p not in _VACIAS}


@dataclass
class Resolucion:
    estado: str                      # ok | sin_referencia | sin_coincidencia | ambiguo | categoria_inexistente
    referencia: str | None = None    # lo que escribió el usuario
    evaluaciones: list[str] = field(default_factory=list)
    requerimientos: list[str] = field(default_factory=list)
    id_logico: str | None = None
    documentos: list[str] | None = None
    categoria: str | None = None
    observacion: str | None = None
    alternativas: list[str] = field(default_factory=list)
    puntaje: float | None = None
    catalogo: list[dict] = field(default_factory=list)

    def destino(self) -> str:
        partes = []
        if self.requerimientos:
            partes.append(", ".join(self.requerimientos))
        if self.id_logico:
            partes.append(f"id_logico {self.id_logico}")
        if self.categoria:
            partes.append(f"categoría {self.categoria}")
        if self.documentos:
            partes.append(", ".join(self.documentos))
        if self.observacion:
            partes.append(self.observacion)
        if self.evaluaciones:
            partes.append("(" + ", ".join(self.evaluaciones) + ")")
        return " ".join(partes) or "sin resolver"

    def resumen(self) -> dict:
        return {"estado": self.estado, "puntaje": self.puntaje, "evaluaciones": self.evaluaciones,
                "requerimientos": self.requerimientos, "id_logico": self.id_logico, "documentos": self.documentos,
                "categoria": self.categoria, "observacion": self.observacion, "alternativas": self.alternativas}


def _grupos(catalogo: list[dict], tipo: str | None = None, roles: tuple[str, ...] | None = None) -> dict[str, dict]:
    """Agrupa el catálogo Q0 por evaluación cruzada."""
    grupos: dict[str, dict] = {}
    for f in catalogo:
        if tipo and f["tipo_analisis"] != tipo:
            continue
        g = grupos.setdefault(f["evaluacion_id"], {"evaluacion_id": f["evaluacion_id"], "tipo": f["tipo_analisis"],
                                                   "documento_id": f["documento_id"], "categoria": f["categoria"],
                                                   "resultado_id": f["resultado_id"], "vigente": f["vigente"],
                                                   "requerimientos": [], "textos": [], "logicos": []})
        if roles and f["rol"] not in roles:
            continue
        if f["requerimiento_id"] not in g["requerimientos"]:
            g["requerimientos"].append(f["requerimiento_id"])
            g["textos"].append(f["texto"] or "")
            g["logicos"].append(f["id_logico"])
    for g in grupos.values():
        g["requerimientos"].sort()
    return grupos


def _texto_grupo(g: dict) -> str:
    extra = [g.get("categoria") or "", (g.get("documento_id") or "").replace("-", " ")]
    return " ".join(g["textos"] + extra)


def _puntuar(fragmento: str, grupos: dict[str, dict]) -> tuple[float, list[dict]]:
    buscadas = raices(fragmento)
    if not buscadas:
        return 0.0, []
    puntuados = [(len(buscadas & raices(_texto_grupo(g))) / len(buscadas), g) for g in grupos.values()]
    if not puntuados:
        return 0.0, []
    mejor = max(p[0] for p in puntuados)
    return round(mejor, 2), [g for p, g in puntuados if p == mejor]


def _normalizar_categoria(nombre: str | None, categorias: set[str]) -> str | None:
    if not nombre:
        return None
    buscada = normalizar(nombre).strip()
    for c in categorias:
        n = normalizar(c).strip()
        if buscada == n or buscada.rstrip("s") == n or buscada[:6] == n[:6]:
            return c
    return None


def resolver_entidades(catalogo: list[dict], ext: dict) -> Resolucion:
    ent, intencion = ext["entidades"], ext["intencion"]
    texto = ent.get("requerimiento_texto")
    ids = ent.get("requerimiento_ids") or []

    if intencion in ("comparacion_requerimientos", "grado_contradiccion"):
        grupos = _grupos(catalogo, "comparacion", ("comparado",))
        if ent.get("evaluacion_id"):
            g = grupos.get(ent["evaluacion_id"])
            if not g:
                return Resolucion("sin_coincidencia", ent["evaluacion_id"], catalogo=catalogo)
            candidatos, puntaje = [g], None
        elif ids:
            candidatos = [g for g in grupos.values() if set(ids) <= set(g["requerimientos"])]
            puntaje = None
            if not candidatos:
                return Resolucion("sin_coincidencia", ", ".join(ids), catalogo=catalogo)
        elif texto:
            puntaje, candidatos = _puntuar(texto, grupos)
            if puntaje < 0.5:
                return Resolucion("sin_coincidencia", texto, puntaje=puntaje, catalogo=catalogo)
        else:
            return Resolucion("sin_referencia", catalogo=catalogo)
        pares = {tuple(g["requerimientos"]) for g in candidatos}
        if len(pares) > 1:
            return Resolucion("ambiguo", texto or ", ".join(ids), puntaje=puntaje, catalogo=catalogo,
                              alternativas=[" y ".join(p) for p in sorted(pares)])
        par = list(pares.pop())
        if intencion == "grado_contradiccion" and ent.get("evaluacion_id"):
            evaluaciones = [ent["evaluacion_id"]]
        else:
            evaluaciones = sorted(g["evaluacion_id"] for g in grupos.values() if g["requerimientos"] == par)
        return Resolucion("ok", texto, evaluaciones=evaluaciones, requerimientos=par, puntaje=puntaje, catalogo=catalogo)

    if intencion == "dependencia_requerimiento":
        filas = [f for f in catalogo if f["rol"] == "origen_dependencia"]
        logicos: dict[str, dict] = {}
        for f in filas:
            g = logicos.setdefault(f["id_logico"], {"id_logico": f["id_logico"], "textos": [], "requerimientos": [],
                                                    "evaluaciones": [], "documentos": [], "categoria": None,
                                                    "documento_id": None})
            g["textos"].append(f["texto"] or "")
            g["requerimientos"].append(f["requerimiento_id"])
            g["evaluaciones"].append(f["evaluacion_id"])
            g["documentos"].append(f["documento_id"])
        puntaje = None
        if ids:
            elegidos = [g for g in logicos.values() if any(i in g["requerimientos"] or i == g["id_logico"] for i in ids)]
        elif ent.get("evaluacion_id"):
            elegidos = [g for g in logicos.values() if ent["evaluacion_id"] in g["evaluaciones"]]
        elif ent.get("documento_id"):
            elegidos = [g for g in logicos.values() if ent["documento_id"] in g["documentos"]]
        elif texto:
            puntaje, elegidos = _puntuar(texto, logicos)
            if puntaje < 0.5:
                return Resolucion("sin_coincidencia", texto, puntaje=puntaje, catalogo=catalogo)
        else:
            return Resolucion("sin_referencia", catalogo=catalogo)
        if not elegidos:
            ref = ", ".join(ids) or ent.get("evaluacion_id") or ent.get("documento_id")
            return Resolucion("sin_coincidencia", ref, catalogo=catalogo)
        if len(elegidos) > 1:
            return Resolucion("ambiguo", texto, puntaje=puntaje, catalogo=catalogo,
                              alternativas=[g["id_logico"] for g in elegidos])
        g = elegidos[0]
        return Resolucion("ok", texto, id_logico=g["id_logico"], evaluaciones=sorted(set(g["evaluaciones"])),
                          requerimientos=sorted(set(g["requerimientos"])), puntaje=puntaje, catalogo=catalogo)

    if intencion == "cobertura_categoria":
        grupos = _grupos(catalogo, "cobertura", ("alcance_cobertura",))
        categorias = {g["categoria"] for g in grupos.values() if g["categoria"]}
        pedida = ext["conceptos"].get("categoria")
        categoria = _normalizar_categoria(pedida, categorias)
        if pedida and not categoria:
            return Resolucion("categoria_inexistente", pedida, alternativas=sorted(categorias), catalogo=catalogo)
        documentos: list[str] | None = None
        puntaje = None
        if ent.get("documento_id"):
            documentos = [g["documento_id"] for g in grupos.values() if g["documento_id"] == ent["documento_id"]]
            if not documentos:
                return Resolucion("sin_coincidencia", ent["documento_id"], catalogo=catalogo)
        elif ent.get("evaluacion_id"):
            documentos = [g["documento_id"] for g in grupos.values() if g["evaluacion_id"] == ent["evaluacion_id"]]
            if not documentos:
                return Resolucion("sin_coincidencia", ent["evaluacion_id"], catalogo=catalogo)
        elif ids:
            documentos = sorted({g["documento_id"] for g in grupos.values() if set(ids) & set(g["requerimientos"])})
            if not documentos:
                return Resolucion("sin_coincidencia", ", ".join(ids), catalogo=catalogo)
        elif texto:
            # El fragmento solo acota documentos si coincide con un requerimiento; la categoría sigue siendo la clave.
            puntaje, candidatos = _puntuar(texto, grupos)
            if puntaje >= 0.5:
                documentos = sorted({g["documento_id"] for g in candidatos})
            elif not categoria:
                return Resolucion("sin_coincidencia", texto, puntaje=puntaje, catalogo=catalogo)
            else:
                puntaje = None
        if not categoria:
            if not documentos:
                return Resolucion("sin_referencia", catalogo=catalogo, alternativas=sorted(categorias))
            cats = {g["categoria"] for g in grupos.values() if g["documento_id"] in documentos}
            categoria = sorted(cats)[0]
        evaluaciones = sorted(g["evaluacion_id"] for g in grupos.values()
                              if g["categoria"] == categoria and (documentos is None or g["documento_id"] in documentos))
        return Resolucion("ok", pedida or texto, categoria=categoria, documentos=documentos, evaluaciones=evaluaciones,
                          puntaje=puntaje, catalogo=catalogo)

    if intencion == "derivacion_observacion":
        grupos = {k: g for k, g in _grupos(catalogo).items() if g["resultado_id"]}
        resultados = {g["resultado_id"]: g for g in grupos.values()}
        if ent.get("observacion_id"):
            g = resultados.get(ent["observacion_id"])
            if not g:
                return Resolucion("sin_coincidencia", ent["observacion_id"], catalogo=catalogo)
            return Resolucion("ok", ent["observacion_id"], observacion=g["resultado_id"], evaluaciones=[g["evaluacion_id"]],
                              catalogo=catalogo)
        puntaje = None
        if ent.get("evaluacion_id"):
            elegidos = [g for g in grupos.values() if g["evaluacion_id"] == ent["evaluacion_id"]]
        elif ids:
            elegidos = [g for g in grupos.values() if set(ids) & set(g["requerimientos"])]
        elif ent.get("documento_id"):
            elegidos = [g for g in grupos.values() if g["documento_id"] == ent["documento_id"]]
        else:
            fragmento = " ".join(x for x in (texto, ext["conceptos"].get("categoria")) if x)
            if not fragmento:
                return Resolucion("sin_referencia", catalogo=catalogo,
                                  alternativas=sorted(resultados))
            puntaje, elegidos = _puntuar(fragmento, grupos)
            if puntaje < 0.5:
                return Resolucion("sin_coincidencia", fragmento, puntaje=puntaje, catalogo=catalogo)
        observaciones = sorted({g["resultado_id"] for g in elegidos})
        if not observaciones:
            return Resolucion("sin_coincidencia", texto or ent.get("evaluacion_id") or ent.get("documento_id"),
                              catalogo=catalogo)
        if len(observaciones) > 1:
            return Resolucion("ambiguo", texto, puntaje=puntaje, catalogo=catalogo, alternativas=observaciones)
        g = resultados[observaciones[0]]
        return Resolucion("ok", texto, observacion=g["resultado_id"], evaluaciones=[g["evaluacion_id"]], puntaje=puntaje,
                          catalogo=catalogo)

    return Resolucion("ok", catalogo=catalogo)


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


_CLAVES_SIN_REGLAS = {"regla_crisp"}  # la regla crisp de una regla difusa documenta su origen; no decidió el caso


def _reglas_citadas(obj: Any) -> list[str]:
    encontrados: set[str] = set()

    def recorrer(x: Any) -> None:
        if isinstance(x, dict):
            for k, v in x.items():
                if k not in _CLAVES_SIN_REGLAS:
                    recorrer(v)
        elif isinstance(x, list):
            for v in x:
                recorrer(v)
        elif isinstance(x, str) and PATRON_REGLA.match(x):
            encontrados.add(x)
    recorrer(obj)
    return sorted(encontrados)


MODULOS = {"evaluacion_individual": "SM1 (Evaluación de calidad individual)",
           "priorizacion_clarificacion": "SM3 (Priorización y clarificación)",
           "analisis_cruzado": "SM2 (Análisis cruzado y cobertura)"}


def controlar_ids_mencionados(kb: BaseConocimiento, rec: Recuperacion, texto: str, catalogo: list[dict]) -> bool:
    """Contrasta con el grafo los IDs que el usuario escribió. Devuelve False si corresponde cerrar con aclaración."""
    literales = [i for i in _ids_literales(texto) if not PATRON_REGLA.match(i)]
    if not literales:
        return True
    filas = {f["id"]: f for f in _ejecutar(kb, rec, "Q0a_ids_mencionados", {"ids": literales})}
    conocidos_sm2 = ({f["evaluacion_id"] for f in catalogo} | {f["requerimiento_id"] for f in catalogo}
                     | {f["documento_id"] for f in catalogo} | {f["resultado_id"] for f in catalogo if f["resultado_id"]})
    faltan = [i for i in literales if i not in filas]
    if faltan:
        rec.aclaracion = (f"La base de conocimiento no registra {', '.join(faltan)}. No voy a suponer un caso parecido. "
                          "Casos analizados por SM2 en la base:\n" + _lista_catalogo(catalogo))
        rec.tipo_cierre = "sin_resultados"
        return False
    for i in literales:
        f = filas[i]
        modulo = f.get("modulo_origen")
        if modulo and modulo != "analisis_cruzado":
            rec.aclaracion = (f"{i} fue emitido por {MODULOS.get(modulo, modulo)}, no por SM2. Su explicación corresponde "
                              "al asistente de ese submódulo.")
            rec.tipo_cierre = "otro_submodulo"
            return False
        if i not in conocidos_sm2 and any(e in f["etiquetas"] for e in ("Requerimiento", "DocumentoVersion", "Evaluacion")):
            rec.aclaracion = (f"La base registra {i}, pero SM2 no tiene análisis cruzados que lo incluyan. "
                              "Casos analizados por SM2:\n" + _lista_catalogo(catalogo))
            rec.tipo_cierre = "sin_resultados"
            return False
    return True


def recuperar(kb: BaseConocimiento, ext: dict, texto: str) -> tuple[Recuperacion, Resolucion | None]:
    rec = Recuperacion()
    intencion = ext["intencion"]
    paquete: dict[str, Any] = {"intencion": intencion, "consulta_usuario": texto,
                               "fuente": "Neo4j · base AuditIA_PG2 (PG2, Grupo 10)"}
    catalogo = _ejecutar(kb, rec, "Q0_candidatos", {})
    if not controlar_ids_mencionados(kb, rec, texto, catalogo):
        return rec, None

    resolucion: Resolucion | None = None
    if intencion != "listar_analisis":
        resolucion = resolver_entidades(catalogo, ext)
        if resolucion.estado != "ok":
            rec.aclaracion, rec.tipo_cierre = mensaje_resolucion(resolucion, ext), "aclaracion_resolucion"
            return rec, resolucion

    if intencion == "comparacion_requerimientos":
        filas = [f["comparacion"] for f in _ejecutar(kb, rec, "Q1_comparacion_par",
                                                      {"requerimiento_ids": resolucion.requerimientos})]
        if not filas:
            rec.aclaracion, rec.tipo_cierre = "La base no registra comparaciones de SM2 para ese par.", "sin_resultados"
            return rec, resolucion
        paquete["requerimientos_consultados"] = resolucion.requerimientos
        paquete["comparaciones"] = filas

    elif intencion == "grado_contradiccion":
        filas = []
        for ev in resolucion.evaluaciones:
            filas.extend(f["grado"] for f in _ejecutar(kb, rec, "Q2_grado_contradiccion", {"evaluacion_id": ev}))
        if not filas:
            rec.aclaracion, rec.tipo_cierre = "La base no registra un grado de contradicción para ese par.", "sin_resultados"
            return rec, resolucion
        paquete["requerimientos_consultados"] = resolucion.requerimientos
        paquete["grados"] = filas

    elif intencion == "dependencia_requerimiento":
        filas = [f["dependencia"] for f in _ejecutar(kb, rec, "Q3_dependencia", {"id_logico": resolucion.id_logico})]
        if not filas:
            rec.aclaracion, rec.tipo_cierre = "La base no registra dependencias rastreadas por SM2 para ese requerimiento.", "sin_resultados"
            return rec, resolucion
        paquete["requerimiento_logico"] = resolucion.id_logico
        paquete["dependencias"] = filas

    elif intencion == "cobertura_categoria":
        filas = [f["cobertura"] for f in _ejecutar(kb, rec, "Q4_cobertura_categoria",
                                                    {"categoria": resolucion.categoria, "documento_ids": resolucion.documentos})]
        if not filas:
            rec.aclaracion, rec.tipo_cierre = (f"La base no registra análisis de cobertura de {resolucion.categoria} "
                                               "para esos documentos."), "sin_resultados"
            return rec, resolucion
        paquete["categoria_consultada"] = resolucion.categoria
        paquete["documentos_consultados"] = resolucion.documentos or "todos los documentos revisados"
        paquete["coberturas"] = filas

    elif intencion == "listar_analisis":
        filtros = ext["filtros"]
        parametros = {"tipo_analisis": filtros["tipo_analisis"], "estado": filtros["estado"],
                      "solo_vigentes": ext["condiciones"]["alcance"] != "todas"}
        if not any((filtros["tipo_analisis"], filtros["estado"])) and parametros["solo_vigentes"]:
            rec.aclaracion = ("Para listar análisis cruzados necesito al menos un filtro: un tipo de análisis (comparación, "
                              "dependencia o cobertura) o un estado (observado, pendiente o sin_hallazgo).")
            rec.tipo_cierre = "aclaracion_filtros"
            return rec, None
        filas = [f["analisis"] for f in _ejecutar(kb, rec, "Q5_listado_analisis", parametros)]
        if not filas:
            rec.aclaracion, rec.tipo_cierre = "La base no registra análisis cruzados que cumplan esos filtros.", "sin_resultados"
            return rec, None
        paquete["filtros_aplicados"] = parametros
        paquete["total_analisis"] = len(filas)
        paquete["analisis"] = filas

    elif intencion == "derivacion_observacion":
        filas = [f["derivacion"] for f in _ejecutar(kb, rec, "Q6_derivacion", {"observacion_id": resolucion.observacion})]
        if not filas:
            rec.aclaracion, rec.tipo_cierre = (f"No encontré en la base una derivación de SM2 para {resolucion.observacion}."
                                               ), "sin_resultados"
            return rec, resolucion
        paquete["derivaciones"] = filas

    ids_reglas = _reglas_citadas(paquete)
    if ids_reglas:
        paquete["reglas"] = _ejecutar(kb, rec, "Q8_reglas", {"ids": ids_reglas})
    rec.paquete = paquete
    return rec, resolucion


# --------------------------------------------------------------------------------------------
# Mensajes de aclaración determinísticos (no pasan por el LLM: no hay nada que explicar)
# --------------------------------------------------------------------------------------------
def _lista_catalogo(catalogo: list[dict]) -> str:
    lineas = []
    for ev, g in _grupos(catalogo).items():
        if g["tipo"] == "comparacion":
            rqs = [f for f in catalogo if f["evaluacion_id"] == ev and f["rol"] == "comparado"]
            detalle = " frente a ".join(f"{f['requerimiento_id']} «{f['texto']}»" for f in rqs)
        elif g["tipo"] == "dependencia":
            rqs = [f for f in catalogo if f["evaluacion_id"] == ev and f["rol"] == "origen_dependencia"]
            detalle = "; ".join(f"{f['requerimiento_id']} «{f['texto']}»" for f in rqs)
        else:
            detalle = f"categoría {g['categoria']} en {g['documento_id']}"
        lineas.append(f"  - {ev} ({g['tipo']}): {detalle}")
    return "\n".join(lineas)


def mensaje_resolucion(res: Resolucion, ext: dict) -> str:
    intencion = ext["intencion"]
    if res.estado == "categoria_inexistente":
        return (f"La base no registra análisis de cobertura para la categoría «{res.referencia}». "
                f"Categorías evaluadas por SM2: {', '.join(res.alternativas) or 'ninguna'}.")
    if res.estado == "sin_referencia":
        if intencion == "cobertura_categoria":
            return ("Indicá qué categoría no funcional querés revisar o en qué documento. Categorías evaluadas por SM2: "
                    f"{', '.join(res.alternativas) or 'ninguna'}.")
        if intencion == "derivacion_observacion":
            return ("Indicá qué hallazgo o pendiente de SM2 querés consultar. Resultados derivados por SM2: "
                    f"{', '.join(res.alternativas)}.")
        return ("No identifiqué a qué requerimientos te referís. Podés nombrarlos por su ID o citar parte de su texto. "
                "Casos analizados por SM2 en la base:\n" + _lista_catalogo(res.catalogo))
    if res.estado == "sin_coincidencia":
        return (f"No encontré en la base de conocimiento un caso analizado por SM2 que coincida con «{res.referencia}». "
                "No voy a suponer uno. Casos disponibles:\n" + _lista_catalogo(res.catalogo))
    if res.estado == "ambiguo":
        return ("Tu descripción coincide con más de un caso. Indicá cuál querés consultar: "
                + "; ".join(res.alternativas) + ".")
    return "No pude resolver la referencia de la consulta."


MENSAJES_CONTROL = {
    "fuera_de_dominio": ("Soy el asistente de SM2 de AuditIA y solo respondo consultas sobre el análisis cruzado y la "
                         "cobertura registrados en la base de conocimiento: contradicciones entre requerimientos, "
                         "dependencias y cobertura de categorías no funcionales. No puedo modificar resultados ni responder "
                         "otros temas. Ejemplo: «¿Se contradicen los requerimientos de modificar el pedido?»"),
    "otro_submodulo": ("Esa consulta corresponde a otro submódulo de AuditIA: la calidad individual de cada requerimiento "
                       "(ambigüedad, verificabilidad, atomicidad y completitud) la evalúa SM1, y la prioridad, la "
                       "criticidad y la urgencia las decide SM3. Desde SM2 puedo explicarte contradicciones, dependencias, "
                       "coberturas y lo que se derivó a priorización."),
    "requiere_aclaracion": ("Necesito un poco más de información para consultar la base. Indicá los requerimientos, el "
                            "documento o la observación (por ID o con parte de su texto) y qué querés saber: si se "
                            "contradicen, su grado de contradicción, una dependencia, la cobertura de una categoría o lo "
                            "que se derivó a priorización."),
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
        for parte in re.split(r";\s*|,\s+", re.sub(r"\s*\([^)]*\)", "", cita)):
            # Se admite el estado entre paréntesis junto al ID («[EV-PED-FRONTERA (pendiente)]»); ese texto se
            # controla igual que el resto de la respuesta (estados y números).
            parte = re.sub(r"\s*\([^)]*\)$", "", parte.strip())
            if parte and PATRON_ID.fullmatch(parte) is None:
                violaciones.append(f"Cita con formato inválido: [{parte}] (entre corchetes solo van IDs del paquete)")
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
    if palabras > 320:
        violaciones.append(f"Respuesta demasiado extensa ({palabras} palabras).")
    return sorted(set(violaciones))


def _n(x: Any, nd: int = 3) -> str:
    """Número con coma decimal, como se escribe en los informes del grupo."""
    if x is None:
        return "null"
    if isinstance(x, bool):
        return str(x).lower()
    if isinstance(x, float):
        return f"{x:.{nd}f}".replace(".", ",")
    return str(x)


def _b(x: Any) -> str:
    return "null" if x is None else str(x).lower()


def _lista(xs: Any) -> str:
    return ", ".join(xs) if xs else "ninguna"


def _es_generica(contenido: str | None) -> bool:
    return bool(contenido) and contenido.startswith("Premisas registradas por el grupo")


def _hechos_evidencias(evidencias: list[dict], hechos: list[str]) -> None:
    for e in evidencias or []:
        if _es_generica(e.get("contenido")):
            hechos.append(f"La evidencia {e['id']} solo registra «{e['contenido']}»: no aporta un argumento propio; el "
                          "fundamento está en las propiedades anteriores.")
        else:
            hechos.append(f"Evidencia {e['id']}: «{e['contenido']}».")


def _frase_resultado(r: dict | None, evaluacion: str) -> str:
    if not r:
        return f"{evaluacion} no genera hallazgo ni pendiente."
    if r["clase"] == "Hallazgo":
        frase = f"{evaluacion} genera el Hallazgo {r['id']} (tipo_defecto {r.get('tipo_defecto')})"
        if r.get("descripcion"):
            frase += f": «{r['descripcion']}»"
        sev = r.get("severidad")
        if isinstance(sev, dict):
            frase += (f". Severidad propuesta {sev['id']}: " + (f"{sev['valor']}" if sev.get("valor") else
                                                                "null (desconocida); no debe completarse"))
        return frase + "."
    frase = f"{evaluacion} genera el Pendiente {r['id']} (motivo {r.get('motivo_pendiente')}"
    if r.get("dato_faltante"):
        frase += f"; dato faltante: «{r['dato_faltante']}»"
    if r.get("destinatario_rol"):
        frase += f"; destinatario {r['destinatario_rol']}"
    frase += "). Un pendiente es falta de información, no un defecto demostrado."
    return frase


def _hechos_comparaciones(paquete: dict, hechos: list[str], ids_req: list[str], estados_req: list[str]) -> None:
    comps = paquete.get("comparaciones", [])
    vistos: set[str] = set()
    for c in comps:
        par = " y ".join(f"{r['id']} («{r['texto']}»)" for r in c["requerimientos"])
        hechos.append(f"La evaluación {c['evaluacion_id']} ({c['documento_id']}, versión {c['version']}) comparó {par}. "
                      f"Premisas registradas: escenarios {c['escenarios']}, resultados_incompatibles = "
                      f"{_b(c['resultados_incompatibles'])}, excepcion_resuelve = {_b(c['excepcion_resuelve'])}, "
                      f"interpretacion_cerrada = {_b(c['interpretacion_cerrada'])}. Quedó {c['estado']} por la regla "
                      f"{_lista(c['reglas'])}.")
        for r in c["requerimientos"]:
            ob, es = r.get("obligacion"), r.get("escenario")
            if ob and r["id"] not in vistos:
                vistos.add(r["id"])
                frase = (f"Obligación de {r['id']} ({ob['id']}): sujeto «{ob['sujeto']}», acción «{ob['accion']}», objeto "
                         f"«{ob['objeto']}», modalidad {ob['modalidad']}, resultado «{ob['resultado']}»")
                if es:
                    frase += f"; escenario {es['id']} (actor «{es['actor']}», objeto «{es['objeto']}», estado «{es['estado']}»)"
                hechos.append(frase + ".")
        if c["contradice"]:
            for x in c["contradice"]:
                hechos.append(f"{c['evaluacion_id']} derivó la relación CONTRADICE de {x['desde']} a {x['hasta']} con ámbito "
                              f"«{x['ambito']}» (regla {x['regla']}).")
        else:
            hechos.append(f"{c['evaluacion_id']} no derivó la relación CONTRADICE.")
        hechos.append(_frase_resultado(c.get("resultado"), c["evaluacion_id"]))
        if c.get("grado_contradiccion") is not None:
            hechos.append(f"{c['evaluacion_id']} tiene grado de pertenencia a contradicción {_n(c['grado_contradiccion'])}, "
                          f"banda {c['banda_difusa']}, calculado con {c['modelo_id']}. El grado mide la intensidad del "
                          f"conflicto; la que decidió el estado es la regla {_lista(c['reglas'])}.")
        else:
            hechos.append(f"{c['evaluacion_id']} no tiene grado de contradicción calculado (grado_contradiccion = null): "
                          "no debe estimarse un valor.")
        _hechos_evidencias(c.get("evidencias"), hechos)
        ids_req.append(c["evaluacion_id"])
        if c.get("resultado"):
            ids_req.append(c["resultado"]["id"])
        estados_req.append(c["estado"])
    pares = {tuple(sorted(r["id"] for r in c["requerimientos"])) for c in comps}
    if len(comps) > 1 and len(pares) == 1 and len({c["estado"] for c in comps}) > 1:
        control = [c for c in comps if any("Control" in (e.get("contenido") or "") for e in c.get("evidencias", []))]
        otras = [c for c in comps if c not in control]
        frase = (f"Las evaluaciones {_lista([c['evaluacion_id'] for c in comps])} comparan el mismo par con premisas "
                 f"distintas (escenarios {' frente a '.join(c['escenarios'] for c in comps)}); cada conclusión vale para "
                 "su premisa.")
        if control and otras:
            frase += (f" {control[0]['evaluacion_id']} es una evaluación de control del par (evidencia "
                      f"{control[0]['evidencias'][0]['id']}): funciona como control de falsos positivos, no es un "
                      f"desacuerdo entre análisis y no anula a {_lista([c['evaluacion_id'] for c in otras])}. La evidencia del control describe solo la premisa de "
                      "ese control; no agrega una conclusión sobre la contradicción ni la confirma, limita o explica.")
        hechos.append(frase)


def _hechos_grados(paquete: dict, hechos: list[str], ids_req: list[str], estados_req: list[str]) -> None:
    for g in paquete.get("grados", []):
        par = " y ".join(f"{r['id']} («{r['texto']}»)" for r in g["requerimientos"])
        hechos.append(f"La evaluación {g['evaluacion_id']} ({g['documento_id']}) comparó {par}; escenarios {g['escenarios']}. "
                      f"Quedó {g['estado']} por la regla {_lista(g['reglas_crisp'])}.")
        ids_req.append(g["evaluacion_id"])
        estados_req.append(g["estado"])
        if g.get("grado_contradiccion") is None:
            hechos.append(f"No hay grado de contradicción calculado para {g['evaluacion_id']} (grado_contradiccion = null, "
                          "sin modelo difuso aplicado). No debe estimarse ni calcularse un valor.")
        else:
            entradas = [e for e in g.get("pertenencias_entrada", []) if e.get("pertenencia") is not None and e["pertenencia"] >= 0.01]
            pert = "; ".join(f"{e['variable']} {e['etiqueta']} {_n(e['pertenencia'])}" for e in entradas)
            hechos.append(f"Entradas valoradas: Solapamiento_Escenario = {_n(g['solapamiento_escenario'], 1)} e "
                          f"Incompatibilidad_Resultados = {_n(g['incompatibilidad_resultados'], 1)}. Pertenencias "
                          f"relevantes: {pert}.")
            for var in ("Solapamiento_Escenario", "Incompatibilidad_Resultados"):
                propias = [e for e in g.get("pertenencias_entrada", []) if e["variable"] == var and e.get("pertenencia") is not None]
                if propias:
                    mayor = max(propias, key=lambda e: e["pertenencia"])
                    hechos.append(f"{var} pertenece sobre todo a la etiqueta {mayor['etiqueta']} ({_n(mayor['pertenencia'])}); "
                                  "usá ese nombre de etiqueta y no otro.")
            acts = sorted(g.get("reglas_difusas") or [], key=lambda r: -r["activacion"])
            if acts:
                hechos.append("Activación de las reglas difusas: " + "; ".join(
                    f"{r['id']} {_n(r['activacion'])} (antecedente {r['antecedente']}, salida {r['salida']})" for r in acts)
                    + f". La regla dominante es {acts[0]['id']}.")
            salidas = {e["etiqueta"]: e for e in g.get("etiquetas_salida", [])}
            if salidas:
                hechos.append("Etiquetas de la salida Pertenencia_Contradiccion: " + "; ".join(
                    f"{e['etiqueta']} (centro {_n(e['centro'], 1)}, id {e['id']})" for e in salidas.values())
                    + ". La salida «media» de las reglas difusas corresponde a la etiqueta Intermedia.")
            hechos.append(f"Resultado: grado {_n(g['grado_contradiccion'])}, banda {g['banda_difusa']}, calculado con "
                          f"{g['modelo_id']} ({g['modelo_metodo']}), modelo en estado {g['modelo_estado_validacion']}, "
                          f"fuente {g['fuente_modelo']}. El grado mide la intensidad del conflicto y no cambia el estado "
                          "de la evaluación.")
            asociadas = sorted({r.get("regla_crisp") for r in g.get("reglas_difusas") or [] if r.get("regla_crisp")})
            if asociadas:
                hechos.append(f"Las reglas difusas citan como antecedente crisp a {_lista(asociadas)}; esa referencia "
                              f"documenta su origen y no es la regla que decidió el estado ({_lista(g['reglas_crisp'])}).")
            if g.get("revision_senior_requerida"):
                hechos.append(f"La banda {g['banda_difusa']} marca un caso de frontera: revision_senior_requerida = true. "
                              "La base no registra una revisión realizada.")
        hechos.append(_frase_resultado(g.get("resultado"), g["evaluacion_id"]))
        if g.get("resultado"):
            ids_req.append(g["resultado"]["id"])
        _hechos_evidencias(g.get("evidencias"), hechos)


def _hechos_dependencias(paquete: dict, hechos: list[str], ids_req: list[str], estados_req: list[str]) -> None:
    for d in paquete.get("dependencias", []):
        en = d["elemento_necesario"]
        hechos.append(f"Versión {d['version']} ({d['documento_id']}): {d['requerimiento_id']} («{d['texto']}») depende del "
                      f"elemento necesario {en['id']} (concepto «{en['concepto']}», referencia «{en['referencia']}»). "
                      f"Referencias no disponibles en el documento: {_lista(d['referencias_no_disponibles'])}.")
        hechos.append(f"La evaluación {d['evaluacion_id']} rastreó la dependencia {d['dependencia_id']}: estado de la "
                      f"dependencia {d['estado_dependencia']}; referencia_necesaria_disponible = "
                      f"{_b(d['referencia_necesaria_disponible'])}; cotejo de la definición «{d['cotejo_definicion']}»; "
                      f"busqueda_completa = {_b(d['busqueda_completa'])}. La evaluación quedó {d['estado_evaluacion']} "
                      f"por la regla {_lista(d['reglas'])}.")
        for r in d.get("resuelta_por", []):
            hechos.append(f"La dependencia {d['dependencia_id']} figura resuelta por {r['id']} («{r['texto']}»). La "
                          f"definición está en {r['id']}, no en {d['requerimiento_id']}, que es el requerimiento que depende.")
        if d.get("reevalua_a"):
            hechos.append(f"{d['evaluacion_id']} REEVALUA a {_lista(d['reevalua_a'])}.")
        if not d["vigente"] and d.get("reevaluada_por"):
            hechos.append(f"{d['evaluacion_id']} fue reevaluada por {_lista(d['reevaluada_por'])}: su resultado se conserva "
                          f"como historia de la versión {d['version']} y no se modifica.")
        r = d.get("resultado")
        if r:
            frase = f"{d['evaluacion_id']} genera el Pendiente {r['id']} (motivo {r['motivo_pendiente']}"
            if r.get("dato_faltante"):
                frase += f"; dato faltante: «{r['dato_faltante']}»"
            frase += f"): «{r['descripcion']}». Un anexo no recibido no prueba que la información no exista: no es un hallazgo."
            hechos.append(frase)
            ids_req.append(r["id"])
            for s in r.get("seguimiento_sm3", []):
                if s.get("estado") == "resuelto":
                    hechos.append(f"El seguimiento de {r['id']} en SM3 es la decisión {s['decision_id']} con estado resuelto.")
                else:
                    hechos.append(f"El seguimiento de {r['id']} en SM3 es la decisión {s['decision_id']} con estado "
                                  f"{s['estado']}: la base no registra que ese seguimiento se haya cerrado, aunque otra "
                                  "versión haya resuelto la dependencia.")
                    estados_req.append(s["estado"])
        else:
            hechos.append(f"{d['evaluacion_id']} no genera hallazgo ni pendiente.")
        _hechos_evidencias(d.get("evidencias"), hechos)
        ids_req.extend([d["evaluacion_id"], d["dependencia_id"]])
        estados_req.extend([d["estado_evaluacion"], d["estado_dependencia"]])


def _hechos_coberturas(paquete: dict, hechos: list[str], ids_req: list[str], estados_req: list[str]) -> None:
    for c in paquete.get("coberturas", []):
        pf, cat = c["perfil"], c["categoria"]
        hechos.append(f"Documento {c['documento_id']}: la evaluación {c['evaluacion_id']} revisó la categoría {cat['nombre']} "
                      f"({cat['id']}) con el perfil {pf['id']} (datos_sensibles = {_b(pf['datos_sensibles'])}, confirmado = "
                      f"{_b(pf['confirmado'])}). Necesidades: {_lista(c['necesidades'])}. Partes cubiertas: "
                      f"{_lista(c['partes_cubiertas'])}. condicion_catalogo = {_b(c['condicion_catalogo'])}; "
                      f"busqueda_completa = {_b(c['busqueda_completa'])}; cobertura «{c['cobertura']}». Quedó {c['estado']} "
                      f"por la regla {_lista(c['reglas'])}.")
        for x in c.get("exige", []):
            hechos.append(f"El perfil {pf['id']} EXIGE {cat['nombre']} para «{x['necesidad']}» (regla {x['regla']}).")
        if not c.get("exige"):
            hechos.append(f"No se derivó EXIGE para el perfil {pf['id']}: la condición del catálogo no está confirmada "
                          f"(condicion_catalogo = {_b(c['condicion_catalogo'])}). No es una brecha demostrada.")
        for x in c.get("cubre", []):
            hechos.append(f"{x['requerimiento_id']} («{x['texto']}») CUBRE {cat['nombre']} para «{x['necesidad']}» "
                          f"(regla {x['regla']}).")
        if not c.get("cubre") and c["estado"] == "observado":
            rqs = "; ".join(f"{r['id']} («{r['texto']}»)" for r in c.get("requerimientos_del_documento", []))
            hechos.append(f"Ningún requerimiento de {c['documento_id']} cubre {cat['nombre']}; el documento contiene {rqs}.")
        elif not c.get("cubre"):
            hechos.append(f"La cobertura de {c['documento_id']} quedó «{c['cobertura']}»: no se afirma que falte cobertura; "
                          "antes hay que decidir si la categoría es exigible.")
        if c.get("resultado"):
            hechos.append(_frase_resultado(c["resultado"], c["evaluacion_id"]))
            ids_req.append(c["resultado"]["id"])
        else:
            hechos.append(f"{c['evaluacion_id']} quedó sin hallazgo en el alcance revisado: no certifica todo el documento.")
        _hechos_evidencias(c.get("evidencias"), hechos)
        ids_req.append(c["evaluacion_id"])
        estados_req.append(c["estado"])


def _hechos_listado(paquete: dict, hechos: list[str], ids_req: list[str], estados_req: list[str]) -> None:
    f = paquete["filtros_aplicados"]
    hechos.append(f"Filtros aplicados: tipo_analisis = {_b(f['tipo_analisis'])}, estado = {_b(f['estado'])}, solo vigentes "
                  f"= {_b(f['solo_vigentes'])}. Total de evaluaciones recuperadas: {paquete['total_analisis']}.")
    for a in paquete.get("analisis", []):
        frase = f"{a['evaluacion_id']} ({a['tipo_analisis']}, {a['documento_id']}): {a['estado']} por {_lista(a['reglas'])}"
        if a.get("resultado_id"):
            frase += f"; genera {a['clase']} {a['resultado_id']} ({a['motivo_o_defecto']})"
            if a.get("dato_faltante"):
                frase += f" con dato faltante «{a['dato_faltante']}»"
        else:
            frase += "; sin hallazgo ni pendiente"
        if a.get("grado_contradiccion") is not None:
            frase += f"; grado de contradicción {_n(a['grado_contradiccion'])}, banda {a['banda_difusa']}"
        hechos.append(frase + ".")
        ids_req.append(a["evaluacion_id"])
        if a.get("resultado_id"):
            ids_req.append(a["resultado_id"])
        estados_req.append(a["estado"])
    if f["solo_vigentes"]:
        hechos.append("Solo se listan evaluaciones vigentes: las que otra evaluación REEVALUA quedan como historia y no "
                      "aparecen en este listado.")


def _hechos_derivaciones(paquete: dict, hechos: list[str], ids_req: list[str], estados_req: list[str]) -> None:
    for d in paquete.get("derivaciones", []):
        afecta = (f"los requerimientos {_lista(d['afecta_requerimientos'])}" if d["afecta_requerimientos"]
                  else f"la categoría {_lista(d['afecta_categoria'])}")
        hechos.append(f"{d['clase']} {d['observacion_id']} emitido por el módulo {d['modulo_origen']} en la evaluación "
                      f"{d['evaluacion_id']} ({d['tipo_analisis']}, {d['documento_id']}, estado {d['estado_evaluacion']}); "
                      f"{d['tipo_defecto'] or d['motivo_pendiente']}: «{d['descripcion']}». Afecta a {afecta}. Reglas del "
                      f"resultado: {_lista(d['reglas_origen'])}.")
        sv = d["severidad_propuesta"]
        valor = (f"con valor {sv['valor']}" if sv.get("valor") else "con valor null (desconocida)")
        hechos.append(f"Contrato de derivación: severidad base propuesta {sv['id']} {valor}, propuesta_por "
                      f"{sv['propuesta_por']}, validación {sv['validacion']}; fundamento registrado: «{sv['fundamento']}». "
                      + ("La severidad null no se completa ni se reemplaza por otro valor; bloqueante no es una severidad."
                         if not sv.get("valor") else ""))
        hechos.append(f"Dato faltante derivado: «{d['dato_faltante']}»." if d.get("dato_faltante")
                      else f"{d['observacion_id']} no registra dato faltante.")
        r = d.get("recepcion_sm3")
        if r:
            hechos.append(f"Recepción registrada por SM3: decisión {r['decision_id']} con prioridad {r['prioridad']}, motivo "
                          f"{r['motivo']}, estado de seguimiento {r['estado_seguimiento']}, provisional = "
                          f"{_b(r['provisional'])}, emitible = {_b(r['emitible'])}. Esos valores los decide SM3; SM2 solo "
                          "informa lo que se derivó y no los justifica.")
            ids_req.append(r["decision_id"])
            estados_req.append(r["estado_seguimiento"])
        _hechos_evidencias(d.get("evidencias"), hechos)
        ids_req.extend([d["observacion_id"], d["evaluacion_id"], sv["id"]])
        estados_req.append(d["estado_evaluacion"])


def hechos_verificables(paquete: dict) -> tuple[list[str], dict]:
    """Lectura determinística del paquete: frases cortas construidas solo con valores recuperados de Neo4j.
    Devuelve también lo que la respuesta debe cubrir (IDs y estados) para el control de cobertura."""
    hechos: list[str] = []
    ids_req: list[str] = []
    estados_req: list[str] = []
    _hechos_comparaciones(paquete, hechos, ids_req, estados_req)
    _hechos_grados(paquete, hechos, ids_req, estados_req)
    _hechos_dependencias(paquete, hechos, ids_req, estados_req)
    _hechos_coberturas(paquete, hechos, ids_req, estados_req)
    if "analisis" in paquete:
        _hechos_listado(paquete, hechos, ids_req, estados_req)
    _hechos_derivaciones(paquete, hechos, ids_req, estados_req)
    for r in paquete.get("reglas", []):
        if r.get("descripcion"):
            hechos.append(f"Regla {r['id']} ({r['ejecucion']}, estado {r['estado_validacion']}, {r.get('fuente') or 'PG1'}): "
                          f"{r['descripcion']}")
    if _es_candidato(paquete):
        hechos.append("Las reglas y modelos citados tienen estado candidata: el resultado es provisional, del prototipo "
                      "académico, sin validación experta. La respuesta debe decirlo con la palabra «provisional».")
    # Esqueleto de conclusiones: cada elemento con su estado exacto, su regla y su resultado, listo para copiar.
    pares_estado: list[str] = []

    def _res(r: dict | None) -> str:
        return f", genera {r['clase']} {r['id']}" if r else ", sin hallazgo ni pendiente"

    for x in paquete.get("comparaciones", []) + paquete.get("coberturas", []):
        pares_estado.append(f"{x['evaluacion_id']} ({x['estado']}, regla {_lista(x['reglas'])}{_res(x.get('resultado'))})")
    for x in paquete.get("grados", []):
        pares_estado.append(f"{x['evaluacion_id']} ({x['estado']}, regla {_lista(x['reglas_crisp'])}{_res(x.get('resultado'))})")
    for x in paquete.get("analisis", []):
        res = {"clase": x["clase"], "id": x["resultado_id"]} if x.get("resultado_id") else None
        pares_estado.append(f"{x['evaluacion_id']} ({x['estado']}, regla {_lista(x['reglas'])}{_res(res)})")
    for d in paquete.get("dependencias", []):
        for s_ in (d.get("resultado") or {}).get("seguimiento_sm3", []):
            if s_.get("estado") != "resuelto":
                hechos.append(f"Antes de la oración final de provisionalidad, escribí esta oración exacta: «El seguimiento de "
                              f"{d['resultado']['id']} en SM3 ({s_['decision_id']}) sigue {s_['estado']}, aunque la dependencia "
                              f"quedó resuelta en {_lista(d['reevaluada_por'])}.»" if d["estado_dependencia"] == "pendiente" else
                              f"El seguimiento de {d['resultado']['id']} en SM3 ({s_['decision_id']}) sigue {s_['estado']}.")
        pares_estado.append(f"{d['evaluacion_id']} ({d['estado_evaluacion']}, regla {_lista(d['reglas'])}{_res(d.get('resultado'))})")
        resolutor = f", resuelta por {_lista([r['id'] for r in d['resuelta_por']])}" if d.get("resuelta_por") else ""
        pares_estado.append(f"{d['dependencia_id']} ({d['estado_dependencia']}{resolutor})")
        for s in (d.get("resultado") or {}).get("seguimiento_sm3", []):
            pares_estado.append(f"{d['resultado']['id']} con seguimiento {s['decision_id']} ({s['estado']})")
    for d in paquete.get("derivaciones", []):
        pares_estado.append(f"{d['observacion_id']} ({d['clase']}) de {d['evaluacion_id']} ({d['estado_evaluacion']}, "
                            f"reglas {_lista(d['reglas_origen'])})")
        if d.get("recepcion_sm3"):
            pares_estado.append(f"{d['recepcion_sm3']['decision_id']} ({d['recepcion_sm3']['estado_seguimiento']})")
    if pares_estado:
        hechos.insert(0, "Conclusiones registradas, para escribirlas en el texto corrido de la respuesta (ID con su estado exacto "
                      "entre paréntesis; esto va en el texto y no entre corchetes): " + "; ".join(dict.fromkeys(pares_estado)) + ".")
    if len(paquete.get("coberturas", [])) > 1:
        hechos.insert(1, "Cada documento tiene su propia conclusión: no las combines en una sola (por ejemplo, «cubierta "
                      "parcialmente»). La base no registra ninguna cobertura parcial.")
    sin_siguiente = not any(
        (x.get("resultado") or {}).get("dato_faltante") or x.get("dato_faltante") or x.get("revision_senior_requerida")
        for clave in ("comparaciones", "grados", "dependencias", "coberturas", "analisis", "derivaciones")
        for x in paquete.get(clave, []))
    if sin_siguiente:
        hechos.append("El paquete no registra un dato faltante ni una revisión pendiente: no propongas un siguiente paso.")
    for clave, campo in (("comparaciones", "reglas"), ("grados", "reglas_crisp"), ("dependencias", "reglas"),
                         ("coberturas", "reglas"), ("analisis", "reglas"), ("derivaciones", "reglas_origen")):
        for x in paquete.get(clave, []):
            ids_req.extend(x.get(campo) or [])
    ids_obligatorios = list(dict.fromkeys(ids_req))[:14]
    permitidos = sorted(_estados_del_paquete(paquete))
    prohibidos = [e for e in ESTADOS_DOMINIO if e not in permitidos]
    estados_obligatorios = sorted(set(e for e in estados_req if e))
    if ids_obligatorios:
        hechos.append(f"La respuesta debe mencionar estos IDs: {_lista(ids_obligatorios)}.")
    if estados_obligatorios:
        hechos.append("La respuesta debe escribir textualmente estos estados, tal como figuran: "
                      f"{_lista(estados_obligatorios)}. Un verbo parecido (por ejemplo «se observó») no alcanza.")
    hechos.append(f"Estados que figuran en el paquete: {_lista(permitidos) if permitidos else 'ninguno'}. Las descripciones "
                  "de las reglas son condiciones generales, no conclusiones sobre este caso: no escribas las palabras "
                  f"{_lista(['«' + e + '»' for e in prohibidos])} en la respuesta.")
    return [h for h in hechos if h], {"ids": ids_obligatorios, "estados": estados_obligatorios}


ESTADOS_DOMINIO = ("observado", "pendiente", "sin hallazgo", "no evaluable", "resuelta", "resuelto", "por consultar",
                   "no aplicable")


def _es_candidato(paquete: dict) -> bool:
    textos, _ = _valores(paquete)
    return "candidata" in textos or any(
        isinstance(d.get("recepcion_sm3"), dict) and d["recepcion_sm3"].get("provisional")
        for d in paquete.get("derivaciones", []))


def _estados_del_paquete(paquete: dict, con_reglas: bool = False) -> set[str]:
    textos, _ = _valores(paquete)
    estados = {t.replace("_", " ").lower() for t in textos if t.replace("_", " ").lower() in ESTADOS_DOMINIO}
    if con_reglas:
        # Citar la condición de una regla recuperada del grafo es legítimo: sus palabras de estado no se tratan como inventadas.
        for r in paquete.get("reglas", []):
            descripcion = (r.get("descripcion") or "").lower()
            estados |= {e for e in ESTADOS_DOMINIO if re.search(r"\b" + re.escape(e) + r"\b", descripcion)}
    return estados


def _severidades_del_paquete(paquete: dict) -> set[str]:
    encontradas: set[str] = set()

    def recorrer(x: Any) -> None:
        if isinstance(x, dict):
            if str(x.get("id", "")).startswith("SV-") and x.get("valor"):
                encontradas.add(str(x["valor"]).lower())
            for v in x.values():
                recorrer(v)
        elif isinstance(x, list):
            for v in x:
                recorrer(v)
    recorrer(paquete)
    return encontradas


def _pendientes_abiertos(paquete: dict) -> set[str]:
    """Pendientes del paquete cuyo seguimiento no figura resuelto (por ejemplo, P-TASA con D-P-TASA por_consultar)."""
    abiertos: set[str] = set()

    def recorrer(x: Any) -> None:
        if isinstance(x, dict):
            if x.get("clase") == "Pendiente":
                pid = x.get("id") or x.get("observacion_id") or x.get("resultado_id")
                seg = x.get("seguimiento_sm3") or []
                rec = x.get("recepcion_sm3") or {}
                estados = [s.get("estado") for s in seg] + [rec.get("estado_seguimiento")]
                if pid and "resuelto" not in estados:
                    abiertos.add(pid)
            for v in x.values():
                recorrer(v)
        elif isinstance(x, list):
            for v in x:
                recorrer(v)
    recorrer(paquete)
    return abiertos


_PATRON_SEVERIDAD = re.compile(
    r"severidad(?:\s+base)?(?:\s+propuesta)?(?:\s+(?:es|fue|era|queda|qued[oó]|ser[ií]a|de|como))?\s*[:=]?\s*«?"
    r"\b(baja|media|alta|bloqueante|mayor|menor)\b")
_PATRON_CIERRE = re.compile(r"\b(resuelt[oa]s?|cerrad[oa]s?|se resolvi[oó]|se cerr[oó])\b")
_PATRON_NEGACION = re.compile(r"\b(no|sin|todav[ií]a|sigue|siguen|a[uú]n|conserva|conservan|permanece|mantiene)\b")


def controles_criterios_pg2(respuesta: str, paquete: dict) -> list[str]:
    """Criterios de aceptación de PG2 §4.3 y segunda mitad de GL05 (el LLM no altera conclusiones)."""
    violaciones: list[str] = []
    texto = respuesta.replace("_", " ").lower()
    permitidos = _estados_del_paquete(paquete, con_reglas=True)
    for estado in ESTADOS_DOMINIO:
        if re.search(rf"\b{estado}\b", texto) and estado not in permitidos:
            violaciones.append(f"Usa el estado «{estado}», que no figura en el paquete (alteraría una conclusión)")
    if _es_candidato(paquete) and not re.search(r"provisional|candidat|validaci[oó]n experta", texto):
        violaciones.append("No aclara que el resultado es provisional o candidato, sin validación experta")
    # Severidad (GL07): no se inventa ni se completa; bloqueante, mayor y menor no son valores de severidad.
    severidades = _severidades_del_paquete(paquete)
    for m in _PATRON_SEVERIDAD.finditer(texto):
        valor = m.group(1)
        if valor in ("bloqueante", "mayor", "menor"):
            violaciones.append(f"Presenta «{valor}» como severidad; GL07 no lo admite como valor de severidad")
        elif valor not in severidades:
            violaciones.append(f"Atribuye severidad «{valor}», que no figura en el paquete (la severidad es null o distinta)")
    # Etiqueta difusa de cada entrada: debe ser la de mayor pertenencia que figura en el paquete (MD-CONTR-1.0).
    for g in paquete.get("grados", []):
        for var, palabra in (("Solapamiento_Escenario", "solapamiento"), ("Incompatibilidad_Resultados", "incompatibilidad")):
            propias = [e for e in g.get("pertenencias_entrada", []) if e["variable"] == var and e.get("pertenencia") is not None]
            if not propias:
                continue
            mayor = max(propias, key=lambda e: e["pertenencia"])["etiqueta"].lower()
            for m in re.finditer(palabra + r"(?:\s+\w+){0,2}?\s+(alt[oa]|medi[oa]|baj[oa])\b", texto):
                if m.group(1)[:3] != mayor[:3]:
                    violaciones.append(f"Llama «{m.group(1)}» a {palabra}, cuya etiqueta dominante es {mayor}")
    # Una revisión sin hallazgo describe lo revisado; no certifica ni garantiza el documento (PI1, PG2 §2.20).
    for clausula in re.split(r"[.;:]|,\s", respuesta):
        cl = clausula.lower()
        if re.search(r"\b(certific|garantiz)", cl) and not _PATRON_NEGACION.search(cl):
            violaciones.append("Afirma una certificación o garantía que el paquete no registra")
            break
    # Cobertura parcial: ACC-RD15 está solo catalogada; no se afirma salvo que el paquete registre cobertura parcial.
    if re.search(r"cubiert[oa]s?\s+parcialmente|parcialmente\s+cubiert|cobertura\s+parcial", texto) and \
            not any("parcial" in t.lower() for t in _valores(paquete)[0] if "cobertura" in t.lower() or t.lower() == "parcial"):
        violaciones.append("Afirma una cobertura parcial, que no figura en el paquete (ACC-RD15 no se aplicó)")
    # Atribución de la resolución de una dependencia: solo puede citarse el requerimiento que RESUELTA_POR registra.
    resolutores = {r["id"] for d in paquete.get("dependencias", []) for r in d.get("resuelta_por", [])}
    for m in re.finditer(r"resuelt[oa]s?\s+(?:por|con)\s+(?:el\s+requerimiento\s+|la\s+definici[oó]n\s+)?[\[(]?(" + PATRON_ID.pattern + ")",
                         respuesta):
        if m.group(1).rstrip(".") not in resolutores:
            violaciones.append(f"Atribuye la resolución a {m.group(1)}, que no figura en RESUELTA_POR")
    # Un pendiente cuyo seguimiento sigue abierto no se presenta como resuelto (PG2 §4.3, respuesta parcial).
    for pid in _pendientes_abiertos(paquete):
        for clausula in re.split(r"[.;:]|,\s|\s(?:y|mientras|pero|aunque)\s", respuesta):
            if _menciona_id(clausula, pid) and _PATRON_CIERRE.search(clausula.lower()) and not _PATRON_NEGACION.search(clausula.lower()):
                violaciones.append(f"Presenta {pid} como resuelto o cerrado, pero su seguimiento no figura resuelto")
                break
    return violaciones


def _menciona_id(texto: str, ident: str) -> bool:
    """Coincidencia de ID completo: P-TASA no cuenta como mencionado dentro de D-P-TASA o DEP-TASA-v1."""
    return re.search(r"(?<![\w-])" + re.escape(ident) + r"(?![\w-])", texto) is not None


def _cobertura(respuesta: str, requisitos: dict) -> list[str]:
    texto = respuesta.replace("_", " ").lower()
    faltan = [f"No menciona {i}" for i in requisitos.get("ids", []) if not _menciona_id(respuesta, i)]
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
            + f"\n\nPAQUETE DE EVIDENCIA (JSON recuperado de Neo4j):\n{json.dumps(paquete, ensure_ascii=False)}")
    mensaje = base
    for intento in (1, 2, 3):
        crudo, meta = llm.chat(prompts["explicacion"], mensaje, llm.cfg.temperatura_explicacion, max_tokens=700)
        respuesta = _limpiar_formato(crudo)
        violaciones = (verificar_respuesta(respuesta, paquete) + controles_criterios_pg2(respuesta, paquete)
                       + _cobertura(respuesta, requisitos))
        traza["intentos"].append({"intento": intento, "respuesta": respuesta, "violaciones": violaciones, **meta})
        if not violaciones:
            traza["resultado_verificacion"] = "aprobada"
            return respuesta, traza
        mensaje = (base + "\n\nTU RESPUESTA ANTERIOR:\n" + respuesta
                   + "\n\nFue rechazada por el verificador de fidelidad (GL05) por: " + "; ".join(violaciones)
                   + ". Corregila: conservá lo que estaba bien, corregí o agregá solo lo señalado, usá solo IDs y números "
                   "del paquete y cubrí los hechos indicados.")
    traza["resultado_verificacion"] = "rechazada; se emite la respuesta de respaldo"
    return respuesta_respaldo(paquete), traza


def respuesta_respaldo(paquete: dict) -> str:
    """Explicación determinística mínima cuando el LLM no supera el verificador."""
    partes = ["No pude generar una explicación verificable; resumo los datos recuperados de la base sin interpretarlos. "
              "Son resultados provisionales del prototipo, sin validación experta."]
    for c in paquete.get("comparaciones", []):
        res = c["resultado"]["id"] if c.get("resultado") else "sin resultado"
        partes.append(f"Evaluación {c['evaluacion_id']} ({c['estado']}, regla {_lista(c['reglas'])}): {res}.")
    for g in paquete.get("grados", []):
        partes.append(f"Evaluación {g['evaluacion_id']}: estado {g['estado']}, grado {_n(g['grado_contradiccion'])}, "
                      f"banda {g['banda_difusa']}.")
    for d in paquete.get("dependencias", []):
        partes.append(f"Versión {d['version']}: evaluación {d['evaluacion_id']} {d['estado_evaluacion']}; dependencia "
                      f"{d['dependencia_id']} {d['estado_dependencia']}.")
    for c in paquete.get("coberturas", []):
        partes.append(f"{c['documento_id']}: evaluación {c['evaluacion_id']} {c['estado']}, cobertura {c['cobertura']}.")
    for a in paquete.get("analisis", []):
        partes.append(f"{a['evaluacion_id']} ({a['tipo_analisis']}): {a['estado']}.")
    for d in paquete.get("derivaciones", []):
        partes.append(f"{d['observacion_id']}: severidad propuesta {d['severidad_propuesta']['valor'] or 'null'}; "
                      f"evaluación {d['evaluacion_id']} {d['estado_evaluacion']}.")
    return "\n".join(partes)


# --------------------------------------------------------------------------------------------
# Orquestador
# --------------------------------------------------------------------------------------------
def resumen_resultado(paquete: dict) -> list[str]:
    lineas: list[str] = []
    for c in paquete.get("comparaciones", []):
        grado = f" · grado {c['grado_contradiccion']:.6f} ({c['banda_difusa']})" if c.get("grado_contradiccion") is not None else " · grado null"
        res = f" -> {c['resultado']['clase']} {c['resultado']['id']}" if c.get("resultado") else ""
        lineas.append(f"{c['evaluacion_id']} · {c['documento_id']} · estado {c['estado']} · escenarios {c['escenarios']}"
                      f" · reglas {c['reglas']}{grado}{res}")
        for x in c.get("contradice", []):
            lineas.append(f"   CONTRADICE {x['desde']} -> {x['hasta']} · ámbito «{x['ambito']}» · {x['regla']}")
    for g in paquete.get("grados", []):
        grado = f"{g['grado_contradiccion']:.6f}" if g.get("grado_contradiccion") is not None else "null"
        lineas.append(f"{g['evaluacion_id']} · estado {g['estado']} · x={g['solapamiento_escenario']} "
                      f"y={g['incompatibilidad_resultados']} · grado {grado} · banda {g['banda_difusa']} · "
                      f"modelo {g['modelo_id']} · regla crisp {g['reglas_crisp']}")
        if g.get("reglas_difusas"):
            lineas.append("   activaciones " + str({r["id"]: r["activacion"] for r in g["reglas_difusas"]}))
        if g.get("resultado"):
            lineas.append(f"   -> {g['resultado']['clase']} {g['resultado']['id']} · revisión senior "
                          f"{str(g['revision_senior_requerida']).lower()}")
    for d in paquete.get("dependencias", []):
        res = f" -> {d['resultado']['id']}" if d.get("resultado") else ""
        seg = "".join(f" ({s['decision_id']} {s['estado']})" for s in (d.get("resultado") or {}).get("seguimiento_sm3", []))
        resuelta = f" · resuelta por {[r['id'] for r in d['resuelta_por']]}" if d.get("resuelta_por") else ""
        reev = f" · REEVALUA a {d['reevalua_a']}" if d.get("reevalua_a") else ""
        lineas.append(f"v{d['version']} · {d['evaluacion_id']} · {d['estado_evaluacion']} · {d['dependencia_id']} "
                      f"{d['estado_dependencia']} · reglas {d['reglas']}{resuelta}{reev}{res}{seg}")
    for c in paquete.get("coberturas", []):
        res = f" -> {c['resultado']['clase']} {c['resultado']['id']}" if c.get("resultado") else ""
        exige = "EXIGE" if c.get("exige") else "sin EXIGE"
        cubre = f"CUBRE {[x['requerimiento_id'] for x in c['cubre']]}" if c.get("cubre") else "sin CUBRE"
        lineas.append(f"{c['documento_id']} · {c['evaluacion_id']} · {c['estado']} · cobertura {c['cobertura']} · "
                      f"{exige} · {cubre} · reglas {c['reglas']}{res}")
    for a in paquete.get("analisis", []):
        res = f" -> {a['clase']} {a['resultado_id']}" if a.get("resultado_id") else ""
        lineas.append(f"{a['evaluacion_id']} · {a['tipo_analisis']} · {a['estado']} · reglas {a['reglas']}{res}")
    for d in paquete.get("derivaciones", []):
        sv = d["severidad_propuesta"]
        r = d.get("recepcion_sm3") or {}
        lineas.append(f"{d['observacion_id']} · {d['evaluacion_id']} ({d['estado_evaluacion']}) · severidad {sv['id']} = "
                      f"{sv['valor']} · reglas {d['reglas_origen']}")
        if r:
            lineas.append(f"   recepción SM3: {r['decision_id']} · {r['prioridad']}/{r['motivo']} · {r['estado_seguimiento']} · "
                          f"provisional={str(r['provisional']).lower()} · emitible={str(r['emitible']).lower()}")
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
            traza["resolucion_entidad"] = resolucion.resumen()
        if mostrar:
            titulo_etapa("3", "CONSULTA CYPHER A NEO4J", "plantillas parametrizadas de solo lectura")
            if resolucion:
                print(f"    resolución de entidad: {resolucion.estado} -> {resolucion.destino()}"
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
                print(textwrap.fill(linea, 140, initial_indent="    ", subsequent_indent="       "))
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
    print(T.c(T.NEGRITA, "Verificación del entorno de PI4 · SM2"))
    try:
        p = cargar_prompts()
        print(T.c(T.VERDE, f"  [ok] prompts y esquema cargados (huella {p['huella']})"))
        for nombre in CONSULTAS:
            assert es_solo_lectura(cargar_consulta(nombre)), nombre
        print(T.c(T.VERDE, f"  [ok] {len(CONSULTAS)} consultas Cypher de solo lectura"))
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
        if fila["evaluaciones_sm2"] == 0:
            print(T.c(T.ROJO, "  [error] la base no contiene AuditIA_PG2. Cargar PG2 con ejecutar_pg2.py antes de usar PI4."))
            ok = False
        elif fila["publicadas"] < fila["evaluaciones_sm2"]:
            print(T.c(T.AMARILLO, "  [aviso] hay evaluaciones sin publicar: ¿se ejecutaron todos los scripts de PG2?"))
        if fila["reglas_sm2_con_descripcion"] == 0:
            print(T.c(T.AMARILLO, "  [aviso] las reglas de SM2 no tienen descripción. Ejecutar una vez: "
                                  "python pi4_sm2_asistente.py --preparar"))
    except ErrorBase as e:
        print(T.c(T.ROJO, f"  [error] {e}"))
        ok = False
    print(T.c(T.VERDE if ok else T.ROJO, "Entorno listo." if ok else "Hay problemas que resolver antes de continuar."))
    return 0 if ok else 1


def modo_preparar(cfg: Config, confirmar: bool) -> int:
    print("Se incorporará a los nodos Regla de AuditIA_PG2 el texto SI...ENTONCES de las 22 reglas de SM2 de PG1 §6.5 "
          "(ACC-* y CAT-EX-*), sin sobrescribir.")
    if confirmar and input("¿Continuar? (s/n): ").strip().lower() not in ("s", "si", "sí"):
        print("Cancelado.")
        return 1
    kb = BaseConocimiento(cfg)
    n = kb.escribir_preparacion()
    fila = kb.leer("Q7_verificacion")[0]
    kb.cerrar()
    print(T.c(T.VERDE, f"Reglas documentadas: {n}. Reglas de SM2 con descripción en el grafo: "
                       f"{fila['reglas_sm2_con_descripcion']} de {fila['reglas_sm2']}."))
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
    if "entidad" in esperado:
        resolucion = json.dumps(traza.get("resolucion_entidad") or {}, ensure_ascii=False)
        controles["entidad"] = all(f'"{e}"' in resolucion for e in esperado["entidad"])
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
               "modelo": asistente.cfg.modelo, "hilos": asistente.cfg.hilos, "huella_prompts": asistente.prompts["huella"],
               "aprobados": aprobados, "total": len(resultados), "resultados": resultados}
    ruta_resumen.write_text(json.dumps(resumen, ensure_ascii=False, indent=2), encoding="utf-8")
    print(T.c(T.GRIS, "  resumen guardado en ejecuciones/resumen_casos.json"))
    return 0 if aprobados == len(resultados) else 1


def modo_interactivo(asistente: Asistente) -> int:
    print(T.c(T.NEGRITA + T.AZUL, "AuditIA · SM2 · Asistente de análisis cruzado y cobertura (PI4)"))
    print(T.c(T.GRIS, f"Modelo {asistente.cfg.modelo} · Neo4j {asistente.cfg.neo4j_uri} · "
                      "escribí 'salir' para terminar o 'catalogo' para ver los casos analizados"))
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
    ap = argparse.ArgumentParser(description="AuditIA PI4 · SM2 · LLM + Neo4j (patrón sándwich)")
    ap.add_argument("-p", "--pregunta", help="ejecuta una sola consulta y termina")
    ap.add_argument("--casos", nargs="*", metavar="ID", help="ejecuta la batería de casos (opcionalmente solo algunos IDs)")
    ap.add_argument("--verificar", action="store_true", help="comprueba Neo4j, Ollama y los archivos del prototipo")
    ap.add_argument("--preparar", action="store_true", help="incorpora una vez el texto de las reglas de SM2 de PG1 al grafo")
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
