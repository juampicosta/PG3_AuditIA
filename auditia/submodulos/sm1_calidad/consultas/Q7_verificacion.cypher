// Q7. Verificación de la base PG2 antes de iniciar el asistente. Solo lectura.
MATCH (ev:AuditIA_PG2:EvaluacionIndividual)
WITH count(ev) AS evaluaciones_sm1, sum(CASE WHEN ev.publicado = true THEN 1 ELSE 0 END) AS publicadas
MATCH (j:AuditIA_PG2:JuicioCriterio)
WITH evaluaciones_sm1, publicadas, count(j) AS juicios,
     sum(CASE WHEN j.grado_ambiguedad IS NULL THEN 0 ELSE 1 END) AS grados_ambiguedad
MATCH (r:AuditIA_PG2:Regla)
RETURN evaluaciones_sm1, publicadas, juicios, grados_ambiguedad,
       count(r) AS reglas, sum(CASE WHEN r.descripcion IS NULL THEN 0 ELSE 1 END) AS reglas_con_descripcion;
