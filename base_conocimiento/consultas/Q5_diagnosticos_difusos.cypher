// ¿Qué intensidad agregan los PI3 sin reemplazar los estados de SM1 y SM2?
MATCH (n:AuditIA_PG2)-[:APLICA_MODELO]->(m:ModeloDifuso)
WHERE m.id IN ['MD-AMB-1.0','MD-CONTR-1.0']
RETURN n.id AS instancia,m.id AS modelo,n.estado AS estado_crisp,
       n.input_x AS entrada_x,n.input_y AS entrada_y,
       round(coalesce(n.grado_ambiguedad,n.grado_contradiccion),6) AS grado,
       n.banda_difusa AS banda,n.revision_senior_requerida AS requiere_revision
ORDER BY modelo,instancia;
