// Q0. Requerimientos evaluados por SM1. Alimenta la resolución determinística de entidades.
// Solo lectura. Sin parámetros.
MATCH (ev:AuditIA_PG2:EvaluacionIndividual)-[:EVALUA]->(rq:AuditIA_PG2:Requerimiento),
      (ev)-[:REVISA_DOCUMENTO]->(doc:AuditIA_PG2:DocumentoVersion)
WITH rq, doc, collect(DISTINCT ev.id) AS evaluaciones
RETURN rq.id AS requerimiento_id, rq.id_logico AS id_logico, rq.texto_original AS texto,
       doc.id AS documento_id, toInteger(doc.version) AS version, evaluaciones
ORDER BY id_logico, version;
