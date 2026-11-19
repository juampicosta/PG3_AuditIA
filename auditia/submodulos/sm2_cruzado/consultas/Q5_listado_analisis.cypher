// Q5. Listado filtrado de evaluaciones cruzadas de SM2 con su regla, resultado y grado.
// Parámetros: $tipo_analisis, $estado (String o null) y $solo_vigentes (Boolean).
MATCH (ev:AuditIA_PG2:EvaluacionCruzada)-[:REVISA_DOCUMENTO]->(doc:DocumentoVersion)
WHERE ($tipo_analisis IS NULL OR ev.tipo_analisis = $tipo_analisis)
  AND ($estado IS NULL OR ev.estado = $estado)
  AND ($solo_vigentes = false OR NOT EXISTS { MATCH (:Evaluacion)-[:REEVALUA]->(ev) })
OPTIONAL MATCH (ev)-[:GENERA]->(o:ResultadoAnalisis)
RETURN {
  evaluacion_id: ev.id,
  tipo_analisis: ev.tipo_analisis,
  estado: ev.estado,
  documento_id: doc.id,
  reglas: [(ev)-[:APLICA_REGLA]->(r:Regla) | r.id],
  resultado_id: o.id,
  clase: CASE WHEN o:Hallazgo THEN 'Hallazgo' WHEN o:Pendiente THEN 'Pendiente' ELSE null END,
  motivo_o_defecto: coalesce(o.tipo_defecto, o.motivo_pendiente),
  dato_faltante: o.dato_faltante,
  grado_contradiccion: CASE WHEN ev.grado_contradiccion IS NULL THEN null ELSE round(ev.grado_contradiccion, 6) END,
  banda_difusa: ev.banda_difusa,
  vigente: NOT EXISTS { MATCH (:Evaluacion)-[:REEVALUA]->(ev) }
} AS analisis
ORDER BY analisis.tipo_analisis, analisis.evaluacion_id;
