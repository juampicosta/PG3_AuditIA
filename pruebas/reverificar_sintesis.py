#!/usr/bin/env python3
"""Re-verifica, sin volver a llamar al LLM, las síntesis aceptadas en las corridas guardadas
con el verificador semántico de la versión 1.2 (número ↔ variable, atributos ↔ ID).

Uso: python pruebas/reverificar_sintesis.py   ->  pruebas/resultados/reverificacion_sintesis_v1.2.json
"""
import json, sys
from pathlib import Path
RAIZ = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(RAIZ))
from auditia.orquestador import Orquestador, verificar_semantica  # noqa: E402

def main():
    orq = Orquestador.__new__(Orquestador)  # solo se usan métodos que no requieren Neo4j ni LLM
    filas = []
    for ruta in sorted((RAIZ / "trazas").glob("2*.json")):
        t = json.loads(ruta.read_text(encoding="utf-8"))
        sint = t.get("sintesis") or {}
        if len(t.get("pasos", [])) < 2:
            continue
        aceptada = sint.get("modo") == "sintesis_llm_verificada"
        texto = t.get("respuesta_final", "")
        respuestas = [p["traza"].get("respuesta_final", "") for p in t["pasos"]]
        sem = verificar_semantica(texto, respuestas)
        completo = Orquestador.verificar_sintesis(orq, texto, t["pasos"], t.get("consulta_usuario", "")) if aceptada else []
        filas.append({"traza": ruta.name, "caso": t.get("caso"), "modo_sintesis": sint.get("modo"),
                      "violaciones_semanticas": sem, "aprobada_v1_2": not sem and not completo})
    res = {"verificador": "PG3-AuditIA-1.2", "sintesis_revisadas": len(filas),
           "aprobadas": sum(f["aprobada_v1_2"] for f in filas), "detalle": filas}
    destino = RAIZ / "pruebas/resultados/reverificacion_sintesis_v1.2.json"
    destino.write_text(json.dumps(res, ensure_ascii=False, indent=2), encoding="utf-8")
    for f in filas:
        print(f"{f['caso']:7} {f['modo_sintesis']:28} {'OK' if f['aprobada_v1_2'] else 'RECHAZADA'} {f['violaciones_semanticas']}")
    print(f"{res['aprobadas']}/{res['sintesis_revisadas']} síntesis aprobadas con el verificador 1.2")

if __name__ == "__main__":
    main()
