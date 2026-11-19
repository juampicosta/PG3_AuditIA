// ¿Qué decisiones conserva el informe de cada versión del catálogo?
MATCH (i:AuditIA_PG2:InformeAuditoria)-[:INCLUYE]->(d:DecisionPrioridad)-[:TIENE_ESTADO]->(er:EstadoResolucion)
WHERE i.id IN ['INF-DOC-CAT-v1','INF-DOC-CAT-v2']
RETURN i.id AS informe,d.id AS decision,er.valor AS seguimiento
ORDER BY informe,decision;
