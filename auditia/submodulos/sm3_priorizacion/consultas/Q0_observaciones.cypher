// Q0. Observaciones recibidas por SM3 con su decisión vigente, si la tienen. Alimenta la resolución
// determinística de entidades: el LLM nunca elige un ID del grafo. Solo lectura. Sin parámetros.
MATCH (ev:AuditIA_PG2:Evaluacion)-[:GENERA]->(o:ResultadoAnalisis), (ev)-[:REVISA_DOCUMENTO]->(doc:DocumentoVersion)
OPTIONAL MATCH (d:DecisionPrioridad)-[:PRIORIZA]->(o)
WHERE NOT EXISTS { MATCH (:DecisionPrioridad)-[:SUSTITUYE_A]->(d) }
RETURN o.id AS observacion_id,
       CASE WHEN o:Hallazgo THEN 'hallazgo' WHEN o:Pendiente THEN 'pendiente'
            WHEN o:IncidenciaEntrada THEN 'incidencia_entrada' ELSE 'resultado' END AS tipo,
       o.modulo_origen AS modulo_origen, o.descripcion AS descripcion, o.tipo_defecto AS tipo_defecto,
       o.dato_faltante AS dato_faltante, doc.id AS documento_id,
       [(o)-[:AFECTA_REQUERIMIENTO]->(rq:Requerimiento) | rq.texto_original] AS textos_requerimiento,
       d.id AS decision_id
ORDER BY observacion_id;
