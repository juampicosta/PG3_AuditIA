// Q3. Dependencia de un requerimiento lógico en cada versión: elemento necesario, referencias no disponibles,
// evaluación que la rastreó, estado de la dependencia, definición que la resuelve, regla, resultado, reevaluación
// (REEVALUA) y estado del seguimiento que SM3 registró para el resultado.
// Parámetros: $id_logico (String).
MATCH (rq:AuditIA_PG2:Requerimiento {id_logico: $id_logico})-[dd:DEPENDE_DE]->(en:ElementoNecesario)
MATCH (ev:EvaluacionCruzada {id: dd.evaluacion_id})-[:RASTREA]->(dep:Dependencia)-[:TIENE_ORIGEN]->(rq)
MATCH (ev)-[:REVISA_DOCUMENTO]->(doc:DocumentoVersion)
OPTIONAL MATCH (ev)-[:GENERA]->(o:ResultadoAnalisis)
RETURN {
  version: toInteger(doc.version),
  documento_id: doc.id,
  requerimiento_id: rq.id,
  texto: rq.texto_original,
  referencias_no_disponibles: doc.referencias_no_disponibles,
  elemento_necesario: {id: en.id, concepto: en.concepto, referencia: en.referencia},
  evaluacion_id: ev.id,
  estado_evaluacion: ev.estado,
  dependencia_id: dep.id,
  estado_dependencia: dep.estado,
  referencia_necesaria_disponible: ev.referencia_necesaria_disponible,
  cotejo_definicion: ev.cotejo_definicion,
  busqueda_completa: ev.busqueda_completa,
  resuelta_por: [(dep)-[:RESUELTA_POR]->(d:Requerimiento) | {id: d.id, texto: d.texto_original}],
  reglas: [(ev)-[:APLICA_REGLA]->(r:Regla) | r.id],
  evidencias: [(ev)-[:SE_SUSTENTA_EN]->(e:Evidencia) | {id: e.id, tipo: e.tipo, contenido: e.contenido}],
  resultado: CASE WHEN o IS NULL THEN null ELSE
    {id: o.id, clase: CASE WHEN o:Hallazgo THEN 'Hallazgo' ELSE 'Pendiente' END,
     motivo_pendiente: o.motivo_pendiente, dato_faltante: o.dato_faltante, descripcion: o.descripcion,
     seguimiento_sm3: [(d:DecisionPrioridad)-[:PRIORIZA]->(o) WHERE NOT EXISTS { MATCH (:DecisionPrioridad)-[:SUSTITUYE_A]->(d) } |
       {decision_id: d.id, estado: head([(d)-[:TIENE_ESTADO]->(er:EstadoResolucion) | er.valor])}]} END,
  reevalua_a: [(ev)-[:REEVALUA]->(a:Evaluacion) | a.id],
  reevaluada_por: [(n:Evaluacion)-[:REEVALUA]->(ev) | n.id],
  vigente: NOT EXISTS { MATCH (:Evaluacion)-[:REEVALUA]->(ev) }
} AS dependencia
ORDER BY dependencia.version;
