// Q2. Grado difuso de ambigüedad residual (MD-AMB-1.0) con entradas, pertenencias,
// reglas activadas, parámetros del modelo y fuente PI3. La pertenencia de cada entrada
// se calcula con los parámetros almacenados en el grafo; no se recalcula el centroide.
// Parámetros: $requerimiento_id (String).
MATCH (ev:AuditIA_PG2:EvaluacionIndividual)-[:EVALUA]->(rq:AuditIA_PG2:Requerimiento {id: $requerimiento_id}),
      (ev)-[:REVISA_DOCUMENTO]->(doc:AuditIA_PG2:DocumentoVersion),
      (ev)-[:CONTIENE_JUICIO]->(j:JuicioCriterio)-[:APLICA_CRITERIO]->(:CriterioCalidad {nombre: 'ambiguedad'})
OPTIONAL MATCH (j)-[:APLICA_MODELO]->(md:ModeloDifuso)
OPTIONAL MATCH (md)-[:CITA_FUENTE]->(f:Fuente)
WITH ev, rq, doc, j, md, f,
     CASE WHEN md IS NULL THEN [] ELSE
       [(md)-[:DEFINE_VARIABLE]->(v:VariableDifusa)-[:TIENE_ETIQUETA]->(et:EtiquetaDifusa) |
        {variable: v.nombre, rol: v.rol, etiqueta: et.nombre, centro: et.centro, sigma: et.sigma,
         pertenencia_entrada: CASE
           WHEN v.slot = 'premisa_x' AND j.divergencia_lecturas IS NOT NULL
             THEN round(exp(-0.5 * ((j.divergencia_lecturas - et.centro) / et.sigma) ^ 2), 3)
           WHEN v.slot = 'premisa_y' AND j.delimitacion_contexto IS NOT NULL
             THEN round(exp(-0.5 * ((j.delimitacion_contexto - et.centro) / et.sigma) ^ 2), 3)
           ELSE null END}]
     END AS etiquetas,
     CASE WHEN md IS NULL THEN [] ELSE
       [(md)-[:DEFINE_REGLA]->(rd:ReglaDifusa) |
        {id: rd.id, antecedente: rd.antecedente, salida: rd.salida, regla_crisp: rd.regla_crisp, orden: rd.orden}]
     END AS reglas_difusas
RETURN {
  evaluacion_id: ev.id,
  estado_evaluacion: ev.estado,
  documento_id: doc.id,
  version: toInteger(doc.version),
  requerimiento_id: rq.id,
  texto_requerimiento: rq.texto_original,
  vigente: NOT EXISTS { MATCH (:Evaluacion)-[:REEVALUA]->(ev) },
  juicio_id: j.id,
  estado_juicio: j.estado,
  justificacion: j.justificacion,
  reglas_juicio: [(j)-[:APLICA_REGLA]->(r:Regla) | r.id],
  evidencias: [(j)-[:SE_SUSTENTA_EN]->(e:Evidencia) |
               {id: e.id, tipo: e.tipo, contenido: e.contenido, localizador: e.localizador}],
  divergencia_lecturas: j.divergencia_lecturas,
  delimitacion_contexto: j.delimitacion_contexto,
  valoracion_confirmada: j.valoracion_confirmada,
  estado_calculo_difuso: j.estado_calculo_difuso,
  grado_ambiguedad: CASE WHEN j.grado_ambiguedad IS NULL THEN null ELSE round(j.grado_ambiguedad, 6) END,
  banda_difusa: j.banda_difusa,
  reglas_difusas_activadas: j.reglas_difusas_ids,
  activaciones: CASE WHEN j.activaciones IS NULL THEN null ELSE [a IN j.activaciones | round(a, 3)] END,
  revision_senior_requerida: coalesce(j.revision_senior_requerida, false),
  resultado_difuso_provisional: j.resultado_difuso_provisional,
  modelo_id: md.id,
  modelo_estado_validacion: md.estado_validacion,
  modelo_metodo: CASE WHEN md IS NULL THEN null
                 ELSE md.tipo + ' ' + md.operador_and + '/' + md.agregacion + ', ' + md.desdifusificacion END,
  fuente_modelo: f.nombre,
  etiquetas: etiquetas,
  reglas_difusas: reglas_difusas
} AS grado
ORDER BY ev.fecha, ev.id;
