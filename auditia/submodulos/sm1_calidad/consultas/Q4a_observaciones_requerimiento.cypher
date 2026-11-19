// Q4a. Observaciones de SM1 (Hallazgo o Pendiente) asociadas a un requerimiento lógico.
// Resuelve el $observacion_id que necesita Q4 cuando el usuario describe el requerimiento.
// Parámetros: $id_logico (String), $criterio (String o null).
MATCH (ev:AuditIA_PG2:EvaluacionIndividual)-[:GENERA]->(o:ResultadoAnalisis)-[:AFECTA_REQUERIMIENTO]->(rq:Requerimiento {id_logico: $id_logico})
WHERE o:Hallazgo OR o:Pendiente
OPTIONAL MATCH (o)-[:DERIVA_DE_JUICIO]->(:JuicioCriterio)-[:APLICA_CRITERIO]->(c:CriterioCalidad)
WITH o, ev, rq, c
WHERE $criterio IS NULL OR c.nombre = $criterio
RETURN o.id AS observacion_id,
       CASE WHEN o:Hallazgo THEN 'Hallazgo' ELSE 'Pendiente' END AS clase,
       c.nombre AS criterio, ev.id AS evaluacion_id, rq.id AS requerimiento_id
ORDER BY observacion_id;
