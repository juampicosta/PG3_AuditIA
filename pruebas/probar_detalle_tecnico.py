"""Regresión de la evidencia técnica persistida. Ejecutar con Neo4j disponible.

  podman compose exec -T app python pruebas/probar_detalle_tecnico.py

Usa un lote T propio y lo elimina al finalizar; no necesita llamadas al LLM.
"""
from __future__ import annotations

import json
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from auditia.ingesta import ErrorIngesta, Ingesta, proponer


class DetalleTecnico(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.ing = Ingesta()
        cls.propuesta = proponer(["El sistema debe cargar rápidamente el catálogo."], usar_llm=False,
                                documento="Prueba de detalle técnico")
        cls.propuesta["analista"] = "Prueba de trazabilidad"
        cls.propuesta["requerimientos"][0]["premisas"]["prioridad"].update(
            criticidad_valor="media", grado_criticidad=5.0, hito_acordado=False)
        cls.resultado = cls.ing.registrar(cls.propuesta, prefijo="T")
        cls.addClassCleanup(cls.ing.cerrar)
        cls.addClassCleanup(cls.ing.borrar, cls.resultado["lote"])

    def test_json_serializable_y_vinculos_completos(self):
        res = self.ing.resumen(self.resultado["lote"])
        json.dumps(res, ensure_ascii=False, allow_nan=False)
        nodos = {n["id"]: n["datos"] for n in res["tecnico"]["nodos"]}
        for o in res["observaciones"]:
            self.assertIn(o["juicio_id"], nodos)
            self.assertIn(o["id"], nodos)
            self.assertIn(o["decision"]["id"], nodos)
            self.assertTrue(any(r["desde"] == o["decision"]["id"] and r["relacion"] == "USA_CONTEXTO"
                                for r in res["tecnico"]["relaciones"]))

    def test_matriz_y_prioridad_preventiva_con_importancia_declarada(self):
        t = self.resultado["tecnico"]
        self.assertEqual(len(t["matriz"]), 9)
        hallazgo = next(o for o in self.resultado["observaciones"] if o["clase"] == "Hallazgo")
        self.assertEqual(hallazgo["decision"]["criticidad"]["valor"], "media")
        self.assertEqual(hallazgo["decision"]["categoria_matriz"], "mayor")
        self.assertEqual(hallazgo["decision"]["prioridad"], "bloqueante")
        self.assertEqual(hallazgo["decision"]["motivo"], "preventivo")
        self.assertIn("PRC-RD02", hallazgo["decision"]["reglas"])
        contexto = next(n["datos"] for n in t["nodos"] if n["id"] == "X-" + hallazgo["id"])
        self.assertIs(contexto["hito_acordado"], False)

    def test_pendiente_conserva_severidad_desconocida(self):
        pendiente = next(o for o in self.resultado["observaciones"] if o["clase"] == "Pendiente")
        self.assertIsNone(pendiente["severidad"]["valor"])
        self.assertIsNone(pendiente["decision"]["grado_urgencia"])
        n = next(n["datos"] for n in self.resultado["tecnico"]["nodos"]
                 if n["id"] == pendiente["decision"]["id"])
        self.assertEqual(n["estado_calculo_difuso"], "datos_desconocidos")

    def test_historial_conserva_lectura_premisas_y_tiempos(self):
        res = self.ing.resumen(self.resultado["lote"])
        prop = res["tecnico"]["propuesta_confirmada"]
        self.assertEqual(prop["requerimientos"][0]["extraccion"], self.propuesta["requerimientos"][0]["extraccion"])
        self.assertEqual(prop["requerimientos"][0]["premisas"]["prioridad"]["criticidad_valor"], "media")
        self.assertEqual(res["tiempos"], self.resultado["tiempos"])
        self.assertEqual(len(res["tiempos"]["etapas"]), 3)
        self.assertTrue(res["controles"]["todos_en_cero"])

    def test_modelos_y_activaciones_corresponden_al_registro(self):
        t = self.resultado["tecnico"]
        modelos = {m["datos"]["id"]: m for m in t["modelos"]}
        calculados = [n["datos"] for n in t["nodos"] if n["datos"].get("estado_calculo_difuso") == "calculado"]
        self.assertTrue(calculados)
        for n in calculados:
            m = modelos[n["modelo_difuso_version"]]
            self.assertEqual(len(m["variables"]), 3)
            self.assertEqual(len(n["reglas_difusas_ids"]), len(n["activaciones"]))
            self.assertTrue(set(n["reglas_difusas_ids"]) <= {r["id"] for r in m["reglas"]})
            self.assertTrue(all(0 <= a <= 1 for a in n["activaciones"]))

    def test_consultar_detalle_no_modifica_el_grafo(self):
        query = "MATCH (n:AuditIA_PG2) OPTIONAL MATCH (n)-[r]->() RETURN count(DISTINCT n) AS nodos, count(r) AS relaciones"
        antes = self.ing._q(query)
        self.ing.resumen(self.resultado["lote"])
        self.assertEqual(self.ing._q(query), antes)
        with self.assertRaises(ErrorIngesta):
            self.ing.resumen("T-NO-EXISTE")


if __name__ == "__main__":
    unittest.main(verbosity=2)
