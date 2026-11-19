// Q5. Historia de un requerimiento lógico: versiones, evaluaciones de SM1, retorno (REEVALUA),
// respuestas consideradas, preguntas, criterio de aceptación y seguimiento de cada observación.
// Parámetros: $id_logico (String).
MATCH (rq:AuditIA_PG2:Requerimiento {id_logico: $id_logico})<-[:EVALUA]-(ev:EvaluacionIndividual)-[:REVISA_DOCUMENTO]->(doc:DocumentoVersion)
OPTIONAL MATCH (ev)-[re:REEVALUA]->(anterior:Evaluacion)
RETURN {
  version: toInteger(doc.version),
  documento_id: doc.id,
  requerimiento_id: rq.id,
  texto_requerimiento: rq.texto_original,
  evaluacion_id: ev.id,
  estado: ev.estado,
  fecha: toString(ev.fecha),
  reevalua_a: anterior.id,
  evento_retorno: re.evento_id,
  resultado_reevaluacion: ev.resultado_reevaluacion,
  reglas_evaluacion: [(ev)-[:APLICA_REGLA]->(r:Regla) | r.id],
  juicios: [(ev)-[:CONTIENE_JUICIO]->(j:JuicioCriterio)-[:APLICA_CRITERIO]->(c:CriterioCalidad) |
            {criterio: c.nombre, juicio_id: j.id, estado: j.estado,
             grado_ambiguedad: CASE WHEN j.grado_ambiguedad IS NULL THEN null ELSE round(j.grado_ambiguedad, 6) END,
             banda_difusa: j.banda_difusa}],
  criterio_aceptacion: [(rq)-[:SE_INTERPRETA_CON]->(:ContextoRequerimiento)-[:DECLARA]->(ca:CriterioAceptacion) |
                        {id: ca.id, metodo: ca.metodo, condicion_aprobacion: ca.condicion_aprobacion}],
  respuestas_consideradas: [(ev)-[:CONSIDERA_RESPUESTA]->(a:Respuesta) |
                            {id: a.id, contenido: a.contenido, estado_validacion: a.estado_validacion,
                             fecha: toString(a.fecha)}],
  observaciones: [(ev)-[:GENERA]->(o:ResultadoAnalisis) |
                  {id: o.id,
                   clase: CASE WHEN o:Hallazgo THEN 'Hallazgo' WHEN o:Pendiente THEN 'Pendiente'
                               WHEN o:IncidenciaEntrada THEN 'IncidenciaEntrada' ELSE 'ResultadoAnalisis' END,
                   preguntas: [(q:Pregunta)-[:ACLARA]->(o) |
                               {id: q.id, texto: q.texto,
                                respuestas: [(a:Respuesta)-[:RESPONDE_A]->(q) |
                                             {id: a.id, contenido: a.contenido, estado_validacion: a.estado_validacion}]}],
                   seguimiento: [(d:DecisionPrioridad)-[:PRIORIZA]->(o) |
                                 {decision_id: d.id, prioridad: d.prioridad, motivo: d.motivo,
                                  provisional: d.provisional,
                                  estado: head([(d)-[:TIENE_ESTADO]->(er:EstadoResolucion) | er.valor]),
                                  sustituye_a: head([(d)-[:SUSTITUYE_A]->(p:DecisionPrioridad) | p.id])}]}]
} AS version_evaluada
ORDER BY toInteger(doc.version), ev.fecha, ev.id;
