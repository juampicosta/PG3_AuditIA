// Q3. Listado filtrado de juicios de SM1.
// Parámetros: $criterio, $estado, $banda (String o null) y $solo_vigentes (Boolean).
MATCH (ev:AuditIA_PG2:EvaluacionIndividual)-[:CONTIENE_JUICIO]->(j:JuicioCriterio)-[:APLICA_CRITERIO]->(c:CriterioCalidad),
      (ev)-[:EVALUA]->(rq:Requerimiento),
      (ev)-[:REVISA_DOCUMENTO]->(doc:DocumentoVersion)
WHERE ($criterio IS NULL OR c.nombre = $criterio)
  AND ($estado IS NULL OR j.estado = $estado)
  AND ($banda IS NULL OR j.banda_difusa = $banda)
  AND ($solo_vigentes = false OR NOT EXISTS { MATCH (:Evaluacion)-[:REEVALUA]->(ev) })
RETURN {
  requerimiento_id: rq.id,
  texto_requerimiento: rq.texto_original,
  documento_id: doc.id,
  version: toInteger(doc.version),
  evaluacion_id: ev.id,
  estado_evaluacion: ev.estado,
  criterio: c.nombre,
  juicio_id: j.id,
  estado: j.estado,
  reglas: [(j)-[:APLICA_REGLA]->(r:Regla) | r.id],
  grado_ambiguedad: CASE WHEN j.grado_ambiguedad IS NULL THEN null ELSE round(j.grado_ambiguedad, 6) END,
  banda_difusa: j.banda_difusa,
  resultados: [(o:ResultadoAnalisis)-[:DERIVA_DE_JUICIO]->(j) | o.id]
} AS juicio
ORDER BY rq.id_logico, toInteger(doc.version), ev.id, c.nombre
LIMIT 40;
