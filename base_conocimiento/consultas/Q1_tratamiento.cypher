// ¿Qué observaciones requieren atención y qué distingue el bloqueo preventivo del sustantivo?
MATCH (ev:AuditIA_PG2:Evaluacion)-[:GENERA]->(o)-[:TIENE_SEVERIDAD]->(sv),
      (d:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]->(o),
      (d)-[:USA_CONTEXTO]->(x),(d)-[:APLICA_REGLA]->(r),
      (d)-[:TIENE_ESTADO]->(er),(d)-[:SE_SUSTENTA_EN]->(e)-[:CITA_FUENTE]->(f),
      (et:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-x-alta'})
WHERE o.id IN ['H-CAT-B','P-TASA','H-DESC','H-SEG']
  AND NOT EXISTS { MATCH (d)-[:SUSTITUYE_A]->() }
WITH ev,o,sv,d,x,r,er,et,collect(DISTINCT e.id) AS evidencias,
     collect(DISTINCT f.id) AS fuentes
RETURN ev.id AS evaluacion,o.id AS observacion,o.modulo_origen AS origen,
       sv.valor AS severidad,d.prioridad AS prioridad,d.motivo AS motivo,
       CASE WHEN sv.grado_severidad>=0 AND sv.grado_severidad<=10 AND et.sigma>0
         THEN round(exp(-0.5*((sv.grado_severidad-et.centro)/et.sigma)^2),6)
         ELSE null END AS mu_severidad_alta,
       d.provisional AS provisional,r.id AS regla,evidencias,fuentes
ORDER BY observacion;
