// Q4. Consulta Q4_paquete_llm.cypher de PG2, reutilizada sin cambios: es el contrato de PI4 (PG2 §4.1).
// En SM3 se lee el seguimiento del tratamiento: prioridad, motivo, estado, tratamiento_activo, provisional y emitible.
// Parámetro: $observacion_id (String).
MATCH (o:AuditIA_PG2:ResultadoAnalisis {id:$observacion_id})<-[:GENERA]-(origen)-[:REVISA_DOCUMENTO]->(doc_origen),
      (d:DecisionPrioridad)-[:PRIORIZA]->(o),(d)-[:TIENE_ESTADO]->(er)
WHERE NOT EXISTS {MATCH (:DecisionPrioridad)-[:SUSTITUYE_A]->(d)}
OPTIONAL MATCH (d)-[:SE_BASA_EN_REEVALUACION]->(reevaluacion:Evaluacion)
WITH o,origen,doc_origen,d,er,coalesce(reevaluacion,origen) AS actual
MATCH (actual)-[:REVISA_DOCUMENTO]->(doc)
OPTIONAL MATCH (o)-[:DERIVA_DE_JUICIO]->(jo)-[:APLICA_CRITERIO]->(criterio)
OPTIONAL MATCH (actual)-[:CONTIENE_JUICIO]->(ja)-[:APLICA_CRITERIO]->(criterio)
WITH o,origen,doc_origen,d,er,actual,doc,jo,ja
OPTIONAL MATCH (o)-[:SE_SUSTENTA_EN]->(eo)-[:CITA_FUENTE]->(fo)
WITH o,origen,doc_origen,d,er,actual,doc,jo,ja,
 collect(DISTINCT CASE WHEN eo IS NOT NULL THEN {id:eo.id,tipo:eo.tipo,contenido:eo.contenido,localizador:eo.localizador,fuente:fo.id} END) AS evidencia_origen
OPTIONAL MATCH (d)-[:SE_SUSTENTA_EN]->(ed)-[:CITA_FUENTE]->(fd)
WITH o,origen,doc_origen,d,er,actual,doc,jo,ja,evidencia_origen,
 collect(DISTINCT CASE WHEN ed IS NOT NULL THEN {id:ed.id,tipo:ed.tipo,contenido:ed.contenido,localizador:ed.localizador,fuente:fd.id} END) AS evidencia_decision
OPTIONAL MATCH (actual)-[:SE_SUSTENTA_EN]->(ea)-[:CITA_FUENTE]->(fa)
WITH o,origen,doc_origen,d,er,actual,doc,jo,ja,evidencia_origen,evidencia_decision,
 collect(DISTINCT CASE WHEN ea IS NOT NULL THEN {id:ea.id,tipo:ea.tipo,contenido:ea.contenido,localizador:ea.localizador,fuente:fa.id} END) AS evidencia_evaluacion_vigente
OPTIONAL MATCH (o)-[:APLICA_REGLA]->(r1)
WITH o,origen,doc_origen,d,er,actual,doc,jo,ja,evidencia_origen,evidencia_decision,evidencia_evaluacion_vigente,collect(DISTINCT r1.id) AS reglas_origen
OPTIONAL MATCH (d)-[:APLICA_REGLA]->(r2)
WITH o,origen,doc_origen,d,er,actual,doc,jo,ja,evidencia_origen,evidencia_decision,evidencia_evaluacion_vigente,reglas_origen,collect(DISTINCT r2.id) AS reglas_decision
RETURN {observacion_id:o.id,documento_id:doc.id,version:doc.version,
 documento_origen_id:doc_origen.id,version_origen:doc_origen.version,
 modulo_origen:o.modulo_origen,evaluacion_id:actual.id,evaluacion_origen_id:origen.id,
 estado_evaluacion_vigente:actual.estado,descripcion:o.descripcion,descripcion_corresponde_a:'observacion_historica',
 grado_ambiguedad:ja.grado_ambiguedad,grado_ambiguedad_origen:jo.grado_ambiguedad,
 modelo_ambiguedad:ja.modelo_difuso_version,
 grado_contradiccion:actual.grado_contradiccion,modelo_diagnostico:actual.modelo_difuso_version,
 decision_id:d.id,prioridad:d.prioridad,motivo:d.motivo,estado:er.valor,
 provisional:d.provisional,emitible:d.emitible,tratamiento_activo:er.valor<>'resuelto',dato_faltante:o.dato_faltante,
 grado_urgencia:d.grado_urgencia,modelo_difuso:d.modelo_difuso_version,
 reglas_origen:reglas_origen,reglas_decision:reglas_decision,
 evidencia_origen:evidencia_origen,evidencia_decision:evidencia_decision,
 evidencia_evaluacion_vigente:evidencia_evaluacion_vigente} AS paquete;
