"""AuditIA · PG3 · API unificada (FastAPI) y servidor de la miniapp web.

Endpoints:
  GET  /                      miniapp (auditia/web/index.html)
  GET  /api/salud             estado de Neo4j, Ollama, modelo y base cargada
  GET  /api/ejemplos          consultas de ejemplo (casos integrados de pruebas/casos_e2e.json)
  POST /api/consultas         {"consulta": "..."} -> {"id": ...}  (la consulta se procesa en segundo plano)
  GET  /api/consultas/{id}    estado, etapa actual y, al terminar, la traza completa
  POST /api/consultar         versión síncrona (espera la respuesta; útil para scripts y curl)
  GET  /api/trazas            últimas trazas guardadas
  GET  /api/trazas/{nombre}   una traza guardada

Análisis de requerimientos nuevos (v1.3, auditia/ingesta.py):
  POST   /api/analisis/documentos        {"nombre": "x.docx", "contenido_b64": "..."} -> requerimientos detectados
  POST   /api/analisis/propuestas        {"requerimientos": [...], "contexto": "", "usar_llm": true} -> {"id": ...}
  GET    /api/analisis/propuestas/{id}   estado y, al terminar, la propuesta de premisas para revisar
  POST   /api/analisis/lotes             {"propuesta": {...}} premisas confirmadas -> escribe, infiere y devuelve el resultado
  GET    /api/analisis/lotes             lotes ingresados por el analista
  GET    /api/analisis/lotes/{lote}      resultado de un lote
  DELETE /api/analisis/lotes/{lote}      borra un lote (solo nodos con origen = analista)
"""
from __future__ import annotations

import json
import threading
import uuid
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

from fastapi import FastAPI, HTTPException
from fastapi.responses import FileResponse
from pydantic import BaseModel, Field

import base64

from . import documentos, ingesta
from .config import DIR_TRAZAS, RAIZ
from .orquestador import VERSION, Orquestador

app = FastAPI(title="AuditIA · Asistente integrado (PG3)", version=VERSION,
              description="Grupo 10 · Inteligencia Artificial · UTN FRM · 2026")
_orq: Orquestador | None = None
_ejecutor = ThreadPoolExecutor(max_workers=1)   # Ollama local: una consulta por vez, el resto espera en cola
_trabajos: dict[str, dict] = {}
_lock = threading.Lock()
WEB = Path(__file__).resolve().parent / "web"


def orquestador() -> Orquestador:
    global _orq
    if _orq is None:
        _orq = Orquestador()
    return _orq


class Pedido(BaseModel):
    consulta: str = Field(min_length=1, max_length=600)


def _resumen(traza: dict) -> dict:
    """Respuesta para la miniapp: lo esencial más la trazabilidad por paso (sin el paquete completo)."""
    return {
        "consulta": traza.get("consulta_usuario"),
        "respuesta": traza.get("respuesta_final"),
        "tipo_salida": traza.get("tipo_salida"),
        "motivo_cierre": traza.get("motivo_cierre"),
        "segundos": traza.get("segundos_totales"),
        "archivo_traza": traza.get("archivo_traza"),
        "enrutamiento": {
            "fuente": (traza.get("enrutamiento") or {}).get("fuente"),
            "plan": (traza.get("enrutamiento") or {}).get("plan"),
            "intentos": len((traza.get("enrutamiento") or {}).get("intentos", [])),
        },
        "pasos": [{"paso": p["paso"], "submodulo": p["submodulo"], "subconsulta": p["subconsulta"],
                   "enlace": p.get("enlace"), "reenrutado_desde": p.get("reenrutado_desde"),
                   "respuesta": p["traza"].get("respuesta_final"), "segundos": p["traza"].get("segundos_totales"),
                   "trazabilidad": p.get("trazabilidad")} for p in traza.get("pasos", [])],
        "sintesis": {"modo": (traza.get("sintesis") or {}).get("modo"),
                     "intentos": len((traza.get("sintesis") or {}).get("intentos", []))},
    }


def _procesar(tid: str, consulta: str) -> None:
    def progreso(etapa: str, detalle: str) -> None:
        with _lock:
            _trabajos[tid]["etapas"].append({"etapa": etapa, "detalle": detalle})
    with _lock:
        _trabajos[tid]["estado"] = "procesando"
    try:
        traza = orquestador().responder(consulta, etiqueta="web", progreso=progreso)
        with _lock:
            _trabajos[tid].update({"estado": "terminado", "resultado": _resumen(traza)})
    except Exception as e:  # noqa: BLE001
        with _lock:
            _trabajos[tid].update({"estado": "error", "error": str(e)})


@app.get("/", include_in_schema=False)
def inicio():
    return FileResponse(WEB / "index.html")


@app.get("/api/salud")
def salud():
    return orquestador().verificar()


@app.get("/api/ejemplos")
def ejemplos():
    ruta = RAIZ / "pruebas" / "casos_e2e.json"
    casos = json.loads(ruta.read_text(encoding="utf-8")) if ruta.exists() else []
    return [{"id": c["id"], "titulo": c["titulo"], "consulta": c["consulta"]} for c in casos]


@app.post("/api/consultas")
def encolar(pedido: Pedido):
    tid = uuid.uuid4().hex[:10]
    with _lock:
        en_cola = sum(1 for t in _trabajos.values() if t["estado"] in ("en_cola", "procesando"))
        _trabajos[tid] = {"id": tid, "estado": "en_cola", "consulta": pedido.consulta, "etapas": [], "en_cola": en_cola}
    _ejecutor.submit(_procesar, tid, pedido.consulta)
    return {"id": tid, "en_cola": en_cola}


@app.get("/api/consultas/{tid}")
def estado(tid: str):
    with _lock:
        t = _trabajos.get(tid)
        if not t:
            raise HTTPException(404, "Consulta inexistente")
        return dict(t)


@app.post("/api/consultar")
def consultar(pedido: Pedido):
    return _resumen(orquestador().responder(pedido.consulta, etiqueta="api"))


@app.get("/api/trazas")
def trazas(limite: int = 20):
    archivos = sorted(DIR_TRAZAS.glob("*.json"), reverse=True)[:limite]
    return [a.name for a in archivos]


@app.get("/api/trazas/{nombre}")
def traza(nombre: str):
    ruta = (DIR_TRAZAS / nombre).resolve()
    if ruta.parent != DIR_TRAZAS.resolve() or not ruta.exists():
        raise HTTPException(404, "Traza inexistente")
    return json.loads(ruta.read_text(encoding="utf-8"))


# ============================================================================================
# Análisis de requerimientos nuevos (v1.3)
# ============================================================================================
_ingesta: ingesta.Ingesta | None = None


def servicio_ingesta() -> ingesta.Ingesta:
    global _ingesta
    if _ingesta is None:
        _ingesta = ingesta.Ingesta()
        _ingesta.asegurar_preparacion()
    return _ingesta


class ItemRequerimiento(BaseModel):
    texto: str = Field(min_length=8, max_length=1000)
    ubicacion: str = Field(default="", max_length=80)
    id_documento: str = Field(default="", max_length=40)


class PedidoPropuesta(BaseModel):
    requerimientos: list[str | ItemRequerimiento] = Field(min_length=1, max_length=ingesta.MAX_REQUERIMIENTOS)
    contexto: str = Field(default="", max_length=1500)
    usar_llm: bool = True
    documento: str = Field(default="", max_length=160)


class PedidoDocumento(BaseModel):
    nombre: str = Field(min_length=3, max_length=160)
    contenido_b64: str = Field(min_length=4, max_length=12_000_000)


class PedidoLote(BaseModel):
    propuesta: dict


def _proponer(tid: str, pedido: PedidoPropuesta) -> None:
    def progreso(etapa: str, detalle: str) -> None:
        with _lock:
            _trabajos[tid]["etapas"].append({"etapa": etapa, "detalle": detalle})
    with _lock:
        _trabajos[tid]["estado"] = "procesando"
    try:
        items = [r if isinstance(r, str) else r.model_dump() for r in pedido.requerimientos]
        prop = ingesta.proponer(items, pedido.contexto, pedido.usar_llm, progreso=progreso, documento=pedido.documento)
        with _lock:
            _trabajos[tid].update({"estado": "terminado", "resultado": prop})
    except Exception as e:  # noqa: BLE001
        with _lock:
            _trabajos[tid].update({"estado": "error", "error": str(e)})


@app.post("/api/analisis/propuestas")
def encolar_propuesta(pedido: PedidoPropuesta):
    usa_llm = pedido.usar_llm
    for r in pedido.requerimientos:
        t = r if isinstance(r, str) else r.texto
        if not 8 <= len(t.strip()) <= 1000:
            raise HTTPException(422, "Cada requerimiento debe tener entre 8 y 1000 caracteres.")
    tid = "p" + uuid.uuid4().hex[:9]
    with _lock:
        en_cola = sum(1 for t in _trabajos.values() if t["estado"] in ("en_cola", "procesando"))
        _trabajos[tid] = {"id": tid, "estado": "en_cola", "tipo": "propuesta", "etapas": [], "en_cola": en_cola}
    if usa_llm:
        _ejecutor.submit(_proponer, tid, pedido)   # comparte la cola de Ollama con las consultas
    else:
        _proponer(tid, pedido)                     # borrador léxico: instantáneo, no usa Ollama
    return {"id": tid, "en_cola": en_cola if usa_llm else 0}


@app.post("/api/analisis/documentos")
def leer_documento(pedido: PedidoDocumento):
    """Extrae el texto de un .txt/.md/.docx/.pdf y devuelve los requerimientos detectados con su ubicación."""
    try:
        datos = base64.b64decode(pedido.contenido_b64.split(",", 1)[-1], validate=False)
        return documentos.leer_documento(pedido.nombre, datos)
    except documentos.ErrorDocumento as e:
        raise HTTPException(422, str(e)) from e


@app.get("/api/analisis/propuestas/{tid}")
def estado_propuesta(tid: str):
    return estado(tid)


@app.post("/api/analisis/lotes")
def registrar_lote(pedido: PedidoLote):
    try:
        return servicio_ingesta().registrar(pedido.propuesta)
    except ingesta.ErrorIngesta as e:
        raise HTTPException(422, str(e)) from e


@app.get("/api/analisis/lotes")
def listar_lotes():
    return servicio_ingesta().listar()


@app.get("/api/analisis/lotes/{lote}")
def ver_lote(lote: str):
    try:
        res = servicio_ingesta().resumen(lote)
    except ingesta.ErrorIngesta as e:
        raise HTTPException(404, str(e)) from e
    res["consultas_sugeridas"] = ingesta.consultas_sugeridas(res)
    return res


@app.delete("/api/analisis/lotes/{lote}")
def borrar_lote(lote: str):
    try:
        return {"lote": lote, "borrados": servicio_ingesta().borrar(lote)}
    except ingesta.ErrorIngesta as e:
        raise HTTPException(422, str(e)) from e
