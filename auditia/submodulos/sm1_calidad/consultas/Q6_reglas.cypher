// Q6. Consulta complementaria: texto, estado y fuente de las reglas citadas en un paquete.
// Parámetros: $ids (List<String>).
MATCH (r:AuditIA_PG2:Regla)
WHERE r.id IN $ids
RETURN r.id AS id, r.modulo AS modulo, r.estado_validacion AS estado_validacion,
       r.ejecucion AS ejecucion, r.descripcion AS descripcion, r.descripcion_fuente AS fuente
ORDER BY id;
