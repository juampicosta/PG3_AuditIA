// Cada consulta devuelve un conteo de incumplimientos; resultado esperado: cero.
MATCH (r:AuditIA_PG2:ResultadoAnalisis)
WHERE NOT (r)-[:SE_SUSTENTA_EN]->(:Evidencia) OR NOT (r)-[:APLICA_REGLA]->(:Regla)
RETURN count(r) AS resultados_sin_trazabilidad;
MATCH (d:AuditIA_PG2:DecisionPrioridad) WHERE d.provisional<>true OR d.provisional IS NULL
RETURN count(d) AS decisiones_candidatas_no_provisionales;
MATCH (i:AuditIA_PG2:IncidenciaEntrada)<-[:PRIORIZA]-(d)
RETURN count(d) AS incidencias_priorizadas;
MATCH (e:AuditIA_PG2:EvaluacionIndividual {publicado:true,entrada_valida:true})
OPTIONAL MATCH (e)-[:CONTIENE_JUICIO]->(j)-[:APLICA_CRITERIO]->(c)
WITH e,count(j) AS juicios,count(DISTINCT c) AS criterios
WHERE juicios<>4 OR criterios<>4 RETURN count(e) AS cardinalidades_incorrectas;
MATCH (d:AuditIA_PG2:DecisionPrioridad)-[:TIENE_ESTADO]->(:EstadoResolucion {valor:'resuelto'})
WHERE NOT (d)-[:SUSTITUYE_A]->() OR NOT (d)-[:SE_BASA_EN_REEVALUACION]->(:Evaluacion {autorizada_por_origen:true,correspondencia_version:true})
RETURN count(d) AS cierres_sin_reevaluacion;
MATCH (e:AuditIA_PG2:EtiquetaDifusa) WHERE e.sigma<=0 OR e.sigma IS NULL
RETURN count(e) AS sigmas_invalidos;
MATCH (d:AuditIA_PG2:DecisionPrioridad) WHERE d.grado_urgencia<0 OR d.grado_urgencia>10
RETURN count(d) AS grados_fuera_de_rango;
MATCH p=(e:AuditIA_PG2:Evaluacion)-[:REEVALUA*1..20]->(e)
RETURN count(p) AS ciclos_de_reevaluacion;
