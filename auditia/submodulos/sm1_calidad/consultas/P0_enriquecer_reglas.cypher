// P0. Preparación única (escritura). Incorpora al grafo el texto SI...ENTONCES de las reglas que
// usa SM1, tomado del catálogo de PG1 (secciones 6.3, 6.4 y 6.6). Así el LLM recibe el significado
// de cada regla como dato recuperado y no necesita "saberlo". No sobrescribe textos existentes,
// no crea nodos y no modifica estados, grados ni decisiones. Es idempotente.
UNWIND [
 {id:'GL01', fuente:'PG1 §6.3', descripcion:'SI la extracción o normalización pierde o altera significado, identidad o versión (entrada_valida = falso) ENTONCES estado = no_evaluable y se registra IncidenciaEntrada; no se emiten juicios.'},
 {id:'GL02', fuente:'PG1 §6.3', descripcion:'SI la entrada es válida y falta un dato o referencia identificado como necesario para concluir ENTONCES el análisis afectado queda pendiente con dato_faltante; los análisis independientes continúan.'},
 {id:'GL03', fuente:'PG1 §6.3', descripcion:'SI llega una respuesta validada o una versión corregida vinculada a una evaluación publicada ENTONCES se crea una evaluación nueva que REEVALUA la anterior; los resultados históricos no se modifican.'},
 {id:'GL05', fuente:'PG1 §6.3', descripcion:'SI una propuesta del LLM (extracción, normalización, redacción o explicación) introduce datos no respaldados o altera una conclusión ENTONCES se rechaza y prevalece la regla.'},
 {id:'GL06', fuente:'PG1 §6.3', descripcion:'SI una evaluación de SM1 o SM2 se publica con Hallazgo o Pendiente ENTONCES se deriva a SM3 con el contrato mínimo (IDs, versión, evidencia, regla, severidad y dato faltante); una IncidenciaEntrada vuelve al analista y no se prioriza.'},
 {id:'GL07', fuente:'PG1 §6.3', descripcion:'SI se deriva un Hallazgo o Pendiente ENTONCES debe incluir una instancia de Severidad (baja, media, alta o null) con su propuesta; bloqueante, mayor y menor no son valores de severidad.'},
 {id:'EVI-RD03', fuente:'PG1 §6.4', descripcion:'SI criterio = verificabilidad, la aceptación es necesaria y no está disponible ENTONCES el juicio queda pendiente.'},
 {id:'EVI-RD04', fuente:'PG1 §6.4', descripcion:'SI hay cuatro juicios informados y al menos uno incumple ENTONCES estado = observado.'},
 {id:'EVI-RD05', fuente:'PG1 §6.4', descripcion:'SI hay cuatro juicios, ningún incumplimiento y al menos un pendiente ENTONCES estado = pendiente.'},
 {id:'EVI-RD06', fuente:'PG1 §6.4', descripcion:'SI los cuatro juicios cumplen ENTONCES estado = sin_hallazgo (en el alcance local).'},
 {id:'EVI-HC02', fuente:'PG1 §6.4', descripcion:'SI quedan dos o más lecturas relevantes y el contexto no las delimita ENTONCES ambigüedad incumple.'},
 {id:'EVI-HC03', fuente:'PG1 §6.4', descripcion:'SI una aceptación o referencia accesible elimina las alternativas de un aspecto ENTONCES ese aspecto queda resuelto.'},
 {id:'EVI-HC04', fuente:'PG1 §6.4', descripcion:'SI existe un método finito, observable y con condición de aprobación ENTONCES verificabilidad cumple.'},
 {id:'EVI-HC08', fuente:'PG1 §6.4', descripcion:'SI hay una sola obligación con unidad de aceptación confirmada ENTONCES atomicidad cumple.'},
 {id:'EVI-HC09', fuente:'PG1 §6.4', descripcion:'SI tras revisar el alcance queda una sola lectura relevante ENTONCES ambigüedad cumple.'},
 {id:'EVI-HC10', fuente:'PG1 §6.4', descripcion:'SI la información aplicable está identificada y no hay omisiones demostradas ENTONCES completitud cumple.'},
 {id:'EVI-HC11', fuente:'PG1 §6.4', descripcion:'SI se publica un hallazgo local ENTONCES el evaluador propone Severidad con fundamento en el efecto del defecto sobre la obligación; si no puede justificarla, valor = null y validación pendiente.'},
 {id:'PRC-RD02', fuente:'PG1 §6.6', descripcion:'SI falta un dato confirmado como necesario para elegir el tratamiento ENTONCES prioridad bloqueante, motivo preventivo, provisional.'},
 {id:'PRC-RD09', fuente:'PG1 §6.6', descripcion:'SI la respuesta está validada, la reevaluación del origen informa resuelta, autorizada y con versión coincidente, y la revisión es conforme ENTONCES nuevo estado resuelto.'}
] AS item
MATCH (r:AuditIA_PG2:Regla {id: item.id})
SET r.descripcion = coalesce(r.descripcion, item.descripcion),
    r.descripcion_fuente = coalesce(r.descripcion_fuente, item.fuente)
RETURN count(r) AS reglas_documentadas;
