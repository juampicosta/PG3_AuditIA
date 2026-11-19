// ¿Qué urgencia gradual surge de severidad y criticidad sin cambiar la prioridad crisp?
MATCH (ev:AuditIA_PG2:Evaluacion)-[:GENERA]->(o)-[:TIENE_SEVERIDAD]->(sv),
      (d:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]->(o),
      (cr:AuditIA_PG2:Criticidad {id:d.criticidad_id}),
      (et:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-y-alta'})
WHERE o.id IN ['H-PRIO-MAYOR','H-PRIO-MENOR','H-PRIO-EXCEPCION','H-PRIO-FRONTERA']
WITH ev,o,sv,d,cr,et
RETURN o.id AS observacion,sv.grado_severidad AS severidad_gradual,
       cr.grado_criticidad AS criticidad_gradual,
       round(exp(-0.5*((cr.grado_criticidad-et.centro)/et.sigma)^2),6) AS mu_criticidad_alta,
       round(d.grado_urgencia,6) AS urgencia,d.prioridad AS prioridad,
       d.motivo AS motivo,d.provisional AS provisional,
       d.modelo_difuso_version AS modelo
ORDER BY observacion;
