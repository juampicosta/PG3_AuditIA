"""Exporta, solo lectura, el lote de la demo y el estado del sistema para las capturas del informe v1.3."""
import json, sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parent))
from auditia import api

dest = Path(__file__).resolve().parent / "pruebas" / "resultados" / "demo_v13"
dest.mkdir(parents=True, exist_ok=True)
lotes = api.listar_lotes()
lote = sys.argv[1] if len(sys.argv) > 1 else sorted(l["lote"] for l in lotes if l["lote"].startswith("L"))[-1]
datos = {"salud": api.salud(), "ejemplos": api.ejemplos(), "lotes": lotes, "lote": api.ver_lote(lote)}
for k, v in datos.items():
    (dest / f"{k}.json").write_text(json.dumps(v, ensure_ascii=False, indent=1, default=str), encoding="utf-8")
print("exportado", lote, "en", dest)
