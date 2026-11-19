// Q2. ¿Por qué una observación recibió su prioridad? Decisión vigente con sus premisas (ContextoPrioridad),
// regla aplicada, severidad del emisor, criticidad declarada, celda de MPR-01, decisión anterior (SUSTITUYE_A),
// evidencia y reevaluaciones de la evaluación de origen, indicando si la decisión se basa en cada una.
// Parámetro: $observacion_id (String).
MATCH (o:AuditIA_PG2:ResultadoAnalisis {id: $observacion_id})<-[:PRIORIZA]-(d:DecisionPrioridad)
WHERE NOT EXISTS { MATCH (:DecisionPrioridad)-[:SUSTITUYE_A]->(d) }
MATCH (d)-[:USA_CONTEXTO]->(x:ContextoPrioridad), (d)-[:APLICA_REGLA]->(r:Regla),
      (d)-[:TIENE_ESTADO]->(er:EstadoResolucion), (o)-[:TIENE_SEVERIDAD]->(sv:Severidad),
      (origen:Evaluacion)-[:GENERA]->(o)
OPTIONAL MATCH (cr:AuditIA_PG2:Criticidad {id: d.criticidad_id})
OPTIONAL MATCH (celda:AuditIA_PG2:CeldaMatriz {severidad: sv.valor, criticidad: cr.valor})
OPTIONAL MATCH (d)-[:SUSTITUYE_A]->(prev:DecisionPrioridad)
RETURN {
  observacion_id: o.id,
  tipo: CASE WHEN o:Hallazgo THEN 'hallazgo' ELSE 'pendiente' END,
  modulo_origen: o.modulo_origen,
  evaluacion_origen_id: origen.id,
  descripcion_origen: o.descripcion,
  dato_faltante_origen: o.dato_faltante,
  severidad: {id: sv.id, valor: sv.valor, grado_severidad: sv.grado_severidad, propuesta_por: sv.propuesta_por},
  criticidad: CASE WHEN cr IS NULL THEN null ELSE
    {id: cr.id, valor: cr.valor, grado_criticidad: cr.grado_criticidad, ambito: cr.ambito,
     fundamento: cr.fundamento, declarante_rol: cr.declarante_rol} END,
  celda_mpr01: CASE WHEN celda IS NULL THEN null ELSE
    {id: celda.id, categoria: celda.categoria, version: celda.version, estado_validacion: celda.estado_validacion} END,
  contexto: x {.id, .info_para_priorizar_suficiente, .necesidad_dato_confirmada, .dato_para_priorizar_disponible,
               .obligacion_esencial_indefinida, .bloqueo_sustantivo_confirmado, .hito_acordado,
               .diferimiento_aceptado, .impacto_acotado, .mapeo_alta_bloqueante},
  decision_id: d.id, prioridad: d.prioridad, motivo: d.motivo, regla: r.id,
  estado: er.valor, provisional: d.provisional, emitible: d.emitible,
  revisada_humanamente: d.revisada_humanamente,
  revision_senior_requerida: coalesce(d.revision_senior_requerida, false),
  decision_anterior: CASE WHEN prev IS NULL THEN null ELSE
    {id: prev.id, prioridad: prev.prioridad, motivo: prev.motivo,
     regla: head([(prev)-[:APLICA_REGLA]->(rp:Regla) | rp.id]),
     estado: head([(prev)-[:TIENE_ESTADO]->(ep:EstadoResolucion) | ep.valor])} END,
  evidencia_decision: [(d)-[:SE_SUSTENTA_EN]->(e:Evidencia) |
    {id: e.id, contenido: e.contenido, fuente: head([(e)-[:CITA_FUENTE]->(f:Fuente) | f.id])}],
  reevaluaciones_del_origen: [(posterior:Evaluacion)-[:REEVALUA]->(origen) |
    {id: posterior.id, estado: posterior.estado, resultado_reevaluacion: posterior.resultado_reevaluacion,
     documento_id: head([(posterior)-[:REVISA_DOCUMENTO]->(dp:DocumentoVersion) | dp.id]),
     decision_se_basa_en_ella: EXISTS { MATCH (d)-[:SE_BASA_EN_REEVALUACION]->(posterior) }}]
} AS fundamento;
