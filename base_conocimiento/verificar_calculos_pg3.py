#!/usr/bin/env python3
"""PG3 · Verificación numérica independiente de los tres modelos difusos (MD-AMB, MD-CONTR, MD-URG).

Recalcula en Python, sin Neo4j, cada grado difuso y sus activaciones a partir de los parámetros de PI3
(datos/modelos_pi3.json) y los compara con DOS fuentes:
  1. evidencias/calculos_difusos.json   valores registrados en la corrida de PG2 (ahora incluido en el paquete);
  2. exportacion/auditia_export.json    valores leídos de la base recargada en el entorno integrado de PG3.

Uso: python base_conocimiento/verificar_calculos_pg3.py   (no requiere Docker ni conexión)
Resultado: evidencias/verificacion_independiente_pg3.json
"""
import json, pathlib, sys
ROOT = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))
from verificar_calculos import infer  # implementación independiente de PG2 (Mamdani min/max, centroide en 1001 puntos)

MAPA = {"DecisionPrioridad": ("MD-URG-1.0", "grado_urgencia"),
        "JuicioCriterio": ("MD-AMB-1.0", "grado_ambiguedad"),
        "EvaluacionCruzada": ("MD-CONTR-1.0", "grado_contradiccion")}


def desde_exportacion():
    datos = json.loads((ROOT / "exportacion/auditia_export.json").read_text(encoding="utf-8"))
    filas = []
    for n in datos["nodos"]:
        p = n["props"]
        for etiqueta, (modelo, campo) in MAPA.items():
            if etiqueta in n["etiquetas"] and p.get(campo) is not None and p.get("activaciones"):
                filas.append({"id": p["id"], "modelo": modelo, "x": p["input_x"], "y": p["input_y"],
                              "grado": p[campo], "activaciones": p["activaciones"]})
    return filas


def contrastar(filas, modelos, fuente):
    salida = []
    for f in filas:
        grado, act = infer(modelos[f["modelo"].split("-")[1]], f["x"], f["y"])
        err = abs(grado - f["grado"])
        err_a = max(abs(a - b) for a, b in zip(act, f["activaciones"]))
        salida.append({"fuente": fuente, "id": f["id"], "modelo": f["modelo"], "entrada": [f["x"], f["y"]],
                       "grado_registrado": f["grado"], "grado_python": grado, "error_absoluto": err,
                       "error_maximo_activaciones": err_a, "estado": "pasado" if err <= 1e-9 and err_a <= 1e-9 else "fallido"})
    return salida


def main():
    modelos = json.loads((ROOT / "datos/modelos_pi3.json").read_text(encoding="utf-8"))
    pg2 = json.loads((ROOT / "evidencias/calculos_difusos.json").read_text(encoding="utf-8"))
    pg3 = desde_exportacion()
    comps = contrastar(pg2, modelos, "evidencia_PG2") + contrastar(pg3, modelos, "base_recargada_PG3")
    ok = all(c["estado"] == "pasado" for c in comps)
    res = {"metodo": "Mamdani MIN/MAX, centroide discreto de 1001 puntos (implementación independiente de Cypher)",
           "tolerancia_absoluta": 1e-9, "total": len(comps), "pasados": sum(c["estado"] == "pasado" for c in comps),
           "error_maximo": max(c["error_absoluto"] for c in comps), "comparaciones": comps}
    (ROOT / "evidencias/verificacion_independiente_pg3.json").write_text(json.dumps(res, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Comparaciones: {res['pasados']}/{res['total']} pasadas (PG2: {len(pg2)}, base PG3: {len(pg3)}); error máximo {res['error_maximo']:.2e}")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
