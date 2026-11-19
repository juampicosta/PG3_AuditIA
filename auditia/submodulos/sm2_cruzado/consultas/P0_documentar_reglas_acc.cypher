// P0. Preparación única (escritura). Incorpora al grafo el texto SI...ENTONCES de las reglas de SM2,
// copiado literalmente del catálogo de PG1 (§6.5, reglas ACC-* y CAT-EX-*). Así el LLM recibe el significado
// de cada regla como dato recuperado y no necesita "saberlo". Solo agrega descripcion y descripcion_fuente
// cuando todavía no existen (coalesce): no sobrescribe, no crea nodos ni relaciones y no modifica estados,
// grados, ejecucion ni decisiones. Es idempotente. Las reglas globales que usa SM2 (GL02, GL03, GL06 y GL07)
// ya tienen su texto en la base y no se tocan.
UNWIND [
 {id:'ACC-RD03', descripcion:'SI los escenarios del par son excluyentes y la interpretación está cerrada ENTONCES sin hallazgo para ese par.'},
 {id:'ACC-RD04', descripcion:'SI una excepción o precedencia explícita concilia el par ENTONCES sin hallazgo por contradicción.'},
 {id:'ACC-RD05', descripcion:'SI los escenarios coinciden, los resultados son incompatibles y ninguna excepción los concilia ENTONCES Hallazgo(contradiccion) y se deriva CONTRADICE.'},
 {id:'ACC-RD06', descripcion:'SI el solapamiento es parcial con región común definida e incompatible ENTONCES Hallazgo(contradiccion_en_region).'},
 {id:'ACC-RD07', descripcion:'SI no puede cerrarse la interpretación del escenario ENTONCES Pendiente(frontera_semantica).'},
 {id:'ACC-RD08', descripcion:'SI la necesidad está confirmada y una definición disponible y pertinente la resuelve ENTONCES dependencia resuelta, sin hallazgo.'},
 {id:'ACC-RD09', descripcion:'SI la necesidad está confirmada, la búsqueda es completa y no hay definición pertinente ENTONCES Hallazgo(dependencia_no_resuelta).'},
 {id:'ACC-RD10', descripcion:'SI el perfil confirmado satisface la condición de una regla del catálogo ENTONCES categoría exigible (se deriva EXIGE).'},
 {id:'ACC-RD11', descripcion:'SI el perfil confirmado no satisface la condición ENTONCES categoría no aplicable, sin hallazgo.'},
 {id:'ACC-RD12', descripcion:'SI se desconoce la condición del catálogo ENTONCES Pendiente(perfil_insuficiente).'},
 {id:'ACC-RD13', descripcion:'SI la categoría es exigible, la búsqueda es completa y no hay partes cubiertas ENTONCES Hallazgo(brecha_cobertura).'},
 {id:'ACC-RD14', descripcion:'SI todas las necesidades aplicables están cubiertas por requerimientos pertinentes ENTONCES cobertura completa (se deriva CUBRE).'},
 {id:'ACC-RD15', descripcion:'SI hay una parte identificable cubierta y otra ausente en revisión completa ENTONCES Hallazgo(cobertura_parcial).'},
 {id:'ACC-RD16', descripcion:'SI la categoría es exigible pero no se puede cerrar la pertinencia de las obligaciones ENTONCES Pendiente(cobertura_indeterminada); si la duda es local, aplica GL09.'},
 {id:'ACC-RD18', descripcion:'SI los escenarios coinciden y los resultados pueden satisfacerse a la vez ENTONCES sin hallazgo.'},
 {id:'ACC-RD19', descripcion:'SI hay región común definida y los resultados coexisten ENTONCES sin hallazgo en esa región.'},
 {id:'ACC-HC01', descripcion:'SI dos obligaciones de requerimientos distintos comparten objeto y acción ENTONCES proponer el par para comparación.'},
 {id:'ACC-HC02', descripcion:'SI una referencia disponible coincide en alcance, concepto y condición con la necesidad ENTONCES la definición es pertinente.'},
 {id:'ACC-HC03', descripcion:'SI el cotejo necesidad–obligación está fundamentado y el mapa validado ENTONCES se cierra la interpretación de cobertura.'},
 {id:'ACC-HC04', descripcion:'SI se fundamenta un hallazgo de contradicción ENTONCES se propone severidad base alta (candidata); dependencias y brechas sin pauta conservan null y valor_original.'},
 {id:'CAT-EX-SEG', descripcion:"SI el perfil confirmado declara datos sensibles ENTONCES revisar Seguridad para la necesidad 'protección de datos sensibles'."},
 {id:'CAT-EX-PARC', descripcion:'SI el perfil construido exige control y registro de accesos ENTONCES revisar Seguridad con esas dos necesidades.'}
] AS item
MATCH (r:AuditIA_PG2:Regla {id: item.id})
SET r.descripcion = coalesce(r.descripcion, item.descripcion),
    r.descripcion_fuente = coalesce(r.descripcion_fuente, 'PG1 §6.5')
RETURN count(r) AS reglas_documentadas;
