// Q3. ¿Qué urgencia tiene una observación y cómo se calculó? Resultado Mamdani de MD-URG-1.0 guardado por
// 04_difusa.cypher de PG2: entradas, pertenencias, activación de cada regla, grado y banda. La pertenencia de
// cada entrada se calcula con los centros y sigma almacenados en el grafo; el centroide no se recalcula.
// Parámetro: $observacion_id (String).
MATCH (o:AuditIA_PG2:ResultadoAnalisis {id: $observacion_id})<-[:PRIORIZA]-(d:DecisionPrioridad)
WHERE NOT EXISTS { MATCH (:DecisionPrioridad)-[:SUSTITUYE_A]->(d) }
MATCH (o)-[:TIENE_SEVERIDAD]->(sv:Severidad), (d)-[:APLICA_REGLA]->(r:Regla)
OPTIONAL MATCH (cr:AuditIA_PG2:Criticidad {id: d.criticidad_id})
OPTIONAL MATCH (d)-[:APLICA_MODELO]->(m:ModeloDifuso)
OPTIONAL MATCH (m)-[:CITA_FUENTE]->(fm:Fuente)
WITH o, d, r, sv, cr, m, fm,
     [(:AuditIA_PG2:ModeloDifuso {id: 'MD-URG-1.0'})-[:DEFINE_VARIABLE]->(v:VariableDifusa)-[:TIENE_ETIQUETA]->(et:EtiquetaDifusa)
      | {variable: v.nombre, slot: v.slot, etiqueta: et.codigo, centro: et.centro, sigma: et.sigma}] AS etiquetas,
     [(:AuditIA_PG2:ModeloDifuso {id: 'MD-URG-1.0'})-[:DEFINE_REGLA]->(rd:ReglaDifusa)
      | {id: rd.id, orden: rd.orden, antecedente: rd.antecedente, salida: rd.salida, regla_crisp: rd.regla_crisp}] AS reglas_modelo
RETURN {
  observacion_id: o.id, decision_id: d.id, prioridad: d.prioridad, motivo: d.motivo, regla_decision: r.id,
  estado_seguimiento: head([(d)-[:TIENE_ESTADO]->(er:EstadoResolucion) | er.valor]),
  provisional: d.provisional, emitible: d.emitible,
  severidad: sv.valor, x_severidad: sv.grado_severidad, severidad_propuesta_por: sv.propuesta_por,
  criticidad_id: cr.id, criticidad: cr.valor, y_criticidad: cr.grado_criticidad,
  estado_calculo_difuso: d.estado_calculo_difuso,
  grado_urgencia: CASE WHEN d.grado_urgencia IS NULL THEN null ELSE round(d.grado_urgencia, 6) END,
  banda_urgencia: d.banda_difusa,
  resultado_difuso_provisional: d.resultado_difuso_provisional,
  revision_senior_requerida: coalesce(d.revision_senior_requerida, false),
  modelo_id: m.id, modelo_estado_validacion: m.estado_validacion,
  modelo_metodo: CASE WHEN m IS NULL THEN null
                 ELSE m.tipo + ' ' + m.operador_and + '/' + m.agregacion + ', ' + m.desdifusificacion END,
  fuente_modelo: fm.id, validez_fuente_modelo: fm.validez,
  activaciones: CASE WHEN d.reglas_difusas_ids IS NULL THEN [] ELSE
    [i IN range(0, size(d.reglas_difusas_ids) - 1) | {regla: d.reglas_difusas_ids[i], alfa: round(d.activaciones[i], 6)}] END,
  pertenencias: CASE WHEN d.estado_calculo_difuso = 'calculado' THEN
    [e IN etiquetas WHERE e.slot = 'F26.grado_severidad' |
       {variable: e.variable, etiqueta: e.etiqueta, mu: round(exp(-0.5 * ((sv.grado_severidad - e.centro) / e.sigma) ^ 2), 4)}] +
    [e IN etiquetas WHERE e.slot = 'F27.grado_criticidad' |
       {variable: e.variable, etiqueta: e.etiqueta, mu: round(exp(-0.5 * ((cr.grado_criticidad - e.centro) / e.sigma) ^ 2), 4)}]
    ELSE [] END,
  reglas_modelo: reglas_modelo
} AS urgencia;
