// AuditIA PG3 v1.3 · Inferencia crisp para requerimientos nuevos ingresados por el analista.
// Generaliza la materialización de 03_inferencia_crisp.cypher: las condiciones de las reglas son las mismas,
// pero los identificadores de resultados se derivan del caso (no hay IDs fijos de casos construidos).
// Cada sentencia se limita al lote recibido ($lote); nunca toca los casos de PG2.
// Orden: excepciones antes que defectos (PG1 §6), juicio → evaluación → resultado → severidad → contexto → prioridad.
// Después se ejecuta 04_difusa.cypher acotado al mismo lote y 06_informes.cypher.

// SM1. Juicio por criterio. Se agregan las reglas catalogadas EVI-HC01/HC03/HC05/HC06/HC07 de PG1 §6.4.
MATCH (ev:AuditIA_PG2:EvaluacionIndividual {lote:$lote,publicado:false,entrada_valida:true})-[:CONTIENE_JUICIO]->(j)-[:APLICA_CRITERIO]->(c)
WITH ev,j,c, CASE
 WHEN c.nombre='verificabilidad' AND j.aceptacion_necesaria=true AND j.aceptacion_disponible=false THEN 'EVI-RD03'
 WHEN j.info_necesaria_identificada=true AND j.info_disponible=false THEN 'GL02'
 WHEN c.nombre='atomicidad' AND j.obligaciones_independientes=1 AND j.unidad_aceptacion_confirmada=true THEN 'EVI-HC08'
 WHEN c.nombre='atomicidad' AND j.obligaciones_independientes>=2 AND j.unidad_aceptacion_confirmada=true THEN 'EVI-HC06'
 WHEN c.nombre='atomicidad' AND j.obligaciones_independientes>=2 AND j.unidad_aceptacion_confirmada=false THEN 'EVI-HC01'
 WHEN c.nombre='ambiguedad' AND j.revision_semantica_completa=true AND j.lecturas_residuales>=2 AND j.aceptacion_delimita=true THEN 'EVI-HC03'
 WHEN c.nombre='ambiguedad' AND j.revision_semantica_completa=true AND j.lecturas_residuales>=2 AND j.delimitacion_confirmada=false THEN 'EVI-HC02'
 WHEN c.nombre='ambiguedad' AND j.revision_semantica_completa=true AND j.lecturas_residuales=1 THEN 'EVI-HC09'
 WHEN c.nombre='verificabilidad' AND j.comprobacion_definida=true AND j.metodo_discrimina=false THEN 'EVI-HC07'
 WHEN c.nombre='verificabilidad' AND j.comprobacion_definida=true THEN 'EVI-HC04'
 WHEN c.nombre='completitud' AND j.informacion_aplicable_identificada=true AND j.omisiones_demostradas>=1 THEN 'EVI-HC05'
 WHEN c.nombre='completitud' AND j.informacion_aplicable_identificada=true AND j.omisiones_demostradas=0 THEN 'EVI-HC10'
 ELSE null END AS regla
WHERE regla IS NOT NULL
MATCH (r:AuditIA_PG2:Regla {id:regla})
SET j.estado=CASE WHEN regla IN ['EVI-RD03','GL02'] THEN 'pendiente'
 WHEN regla IN ['EVI-HC02','EVI-HC01','EVI-HC07','EVI-HC05'] THEN 'incumple' ELSE 'cumple' END
MERGE (j)-[:APLICA_REGLA]->(r);

// SM1. Estado de la evaluación (EVI-RD04/05/06), idéntico a 03.
MATCH (ev:AuditIA_PG2:EvaluacionIndividual {lote:$lote,publicado:false,entrada_valida:true})-[:CONTIENE_JUICIO]->(j)
WITH ev,collect(j) AS js
WHERE size(js)=4 AND all(x IN js WHERE x.estado IN ['cumple','incumple','pendiente'])
WITH ev,js,CASE WHEN any(x IN js WHERE x.estado='incumple') THEN 'EVI-RD04'
 WHEN any(x IN js WHERE x.estado='pendiente') THEN 'EVI-RD05' ELSE 'EVI-RD06' END AS rid
MATCH (r:AuditIA_PG2:Regla {id:rid})
SET ev.estado=CASE rid WHEN 'EVI-RD04' THEN 'observado' WHEN 'EVI-RD05' THEN 'pendiente' ELSE 'sin_hallazgo' END
MERGE (ev)-[:APLICA_REGLA]->(r);

// SM1. Materialización genérica: un resultado por juicio que requiere tratamiento.
// ID: H-<caso>-<criterio> (incumple) o P-<caso>-<criterio> (pendiente).
MATCH (ev:AuditIA_PG2:EvaluacionIndividual {lote:$lote,publicado:false,entrada_valida:true})-[:CONTIENE_JUICIO]->(j)-[:APLICA_CRITERIO]->(c),
      (ev)-[:EVALUA]->(rq),(j)-[:APLICA_REGLA]->(rj:Regla)
WHERE j.estado IN ['incumple','pendiente']
WITH ev,j,c,rq,rj,
 (CASE j.estado WHEN 'incumple' THEN 'H-' ELSE 'P-' END)+substring(ev.id,3)+'-'+
 (CASE c.nombre WHEN 'atomicidad' THEN 'ATO' WHEN 'ambiguedad' THEN 'AMB' WHEN 'verificabilidad' THEN 'VER' ELSE 'COM' END) AS oid
MERGE (o:AuditIA_PG2 {id:oid})
ON CREATE SET o:ResultadoAnalisis,o.lote=$lote,o.origen='analista',o.fecha=ev.fecha,o.version='1',
 o.modulo_origen='evaluacion_individual',o.descripcion=j.justificacion,o.procedencia_coherente=true,
 o.destinatario_rol='priorizacion_clarificacion'
FOREACH (_ IN CASE WHEN j.estado='incumple' THEN [1] ELSE [] END |
 SET o:Hallazgo,o.tipo_defecto=c.nombre,
  o.descripcion_defecto=coalesce(j.descripcion_defecto, CASE c.nombre
   WHEN 'ambiguedad' THEN 'Lecturas relevantes con aceptación diferente no delimitadas'
   WHEN 'atomicidad' THEN 'Obligaciones aceptables por separado sin unidad de aceptación'
   WHEN 'verificabilidad' THEN 'El método fijado no discrimina cumplimiento'
   ELSE 'Omisión indispensable demostrada' END))
FOREACH (_ IN CASE WHEN j.estado='pendiente' THEN [1] ELSE [] END |
 SET o:Pendiente,
  o.motivo_pendiente=CASE rj.id WHEN 'EVI-RD03' THEN 'aceptacion_no_recibida' ELSE 'informacion_no_disponible' END,
  o.dato_faltante=coalesce(j.dato_faltante, CASE rj.id WHEN 'EVI-RD03' THEN 'Criterio de aceptación y alcance' ELSE 'Información necesaria para concluir' END),
  o.interpretaciones=coalesce(j.lecturas,[]))
MERGE (ev)-[:GENERA]->(o) MERGE (o)-[:DERIVA_DE_JUICIO]->(j) MERGE (o)-[:AFECTA_REQUERIMIENTO]->(rq)
MERGE (o)-[:APLICA_REGLA]->(rj)
WITH o,j MATCH (j)-[:SE_SUSTENTA_EN]->(e)
MERGE (o)-[:SE_SUSTENTA_EN]->(e);

// SM2 comparación. Excepciones y control semántico preceden al defecto (ACC-RD07, RD03, RD04 antes de RD05/RD06).
// Se agregan las reglas catalogadas ACC-RD04, RD06, RD18 y RD19 de PG1 §6.5.
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {lote:$lote,tipo_analisis:'comparacion',publicado:false,entrada_valida:true})
WHERE ev.datos_controlados=true
WITH ev,CASE
 WHEN ev.interpretacion_cerrada=false THEN 'ACC-RD07'
 WHEN ev.escenarios='excluyentes' THEN 'ACC-RD03'
 WHEN ev.excepcion_resuelve=true THEN 'ACC-RD04'
 WHEN ev.escenarios='coincidentes' AND ev.resultados_incompatibles=true THEN 'ACC-RD05'
 WHEN ev.escenarios='coincidentes' AND ev.resultados_incompatibles=false THEN 'ACC-RD18'
 WHEN ev.escenarios='parciales' AND ev.region_comun_definida=false THEN 'ACC-RD07'
 WHEN ev.escenarios='parciales' AND ev.resultados_incompatibles=true THEN 'ACC-RD06'
 WHEN ev.escenarios='parciales' AND ev.resultados_incompatibles=false THEN 'ACC-RD19'
 ELSE null END AS rid
WHERE rid IS NOT NULL MATCH (r:AuditIA_PG2:Regla {id:rid})
SET ev.estado=CASE WHEN rid IN ['ACC-RD05','ACC-RD06'] THEN 'observado' WHEN rid='ACC-RD07' THEN 'pendiente' ELSE 'sin_hallazgo' END
MERGE (ev)-[:APLICA_REGLA]->(r);

// SM2. Hallazgo de contradicción o pendiente de frontera, con ID derivado del par.
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {lote:$lote,tipo_analisis:'comparacion',publicado:false})-[:APLICA_REGLA]->(r:Regla)
WHERE ev.estado IN ['observado','pendiente'] AND r.id IN ['ACC-RD05','ACC-RD06','ACC-RD07']
WITH ev,r,(CASE ev.estado WHEN 'observado' THEN 'H-' ELSE 'P-' END)+substring(ev.id,3) AS oid
MERGE (o:AuditIA_PG2 {id:oid})
ON CREATE SET o:ResultadoAnalisis,o.lote=$lote,o.origen='analista',o.fecha=ev.fecha,o.version='1',
 o.modulo_origen='analisis_cruzado',o.descripcion=ev.justificacion,o.procedencia_coherente=true,
 o.destinatario_rol=CASE ev.estado WHEN 'observado' THEN 'priorizacion_clarificacion' ELSE 'revision_experta' END
FOREACH (_ IN CASE WHEN ev.estado='observado' THEN [1] ELSE [] END |
 SET o:Hallazgo,o.tipo_defecto=CASE r.id WHEN 'ACC-RD06' THEN 'contradiccion_en_region' ELSE 'contradiccion' END,
  o.descripcion_defecto=CASE r.id WHEN 'ACC-RD06' THEN 'Resultados incompatibles en la región común de los escenarios'
   ELSE 'Resultados incompatibles en el mismo escenario' END)
FOREACH (_ IN CASE WHEN ev.estado='pendiente' THEN [1] ELSE [] END |
 SET o:Pendiente,o.motivo_pendiente='frontera_semantica',
  o.dato_faltante=coalesce(ev.dato_faltante,'Delimitar la región común entre los escenarios'),o.interpretaciones=[])
MERGE (ev)-[:GENERA]->(o) MERGE (o)-[:APLICA_REGLA]->(r)
WITH ev,o MATCH (ev)-[:COMPARA]->(rq)
MERGE (o)-[:AFECTA_REQUERIMIENTO]->(rq)
WITH ev,o,rq OPTIONAL MATCH (e:AuditIA_PG2:Evidencia {id:'E-'+rq.id})
FOREACH (x IN CASE WHEN e IS NULL THEN [] ELSE [e] END | MERGE (o)-[:SE_SUSTENTA_EN]->(x))
WITH DISTINCT ev,o MATCH (ev)-[:SE_SUSTENTA_EN]->(e2)
MERGE (o)-[:SE_SUSTENTA_EN]->(e2);

// ACC-RD05/RD06. Relación CONTRADICE entre los requerimientos del par.
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {lote:$lote,estado:'observado'})-[:COMPARA]->(a),(ev)-[:COMPARA]->(b),
      (ev)-[:APLICA_REGLA]->(r:Regla)
WHERE a.id<b.id AND r.id IN ['ACC-RD05','ACC-RD06']
MERGE (a)-[:CONTRADICE {evaluacion_id:ev.id,regla_id:r.id,version:'1',ambito:coalesce(ev.ambito_comun,'escenario comparado')}]->(b);

// GL07. Todo hallazgo o pendiente recibe Severidad; la del pendiente queda null.
MATCH (ev:AuditIA_PG2:Evaluacion {lote:$lote,publicado:false})-[:GENERA]->(o)
WHERE o:Hallazgo OR o:Pendiente
OPTIONAL MATCH (o)-[:DERIVA_DE_JUICIO]->(j:JuicioCriterio)
WITH ev,o,j
MERGE (sv:AuditIA_PG2 {id:'SV-'+o.id})
ON CREATE SET sv:Severidad,sv.lote=$lote,sv.origen='analista',sv.propuesta_por=o.modulo_origen,
 sv.validacion='candidata',sv.normalizacion='candidata',
 sv.valor=CASE WHEN o:Pendiente THEN null ELSE coalesce(j.severidad_propuesta,ev.severidad_propuesta) END,
 sv.grado_severidad=CASE WHEN o:Pendiente THEN null ELSE coalesce(j.puntuacion_severidad_propuesta,ev.puntuacion_severidad_propuesta) END,
 sv.modelo_difuso_version='MD-URG-1.0',sv.fundamento='Propuesta confirmada por el analista al ingresar el caso'
MERGE (o)-[:TIENE_SEVERIDAD]->(sv)
WITH o,sv MATCH (o)-[:SE_SUSTENTA_EN]->(e),(r:AuditIA_PG2:Regla {id:'GL07'})
MERGE (sv)-[:SE_SUSTENTA_EN]->(e) MERGE (o)-[:APLICA_REGLA]->(r);

// GL06. Contrato de derivación: contexto y criticidad tomados de las premisas del requerimiento afectado.
// Si la criticidad no fue declarada, el contexto lo registra como dato faltante (no se inventa un valor).
MATCH (ev:AuditIA_PG2:Evaluacion {lote:$lote})-[:GENERA]->(o)-[:AFECTA_REQUERIMIENTO]->(rq)
WHERE (o:Hallazgo OR o:Pendiente) AND NOT EXISTS {MATCH (x:ContextoPrioridad) WHERE x.observacion_id=o.id}
WITH o,rq ORDER BY coalesce(rq.grado_criticidad,-1.0) DESC
WITH o,collect(rq) AS rqs
WITH o,rqs,head(rqs) AS rq
MERGE (x:AuditIA_PG2 {id:'X-'+o.id})
ON CREATE SET x:ContextoPrioridad,x.lote=$lote,x.origen='analista',x.observacion_id=o.id,
 x.info_para_priorizar_suficiente=(rq.criticidad_valor IS NOT NULL),
 x.necesidad_dato_confirmada=(rq.criticidad_valor IS NULL),
 x.dato_para_priorizar_disponible=(rq.criticidad_valor IS NOT NULL),
 x.dato_para_resolver_identificado=true,
 x.dato_para_resolver=CASE WHEN rq.criticidad_valor IS NULL THEN 'Criticidad de '+rq.id_logico+' declarada por el referente de negocio'
  ELSE coalesce(o.dato_faltante,'Confirmar condición y alcance de '+rq.id_logico) END,
 x.obligacion_esencial_indefinida=any(r IN rqs WHERE r.obligacion_esencial_indefinida=true),
 x.bloqueo_sustantivo_confirmado=any(r IN rqs WHERE r.bloqueo_sustantivo_confirmado=true),
 x.hito_acordado=all(r IN rqs WHERE r.hito_acordado=true),
 x.diferimiento_aceptado=all(r IN rqs WHERE r.diferimiento_aceptado=true),
 x.impacto_acotado=all(r IN rqs WHERE r.impacto_acotado=true),
 x.criticidad_valor=rq.criticidad_valor,x.mapeo_alta_bloqueante='candidato_activo'
MERGE (cr:AuditIA_PG2 {id:'CR-'+o.id})
ON CREATE SET cr:Criticidad,cr.lote=$lote,cr.origen='analista',cr.valor=rq.criticidad_valor,
 cr.grado_criticidad=rq.grado_criticidad,cr.ambito=rq.id,
 cr.fundamento=coalesce(rq.fundamento_criticidad,CASE WHEN rq.criticidad_valor IS NULL THEN 'Declaración todavía no recibida' ELSE 'Declarada por el analista' END),
 cr.declarante_rol='analista',cr.modelo_difuso_version='MD-URG-1.0'
WITH o,x,cr MATCH (o)-[:SE_SUSTENTA_EN]->(e)
MERGE (x)-[:SE_SUSTENTA_EN]->(e) MERGE (cr)-[:SE_SUSTENTA_EN]->(e)
WITH DISTINCT o MATCH (r:AuditIA_PG2:Regla {id:'GL06'})
MERGE (o)-[:APLICA_REGLA]->(r);

// SM3. Prioridad con la misma regla y matriz MPR-01 de 03; la prioridad no modifica la severidad.
MATCH (x:AuditIA_PG2:ContextoPrioridad {lote:$lote}),(o:AuditIA_PG2:ResultadoAnalisis)-[:TIENE_SEVERIDAD]->(sv)
WHERE x.observacion_id=o.id AND o.procedencia_coherente=true AND (o:Hallazgo OR o:Pendiente)
MATCH (cr:AuditIA_PG2:Criticidad {id:'CR-'+substring(x.id,2)})
OPTIONAL MATCH (m:AuditIA_PG2:CeldaMatriz {severidad:sv.valor,criticidad:cr.valor})
WITH x,o,sv,cr,m,CASE
 WHEN x.necesidad_dato_confirmada=true AND x.dato_para_priorizar_disponible=false THEN 'PRC-RD02'
 WHEN x.obligacion_esencial_indefinida=true AND o:Hallazgo THEN 'PRC-HC01'
 WHEN sv.valor IS NULL OR cr.valor IS NULL THEN 'PRC-RD02'
 WHEN m.categoria='bloqueante' AND sv.valor='baja' AND cr.valor='alta' THEN 'PRC-HC02'
 WHEN m.categoria='bloqueante' THEN 'PRC-HC03'
 WHEN m.categoria='mayor' AND x.hito_acordado=true AND x.bloqueo_sustantivo_confirmado=false THEN 'PRC-HC04'
 WHEN m.categoria='menor' AND x.diferimiento_aceptado=true AND x.impacto_acotado=true THEN 'PRC-HC05'
 WHEN m.categoria IN ['mayor','menor'] THEN 'PRC-RD02' ELSE null END AS rid
WHERE rid IS NOT NULL MATCH (r:AuditIA_PG2:Regla {id:rid})
MERGE (d:AuditIA_PG2 {id:'D-'+o.id}) ON CREATE SET d:DecisionPrioridad,d.lote=$lote,d.origen='analista',
 d.fecha=o.fecha,d.provisional=true,
 d.prioridad=CASE rid WHEN 'PRC-HC04' THEN 'mayor' WHEN 'PRC-HC05' THEN 'menor' ELSE 'bloqueante' END,
 d.motivo=CASE rid WHEN 'PRC-RD02' THEN 'preventivo' WHEN 'PRC-HC04' THEN 'en_hito' WHEN 'PRC-HC05' THEN 'diferimiento' ELSE 'sustantivo' END,
 d.categoria_matriz=m.categoria,d.matriz_id_version=CASE WHEN m IS NOT NULL THEN 'MPR-01-1.0' END,
 d.revisada_humanamente=false,d.emitible=false,d.criticidad_id=cr.id
MERGE (d)-[:PRIORIZA]->(o) MERGE (d)-[:USA_CONTEXTO]->(x) MERGE (d)-[:APLICA_REGLA]->(r)
MERGE (er:AuditIA_PG2 {id:'ER-'+o.id}) ON CREATE SET er:EstadoResolucion,er.lote=$lote,er.origen='analista',
 er.valor='por_consultar',er.fecha=o.fecha,er.motivo='Recomendación académica pendiente de revisión'
MERGE (d)-[:TIENE_ESTADO]->(er)
WITH d,x,o MATCH (x)-[:SE_SUSTENTA_EN]->(e)
MERGE (d)-[:SE_SUSTENTA_EN]->(e)
WITH DISTINCT d,o OPTIONAL MATCH (o)-[:AFECTA_REQUERIMIENTO]->(rq)
WITH d,o,collect(rq) AS rqs MATCH (cr:AuditIA_PG2:Criticidad {id:d.criticidad_id})
FOREACH (rq IN rqs | MERGE (rq)-[:TIENE_CRITICIDAD]->(cr));
