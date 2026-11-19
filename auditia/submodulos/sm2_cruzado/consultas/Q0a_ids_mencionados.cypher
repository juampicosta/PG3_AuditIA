// Q0a. Comprueba si los IDs que el usuario escribió literalmente existen en la base y a qué módulo pertenecen.
// Evita responder sobre un requerimiento, documento u observación que el grafo no registra.
// Parámetros: $ids (List<String>).
MATCH (n:AuditIA_PG2)
WHERE n.id IN $ids
RETURN n.id AS id, [l IN labels(n) WHERE l <> 'AuditIA_PG2'] AS etiquetas,
       n.modulo_origen AS modulo_origen, n.modulo AS modulo
ORDER BY id;
