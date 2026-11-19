// Q7. Verificación de la base PG2 antes de iniciar el asistente de SM2. Solo lectura.
MATCH (ev:AuditIA_PG2:EvaluacionCruzada)
WITH count(ev) AS evaluaciones_sm2, sum(CASE WHEN ev.publicado = true THEN 1 ELSE 0 END) AS publicadas,
     sum(CASE WHEN ev.grado_contradiccion IS NULL THEN 0 ELSE 1 END) AS grados_contradiccion
OPTIONAL MATCH (o:AuditIA_PG2:ResultadoAnalisis {modulo_origen: 'analisis_cruzado'})
WITH evaluaciones_sm2, publicadas, grados_contradiccion, count(o) AS resultados_sm2
MATCH (r:AuditIA_PG2:Regla {modulo: 'analisis_cruzado'})
RETURN evaluaciones_sm2, publicadas, grados_contradiccion, resultados_sm2,
       count(r) AS reglas_sm2, sum(CASE WHEN r.descripcion IS NULL THEN 0 ELSE 1 END) AS reglas_sm2_con_descripcion;
