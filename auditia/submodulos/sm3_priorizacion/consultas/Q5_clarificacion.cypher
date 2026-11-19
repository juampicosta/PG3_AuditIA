// Q5. ¿Qué se preguntó para aclarar una observación, a quién y qué se respondió? Pregunta registrada (ACLARA),
// responsable (SE_DIRIGE_A), decisiones que la originan, respuestas (RESPONDE_A) con su validación, evaluación
// que las consideró y revisión del cierre. Una fila por observación; pregunta null si la base no registra ninguna.
// Parámetro: $observaciones (List<String>).
MATCH (o:AuditIA_PG2:ResultadoAnalisis)<-[:PRIORIZA]-(d:DecisionPrioridad)
WHERE o.id IN $observaciones AND NOT EXISTS { MATCH (:DecisionPrioridad)-[:SUSTITUYE_A]->(d) }
MATCH (d)-[:USA_CONTEXTO]->(x:ContextoPrioridad), (d)-[:TIENE_ESTADO]->(er:EstadoResolucion), (d)-[:APLICA_REGLA]->(r:Regla)
OPTIONAL MATCH (q:AuditIA_PG2:Pregunta)-[:ACLARA]->(o)
OPTIONAL MATCH (q)-[:SE_DIRIGE_A]->(resp:Responsable)
OPTIONAL MATCH (rev:RevisionHumana)-[:REVISA]->(d)
RETURN {
  observacion_id: o.id, tipo: CASE WHEN o:Hallazgo THEN 'hallazgo' ELSE 'pendiente' END,
  dato_faltante_origen: o.dato_faltante,
  decision_id: d.id, prioridad: d.prioridad, motivo: d.motivo, regla: r.id, estado: er.valor,
  provisional: d.provisional, emitible: d.emitible,
  decision_anterior: head([(d)-[:SUSTITUYE_A]->(p:DecisionPrioridad) |
    {id: p.id, regla: head([(p)-[:APLICA_REGLA]->(rp:Regla) | rp.id]),
     estado: head([(p)-[:TIENE_ESTADO]->(ep:EstadoResolucion) | ep.valor])}]),
  reevaluacion: head([(d)-[:SE_BASA_EN_REEVALUACION]->(re:Evaluacion) |
    {id: re.id, estado: re.estado, resultado_reevaluacion: re.resultado_reevaluacion}]),
  revision_humana: CASE WHEN rev IS NULL THEN null ELSE
    {id: rev.id, resultado: rev.resultado, naturaleza: rev.naturaleza, alcance: rev.alcance,
     rol: head([(rev)-[:REALIZADA_POR]->(ra:Responsable) | ra.rol])} END,
  // El dato a resolver del contexto se informa solo si no hay una pregunta registrada que ya lo pida.
  dato_para_resolver: CASE WHEN q IS NULL THEN x.dato_para_resolver ELSE null END,
  pregunta: CASE WHEN q IS NULL THEN null ELSE {
    id: q.id, texto: q.texto, dato_clave: q.dato_clave, asignacion: q.asignacion,
    revision_neutralidad: q.revision_neutralidad, propuesta_aceptada: q.propuesta_aceptada,
    responsable: CASE WHEN resp IS NULL THEN null ELSE resp {.id, .rol, .confirmado} END,
    observaciones_que_aclara: COLLECT { MATCH (q)-[:ACLARA]->(otra) RETURN otra.id ORDER BY otra.id },
    decisiones_de_origen: COLLECT { MATCH (q)-[:SE_ORIGINA_EN]->(dq:DecisionPrioridad)
                                    RETURN dq.id + ' (' + dq.prioridad + ')' ORDER BY dq.id },
    respuestas: COLLECT { MATCH (a:Respuesta)-[:RESPONDE_A]->(q)
                          OPTIONAL MATCH (evc:Evaluacion)-[:CONSIDERA_RESPUESTA]->(a)
                          RETURN {id: a.id, fecha: toString(a.fecha), contenido: a.contenido,
                                  estado_validacion: a.estado_validacion, datos_suficientes: a.datos_suficientes,
                                  discordancia_confirmada: a.discordancia_confirmada,
                                  aportada_por: head([(a)-[:APORTADA_POR]->(ra:Responsable) | ra.rol]),
                                  considerada_por: evc.id}
                          ORDER BY a.fecha } } END
} AS clarificacion
ORDER BY o.id;
