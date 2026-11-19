// Q1. Diagnóstico local de un requerimiento: evaluaciones de SM1, juicios por criterio,
// reglas aplicadas, evidencia, resultados derivados e incidencias de entrada.
// Parámetros: $requerimiento_id (String), $criterio (String o null).
MATCH (ev:AuditIA_PG2:EvaluacionIndividual)-[:EVALUA]->(rq:AuditIA_PG2:Requerimiento {id: $requerimiento_id}),
      (ev)-[:REVISA_DOCUMENTO]->(doc:AuditIA_PG2:DocumentoVersion)
OPTIONAL MATCH (ev)-[:CONTIENE_JUICIO]->(j:JuicioCriterio)-[:APLICA_CRITERIO]->(c:CriterioCalidad)
WITH ev, rq, doc, j, c
WHERE j IS NULL OR $criterio IS NULL OR c.nombre = $criterio
WITH ev, rq, doc,
     collect(CASE WHEN j IS NULL THEN null ELSE {
       criterio: c.nombre,
       juicio_id: j.id,
       estado: j.estado,
       justificacion: j.justificacion,
       reglas: [(j)-[:APLICA_REGLA]->(r:Regla) | r.id],
       evidencias: [(j)-[:SE_SUSTENTA_EN]->(e:Evidencia) |
                    {id: e.id, tipo: e.tipo, contenido: e.contenido, localizador: e.localizador}],
       resultados: [(o:ResultadoAnalisis)-[:DERIVA_DE_JUICIO]->(j) |
                    {id: o.id,
                     clase: CASE WHEN o:Hallazgo THEN 'Hallazgo' WHEN o:Pendiente THEN 'Pendiente' ELSE 'ResultadoAnalisis' END,
                     motivo_pendiente: o.motivo_pendiente,
                     dato_faltante: o.dato_faltante,
                     severidad: head([(o)-[:TIENE_SEVERIDAD]->(sv:Severidad) | sv.valor])}],
       grado_ambiguedad: j.grado_ambiguedad,
       banda_difusa: j.banda_difusa,
       revision_senior_requerida: coalesce(j.revision_senior_requerida, false)
     } END) AS juicios
RETURN {
  evaluacion_id: ev.id,
  estado: ev.estado,
  fecha: toString(ev.fecha),
  entrada_valida: ev.entrada_valida,
  documento_id: doc.id,
  version: toInteger(doc.version),
  requerimiento_id: rq.id,
  texto_requerimiento: rq.texto_original,
  reglas_evaluacion: [(ev)-[:APLICA_REGLA]->(r:Regla) | r.id],
  incidencias: [(ev)-[:GENERA]->(i:IncidenciaEntrada) |
                {id: i.id, causa: i.causa, descripcion: i.descripcion,
                 accion_correccion: i.accion_correccion,
                 reglas: [(i)-[:APLICA_REGLA]->(ri:Regla) | ri.id]}],
  reevaluada_por: [(nueva:Evaluacion)-[:REEVALUA]->(ev) | nueva.id],
  reevalua_a: [(ev)-[:REEVALUA]->(anterior:Evaluacion) | anterior.id],
  vigente: NOT EXISTS { MATCH (:Evaluacion)-[:REEVALUA]->(ev) },
  juicios: juicios
} AS evaluacion
ORDER BY ev.fecha, ev.id;
