// GL01. Una entrada no fiel produce incidencia, nunca un hallazgo ni una prioridad.
MATCH (ev:AuditIA_PG2:Evaluacion {publicado:false, entrada_valida:false})
MERGE (i:AuditIA_PG2 {id:'IE-'+ev.id})
ON CREATE SET i:ResultadoAnalisis:IncidenciaEntrada, i.fecha=ev.fecha, i.version='1',
 i.modulo_origen=ev.modulo_origen, i.ambito='extraccion_documento',
 i.causa='perdida_negacion', i.descripcion='Normalización no fiel al original',
 i.accion_correccion='Cotejar y corregir la extracción', i.destinatario_rol='correccion_entrada'
MERGE (ev)-[:GENERA]->(i)
WITH ev,i MATCH (ev)-[:SE_SUSTENTA_EN]->(e:Evidencia),(r:AuditIA_PG2:Regla {id:'GL01'})
MERGE (i)-[:SE_SUSTENTA_EN]->(e) MERGE (i)-[:APLICA_REGLA]->(r)
MERGE (ev)-[:APLICA_REGLA]->(r) SET ev.estado='no_evaluable';

// SM1. Las premisas semánticas se cargan con evidencia explícita.
MATCH (ev:AuditIA_PG2:EvaluacionIndividual {publicado:false,entrada_valida:true})-[:CONTIENE_JUICIO]->(j)-[:APLICA_CRITERIO]->(c)
WITH ev,j,c, CASE
 WHEN c.nombre='verificabilidad' AND j.aceptacion_necesaria=true AND j.aceptacion_disponible=false THEN 'EVI-RD03'
 WHEN j.info_necesaria_identificada=true AND j.info_disponible=false THEN 'GL02'
 WHEN c.nombre='atomicidad' AND j.obligaciones_independientes=1 AND j.unidad_aceptacion_confirmada=true THEN 'EVI-HC08'
 WHEN c.nombre='ambiguedad' AND j.revision_semantica_completa=true AND j.lecturas_residuales>=2 AND j.delimitacion_confirmada=false THEN 'EVI-HC02'
 WHEN c.nombre='ambiguedad' AND j.revision_semantica_completa=true AND j.lecturas_residuales=1 THEN 'EVI-HC09'
 WHEN c.nombre='verificabilidad' AND j.comprobacion_definida=true THEN 'EVI-HC04'
 WHEN c.nombre='completitud' AND j.informacion_aplicable_identificada=true AND j.omisiones_demostradas=0 THEN 'EVI-HC10'
 ELSE null END AS regla
WHERE regla IS NOT NULL
MATCH (r:AuditIA_PG2:Regla {id:regla})
SET j.estado=CASE WHEN regla IN ['EVI-RD03','GL02'] THEN 'pendiente' WHEN regla='EVI-HC02' THEN 'incumple' ELSE 'cumple' END
MERGE (j)-[:APLICA_REGLA]->(r);

MATCH (ev:AuditIA_PG2:EvaluacionIndividual {publicado:false,entrada_valida:true})-[:CONTIENE_JUICIO]->(j)
WITH ev,collect(j) AS js
WHERE size(js)=4 AND all(x IN js WHERE x.estado IN ['cumple','incumple','pendiente'])
WITH ev,js,CASE WHEN any(x IN js WHERE x.estado='incumple') THEN 'EVI-RD04'
 WHEN any(x IN js WHERE x.estado='pendiente') THEN 'EVI-RD05' ELSE 'EVI-RD06' END AS rid
MATCH (r:AuditIA_PG2:Regla {id:rid})
SET ev.estado=CASE rid WHEN 'EVI-RD04' THEN 'observado' WHEN 'EVI-RD05' THEN 'pendiente' ELSE 'sin_hallazgo' END
MERGE (ev)-[:APLICA_REGLA]->(r);

// Materialización local. Se preserva un resultado por juicio que requiere tratamiento.
MATCH (ev:AuditIA_PG2:EvaluacionIndividual {publicado:false,entrada_valida:true})-[:CONTIENE_JUICIO]->(j)-[:APLICA_CRITERIO]->(c), (ev)-[:EVALUA]->(rq)
WHERE j.estado IN ['incumple','pendiente']
WITH ev,j,c,rq,CASE
 WHEN ev.id='EV-CAT-01' THEN CASE c.nombre WHEN 'ambiguedad' THEN 'H-CAT-B' WHEN 'verificabilidad' THEN 'P-CAT-V' ELSE 'P-CAT-C' END
 WHEN ev.id STARTS WITH 'EV-PRIO-' AND j.estado='incumple' THEN replace(ev.id,'EV-','H-')
 ELSE 'R-'+j.id END AS oid
MERGE (o:AuditIA_PG2 {id:oid})
ON CREATE SET o:ResultadoAnalisis, o.fecha=ev.fecha, o.version='1',o.modulo_origen='evaluacion_individual',
 o.descripcion=j.justificacion,o.procedencia_coherente=true,o.destinatario_rol='priorizacion_clarificacion'
FOREACH (_ IN CASE WHEN j.estado='incumple' THEN [1] ELSE [] END | SET o:Hallazgo,o.tipo_defecto=c.nombre,o.descripcion_defecto='Dos lecturas con aceptación diferente')
FOREACH (_ IN CASE WHEN j.estado='pendiente' THEN [1] ELSE [] END | SET o:Pendiente,o.motivo_pendiente='aceptacion_no_recibida',o.dato_faltante='Criterio de aceptación y alcance',o.interpretaciones=[])
MERGE (ev)-[:GENERA]->(o) MERGE (o)-[:DERIVA_DE_JUICIO]->(j) MERGE (o)-[:AFECTA_REQUERIMIENTO]->(rq)
WITH ev,j,o MATCH (j)-[:SE_SUSTENTA_EN]->(e),(j)-[:APLICA_REGLA]->(r)
MERGE (o)-[:SE_SUSTENTA_EN]->(e) MERGE (o)-[:APLICA_REGLA]->(r);

// SM2 comparación. Excepciones y control semántico preceden al defecto.
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {tipo_analisis:'comparacion',publicado:false,entrada_valida:true})
WHERE ev.datos_controlados=true AND ev.interpretacion_cerrada=true
WITH ev,CASE WHEN ev.escenarios='excluyentes' THEN 'ACC-RD03'
 WHEN ev.escenarios='coincidentes' AND ev.resultados_incompatibles=true AND ev.excepcion_resuelve=false THEN 'ACC-RD05' ELSE null END AS rid
WHERE rid IS NOT NULL MATCH (r:AuditIA_PG2:Regla {id:rid})
SET ev.estado=CASE rid WHEN 'ACC-RD05' THEN 'observado' ELSE 'sin_hallazgo' END
MERGE (ev)-[:APLICA_REGLA]->(r);
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {id:'EV-DESC',publicado:false,estado:'observado'})-[:COMPARA]->(rq)
MERGE (h:AuditIA_PG2 {id:'H-DESC'}) ON CREATE SET h:ResultadoAnalisis:Hallazgo,
 h.fecha=ev.fecha,h.version='1',h.modulo_origen='analisis_cruzado',h.tipo_defecto='contradiccion',
 h.descripcion='La misma venta exige precio con y sin descuento',h.descripcion_defecto='Resultados incompatibles en el mismo escenario',h.destinatario_rol='priorizacion_clarificacion',h.procedencia_coherente=true
MERGE (ev)-[:GENERA]->(h) MERGE (h)-[:AFECTA_REQUERIMIENTO]->(rq)
WITH ev,h MATCH (ev)-[:APLICA_REGLA]->(r),(ev)-[:SE_SUSTENTA_EN]->(e)
MERGE (h)-[:APLICA_REGLA]->(r) MERGE (h)-[:SE_SUSTENTA_EN]->(e);
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {id:'EV-DESC',estado:'observado'})-[:COMPARA]->(a),(ev)-[:COMPARA]->(b)
WHERE a.id<b.id
MERGE (a)-[:CONTRADICE {evaluacion_id:ev.id,regla_id:'ACC-RD05',version:'1',ambito:'misma venta A'}]->(b);

// Fragmentos literales del par como evidencia adicional del hallazgo.
MATCH (ev:AuditIA_PG2:Evaluacion {id:'EV-DESC'})-[:GENERA]->(h),
      (ev)-[:COMPARA]->(rq),(e:AuditIA_PG2:Evidencia {id:'E-'+rq.id})
MERGE (h)-[:SE_SUSTENTA_EN]->(e);

// ACC-RD07. La frontera no se confirma como hallazgo por un grado intermedio.
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {tipo_analisis:'comparacion',publicado:false,entrada_valida:true,interpretacion_cerrada:false})
MATCH (r:AuditIA_PG2:Regla {id:'ACC-RD07'})
SET ev.estado='pendiente' MERGE (ev)-[:APLICA_REGLA]->(r)
MERGE (o:AuditIA_PG2 {id:'P-PED-FRONTERA'})
ON CREATE SET o:ResultadoAnalisis:Pendiente,o.fecha=ev.fecha,o.version='1',o.modulo_origen='analisis_cruzado',o.motivo_pendiente='frontera_semantica',o.dato_faltante='Precisar el intervalo entre preparación y despacho',o.descripcion='Solapamiento temporal no delimitado',o.destinatario_rol='revision_experta',o.procedencia_coherente=true
MERGE (ev)-[:GENERA]->(o) MERGE (o)-[:APLICA_REGLA]->(r)
WITH ev,o MATCH (ev)-[:COMPARA]->(rq),(ev)-[:SE_SUSTENTA_EN]->(e)
MERGE (o)-[:AFECTA_REQUERIMIENTO]->(rq) MERGE (o)-[:SE_SUSTENTA_EN]->(e);

// Dependencia. Un anexo no recibido no prueba ausencia de definición.
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {tipo_analisis:'dependencia',publicado:false,entrada_valida:true})-[:RASTREA]->(dep)-[:TIENE_ORIGEN]->(rq),(dep)-[:REQUIERE]->(en)
MERGE (rq)-[:DEPENDE_DE {evaluacion_id:ev.id}]->(en)
WITH ev,dep,rq,CASE
 WHEN ev.necesidad_confirmada=true AND ev.referencia_necesaria_disponible=false THEN 'GL02'
 WHEN ev.necesidad_confirmada=true AND ev.referencia_necesaria_disponible=true AND ev.cotejo_definicion='pertinente' AND ev.validacion_definicion=true THEN 'ACC-RD08'
 WHEN ev.necesidad_confirmada=true AND ev.busqueda_completa=true AND ev.cotejo_definicion='ausente' THEN 'ACC-RD09' ELSE null END AS rid
WHERE rid IS NOT NULL MATCH (r:AuditIA_PG2:Regla {id:rid})
SET ev.estado=CASE rid WHEN 'GL02' THEN 'pendiente' WHEN 'ACC-RD08' THEN 'sin_hallazgo' ELSE 'observado' END,
 dep.estado=CASE rid WHEN 'ACC-RD08' THEN 'resuelta' WHEN 'GL02' THEN 'pendiente' ELSE 'no_resuelta' END
MERGE (ev)-[:APLICA_REGLA]->(r);
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {id:'EV-TASA-1',publicado:false,estado:'pendiente'})-[:RASTREA]->(dep)-[:TIENE_ORIGEN]->(rq)
MERGE (p:AuditIA_PG2 {id:'P-TASA'}) ON CREATE SET p:ResultadoAnalisis:Pendiente,p.fecha=ev.fecha,p.version='1',p.modulo_origen='analisis_cruzado',p.descripcion='El Anexo B citado no fue recibido',p.motivo_pendiente='referencia_no_disponible',p.dato_faltante='Anexo B',p.interpretaciones=[],p.procedencia_coherente=true,p.destinatario_rol='priorizacion_clarificacion'
MERGE (ev)-[:GENERA]->(p) MERGE (p)-[:AFECTA_REQUERIMIENTO]->(rq)
WITH ev,p MATCH (ev)-[:APLICA_REGLA]->(r),(ev)-[:SE_SUSTENTA_EN]->(e)
MERGE (p)-[:APLICA_REGLA]->(r) MERGE (p)-[:SE_SUSTENTA_EN]->(e);

// Cobertura de una necesidad explícita del catálogo, nunca cobertura total del documento.
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {tipo_analisis:'cobertura',publicado:false,entrada_valida:true})-[:USA_PERFIL]->(pf),(ev)-[:EVALUA_CATEGORIA]->(cat)
WITH ev,pf,cat,CASE WHEN ev.condicion_catalogo IS NULL THEN 'ACC-RD12' WHEN ev.condicion_catalogo=false THEN 'ACC-RD11'
 WHEN ev.mapa_cobertura_validado=false THEN 'ACC-RD16'
 WHEN ev.busqueda_completa=true AND ev.cobertura='ninguna' THEN 'ACC-RD13'
 WHEN ev.mapa_cobertura_validado=true AND ev.cobertura='completa' THEN 'ACC-RD14' ELSE null END AS rid
WHERE rid IS NOT NULL MATCH (r:AuditIA_PG2:Regla {id:rid})
SET ev.estado=CASE WHEN rid IN ['ACC-RD12','ACC-RD16'] THEN 'pendiente' WHEN rid='ACC-RD13' THEN 'observado' ELSE 'sin_hallazgo' END
MERGE (ev)-[:APLICA_REGLA]->(r)
FOREACH (_ IN CASE WHEN ev.condicion_catalogo=true THEN [1] ELSE [] END |
 MERGE (pf)-[:EXIGE {evaluacion_id:ev.id,regla_id:'ACC-RD10',necesidad:'protección de datos sensibles'}]->(cat));
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {tipo_analisis:'cobertura',publicado:false,estado:'sin_hallazgo',cobertura:'completa'})-[:VINCULA_COBERTURA]->(rq),(ev)-[:EVALUA_CATEGORIA]->(cat)
MERGE (rq)-[:CUBRE {evaluacion_id:ev.id,regla_id:'ACC-RD14',necesidad:'protección de datos sensibles'}]->(cat);
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {tipo_analisis:'cobertura',publicado:false})-[:EVALUA_CATEGORIA]->(cat)
WHERE ev.estado IN ['observado','pendiente']
WITH ev,cat,CASE WHEN ev.estado='observado' THEN 'H-SEG' ELSE 'P-SEG' END AS oid
MERGE (o:AuditIA_PG2 {id:oid}) ON CREATE SET o:ResultadoAnalisis,o.fecha=ev.fecha,o.version='1',o.modulo_origen='analisis_cruzado',o.descripcion='Resultado de cobertura de protección de datos sensibles',o.procedencia_coherente=true,o.destinatario_rol='priorizacion_clarificacion'
FOREACH (_ IN CASE WHEN ev.estado='observado' THEN [1] ELSE [] END | SET o:Hallazgo,o.tipo_defecto='brecha_cobertura',o.descripcion_defecto='Necesidad exigible sin compromiso pertinente en el alcance buscado')
FOREACH (_ IN CASE WHEN ev.estado='pendiente' THEN [1] ELSE [] END | SET o:Pendiente,o.motivo_pendiente='perfil_insuficiente',o.dato_faltante='Confirmar existencia de datos sensibles',o.interpretaciones=[])
MERGE (ev)-[:GENERA]->(o) MERGE (o)-[:AFECTA_CATEGORIA]->(cat)
WITH ev,o MATCH (ev)-[:APLICA_REGLA]->(r),(ev)-[:SE_SUSTENTA_EN]->(e)
MERGE (o)-[:APLICA_REGLA]->(r) MERGE (o)-[:SE_SUSTENTA_EN]->(e);

// GL06/GL07. Todo hallazgo o pendiente recibe Severidad; valor desconocido queda ausente (null).
MATCH (ev:AuditIA_PG2:Evaluacion {publicado:false})-[:GENERA]->(o)
WHERE o:Hallazgo OR o:Pendiente
OPTIONAL MATCH (o)-[:DERIVA_DE_JUICIO]->(j:JuicioCriterio)
WITH ev,o,j
MERGE (sv:AuditIA_PG2 {id:'SV-'+o.id})
ON CREATE SET sv:Severidad,sv.propuesta_por=o.modulo_origen,sv.validacion='candidata',sv.normalizacion='candidata',
 sv.valor=CASE WHEN o:Pendiente THEN null ELSE coalesce(j.severidad_propuesta,ev.severidad_propuesta) END,
 sv.grado_severidad=CASE WHEN o:Pendiente THEN null ELSE coalesce(j.puntuacion_severidad_propuesta,ev.puntuacion_severidad_propuesta) END,
 sv.modelo_difuso_version='MD-URG-1.0',sv.fundamento='Valor construido por el módulo de origen para la prueba'
MERGE (o)-[:TIENE_SEVERIDAD]->(sv)
WITH ev,o,sv MATCH (o)-[:SE_SUSTENTA_EN]->(e),(r:AuditIA_PG2:Regla {id:'GL07'})
MERGE (sv)-[:SE_SUSTENTA_EN]->(e) MERGE (o)-[:APLICA_REGLA]->(r);

// GL06. Contrato de derivación completo; datos desconocidos explícitos.
MATCH (o:AuditIA_PG2:ResultadoAnalisis)-[:TIENE_SEVERIDAD]->(sv)
WHERE (o:Hallazgo OR o:Pendiente) AND NOT EXISTS {MATCH (x:ContextoPrioridad) WHERE x.observacion_id=o.id}
MERGE (x:AuditIA_PG2 {id:'X-AUTO-'+o.id}) ON CREATE SET x:ContextoPrioridad,x.observacion_id=o.id,x.info_para_priorizar_suficiente=false,x.necesidad_dato_confirmada=true,x.dato_para_priorizar_disponible=false,x.dato_para_resolver_identificado=true,x.dato_para_resolver=coalesce(o.dato_faltante,'Confirmar criticidad y condiciones de tratamiento'),x.mapeo_alta_bloqueante='candidato_activo'
MERGE (cr:AuditIA_PG2 {id:'CR-AUTO-'+o.id}) ON CREATE SET cr:Criticidad,cr.ambito=o.id,cr.fundamento='Declaración todavía no recibida'
WITH x,cr,o MATCH (o)-[:SE_SUSTENTA_EN]->(e),(r:AuditIA_PG2:Regla {id:'GL06'})
MERGE (x)-[:SE_SUSTENTA_EN]->(e) MERGE (cr)-[:SE_SUSTENTA_EN]->(e) MERGE (o)-[:APLICA_REGLA]->(r);

// SM3. La matriz no completa null y la prioridad no modifica la severidad.
MATCH (x:AuditIA_PG2:ContextoPrioridad),(o:AuditIA_PG2:ResultadoAnalisis)-[:TIENE_SEVERIDAD]->(sv)
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
MERGE (d:AuditIA_PG2 {id:'D-'+o.id}) ON CREATE SET d:DecisionPrioridad,d.fecha=o.fecha,d.provisional=true,
 d.prioridad=CASE rid WHEN 'PRC-HC04' THEN 'mayor' WHEN 'PRC-HC05' THEN 'menor' ELSE 'bloqueante' END,
 d.motivo=CASE rid WHEN 'PRC-RD02' THEN 'preventivo' WHEN 'PRC-HC04' THEN 'en_hito' WHEN 'PRC-HC05' THEN 'diferimiento' ELSE 'sustantivo' END,
 d.categoria_matriz=m.categoria,d.matriz_id_version=CASE WHEN m IS NOT NULL THEN 'MPR-01-1.0' END,
 d.revisada_humanamente=false,d.emitible=false,d.criticidad_id=cr.id
MERGE (d)-[:PRIORIZA]->(o) MERGE (d)-[:USA_CONTEXTO]->(x) MERGE (d)-[:APLICA_REGLA]->(r)
MERGE (er:AuditIA_PG2 {id:'ER-'+o.id}) ON CREATE SET er:EstadoResolucion,er.valor='por_consultar',er.fecha=o.fecha,er.motivo='Recomendación académica pendiente de revisión'
MERGE (d)-[:TIENE_ESTADO]->(er)
WITH d,x,o MATCH (x)-[:SE_SUSTENTA_EN]->(e)
MERGE (d)-[:SE_SUSTENTA_EN]->(e)
WITH d,o OPTIONAL MATCH (o)-[:AFECTA_REQUERIMIENTO]->(rq)
WITH d,o,collect(rq) AS rqs MATCH (cr:AuditIA_PG2:Criticidad {id:d.criticidad_id})
FOREACH (rq IN rqs | MERGE (rq)-[:TIENE_CRITICIDAD]->(cr));

