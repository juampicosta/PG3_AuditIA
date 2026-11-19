// Casos construidos: una respuesta parcial no cierra y una completa exige reevaluación.
MATCH (q0:AuditIA_PG2:Fuente {id:'S-CASOS'}),(resp:AuditIA_PG2:Responsable {id:'RESP-NEG'})
MERGE (q:AuditIA_PG2 {id:'Q-CAT'}) ON CREATE SET q:Pregunta,q.texto='¿En qué escenario, con qué volumen y condición se acepta la carga del catálogo?',q.dato_clave='aceptacion_catalogo',q.asignacion='confirmada',q.revision_neutralidad='pendiente',q.propuesta_aceptada=false
MERGE (q)-[:SE_DIRIGE_A]->(resp)
WITH q,resp
MATCH (d:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]->(o) WHERE o.id IN ['H-CAT-B','P-CAT-V','P-CAT-C'] AND NOT EXISTS {MATCH (d)-[:SUSTITUYE_A]->()}
MERGE (q)-[:ACLARA]->(o) MERGE (q)-[:SE_ORIGINA_EN]->(d);
MATCH (q:AuditIA_PG2:Pregunta {id:'Q-CAT'}),(p:AuditIA_PG2:Responsable {id:'RESP-NEG'})
MERGE (a:AuditIA_PG2 {id:'A-CAT-P'}) ON CREATE SET a:Respuesta,a.fecha=datetime('2026-10-31T21:01:00-03:00'),a.contenido='Debe tardar poco',a.estado_validacion='parcial',a.datos_suficientes=false,a.discordancia_confirmada=false
MERGE (a)-[:RESPONDE_A]->(q) MERGE (a)-[:APORTADA_POR]->(p)
MERGE (b:AuditIA_PG2 {id:'A-CAT-C'}) ON CREATE SET b:Respuesta,b.fecha=datetime('2026-10-31T21:02:00-03:00'),b.contenido='100 productos con lista interactiva en menos de 2 segundos en el entorno acordado del caso',b.estado_validacion='validada',b.datos_suficientes=true,b.discordancia_confirmada=false
MERGE (b)-[:RESPONDE_A]->(q) MERGE (b)-[:APORTADA_POR]->(p)
WITH a,b
UNWIND [a,b] AS respuesta
MATCH (fuente:AuditIA_PG2:Fuente {id:'S-CASOS'})
MERGE (e:AuditIA_PG2 {id:'E-'+respuesta.id})
ON CREATE SET e:Evidencia,e.tipo='fragmento',e.contenido=respuesta.contenido,
 e.localizador=respuesta.id,e.naturaleza='caso_construido',e.autor_registro='Grupo 10',e.fecha=respuesta.fecha
MERGE (respuesta)-[:SE_SUSTENTA_EN]->(e) MERGE (e)-[:CITA_FUENTE]->(fuente);
// La revisión siguiente es parte del escenario construido, no una entrevista ni validación senior.
MATCH (old:AuditIA_PG2:Evaluacion {id:'EV-CAT-01',publicado:true}),
 (new:AuditIA_PG2:Evaluacion {id:'EV-CAT-02',publicado:true,estado:'sin_hallazgo'}),
 (a:AuditIA_PG2:Respuesta {id:'A-CAT-C',estado_validacion:'validada',datos_suficientes:true,discordancia_confirmada:false}),
 (r:AuditIA_PG2:Regla {id:'GL03'})
MERGE (new)-[:REEVALUA {evento_id:'RET-CAT-01'}]->(old) MERGE (new)-[:CONSIDERA_RESPUESTA]->(a)
MERGE (new)-[:APLICA_REGLA]->(r)
SET new.resultado_reevaluacion='resuelta',new.autorizada_por_origen=true,new.correspondencia_version=true;
MATCH (old:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]->(o),(old)-[:USA_CONTEXTO]->(x),
 (new:AuditIA_PG2:Evaluacion {id:'EV-CAT-02',resultado_reevaluacion:'resuelta',autorizada_por_origen:true,correspondencia_version:true}),
 (r:AuditIA_PG2:Regla {id:'PRC-RD09'}),(rv:AuditIA_PG2:Responsable {id:'RESP-AN'})
WHERE o.id IN ['H-CAT-B','P-CAT-V','P-CAT-C']
 AND NOT EXISTS { MATCH (old)-[:SUSTITUYE_A]->() }
MERGE (rev:AuditIA_PG2 {id:'REV-RET-CAT'}) ON CREATE SET rev:RevisionHumana,rev.resultado='conforme',rev.naturaleza='caso_construido',rev.fecha=datetime('2026-10-31T21:03:00-03:00'),rev.alcance='Ensayo del protocolo de retorno; no validación experta'
MERGE (rev)-[:REALIZADA_POR]->(rv) MERGE (rev)-[:REVISA]->(new)
MERGE (d:AuditIA_PG2 {id:old.id+'-R2'}) ON CREATE SET d:DecisionPrioridad,d.fecha=rev.fecha,d.prioridad=old.prioridad,d.motivo=old.motivo,d.provisional=true,d.emitible=false,d.revisada_humanamente=true,d.criticidad_id=old.criticidad_id
MERGE (d)-[:SUSTITUYE_A]->(old) MERGE (d)-[:PRIORIZA]->(o) MERGE (d)-[:USA_CONTEXTO]->(x) MERGE (d)-[:SE_BASA_EN_REEVALUACION]->(new) MERGE (d)-[:APLICA_REGLA]->(r)
MERGE (rev)-[:REVISA]->(d)
MERGE (er:AuditIA_PG2 {id:'ER-'+d.id}) ON CREATE SET er:EstadoResolucion,er.valor='resuelto',er.fecha=rev.fecha,er.motivo='Respuesta validada y reevaluación autorizada del caso construido'
MERGE (d)-[:TIENE_ESTADO]->(er)
WITH d,new MATCH (new)-[:SE_SUSTENTA_EN]->(e) MERGE (d)-[:SE_SUSTENTA_EN]->(e);
MATCH (old:AuditIA_PG2:Evaluacion {id:'EV-TASA-1',publicado:true}),(new:AuditIA_PG2:Evaluacion {id:'EV-TASA-2',estado:'sin_hallazgo'}),(r:AuditIA_PG2:Regla {id:'GL03'})
MERGE (new)-[:REEVALUA {evento_id:'RET-TASA-01'}]->(old) MERGE (new)-[:APLICA_REGLA]->(r)
SET new.resultado_reevaluacion='resuelta',new.autorizada_por_origen=true,new.correspondencia_version=true;
