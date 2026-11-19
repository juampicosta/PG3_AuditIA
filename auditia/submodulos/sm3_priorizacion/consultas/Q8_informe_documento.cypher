// Q8. ¿Cómo quedó el informe de auditoría de un documento y qué decisiones siguen abiertas? InformeAuditoria
// (CONSOLIDA) con calidad observada, completitud, madurez (null si no se calculó) y decisiones incluidas.
// Parámetro: $documento_id (String).
MATCH (i:AuditIA_PG2:InformeAuditoria)-[:CONSOLIDA]->(doc:DocumentoVersion {id: $documento_id})
OPTIONAL MATCH (i)-[:INCLUYE]->(d:DecisionPrioridad)-[:TIENE_ESTADO]->(er:EstadoResolucion)
OPTIONAL MATCH (d)-[:PRIORIZA]->(o)
WITH i, doc, d, er, o ORDER BY CASE d.prioridad WHEN 'bloqueante' THEN 0 WHEN 'mayor' THEN 1 ELSE 2 END, o.id
WITH i, doc, collect(CASE WHEN d IS NULL THEN null ELSE
       {decision_id: d.id, observacion_id: o.id, prioridad: d.prioridad, motivo: d.motivo, estado: er.valor} END) AS decisiones
RETURN {
  informe_id: i.id, documento_id: doc.id, version: doc.version,
  hallazgos_demostrados: i.hallazgos_demostrados, calidad_observada: i.calidad_observada,
  unidades_concluyentes: i.unidades_concluyentes, unidades_aplicables: i.unidades_aplicables,
  completitud_auditoria: i.completitud_auditoria, confianza_auditoria: i.confianza_auditoria,
  madurez_documento: i.madurez_documento, alerta_alcance: i.alerta_alcance,
  validacion_experta: i.validacion_experta, emitible: i.emitible,
  decisiones_abiertas: size([x IN decisiones WHERE x.estado <> 'resuelto']),
  decisiones: decisiones
} AS informe;
