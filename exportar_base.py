#!/usr/bin/env python3
"""Exporta la base de conocimiento cargada (etiqueta AuditIA_PG2) sin APOC.

Genera en base_conocimiento/exportacion/:
  - auditia_export.json    nodos (id, etiquetas, propiedades) y relaciones (tipo, origen, destino, propiedades)
  - auditia_export.cypher  script idempotente (MERGE por id) que reconstruye la base en otra instancia Neo4j 5.x
  - resumen.json           conteos por etiqueta y por tipo de relación

Uso: docker compose exec app python exportar_base.py
"""
from __future__ import annotations

import collections
import datetime as dt
import json
import sys
from pathlib import Path

RAIZ = Path(__file__).resolve().parent
sys.path.insert(0, str(RAIZ))
from auditia.config import ConfigGeneral  # noqa: E402

DEST = RAIZ / "base_conocimiento" / "exportacion"


def literal(v):
    if v is None:
        return "null"
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (int, float)):
        return repr(v)
    if isinstance(v, list):
        return "[" + ", ".join(literal(x) for x in v) + "]"
    return "'" + str(v).replace("\\", "\\\\").replace("'", "\\'") + "'"


def mapa(props: dict) -> str:
    return "{" + ", ".join(f"`{k}`: {literal(v)}" for k, v in sorted(props.items())) + "}"


def main() -> int:
    from neo4j import GraphDatabase
    cfg = ConfigGeneral()
    DEST.mkdir(parents=True, exist_ok=True)
    with GraphDatabase.driver(cfg.neo4j_uri, auth=(cfg.neo4j_usuario, cfg.neo4j_password)) as d:
        nodos = [r.data() for r in d.execute_query(
            "MATCH (n:AuditIA_PG2) RETURN n.id AS id, labels(n) AS etiquetas, properties(n) AS props ORDER BY n.id",
            database_=cfg.neo4j_database).records]
        rels = [r.data() for r in d.execute_query(
            "MATCH (a:AuditIA_PG2)-[r]->(b:AuditIA_PG2) RETURN a.id AS origen, type(r) AS tipo, b.id AS destino, "
            "properties(r) AS props ORDER BY origen, tipo, destino", database_=cfg.neo4j_database).records]
    sin_id = [n for n in nodos if n["id"] is None]
    if sin_id:
        print(f"Aviso: {len(sin_id)} nodos sin propiedad id; se exportan en JSON pero no en el Cypher.")

    def serial(x):
        return x.isoformat() if hasattr(x, "isoformat") else str(x)

    (DEST / "auditia_export.json").write_text(json.dumps({"exportado": dt.datetime.now().isoformat(timespec="seconds"),
                                                         "nodos": nodos, "relaciones": rels},
                                                        ensure_ascii=False, indent=1, default=serial), encoding="utf-8")
    lineas = ["// AuditIA · exportación de la base de conocimiento (etiqueta AuditIA_PG2)",
              f"// Generado: {dt.datetime.now().isoformat(timespec='seconds')} · {len(nodos)} nodos · {len(rels)} relaciones",
              "// Idempotente: MERGE por id. Ejecutar en Neo4j 5.x (Browser o cypher-shell).",
              "CREATE CONSTRAINT auditia_id IF NOT EXISTS FOR (n:AuditIA_PG2) REQUIRE n.id IS UNIQUE;", ""]
    for n in nodos:
        if n["id"] is None:
            continue
        etiquetas = ":".join(f"`{e}`" for e in sorted(n["etiquetas"]) if e != "AuditIA_PG2")
        props = {k: (serial(v) if hasattr(v, "isoformat") else v) for k, v in n["props"].items()}
        lineas.append(f"MERGE (n:AuditIA_PG2 {{id: {literal(n['id'])}}}) SET n{':' + etiquetas if etiquetas else ''}, n = {mapa(props)};")
    lineas.append("")
    for r in rels:
        props = {k: (serial(v) if hasattr(v, "isoformat") else v) for k, v in (r["props"] or {}).items()}
        set_ = f" SET r = {mapa(props)}" if props else ""
        lineas.append(f"MATCH (a:AuditIA_PG2 {{id: {literal(r['origen'])}}}), (b:AuditIA_PG2 {{id: {literal(r['destino'])}}}) "
                      f"MERGE (a)-[r:`{r['tipo']}`]->(b){set_};")
    (DEST / "auditia_export.cypher").write_text("\n".join(lineas) + "\n", encoding="utf-8")
    resumen = {"nodos": len(nodos), "relaciones": len(rels),
               "por_etiqueta": dict(collections.Counter(e for n in nodos for e in n["etiquetas"]).most_common()),
               "por_tipo_relacion": dict(collections.Counter(r["tipo"] for r in rels).most_common())}
    (DEST / "resumen.json").write_text(json.dumps(resumen, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Exportados {len(nodos)} nodos y {len(rels)} relaciones en {DEST}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
