// Q10. Verificación de la base PG2 desde SM3 antes de iniciar el asistente. Solo lectura. Sin parámetros.
MATCH (d:AuditIA_PG2:DecisionPrioridad)
WITH count(d) AS decisiones,
     sum(CASE WHEN EXISTS { MATCH (:DecisionPrioridad)-[:SUSTITUYE_A]->(d) } THEN 0 ELSE 1 END) AS vigentes
MATCH (q:AuditIA_PG2:Pregunta)
WITH decisiones, vigentes, count(q) AS preguntas
MATCH (a:AuditIA_PG2:Respuesta)
WITH decisiones, vigentes, preguntas, count(a) AS respuestas
MATCH (i:AuditIA_PG2:InformeAuditoria)
WITH decisiones, vigentes, preguntas, respuestas, count(i) AS informes
MATCH (c:AuditIA_PG2:CeldaMatriz)
WITH decisiones, vigentes, preguntas, respuestas, informes, count(c) AS celdas_mpr01
MATCH (r:AuditIA_PG2:Regla) WHERE r.id STARTS WITH 'PRC-'
RETURN decisiones, vigentes, preguntas, respuestas, informes, celdas_mpr01,
       count(r) AS reglas_prc, sum(CASE WHEN r.descripcion IS NULL THEN 0 ELSE 1 END) AS reglas_prc_con_descripcion;
