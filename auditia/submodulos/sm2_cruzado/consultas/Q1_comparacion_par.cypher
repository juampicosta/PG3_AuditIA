// Q1. Comparación de un par de requerimientos: evaluaciones cruzadas que comparan ambos, premisas del escenario,
// obligaciones, relación CONTRADICE derivada, regla aplicada, evidencia, resultado y grado difuso guardado.
// Parámetros: $requerimiento_ids (List<String>).
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {tipo_analisis: 'comparacion'})-[:COMPARA]->(rq:Requerimiento)
WHERE rq.id IN $requerimiento_ids
WITH ev, collect(DISTINCT rq.id) AS coincidencias
WHERE size(coincidencias) = size($requerimiento_ids)
MATCH (ev)-[:REVISA_DOCUMENTO]->(doc:DocumentoVersion)
OPTIONAL MATCH (ev)-[:GENERA]->(o:ResultadoAnalisis)
OPTIONAL MATCH (ev)-[:APLICA_MODELO]->(md:ModeloDifuso)
RETURN {
  evaluacion_id: ev.id,
  estado: ev.estado,
  documento_id: doc.id,
  version: toInteger(doc.version),
  escenarios: ev.escenarios,
  resultados_incompatibles: ev.resultados_incompatibles,
  excepcion_resuelve: ev.excepcion_resuelve,
  interpretacion_cerrada: ev.interpretacion_cerrada,
  requerimientos: [(ev)-[:COMPARA]->(r:Requerimiento) |
    {id: r.id, texto: r.texto_original,
     obligacion: head([(r)-[:EXPRESA]->(ob:Obligacion) |
       {id: ob.id, sujeto: ob.sujeto, accion: ob.accion, objeto: ob.objeto, modalidad: ob.modalidad, resultado: ob.resultado}]),
     escenario: head([(r)-[:EXPRESA]->(:Obligacion)-[:APLICA_EN]->(es:Escenario) |
       {id: es.id, actor: es.actor, objeto: es.objeto, estado: es.estado}])}],
  contradice: [(a:Requerimiento)-[c:CONTRADICE {evaluacion_id: ev.id}]->(b:Requerimiento) |
    {desde: a.id, hasta: b.id, regla: c.regla_id, ambito: c.ambito}],
  reglas: [(ev)-[:APLICA_REGLA]->(r:Regla) | r.id],
  evidencias: [(ev)-[:SE_SUSTENTA_EN]->(e:Evidencia) | {id: e.id, tipo: e.tipo, contenido: e.contenido}],
  resultado: CASE WHEN o IS NULL THEN null ELSE
    {id: o.id, clase: CASE WHEN o:Hallazgo THEN 'Hallazgo' ELSE 'Pendiente' END,
     tipo_defecto: o.tipo_defecto, motivo_pendiente: o.motivo_pendiente,
     descripcion: o.descripcion, dato_faltante: o.dato_faltante} END,
  grado_contradiccion: CASE WHEN ev.grado_contradiccion IS NULL THEN null ELSE round(ev.grado_contradiccion, 6) END,
  banda_difusa: ev.banda_difusa,
  modelo_id: md.id,
  vigente: NOT EXISTS { MATCH (:Evaluacion)-[:REEVALUA]->(ev) }
} AS comparacion
ORDER BY comparacion.evaluacion_id;
