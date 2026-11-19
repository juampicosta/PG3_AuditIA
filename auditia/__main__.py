"""Interfaz de consola del asistente integrado.

  python -m auditia --verificar
  python -m auditia -p "¿Se contradicen los requerimientos de los descuentos y por qué quedó bloqueante?"
  python -m auditia            (modo interactivo)
"""
from __future__ import annotations

import argparse
import json
import sys
import textwrap

from .orquestador import Orquestador


def imprimir(traza: dict, detalle: bool) -> None:
    ruteo = traza.get("enrutamiento") or {}
    if ruteo:
        plan = ruteo.get("plan", {})
        print(f"\n[enrutamiento · {ruteo.get('fuente')}] {plan.get('tipo')} · {plan.get('motivo', '')}")
    for p in traza.get("pasos", []):
        t = p["trazabilidad"]
        print(f"\n[paso {p['paso']} · {p['submodulo']} · {t['intencion']}] {p['subconsulta']}")
        if p.get("enlace"):
            print(f"   enlace: {p['enlace']}")
        for c in t["consultas"]:
            print(f"   Cypher {c['consulta']} {json.dumps(c['parametros'], ensure_ascii=False)} -> {c['filas']} fila(s)")
        print(f"   reglas: {', '.join(r['id'] for r in t['reglas']) or '-'} · verificación: {t['verificacion']}")
        if detalle:
            print(textwrap.indent(textwrap.fill(p["traza"].get("respuesta_final", ""), 100), "   > "))
    print(f"\n[respuesta · {traza.get('tipo_salida')} · {(traza.get('sintesis') or {}).get('modo', '-')}]")
    for parrafo in (traza.get("respuesta_final") or "").split("\n"):
        print(textwrap.fill(parrafo, 104) if parrafo.strip() else "")
    print(f"\ntraza: {traza.get('archivo_traza')} · {traza.get('segundos_totales')} s")


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(prog="python -m auditia", description="AuditIA · asistente integrado (PG3)")
    ap.add_argument("-p", "--pregunta")
    ap.add_argument("--verificar", action="store_true")
    ap.add_argument("--detalle", action="store_true", help="muestra también la respuesta de cada submódulo")
    a = ap.parse_args(argv)
    orq = Orquestador()
    try:
        if a.verificar:
            estado = orq.verificar()
            print(json.dumps({k: v for k, v in estado.items() if k != "modelos"}, ensure_ascii=False, indent=2))
            return 0 if estado.get("listo") else 1
        if a.pregunta:
            imprimir(orq.responder(a.pregunta, etiqueta="cli"), a.detalle)
            return 0
        print("AuditIA · asistente integrado. Escribí una consulta (o 'salir').")
        while True:
            try:
                q = input("\n> ").strip()
            except (EOFError, KeyboardInterrupt):
                break
            if q.lower() in ("salir", "exit", "quit"):
                break
            if q:
                imprimir(orq.responder(q, etiqueta="cli"), a.detalle)
        return 0
    finally:
        orq.cerrar()


if __name__ == "__main__":
    sys.exit(main())
