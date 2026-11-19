// Q1. ¿Qué observaciones hay que atender y con qué prioridad? Lista las decisiones vigentes de SM3
// (las que no tienen sucesora por SUSTITUYE_A), ordenadas por prioridad y grado de urgencia.
// Parámetros: $prioridad, $motivo, $documento_id (String o null) y $estado ('abiertas', 'resueltas' o 'todas').
MATCH (d:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]->(o:ResultadoAnalisis),
      (d)-[:TIENE_ESTADO]->(er:EstadoResolucion), (d)-[:APLICA_REGLA]->(r:Regla),
      (ev:Evaluacion)-[:GENERA]->(o), (ev)-[:REVISA_DOCUMENTO]->(doc:DocumentoVersion)
WHERE NOT EXISTS { MATCH (:DecisionPrioridad)-[:SUSTITUYE_A]->(d) }
  AND ($prioridad IS NULL OR d.prioridad = $prioridad)
  AND ($motivo IS NULL OR d.motivo = $motivo)
  AND ($documento_id IS NULL OR doc.id = $documento_id)
  AND ($estado = 'todas' OR ($estado = 'abiertas' AND er.valor <> 'resuelto')
       OR ($estado = 'resueltas' AND er.valor = 'resuelto'))
OPTIONAL MATCH (o)-[:TIENE_SEVERIDAD]->(sv:Severidad)
OPTIONAL MATCH (cr:AuditIA_PG2:Criticidad {id: d.criticidad_id})
RETURN o.id AS observacion,
       CASE WHEN o:Hallazgo THEN 'hallazgo' ELSE 'pendiente' END AS tipo,
       o.modulo_origen AS modulo_origen, o.descripcion AS descripcion, doc.id AS documento,
       d.id AS decision, d.prioridad AS prioridad, d.motivo AS motivo, r.id AS regla,
       sv.valor AS severidad, cr.valor AS criticidad,
       CASE WHEN d.grado_urgencia IS NULL THEN null ELSE round(d.grado_urgencia, 3) END AS grado_urgencia,
       d.banda_difusa AS banda_urgencia, er.valor AS estado,
       d.provisional AS provisional, d.emitible AS emitible
ORDER BY CASE d.prioridad WHEN 'bloqueante' THEN 0 WHEN 'mayor' THEN 1 ELSE 2 END,
         coalesce(d.grado_urgencia, -1) DESC, observacion;
