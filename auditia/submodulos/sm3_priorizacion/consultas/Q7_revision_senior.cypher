// Q7. ¿Qué recomendaciones abiertas conviene que revise el analista senior antes de emitirse? Decisiones vigentes
// con la marca revision_senior_requerida o con la regla PRC-HC02, cuyo mapeo alta = bloqueante es candidato.
// La consulta informa por separado la marca real del grafo y el motivo de inclusión. Sin parámetros.
MATCH (d:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]->(o:ResultadoAnalisis), (d)-[:APLICA_REGLA]->(r:Regla),
      (d)-[:TIENE_ESTADO]->(er:EstadoResolucion), (d)-[:USA_CONTEXTO]->(x:ContextoPrioridad)
WHERE NOT EXISTS { MATCH (:DecisionPrioridad)-[:SUSTITUYE_A]->(d) } AND er.valor <> 'resuelto'
  AND (d.revision_senior_requerida = true OR r.id = 'PRC-HC02')
RETURN o.id AS observacion, d.id AS decision, d.prioridad AS prioridad, d.motivo AS motivo, r.id AS regla,
       CASE WHEN d.grado_urgencia IS NULL THEN null ELSE round(d.grado_urgencia, 3) END AS grado_urgencia,
       d.banda_difusa AS banda_urgencia, er.valor AS estado,
       coalesce(d.revision_senior_requerida, false) AS revision_senior_requerida,
       x.mapeo_alta_bloqueante AS mapeo_alta_bloqueante,
       CASE WHEN coalesce(d.revision_senior_requerida, false) THEN 'marca_revision_senior_requerida'
            ELSE 'regla_PRC-HC02_con_mapeo_candidato' END AS motivo_inclusion,
       d.revisada_humanamente AS revisada_humanamente, d.provisional AS provisional, d.emitible AS emitible
ORDER BY observacion;
