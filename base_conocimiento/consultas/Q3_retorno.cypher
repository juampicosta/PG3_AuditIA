// ¿Qué respuesta habilitó el cierre y cómo se conserva el diagnóstico anterior?
MATCH (nueva:AuditIA_PG2:Evaluacion)-[:REEVALUA]->(anterior),
      (nueva)-[:CONSIDERA_RESPUESTA]->(a)-[:RESPONDE_A]->(q),
      (q)-[:ACLARA]->(o),(anterior)-[:GENERA]->(o),
      (d:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]->(o),
      (d)-[:SE_BASA_EN_REEVALUACION]->(nueva),(d)-[:SUSTITUYE_A]->(previa),
      (d)-[:TIENE_ESTADO]->(actual),(previa)-[:TIENE_ESTADO]->(historico),
      (sv:AuditIA_PG2:Severidad)<-[:TIENE_SEVERIDAD]-(o),
      (et:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-x-alta'})
WHERE a.estado_validacion='validada' AND nueva.autorizada_por_origen=true
      AND nueva.correspondencia_version=true
RETURN o.id AS observacion,anterior.id AS anterior,anterior.estado AS estado_anterior,
       a.id AS respuesta,nueva.id AS nueva,nueva.estado AS estado_nuevo,
       historico.valor AS seguimiento_anterior,actual.valor AS seguimiento_actual,
       CASE WHEN sv.grado_severidad>=0 AND sv.grado_severidad<=10 AND et.sigma>0
        THEN round(exp(-0.5*((sv.grado_severidad-et.centro)/et.sigma)^2),6)
        ELSE null END AS mu_alta_historica,
       d.provisional AS provisional
ORDER BY observacion;
