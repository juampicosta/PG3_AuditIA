#!/usr/bin/env python3
"""Prepara la base de conocimiento del asistente integrado (una sola vez).

1. Carga la base de PG2 con su ejecutor original (scripts 01 a 06, consultas Q1-Q3 y 44 comprobaciones).
2. Ejecuta la preparación P0 de cada submódulo (texto SI...ENTONCES de sus reglas de PG1, sin sobrescribir).
3. Verifica conteos y guarda pruebas/resultados/preparacion.json.

Uso (dentro del contenedor de la app):  python preparar_base.py
"""
from __future__ import annotations

import getpass
import json
import os
import sys
import time
from pathlib import Path

RAIZ = Path(__file__).resolve().parent
sys.path.insert(0, str(RAIZ))
sys.path.insert(0, str(RAIZ / "base_conocimiento"))

from auditia.config import ConfigGeneral  # noqa: E402
from auditia.submodulos import REGISTRO, modulo  # noqa: E402


def esperar_neo4j(cfg: ConfigGeneral, intentos: int = 40) -> None:
    from neo4j import GraphDatabase
    for i in range(intentos):
        try:
            with GraphDatabase.driver(cfg.neo4j_uri, auth=(cfg.neo4j_usuario, cfg.neo4j_password)) as d:
                d.verify_connectivity()
            return
        except Exception as e:  # noqa: BLE001
            print(f"  esperando a Neo4j ({i + 1}/{intentos}): {type(e).__name__}")
            time.sleep(3)
    raise SystemExit("Neo4j no respondió.")


def main() -> int:
    cfg = ConfigGeneral()
    if not cfg.neo4j_password:
        raise SystemExit("Falta NEO4J_PASSWORD (archivo .env).")
    resultado: dict = {"fecha": time.strftime("%Y-%m-%dT%H:%M:%S"), "neo4j_uri": cfg.neo4j_uri}
    print("1/3 Esperando a Neo4j…")
    esperar_neo4j(cfg)

    print("2/3 Cargando la base de PG2 con su ejecutor original…")
    import ejecutar_pg2  # base_conocimiento/ejecutar_pg2.py
    getpass.getpass = lambda prompt="": cfg.neo4j_password  # el ejecutor pide la contraseña por teclado
    url_http = os.environ.get("NEO4J_HTTP_URL", "http://neo4j:7474")
    sys.argv = ["ejecutar_pg2.py", "--url", url_http, "--usuario", cfg.neo4j_usuario]
    t0 = time.perf_counter()
    ejecutar_pg2.main()
    reproduccion = json.loads((RAIZ / "base_conocimiento/pruebas/resultados_reproduccion.json").read_text(encoding="utf-8"))
    resultado["pg2"] = {"segundos": round(time.perf_counter() - t0, 1),
                        "pruebas_pasadas": sum(1 for p in reproduccion["pruebas"] if p.get("estado") == "pasado"),
                        "conteo_nodos_relaciones": next(p for p in reproduccion["pruebas"] if p["id"] == "PT21")["despues"]}

    print("3/3 Preparación P0 de cada submódulo (texto de reglas de PG1)…")
    resultado["p0"] = {}
    for clave, ficha in REGISTRO.items():
        mod = modulo(clave)
        kb = mod.BaseConocimiento(cfg.para_submodulo(mod))
        n = kb.escribir_preparacion()
        kb.cerrar()
        resultado["p0"][clave] = n
        print(f"   {clave} · {ficha.nombre}: {n} reglas documentadas")

    from neo4j import GraphDatabase
    with GraphDatabase.driver(cfg.neo4j_uri, auth=(cfg.neo4j_usuario, cfg.neo4j_password)) as d:
        fila = d.execute_query("MATCH (r:Regla:AuditIA_PG2) RETURN count(r) AS total, count(r.descripcion) AS con_texto",
                               database_=cfg.neo4j_database).records[0]
        conteo = d.execute_query("MATCH (n:AuditIA_PG2) OPTIONAL MATCH (n)-[r]->(:AuditIA_PG2) "
                                 "RETURN count(DISTINCT n) AS nodos, count(r) AS relaciones",
                                 database_=cfg.neo4j_database).records[0]
    resultado["final"] = {"reglas": fila["total"], "reglas_con_texto": fila["con_texto"],
                          "nodos": conteo["nodos"], "relaciones": conteo["relaciones"]}
    destino = RAIZ / "pruebas/resultados"
    destino.mkdir(parents=True, exist_ok=True)
    (destino / "preparacion.json").write_text(json.dumps(resultado, ensure_ascii=False, indent=2), encoding="utf-8")
    print(json.dumps(resultado, ensure_ascii=False, indent=2))
    print("Base lista.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
