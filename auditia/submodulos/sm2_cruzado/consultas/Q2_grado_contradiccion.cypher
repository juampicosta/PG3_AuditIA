// Q2. Grado de pertenencia a contradicción (MD-CONTR-1.0) de una evaluación cruzada: entradas, pertenencias,
// reglas difusas con su activación, etiquetas de salida, resultado, fuente PI3 y regla crisp que decidió.
// La pertenencia de cada entrada se calcula con los centros y sigma guardados; no se recalcula el centroide.
// Parámetros: $evaluacion_id (String).
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {id: $evaluacion_id})-[:REVISA_DOCUMENTO]->(doc:DocumentoVersion)
OPTIONAL MATCH (ev)-[:APLICA_MODELO]->(md:ModeloDifuso)
OPTIONAL MATCH (md)-[:CITA_FUENTE]->(f:Fuente)
OPTIONAL MATCH (ev)-[:GENERA]->(o:ResultadoAnalisis)
RETURN {
  evaluacion_id: ev.id,
  estado: ev.estado,
  documento_id: doc.id,
  version: toInteger(doc.version),
  escenarios: ev.escenarios,
  requerimientos: [(ev)-[:COMPARA]->(r:Requerimiento) | {id: r.id, texto: r.texto_original}],
  solapamiento_escenario: ev.solapamiento_escenario,
  incompatibilidad_resultados: ev.incompatibilidad_resultados,
  estado_calculo_difuso: ev.estado_calculo_difuso,
  grado_contradiccion: CASE WHEN ev.grado_contradiccion IS NULL THEN null ELSE round(ev.grado_contradiccion, 6) END,
  banda_difusa: ev.banda_difusa,
  revision_senior_requerida: coalesce(ev.revision_senior_requerida, false),
  reglas_crisp: [(ev)-[:APLICA_REGLA]->(r:Regla) | r.id],
  evidencias: [(ev)-[:SE_SUSTENTA_EN]->(e:Evidencia) | {id: e.id, tipo: e.tipo, contenido: e.contenido}],
  resultado: CASE WHEN o IS NULL THEN null ELSE
    {id: o.id, clase: CASE WHEN o:Hallazgo THEN 'Hallazgo' ELSE 'Pendiente' END,
     tipo_defecto: o.tipo_defecto, motivo_pendiente: o.motivo_pendiente,
     dato_faltante: o.dato_faltante, destinatario_rol: o.destinatario_rol} END,
  modelo_id: md.id,
  modelo_estado_validacion: md.estado_validacion,
  modelo_metodo: CASE WHEN md IS NULL THEN null
                 ELSE md.tipo + ' ' + md.operador_and + '/' + md.agregacion + ', ' + md.desdifusificacion END,
  fuente_modelo: f.nombre,
  reglas_difusas: CASE WHEN md IS NULL OR ev.reglas_difusas_ids IS NULL THEN [] ELSE
    [i IN range(0, size(ev.reglas_difusas_ids) - 1) |
     head([(md)-[:DEFINE_REGLA]->(rd:ReglaDifusa {id: ev.reglas_difusas_ids[i]}) |
       {id: rd.id, antecedente: rd.antecedente, salida: rd.salida, regla_crisp: rd.regla_crisp,
        activacion: round(ev.activaciones[i], 4)}])] END,
  pertenencias_entrada: CASE WHEN md IS NULL THEN [] ELSE
    [(md)-[:DEFINE_VARIABLE]->(v:VariableDifusa {rol: 'entrada'})-[:TIENE_ETIQUETA]->(et:EtiquetaDifusa) |
     {variable: v.nombre, etiqueta: et.nombre, centro: et.centro, sigma: et.sigma,
      pertenencia: round(exp(-0.5 * (((CASE v.slot WHEN 'premisa_x' THEN ev.solapamiento_escenario
                                       ELSE ev.incompatibilidad_resultados END) - et.centro) / et.sigma) ^ 2), 3)}] END,
  etiquetas_salida: CASE WHEN md IS NULL THEN [] ELSE
    [(md)-[:DEFINE_VARIABLE]->(v:VariableDifusa {rol: 'salida'})-[:TIENE_ETIQUETA]->(et:EtiquetaDifusa) |
     {id: et.id, variable: v.nombre, etiqueta: et.nombre, centro: et.centro, sigma: et.sigma}] END
} AS grado;
