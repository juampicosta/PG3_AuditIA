// Agregados descriptivos. Calidad observada y completitud de auditoría son ejes separados.
MATCH (doc:AuditIA_PG2:DocumentoVersion)<-[:REVISA_DOCUMENTO]-(ev:Evaluacion)
WHERE ev.publicado=true
WITH doc,collect(DISTINCT ev) AS evaluaciones
UNWIND evaluaciones AS ev
OPTIONAL MATCH (ev)-[:CONTIENE_JUICIO]->(j)
WITH doc,evaluaciones,collect(DISTINCT j) AS juicios,
 collect(DISTINCT CASE WHEN ev:EvaluacionCruzada THEN ev END) AS cruzadas
WITH doc,evaluaciones,juicios,cruzadas,
 size(juicios)+size(cruzadas) AS unidades,
 size([j IN juicios WHERE j.estado IN ['cumple','incumple']])+
 size([ev IN cruzadas WHERE ev.estado IN ['observado','sin_hallazgo']]) AS concluyentes
UNWIND evaluaciones AS ev
OPTIONAL MATCH (ev)-[:GENERA]->(h:Hallazgo)
WITH doc,evaluaciones,unidades,concluyentes,collect(DISTINCT h) AS hallazgos
MERGE (informe:AuditIA_PG2 {id:'INF-'+doc.id})
ON CREATE SET informe:InformeAuditoria,informe.fecha=datetime('2026-10-31T21:05:00-03:00'),
 informe.hallazgos_demostrados=size(hallazgos),informe.unidades_aplicables=unidades,
 informe.unidades_concluyentes=concluyentes,
 informe.completitud_auditoria=CASE WHEN unidades>0 THEN 1.0*concluyentes/unidades ELSE null END,
 informe.calidad_observada=CASE WHEN size(hallazgos)>0 THEN 'con_defectos_demostrados'
                          WHEN concluyentes=0 THEN 'no_determinable'
                          ELSE 'sin_defectos_demostrados_en_alcance_revisado' END,
 informe.confianza_auditoria=CASE WHEN unidades=0 THEN 'no_determinable' WHEN concluyentes<unidades THEN 'limitada_por_informacion_pendiente' ELSE 'alcance_revisado_concluyente' END,
 informe.validacion_experta='pendiente',informe.emitible=false
MERGE (informe)-[:CONSOLIDA]->(doc)
WITH informe,doc
OPTIONAL MATCH (d:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]->(o)<-[:GENERA]-(origen:Evaluacion)
OPTIONAL MATCH (d)-[:SE_BASA_EN_REEVALUACION]->(reevaluacion:Evaluacion)
WITH informe,doc,d,coalesce(reevaluacion,origen) AS evaluacion_decision
WHERE (evaluacion_decision)-[:REVISA_DOCUMENTO]->(doc)
 AND NOT EXISTS {
  MATCH (sucesora:DecisionPrioridad)-[:SUSTITUYE_A]->(d),
        (sucesora)-[:SE_BASA_EN_REEVALUACION]->(:Evaluacion)-[:REVISA_DOCUMENTO]->(doc)
 }
WITH informe,collect(DISTINCT d) AS decisiones
FOREACH (d IN decisiones | MERGE (informe)-[:INCLUYE]->(d));
