// Q0. Catálogo de lo que analizó SM2: una fila por evaluación cruzada y requerimiento vinculado, con su rol
// (comparado, origen_dependencia, definicion o alcance_cobertura), la categoría evaluada y el resultado.
// Alimenta la resolución determinística de entidades. Solo lectura. Sin parámetros.
MATCH (ev:AuditIA_PG2:EvaluacionCruzada)-[:REVISA_DOCUMENTO]->(doc:AuditIA_PG2:DocumentoVersion)
WITH ev, doc,
     [(ev)-[:COMPARA]->(r:Requerimiento) | {r: r, rol: 'comparado'}] +
     [(ev)-[:RASTREA]->(:Dependencia)-[:TIENE_ORIGEN]->(r:Requerimiento) | {r: r, rol: 'origen_dependencia'}] +
     [(ev)-[:RASTREA]->(:Dependencia)-[:RESUELTA_POR]->(r:Requerimiento) | {r: r, rol: 'definicion'}] +
     CASE WHEN ev.tipo_analisis = 'cobertura'
          THEN [(doc)-[:CONTIENE]->(r:Requerimiento) | {r: r, rol: 'alcance_cobertura'}] ELSE [] END AS vinculos
UNWIND vinculos AS v
WITH DISTINCT ev, doc, v.r AS rq, v.rol AS rol
RETURN ev.id AS evaluacion_id, ev.tipo_analisis AS tipo_analisis, ev.estado AS estado,
       doc.id AS documento_id, toInteger(doc.version) AS version,
       rq.id AS requerimiento_id, rq.id_logico AS id_logico, rq.texto_original AS texto, rol,
       head([(ev)-[:EVALUA_CATEGORIA]->(c:CategoriaNFR) | c.nombre]) AS categoria,
       head([(ev)-[:GENERA]->(o:ResultadoAnalisis) | o.id]) AS resultado_id,
       NOT EXISTS { MATCH (:Evaluacion)-[:REEVALUA]->(ev) } AS vigente
ORDER BY tipo_analisis, evaluacion_id, requerimiento_id;
