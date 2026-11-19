// Q6. ¿Qué categoría asigna MPR-01 a una combinación de severidad y criticidad? Celda de la matriz candidata
// y decisiones vigentes con esa misma combinación, para mostrar cómo actuaron las puertas de hito y diferimiento.
// Parámetros: $severidad y $criticidad (String: baja, media o alta).
MATCH (c:AuditIA_PG2:CeldaMatriz {severidad: $severidad, criticidad: $criticidad})
OPTIONAL MATCH (d:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]->(o)-[:TIENE_SEVERIDAD]->(:Severidad {valor: $severidad})
WHERE NOT EXISTS { MATCH (:DecisionPrioridad)-[:SUSTITUYE_A]->(d) }
  AND EXISTS { MATCH (cr:AuditIA_PG2:Criticidad {id: d.criticidad_id}) WHERE cr.valor = $criticidad }
OPTIONAL MATCH (d)-[:APLICA_REGLA]->(r:Regla)
OPTIONAL MATCH (d)-[:USA_CONTEXTO]->(x:ContextoPrioridad)
OPTIONAL MATCH (d)-[:TIENE_ESTADO]->(er:EstadoResolucion)
WITH c, d, o, r, x, er ORDER BY o.id
WITH c, collect(CASE WHEN d IS NULL THEN null ELSE
    {observacion_id: o.id, decision_id: d.id, prioridad: d.prioridad, motivo: d.motivo, regla: r.id,
     estado: er.valor, categoria_matriz: d.categoria_matriz, hito_acordado: x.hito_acordado,
     diferimiento_aceptado: x.diferimiento_aceptado, impacto_acotado: x.impacto_acotado,
     bloqueo_sustantivo_confirmado: x.bloqueo_sustantivo_confirmado,
     provisional: d.provisional, emitible: d.emitible} END) AS decisiones
RETURN {
  celda: c.id, version: c.version, severidad: c.severidad, criticidad: c.criticidad,
  categoria: c.categoria, estado_validacion: c.estado_validacion, decisiones: decisiones
} AS matriz;
