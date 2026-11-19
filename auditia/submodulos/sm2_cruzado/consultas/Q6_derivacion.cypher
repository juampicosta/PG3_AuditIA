// Q6. Contrato de derivación de un resultado de SM2 hacia SM3 (GL06 y GL07): resultado, evaluación de origen,
// requerimientos o categoría afectados, severidad propuesta por SM2, dato faltante, reglas y evidencia; y, por
// separado, la recepción que registró SM3 (decisión vigente, prioridad, motivo, provisional, emitible y estado).
// Parámetros: $observacion_id (String).
MATCH (ev:AuditIA_PG2:EvaluacionCruzada)-[:GENERA]->(o:ResultadoAnalisis {id: $observacion_id})-[:TIENE_SEVERIDAD]->(sv:Severidad)
MATCH (ev)-[:REVISA_DOCUMENTO]->(doc:DocumentoVersion)
OPTIONAL MATCH (d:DecisionPrioridad)-[:PRIORIZA]->(o)
WHERE NOT EXISTS { MATCH (:DecisionPrioridad)-[:SUSTITUYE_A]->(d) }
OPTIONAL MATCH (d)-[:TIENE_ESTADO]->(er:EstadoResolucion)
RETURN {
  observacion_id: o.id,
  clase: CASE WHEN o:Hallazgo THEN 'Hallazgo' ELSE 'Pendiente' END,
  modulo_origen: o.modulo_origen,
  tipo_defecto: o.tipo_defecto,
  motivo_pendiente: o.motivo_pendiente,
  descripcion: coalesce(o.descripcion_defecto, o.descripcion),
  dato_faltante: o.dato_faltante,
  destinatario_rol: o.destinatario_rol,
  evaluacion_id: ev.id,
  estado_evaluacion: ev.estado,
  tipo_analisis: ev.tipo_analisis,
  documento_id: doc.id,
  version: toInteger(doc.version),
  afecta_requerimientos: [(o)-[:AFECTA_REQUERIMIENTO]->(r:Requerimiento) | r.id],
  afecta_categoria: [(o)-[:AFECTA_CATEGORIA]->(c:CategoriaNFR) | c.nombre],
  reglas_origen: [(o)-[:APLICA_REGLA]->(r:Regla) | r.id],
  evidencias: [(o)-[:SE_SUSTENTA_EN]->(e:Evidencia) | {id: e.id, tipo: e.tipo, contenido: e.contenido}],
  severidad_propuesta: {id: sv.id, valor: sv.valor, propuesta_por: sv.propuesta_por,
                        validacion: sv.validacion, fundamento: sv.fundamento},
  recepcion_sm3: CASE WHEN d IS NULL THEN null ELSE
    {decision_id: d.id, prioridad: d.prioridad, motivo: d.motivo, provisional: d.provisional,
     emitible: d.emitible, estado_seguimiento: er.valor} END
} AS derivacion;
