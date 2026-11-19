// Modelos y parámetros de los tres PI3. Mamdani MIN/MAX; 1001 puntos.
// El grado no sustituye los estados crisp ni la autorización de retorno.

MATCH (ev:AuditIA_PG2:EvaluacionIndividual {entrada_valida:true})-[:CONTIENE_JUICIO]->(n:JuicioCriterio)-[:APLICA_CRITERIO]->(:CriterioCalidad {nombre:'ambiguedad'})
WHERE n.valoracion_confirmada=true AND n.alcance_valoracion_revisado=true
WITH n,n.divergencia_lecturas AS x,n.delimitacion_contexto AS y
MATCH (md:AuditIA_PG2:ModeloDifuso {id:'MD-AMB-1.0'})
SET n.estado_calculo_difuso=CASE WHEN x IS NULL OR y IS NULL THEN 'datos_desconocidos' WHEN x<0 OR x>10 OR y<0 OR y>10 THEN 'dato_fuera_de_rango' ELSE 'calculable' END
WITH n,x,y,md WHERE x>=0 AND x<=10 AND y>=0 AND y<=10
MATCH (exb:AuditIA_PG2:EtiquetaDifusa {id:'MD-AMB-1.0-x-baja'}),
 (exm:AuditIA_PG2:EtiquetaDifusa {id:'MD-AMB-1.0-x-media'}),
 (exa:AuditIA_PG2:EtiquetaDifusa {id:'MD-AMB-1.0-x-alta'}),
 (eyb:AuditIA_PG2:EtiquetaDifusa {id:'MD-AMB-1.0-y-baja'}),
 (eym:AuditIA_PG2:EtiquetaDifusa {id:'MD-AMB-1.0-y-media'}),
 (eya:AuditIA_PG2:EtiquetaDifusa {id:'MD-AMB-1.0-y-alta'})
WHERE exb.sigma>0 AND exm.sigma>0 AND exa.sigma>0 AND eyb.sigma>0 AND eym.sigma>0 AND eya.sigma>0
WITH n,x,y,md,exp(-0.5*((x-exb.centro)/exb.sigma)^2) AS xb,
 exp(-0.5*((x-exm.centro)/exm.sigma)^2) AS xm,
 exp(-0.5*((x-exa.centro)/exa.sigma)^2) AS xa,
 exp(-0.5*((y-eyb.centro)/eyb.sigma)^2) AS yb,
 exp(-0.5*((y-eym.centro)/eym.sigma)^2) AS ym,
 exp(-0.5*((y-eya.centro)/eya.sigma)^2) AS ya
WITH n,x,y,md,[{id:'AMB-RB1',alpha:(CASE WHEN xa<yb THEN xa ELSE yb END)},
 {id:'AMB-RB2',alpha:(CASE WHEN xa<ym THEN xa ELSE ym END)},
 {id:'AMB-RB3',alpha:(CASE WHEN xm<(CASE WHEN yb>ym THEN yb ELSE ym END) THEN xm ELSE (CASE WHEN yb>ym THEN yb ELSE ym END) END)},
 {id:'AMB-RB4',alpha:(CASE WHEN xb>ya THEN xb ELSE ya END)}] AS activaciones
UNWIND activaciones AS act
MATCH (r:AuditIA_PG2:ReglaDifusa {id:act.id})-[:CONSECUENTE]->(et:EtiquetaDifusa)
WHERE et.sigma>0
WITH n,x,y,md,collect({id:act.id,alpha:act.alpha,c:et.centro,s:et.sigma}) AS reglas
UNWIND range(0,1000) AS k
WITH n,x,y,md,reglas,k*0.001 AS z
WITH n,x,y,md,reglas,z,reduce(maximo=0.0,r IN reglas |
 CASE WHEN (CASE WHEN r.alpha<exp(-0.5*((z-r.c)/r.s)^2) THEN r.alpha ELSE exp(-0.5*((z-r.c)/r.s)^2) END)>maximo
 THEN CASE WHEN r.alpha<exp(-0.5*((z-r.c)/r.s)^2) THEN r.alpha ELSE exp(-0.5*((z-r.c)/r.s)^2) END ELSE maximo END) AS mu
WITH n,x,y,md,reglas,sum(z*mu) AS num,sum(mu) AS den
WHERE den>0
SET n.grado_ambiguedad=num/den,n.modelo_difuso_version=md.id,n.input_x=x,n.input_y=y,
 n.reglas_difusas_ids=[r IN reglas | r.id],n.activaciones=[r IN reglas | r.alpha],
 n.estado_calculo_difuso='calculado',n.resultado_difuso_provisional=true,
 n.banda_difusa=CASE WHEN num/den<0.273 THEN 'baja' WHEN num/den<0.727 THEN 'media' ELSE 'alta' END
MERGE (n)-[:APLICA_MODELO]->(md);


MATCH (n:AuditIA_PG2:EvaluacionCruzada {entrada_valida:true,tipo_analisis:'comparacion'})
WHERE n.valoracion_confirmada=true AND n.excepcion_resuelve=false
 AND n.escenarios<>'excluyentes' AND n.dato_necesario_faltante=false
 AND NOT EXISTS {MATCH (n)-[:COMPARA]->(:Requerimiento {entrada_valida:false})}
WITH n,n.solapamiento_escenario AS x,n.incompatibilidad_resultados AS y
MATCH (md:AuditIA_PG2:ModeloDifuso {id:'MD-CONTR-1.0'})
SET n.estado_calculo_difuso=CASE WHEN x IS NULL OR y IS NULL THEN 'datos_desconocidos' WHEN x<0 OR x>10 OR y<0 OR y>10 THEN 'dato_fuera_de_rango' ELSE 'calculable' END
WITH n,x,y,md WHERE x>=0 AND x<=10 AND y>=0 AND y<=10
MATCH (exb:AuditIA_PG2:EtiquetaDifusa {id:'MD-CONTR-1.0-x-baja'}),
 (exm:AuditIA_PG2:EtiquetaDifusa {id:'MD-CONTR-1.0-x-media'}),
 (exa:AuditIA_PG2:EtiquetaDifusa {id:'MD-CONTR-1.0-x-alta'}),
 (eyb:AuditIA_PG2:EtiquetaDifusa {id:'MD-CONTR-1.0-y-baja'}),
 (eym:AuditIA_PG2:EtiquetaDifusa {id:'MD-CONTR-1.0-y-media'}),
 (eya:AuditIA_PG2:EtiquetaDifusa {id:'MD-CONTR-1.0-y-alta'})
WHERE exb.sigma>0 AND exm.sigma>0 AND exa.sigma>0 AND eyb.sigma>0 AND eym.sigma>0 AND eya.sigma>0
WITH n,x,y,md,exp(-0.5*((x-exb.centro)/exb.sigma)^2) AS xb,
 exp(-0.5*((x-exm.centro)/exm.sigma)^2) AS xm,
 exp(-0.5*((x-exa.centro)/exa.sigma)^2) AS xa,
 exp(-0.5*((y-eyb.centro)/eyb.sigma)^2) AS yb,
 exp(-0.5*((y-eym.centro)/eym.sigma)^2) AS ym,
 exp(-0.5*((y-eya.centro)/eya.sigma)^2) AS ya
WITH n,x,y,md,[{id:'CONTR-RB1',alpha:(CASE WHEN xa<ya THEN xa ELSE ya END)},
 {id:'CONTR-RB2',alpha:(CASE WHEN xm<ya THEN xm ELSE ya END)},
 {id:'CONTR-RB3',alpha:(CASE WHEN xa<ym THEN xa ELSE ym END)},
 {id:'CONTR-RB4',alpha:(CASE WHEN xb>yb THEN xb ELSE yb END)}] AS activaciones
UNWIND activaciones AS act
MATCH (r:AuditIA_PG2:ReglaDifusa {id:act.id})-[:CONSECUENTE]->(et:EtiquetaDifusa)
WHERE et.sigma>0
WITH n,x,y,md,collect({id:act.id,alpha:act.alpha,c:et.centro,s:et.sigma}) AS reglas
UNWIND range(0,1000) AS k
WITH n,x,y,md,reglas,k*0.001 AS z
WITH n,x,y,md,reglas,z,reduce(maximo=0.0,r IN reglas |
 CASE WHEN (CASE WHEN r.alpha<exp(-0.5*((z-r.c)/r.s)^2) THEN r.alpha ELSE exp(-0.5*((z-r.c)/r.s)^2) END)>maximo
 THEN CASE WHEN r.alpha<exp(-0.5*((z-r.c)/r.s)^2) THEN r.alpha ELSE exp(-0.5*((z-r.c)/r.s)^2) END ELSE maximo END) AS mu
WITH n,x,y,md,reglas,sum(z*mu) AS num,sum(mu) AS den
WHERE den>0
SET n.grado_contradiccion=num/den,n.modelo_difuso_version=md.id,n.input_x=x,n.input_y=y,
 n.reglas_difusas_ids=[r IN reglas | r.id],n.activaciones=[r IN reglas | r.alpha],
 n.estado_calculo_difuso='calculado',n.resultado_difuso_provisional=true,
 n.banda_difusa=CASE WHEN num/den<0.273 THEN 'baja' WHEN num/den<0.727 THEN 'intermedia' ELSE 'alta' END
MERGE (n)-[:APLICA_MODELO]->(md);


MATCH (n:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]->()-[:TIENE_SEVERIDAD]->(sv),
      (cr:AuditIA_PG2:Criticidad {id:n.criticidad_id})
WITH n,sv.grado_severidad AS x,cr.grado_criticidad AS y
MATCH (md:AuditIA_PG2:ModeloDifuso {id:'MD-URG-1.0'})
SET n.estado_calculo_difuso=CASE WHEN x IS NULL OR y IS NULL THEN 'datos_desconocidos' WHEN x<0 OR x>10 OR y<0 OR y>10 THEN 'dato_fuera_de_rango' ELSE 'calculable' END
WITH n,x,y,md WHERE x>=0 AND x<=10 AND y>=0 AND y<=10
MATCH (exb:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-x-baja'}),
 (exm:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-x-media'}),
 (exa:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-x-alta'}),
 (eyb:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-y-baja'}),
 (eym:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-y-media'}),
 (eya:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-y-alta'})
WHERE exb.sigma>0 AND exm.sigma>0 AND exa.sigma>0 AND eyb.sigma>0 AND eym.sigma>0 AND eya.sigma>0
WITH n,x,y,md,exp(-0.5*((x-exb.centro)/exb.sigma)^2) AS xb,
 exp(-0.5*((x-exm.centro)/exm.sigma)^2) AS xm,
 exp(-0.5*((x-exa.centro)/exa.sigma)^2) AS xa,
 exp(-0.5*((y-eyb.centro)/eyb.sigma)^2) AS yb,
 exp(-0.5*((y-eym.centro)/eym.sigma)^2) AS ym,
 exp(-0.5*((y-eya.centro)/eya.sigma)^2) AS ya
WITH n,x,y,md,[{id:'URG-RB1',alpha:(CASE WHEN ya<(CASE WHEN xm>xa THEN xm ELSE xa END) THEN ya ELSE (CASE WHEN xm>xa THEN xm ELSE xa END) END)},
 {id:'URG-RB2',alpha:(CASE WHEN xa<ym THEN xa ELSE ym END)},
 {id:'URG-RB3',alpha:(CASE WHEN xb<ya THEN xb ELSE ya END)},
 {id:'URG-RB4',alpha:(CASE WHEN xm<(CASE WHEN ym>yb THEN ym ELSE yb END) THEN xm ELSE (CASE WHEN ym>yb THEN ym ELSE yb END) END)},
 {id:'URG-RB5',alpha:(CASE WHEN (CASE WHEN xa<yb THEN xa ELSE yb END)>(CASE WHEN xb<ym THEN xb ELSE ym END) THEN (CASE WHEN xa<yb THEN xa ELSE yb END) ELSE (CASE WHEN xb<ym THEN xb ELSE ym END) END)},
 {id:'URG-RB6',alpha:(CASE WHEN xb<yb THEN xb ELSE yb END)}] AS activaciones
UNWIND activaciones AS act
MATCH (r:AuditIA_PG2:ReglaDifusa {id:act.id})-[:CONSECUENTE]->(et:EtiquetaDifusa)
WHERE et.sigma>0
WITH n,x,y,md,collect({id:act.id,alpha:act.alpha,c:et.centro,s:et.sigma}) AS reglas
UNWIND range(0,1000) AS k
WITH n,x,y,md,reglas,k*0.01 AS z
WITH n,x,y,md,reglas,z,reduce(maximo=0.0,r IN reglas |
 CASE WHEN (CASE WHEN r.alpha<exp(-0.5*((z-r.c)/r.s)^2) THEN r.alpha ELSE exp(-0.5*((z-r.c)/r.s)^2) END)>maximo
 THEN CASE WHEN r.alpha<exp(-0.5*((z-r.c)/r.s)^2) THEN r.alpha ELSE exp(-0.5*((z-r.c)/r.s)^2) END ELSE maximo END) AS mu
WITH n,x,y,md,reglas,sum(z*mu) AS num,sum(mu) AS den
WHERE den>0
SET n.grado_urgencia=num/den,n.modelo_difuso_version=md.id,n.input_x=x,n.input_y=y,
 n.reglas_difusas_ids=[r IN reglas | r.id],n.activaciones=[r IN reglas | r.alpha],
 n.estado_calculo_difuso='calculado',n.resultado_difuso_provisional=true,
 n.banda_difusa=CASE WHEN num/den<2.73 THEN 'baja' WHEN num/den<7.27 THEN 'media' ELSE 'alta' END
MERGE (n)-[:APLICA_MODELO]->(md);


// Bandas de frontera solicitan revisión, sin simular que ya se realizó.
MATCH (n:AuditIA_PG2) WHERE n.banda_difusa IN ['media','intermedia'] SET n.revision_senior_requerida=true;


// Publicación técnica posterior al enriquecimiento difuso.
MATCH (ev:AuditIA_PG2:Evaluacion {publicado:false}) WHERE ev.estado<>'en_revision' SET ev.publicado=true;
