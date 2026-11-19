"""Registro de los tres submódulos de AuditIA (prototipos PI4 integrados sin cambiar su lógica).

Cada submódulo conserva su patrón sándwich validado en PI4:
extracción con LLM -> Cypher fijo de solo lectura -> paquete de evidencia -> explicación -> verificador GL05.
El orquestador de PG3 los usa como herramientas a través de `Asistente.responder()`.
"""
from __future__ import annotations

import importlib
from dataclasses import dataclass
from types import ModuleType


@dataclass(frozen=True)
class FichaSubmodulo:
    clave: str
    paquete: str
    nombre: str
    responsable: str
    tarea_experta: str


REGISTRO: dict[str, FichaSubmodulo] = {
    "SM1": FichaSubmodulo("SM1", "sm1_calidad", "Evaluación de calidad individual", "Costa, Juan Pablo",
                          "Juzga cada requerimiento con cuatro criterios: atomicidad, ambigüedad, verificabilidad y "
                          "completitud; calcula el grado difuso de ambigüedad (MD-AMB-1.0)."),
    "SM2": FichaSubmodulo("SM2", "sm2_cruzado", "Análisis cruzado y cobertura", "Isgró, Tomás Valentino",
                          "Compara pares de requerimientos (contradicción), rastrea dependencias y revisa la cobertura "
                          "de categorías no funcionales; calcula el grado difuso de contradicción (MD-CONTR-1.0)."),
    "SM3": FichaSubmodulo("SM3", "sm3_priorizacion", "Priorización y clarificación", "Lucero, Bruno",
                          "Asigna prioridad y motivo con la matriz MPR-01, calcula la urgencia difusa (MD-URG-1.0) y "
                          "gestiona preguntas de clarificación, seguimiento, revisión senior e informe del documento."),
}

_MODULOS: dict[str, ModuleType] = {}


def modulo(clave: str) -> ModuleType:
    """Importa (una sola vez) el script PI4 del submódulo como módulo de Python."""
    if clave not in _MODULOS:
        _MODULOS[clave] = importlib.import_module(f"auditia.submodulos.{REGISTRO[clave].paquete}.asistente")
    return _MODULOS[clave]
