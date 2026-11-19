// P0. Preparación única (escritura). Incorpora al grafo el texto SI...ENTONCES de las reglas de SM3 (familia PRC)
// que todavía no lo tienen, copiado literalmente del catálogo de PG1 (§6.6, pp. 50-51). PRC-RD02 y PRC-RD09 ya
// tienen texto y no se tocan; no existe PRC-RD05 (se absorbió en GL05, PG1 §6.7). Así el LLM recibe el significado
// de cada regla como dato recuperado y no necesita "saberlo". No sobrescribe textos existentes (coalesce), no crea
// nodos y no modifica estados, ejecución, decisiones ni grados. Es idempotente.
UNWIND [
 {id:'PRC-RD01', descripcion:'SI la observación recibida tiene identidad, versión u origen incoherentes ENTONCES IncidenciaEntrada(ámbito = observacion_recibida) y devolución al emisor, sin prioridad.'},
 {id:'PRC-RD03', descripcion:'SI severidad y criticidad son conocidas y el contexto es suficiente ENTONCES categoria_matriz = MPR-01(severidad, criticidad).'},
 {id:'PRC-RD04', descripcion:'SI la pregunta no tiene responsable ENTONCES asignacion = pendiente.'},
 {id:'PRC-RD06', descripcion:'SI llega una respuesta a una pregunta ENTONCES se registra con estado recibida.'},
 {id:'PRC-RD07', descripcion:'SI la respuesta está validada, es suficiente y no es discordante ENTONCES se deriva al módulo de origen (dispara GL03).'},
 {id:'PRC-RD08', descripcion:'SI dos preguntas tienen el mismo dato_clave, el mismo responsable confirmado y equivalencia semántica confirmada ENTONCES se crea una pregunta agrupada.'},
 {id:'PRC-RD10', descripcion:'SI la respuesta es insuficiente o discordante ENTONCES nuevo estado pendiente_complemento.'},
 {id:'PRC-RD11', descripcion:'SI la revisión es conforme, el responsable está confirmado, hay prioridad y la redacción fue aceptada ENTONCES emitible = verdadero.'},
 {id:'PRC-RD12', descripcion:'SI una pregunta agrupa decisiones con prioridad informada ENTONCES prioridad_presentacion = máxima urgencia (bloqueante > mayor > menor).'},
 {id:'PRC-RD13', descripcion:'SI todas las evaluaciones de la versión están publicadas y cada observación tiene decisión ENTONCES se genera InformeAuditoria con resúmenes y pendientes; madurez = null hasta PI3.'},
 {id:'PRC-HC01', descripcion:'SI un hallazgo deja indefinida una obligación esencial ENTONCES prioridad bloqueante, motivo sustantivo.'},
 {id:'PRC-HC02', descripcion:'SI severidad = baja y criticidad = alta (mapeo candidato activo) ENTONCES bloqueante sustantiva provisional, sin cambiar la severidad.'},
 {id:'PRC-HC03', descripcion:'SI la celda de MPR-01 es bloqueante fuera de la excepción anterior ENTONCES bloqueante sustantiva provisional.'},
 {id:'PRC-HC04', descripcion:'SI la celda es mayor, no hay bloqueo sustantivo y existe hito acordado ENTONCES prioridad mayor (en_hito).'},
 {id:'PRC-HC05', descripcion:'SI la celda es menor, el impacto es acotado y hay diferimiento aceptado ENTONCES prioridad menor (diferimiento).'},
 {id:'PRC-HC06', descripcion:'SI se identificó el dato o decisión que resolvería la observación ENTONCES formular una pregunta concreta y neutral al referente competente.'},
 {id:'PRC-HC07', descripcion:'SI dos preguntas piden el mismo dato con igual significado fundamentado ENTONCES equivalencia_semantica_confirmada = verdadero.'},
 {id:'PRC-HC08', descripcion:'SI hay dependencias no resueltas, brechas de cobertura o bloqueos preventivos sobre requerimientos de criticidad alta ENTONCES alerta_alcance = verdadero con motivo (candidata).'}
] AS item
MATCH (r:AuditIA_PG2:Regla {id: item.id})
WHERE r.id STARTS WITH 'PRC-'
SET r.descripcion = coalesce(r.descripcion, item.descripcion),
    r.descripcion_fuente = coalesce(r.descripcion_fuente, 'PG1 §6.6')
RETURN count(r) AS reglas_documentadas;
