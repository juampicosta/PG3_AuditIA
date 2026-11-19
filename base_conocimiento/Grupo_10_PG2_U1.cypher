// AuditIA - Grupo 10 - PG2
// Ejecutar sobre una instancia Neo4j 5.26.0. No borra bases ajenas.

// ARCHIVO 01_esquema.cypher
// Solo crea restricciones del proyecto; no borra datos ajenos.
CREATE CONSTRAINT auditia_pg2_id IF NOT EXISTS FOR (n:AuditIA_PG2) REQUIRE n.id IS UNIQUE;
CREATE INDEX auditia_pg2_eval_estado IF NOT EXISTS FOR (e:Evaluacion) ON (e.estado);
CREATE INDEX auditia_pg2_fuente_nombre IF NOT EXISTS FOR (f:Fuente) ON (f.nombre);

// ARCHIVO 02_carga.cypher
// Datos académicos del Grupo 10. MERGE por ID; ON CREATE preserva instantáneas.

MERGE (n:AuditIA_PG2 {id: 'F01'})
ON CREATE SET n:Frame, n += {id: 'F01', nombre: 'DocumentoVersion', abstracta: false, origen: 'PG1', localizador: 'PG1 F01'};

MERGE (n:AuditIA_PG2 {id: 'F02'})
ON CREATE SET n:Frame, n += {id: 'F02', nombre: 'Requerimiento', abstracta: false, origen: 'PG1', localizador: 'PG1 F02'};

MERGE (n:AuditIA_PG2 {id: 'F03'})
ON CREATE SET n:Frame, n += {id: 'F03', nombre: 'Obligacion', abstracta: false, origen: 'PG1', localizador: 'PG1 F03'};

MERGE (n:AuditIA_PG2 {id: 'F04'})
ON CREATE SET n:Frame, n += {id: 'F04', nombre: 'Evidencia', abstracta: false, origen: 'PG1', localizador: 'PG1 F04'};

MERGE (n:AuditIA_PG2 {id: 'F05'})
ON CREATE SET n:Frame, n += {id: 'F05', nombre: 'Fuente', abstracta: false, origen: 'PG1', localizador: 'PG1 F05'};

MERGE (n:AuditIA_PG2 {id: 'F06'})
ON CREATE SET n:Frame, n += {id: 'F06', nombre: 'Regla', abstracta: false, origen: 'PG1', localizador: 'PG1 F06'};

MERGE (n:AuditIA_PG2 {id: 'F07'})
ON CREATE SET n:Frame, n += {id: 'F07', nombre: 'Responsable', abstracta: false, origen: 'PG1', localizador: 'PG1 F07'};

MERGE (n:AuditIA_PG2 {id: 'F08'})
ON CREATE SET n:Frame, n += {id: 'F08', nombre: 'RevisionHumana', abstracta: false, origen: 'PG1', localizador: 'PG1 F08'};

MERGE (n:AuditIA_PG2 {id: 'F09'})
ON CREATE SET n:Frame, n += {id: 'F09', nombre: 'Evaluacion', abstracta: true, origen: 'PG1', localizador: 'PG1 F09'};

MERGE (n:AuditIA_PG2 {id: 'F10'})
ON CREATE SET n:Frame, n += {id: 'F10', nombre: 'EvaluacionIndividual', abstracta: false, origen: 'PG1', localizador: 'PG1 F10'};

MERGE (n:AuditIA_PG2 {id: 'F11'})
ON CREATE SET n:Frame, n += {id: 'F11', nombre: 'JuicioCriterio', abstracta: false, origen: 'PG1', localizador: 'PG1 F11'};

MERGE (n:AuditIA_PG2 {id: 'F12'})
ON CREATE SET n:Frame, n += {id: 'F12', nombre: 'CriterioCalidad', abstracta: false, origen: 'PG1', localizador: 'PG1 F12'};

MERGE (n:AuditIA_PG2 {id: 'F13'})
ON CREATE SET n:Frame, n += {id: 'F13', nombre: 'ContextoRequerimiento', abstracta: false, origen: 'PG1', localizador: 'PG1 F13'};

MERGE (n:AuditIA_PG2 {id: 'F14'})
ON CREATE SET n:Frame, n += {id: 'F14', nombre: 'CriterioAceptacion', abstracta: false, origen: 'PG1', localizador: 'PG1 F14'};

MERGE (n:AuditIA_PG2 {id: 'F15'})
ON CREATE SET n:Frame, n += {id: 'F15', nombre: 'EvaluacionCruzada', abstracta: false, origen: 'PG1', localizador: 'PG1 F15'};

MERGE (n:AuditIA_PG2 {id: 'F16'})
ON CREATE SET n:Frame, n += {id: 'F16', nombre: 'Escenario', abstracta: false, origen: 'PG1', localizador: 'PG1 F16'};

MERGE (n:AuditIA_PG2 {id: 'F17'})
ON CREATE SET n:Frame, n += {id: 'F17', nombre: 'Condicion', abstracta: false, origen: 'PG1', localizador: 'PG1 F17'};

MERGE (n:AuditIA_PG2 {id: 'F18'})
ON CREATE SET n:Frame, n += {id: 'F18', nombre: 'ElementoNecesario', abstracta: false, origen: 'PG1', localizador: 'PG1 F18'};

MERGE (n:AuditIA_PG2 {id: 'F19'})
ON CREATE SET n:Frame, n += {id: 'F19', nombre: 'Dependencia', abstracta: false, origen: 'PG1', localizador: 'PG1 F19'};

MERGE (n:AuditIA_PG2 {id: 'F20'})
ON CREATE SET n:Frame, n += {id: 'F20', nombre: 'PerfilSistema', abstracta: false, origen: 'PG1', localizador: 'PG1 F20'};

MERGE (n:AuditIA_PG2 {id: 'F21'})
ON CREATE SET n:Frame, n += {id: 'F21', nombre: 'CategoriaNFR', abstracta: false, origen: 'PG1', localizador: 'PG1 F21'};

MERGE (n:AuditIA_PG2 {id: 'F22'})
ON CREATE SET n:Frame, n += {id: 'F22', nombre: 'ResultadoAnalisis', abstracta: true, origen: 'PG1', localizador: 'PG1 F22'};

MERGE (n:AuditIA_PG2 {id: 'F23'})
ON CREATE SET n:Frame, n += {id: 'F23', nombre: 'Hallazgo', abstracta: false, origen: 'PG1', localizador: 'PG1 F23'};

MERGE (n:AuditIA_PG2 {id: 'F24'})
ON CREATE SET n:Frame, n += {id: 'F24', nombre: 'Pendiente', abstracta: false, origen: 'PG1', localizador: 'PG1 F24'};

MERGE (n:AuditIA_PG2 {id: 'F25'})
ON CREATE SET n:Frame, n += {id: 'F25', nombre: 'IncidenciaEntrada', abstracta: false, origen: 'PG1', localizador: 'PG1 F25'};

MERGE (n:AuditIA_PG2 {id: 'F26'})
ON CREATE SET n:Frame, n += {id: 'F26', nombre: 'Severidad', abstracta: false, origen: 'PG1', localizador: 'PG1 F26'};

MERGE (n:AuditIA_PG2 {id: 'F27'})
ON CREATE SET n:Frame, n += {id: 'F27', nombre: 'Criticidad', abstracta: false, origen: 'PG1', localizador: 'PG1 F27'};

MERGE (n:AuditIA_PG2 {id: 'F28'})
ON CREATE SET n:Frame, n += {id: 'F28', nombre: 'ContextoPrioridad', abstracta: false, origen: 'PG1', localizador: 'PG1 F28'};

MERGE (n:AuditIA_PG2 {id: 'F29'})
ON CREATE SET n:Frame, n += {id: 'F29', nombre: 'DecisionPrioridad', abstracta: false, origen: 'PG1', localizador: 'PG1 F29'};

MERGE (n:AuditIA_PG2 {id: 'F30'})
ON CREATE SET n:Frame, n += {id: 'F30', nombre: 'Pregunta', abstracta: false, origen: 'PG1', localizador: 'PG1 F30'};

MERGE (n:AuditIA_PG2 {id: 'F31'})
ON CREATE SET n:Frame, n += {id: 'F31', nombre: 'Respuesta', abstracta: false, origen: 'PG1', localizador: 'PG1 F31'};

MERGE (n:AuditIA_PG2 {id: 'F32'})
ON CREATE SET n:Frame, n += {id: 'F32', nombre: 'EstadoResolucion', abstracta: false, origen: 'PG1', localizador: 'PG1 F32'};

MERGE (n:AuditIA_PG2 {id: 'F33'})
ON CREATE SET n:Frame, n += {id: 'F33', nombre: 'InformeAuditoria', abstracta: false, origen: 'PG1', localizador: 'PG1 F33'};

MERGE (n:AuditIA_PG2 {id: 'L01'})
ON CREATE SET n:TipoRelacion, n += {id: 'L01', nombre: 'CONTIENE', origen: 'DocumentoVersion', destino: 'Requerimiento', localizador: 'PG1 L01'};

MERGE (n:AuditIA_PG2 {id: 'L02'})
ON CREATE SET n:TipoRelacion, n += {id: 'L02', nombre: 'ACTUALIZA', origen: 'DocumentoVersion', destino: 'DocumentoVersion', localizador: 'PG1 L02'};

MERGE (n:AuditIA_PG2 {id: 'L03'})
ON CREATE SET n:TipoRelacion, n += {id: 'L03', nombre: 'EXPRESA', origen: 'Requerimiento', destino: 'Obligacion', localizador: 'PG1 L03'};

MERGE (n:AuditIA_PG2 {id: 'L04'})
ON CREATE SET n:TipoRelacion, n += {id: 'L04', nombre: 'APLICA_EN', origen: 'Obligacion', destino: 'Escenario', localizador: 'PG1 L04'};

MERGE (n:AuditIA_PG2 {id: 'L05'})
ON CREATE SET n:TipoRelacion, n += {id: 'L05', nombre: 'DELIMITADO_POR', origen: 'Escenario', destino: 'Condicion', localizador: 'PG1 L05'};

MERGE (n:AuditIA_PG2 {id: 'L06'})
ON CREATE SET n:TipoRelacion, n += {id: 'L06', nombre: 'SE_INTERPRETA_CON', origen: 'Requerimiento', destino: 'ContextoRequerimiento', localizador: 'PG1 L06'};

MERGE (n:AuditIA_PG2 {id: 'L07'})
ON CREATE SET n:TipoRelacion, n += {id: 'L07', nombre: 'DECLARA', origen: 'ContextoRequerimiento', destino: 'CriterioAceptacion', localizador: 'PG1 L07'};

MERGE (n:AuditIA_PG2 {id: 'L08'})
ON CREATE SET n:TipoRelacion, n += {id: 'L08', nombre: 'REVISA_DOCUMENTO', origen: 'Evaluacion', destino: 'DocumentoVersion', localizador: 'PG1 L08'};

MERGE (n:AuditIA_PG2 {id: 'L09'})
ON CREATE SET n:TipoRelacion, n += {id: 'L09', nombre: 'EVALUA', origen: 'EvaluacionIndividual', destino: 'Requerimiento', localizador: 'PG1 L09'};

MERGE (n:AuditIA_PG2 {id: 'L10'})
ON CREATE SET n:TipoRelacion, n += {id: 'L10', nombre: 'CONTIENE_JUICIO', origen: 'EvaluacionIndividual', destino: 'JuicioCriterio', localizador: 'PG1 L10'};

MERGE (n:AuditIA_PG2 {id: 'L11'})
ON CREATE SET n:TipoRelacion, n += {id: 'L11', nombre: 'APLICA_CRITERIO', origen: 'JuicioCriterio', destino: 'CriterioCalidad', localizador: 'PG1 L11'};

MERGE (n:AuditIA_PG2 {id: 'L12'})
ON CREATE SET n:TipoRelacion, n += {id: 'L12', nombre: 'COMPARA', origen: 'EvaluacionCruzada', destino: 'Requerimiento', localizador: 'PG1 L12'};

MERGE (n:AuditIA_PG2 {id: 'L13'})
ON CREATE SET n:TipoRelacion, n += {id: 'L13', nombre: 'RASTREA', origen: 'EvaluacionCruzada', destino: 'Dependencia', localizador: 'PG1 L13'};

MERGE (n:AuditIA_PG2 {id: 'L14'})
ON CREATE SET n:TipoRelacion, n += {id: 'L14', nombre: 'TIENE_ORIGEN', origen: 'Dependencia', destino: 'Requerimiento', localizador: 'PG1 L14'};

MERGE (n:AuditIA_PG2 {id: 'L15'})
ON CREATE SET n:TipoRelacion, n += {id: 'L15', nombre: 'REQUIERE', origen: 'Dependencia', destino: 'ElementoNecesario', localizador: 'PG1 L15'};

MERGE (n:AuditIA_PG2 {id: 'L16'})
ON CREATE SET n:TipoRelacion, n += {id: 'L16', nombre: 'RESUELTA_POR', origen: 'Dependencia', destino: 'Requerimiento', localizador: 'PG1 L16'};

MERGE (n:AuditIA_PG2 {id: 'L17'})
ON CREATE SET n:TipoRelacion, n += {id: 'L17', nombre: 'USA_PERFIL', origen: 'EvaluacionCruzada', destino: 'PerfilSistema', localizador: 'PG1 L17'};

MERGE (n:AuditIA_PG2 {id: 'L18'})
ON CREATE SET n:TipoRelacion, n += {id: 'L18', nombre: 'EVALUA_CATEGORIA', origen: 'EvaluacionCruzada', destino: 'CategoriaNFR', localizador: 'PG1 L18'};

MERGE (n:AuditIA_PG2 {id: 'L19'})
ON CREATE SET n:TipoRelacion, n += {id: 'L19', nombre: 'VINCULA_COBERTURA', origen: 'EvaluacionCruzada', destino: 'Requerimiento', localizador: 'PG1 L19'};

MERGE (n:AuditIA_PG2 {id: 'L20'})
ON CREATE SET n:TipoRelacion, n += {id: 'L20', nombre: 'GENERA', origen: 'Evaluacion', destino: 'ResultadoAnalisis', localizador: 'PG1 L20'};

MERGE (n:AuditIA_PG2 {id: 'L21'})
ON CREATE SET n:TipoRelacion, n += {id: 'L21', nombre: 'DERIVA_DE_JUICIO', origen: 'ResultadoAnalisis', destino: 'JuicioCriterio', localizador: 'PG1 L21'};

MERGE (n:AuditIA_PG2 {id: 'L22'})
ON CREATE SET n:TipoRelacion, n += {id: 'L22', nombre: 'AFECTA_REQUERIMIENTO', origen: 'ResultadoAnalisis', destino: 'Requerimiento', localizador: 'PG1 L22'};

MERGE (n:AuditIA_PG2 {id: 'L23'})
ON CREATE SET n:TipoRelacion, n += {id: 'L23', nombre: 'AFECTA_CATEGORIA', origen: 'ResultadoAnalisis', destino: 'CategoriaNFR', localizador: 'PG1 L23'};

MERGE (n:AuditIA_PG2 {id: 'L24'})
ON CREATE SET n:TipoRelacion, n += {id: 'L24', nombre: 'TIENE_SEVERIDAD', origen: 'Hallazgo|Pendiente', destino: 'Severidad', localizador: 'PG1 L24'};

MERGE (n:AuditIA_PG2 {id: 'L25'})
ON CREATE SET n:TipoRelacion, n += {id: 'L25', nombre: 'ES_UN', origen: 'Frame', destino: 'Frame', localizador: 'PG1 L25'};

MERGE (n:AuditIA_PG2 {id: 'L26'})
ON CREATE SET n:TipoRelacion, n += {id: 'L26', nombre: 'REEVALUA', origen: 'Evaluacion', destino: 'Evaluacion', localizador: 'PG1 L26'};

MERGE (n:AuditIA_PG2 {id: 'L27'})
ON CREATE SET n:TipoRelacion, n += {id: 'L27', nombre: 'CONSIDERA_RESPUESTA', origen: 'Evaluacion', destino: 'Respuesta', localizador: 'PG1 L27'};

MERGE (n:AuditIA_PG2 {id: 'L28'})
ON CREATE SET n:TipoRelacion, n += {id: 'L28', nombre: 'CUESTIONA', origen: 'IncidenciaEntrada', destino: 'ResultadoAnalisis', localizador: 'PG1 L28'};

MERGE (n:AuditIA_PG2 {id: 'L29'})
ON CREATE SET n:TipoRelacion, n += {id: 'L29', nombre: 'EXIGE', origen: 'PerfilSistema', destino: 'CategoriaNFR', localizador: 'PG1 L29'};

MERGE (n:AuditIA_PG2 {id: 'L30'})
ON CREATE SET n:TipoRelacion, n += {id: 'L30', nombre: 'CUBRE', origen: 'Requerimiento', destino: 'CategoriaNFR', localizador: 'PG1 L30'};

MERGE (n:AuditIA_PG2 {id: 'L31'})
ON CREATE SET n:TipoRelacion, n += {id: 'L31', nombre: 'CONTRADICE', origen: 'Requerimiento', destino: 'Requerimiento', localizador: 'PG1 L31'};

MERGE (n:AuditIA_PG2 {id: 'L32'})
ON CREATE SET n:TipoRelacion, n += {id: 'L32', nombre: 'DEPENDE_DE', origen: 'Requerimiento', destino: 'ElementoNecesario', localizador: 'PG1 L32'};

MERGE (n:AuditIA_PG2 {id: 'L33'})
ON CREATE SET n:TipoRelacion, n += {id: 'L33', nombre: 'TIENE_CRITICIDAD', origen: 'Requerimiento', destino: 'Criticidad', localizador: 'PG1 L33'};

MERGE (n:AuditIA_PG2 {id: 'L34'})
ON CREATE SET n:TipoRelacion, n += {id: 'L34', nombre: 'PRIORIZA', origen: 'DecisionPrioridad', destino: 'ResultadoAnalisis', localizador: 'PG1 L34'};

MERGE (n:AuditIA_PG2 {id: 'L35'})
ON CREATE SET n:TipoRelacion, n += {id: 'L35', nombre: 'USA_CONTEXTO', origen: 'DecisionPrioridad', destino: 'ContextoPrioridad', localizador: 'PG1 L35'};

MERGE (n:AuditIA_PG2 {id: 'L36'})
ON CREATE SET n:TipoRelacion, n += {id: 'L36', nombre: 'SUSTITUYE_A', origen: 'DecisionPrioridad', destino: 'DecisionPrioridad', localizador: 'PG1 L36'};

MERGE (n:AuditIA_PG2 {id: 'L37'})
ON CREATE SET n:TipoRelacion, n += {id: 'L37', nombre: 'SE_BASA_EN_REEVALUACION', origen: 'DecisionPrioridad', destino: 'Evaluacion', localizador: 'PG1 L37'};

MERGE (n:AuditIA_PG2 {id: 'L38'})
ON CREATE SET n:TipoRelacion, n += {id: 'L38', nombre: 'TIENE_ESTADO', origen: 'DecisionPrioridad', destino: 'EstadoResolucion', localizador: 'PG1 L38'};

MERGE (n:AuditIA_PG2 {id: 'L39'})
ON CREATE SET n:TipoRelacion, n += {id: 'L39', nombre: 'ACLARA', origen: 'Pregunta', destino: 'ResultadoAnalisis', localizador: 'PG1 L39'};

MERGE (n:AuditIA_PG2 {id: 'L40'})
ON CREATE SET n:TipoRelacion, n += {id: 'L40', nombre: 'SE_ORIGINA_EN', origen: 'Pregunta', destino: 'DecisionPrioridad', localizador: 'PG1 L40'};

MERGE (n:AuditIA_PG2 {id: 'L41'})
ON CREATE SET n:TipoRelacion, n += {id: 'L41', nombre: 'SE_DIRIGE_A', origen: 'Pregunta', destino: 'Responsable', localizador: 'PG1 L41'};

MERGE (n:AuditIA_PG2 {id: 'L42'})
ON CREATE SET n:TipoRelacion, n += {id: 'L42', nombre: 'RESPONDE_A', origen: 'Respuesta', destino: 'Pregunta', localizador: 'PG1 L42'};

MERGE (n:AuditIA_PG2 {id: 'L43'})
ON CREATE SET n:TipoRelacion, n += {id: 'L43', nombre: 'APORTADA_POR', origen: 'Respuesta', destino: 'Responsable', localizador: 'PG1 L43'};

MERGE (n:AuditIA_PG2 {id: 'L44'})
ON CREATE SET n:TipoRelacion, n += {id: 'L44', nombre: 'REVISA', origen: 'RevisionHumana', destino: 'EntidadRevisable', localizador: 'PG1 L44'};

MERGE (n:AuditIA_PG2 {id: 'L45'})
ON CREATE SET n:TipoRelacion, n += {id: 'L45', nombre: 'REALIZADA_POR', origen: 'RevisionHumana', destino: 'Responsable', localizador: 'PG1 L45'};

MERGE (n:AuditIA_PG2 {id: 'L46'})
ON CREATE SET n:TipoRelacion, n += {id: 'L46', nombre: 'SE_SUSTENTA_EN', origen: 'EntidadConSustento', destino: 'Evidencia', localizador: 'PG1 L46'};

MERGE (n:AuditIA_PG2 {id: 'L47'})
ON CREATE SET n:TipoRelacion, n += {id: 'L47', nombre: 'APLICA_REGLA', origen: 'EntidadConReglas', destino: 'Regla', localizador: 'PG1 L47'};

MERGE (n:AuditIA_PG2 {id: 'L48'})
ON CREATE SET n:TipoRelacion, n += {id: 'L48', nombre: 'CITA_FUENTE', origen: 'Evidencia|DocumentoVersion', destino: 'Fuente', localizador: 'PG1 L48'};

MERGE (n:AuditIA_PG2 {id: 'L49'})
ON CREATE SET n:TipoRelacion, n += {id: 'L49', nombre: 'SE_FUNDAMENTA_EN', origen: 'Regla|CriterioCalidad', destino: 'Fuente', localizador: 'PG1 L49'};

MERGE (n:AuditIA_PG2 {id: 'L50'})
ON CREATE SET n:TipoRelacion, n += {id: 'L50', nombre: 'CONSOLIDA', origen: 'InformeAuditoria', destino: 'DocumentoVersion', localizador: 'PG1 L50'};

MERGE (n:AuditIA_PG2 {id: 'L51'})
ON CREATE SET n:TipoRelacion, n += {id: 'L51', nombre: 'INCLUYE', origen: 'InformeAuditoria', destino: 'DecisionPrioridad', localizador: 'PG1 L51'};

MERGE (n:AuditIA_PG2 {id: 'GL01'})
ON CREATE SET n:Regla, n += {id: 'GL01', estado_validacion: 'candidata', modulo: 'global', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'GL02'})
ON CREATE SET n:Regla, n += {id: 'GL02', estado_validacion: 'candidata', modulo: 'global', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'GL03'})
ON CREATE SET n:Regla, n += {id: 'GL03', estado_validacion: 'candidata', modulo: 'global', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'GL04'})
ON CREATE SET n:Regla, n += {id: 'GL04', estado_validacion: 'candidata', modulo: 'global', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'GL05'})
ON CREATE SET n:Regla, n += {id: 'GL05', estado_validacion: 'candidata', modulo: 'global', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'GL06'})
ON CREATE SET n:Regla, n += {id: 'GL06', estado_validacion: 'candidata', modulo: 'global', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'GL07'})
ON CREATE SET n:Regla, n += {id: 'GL07', estado_validacion: 'candidata', modulo: 'global', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'GL08'})
ON CREATE SET n:Regla, n += {id: 'GL08', estado_validacion: 'candidata', modulo: 'global', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'GL09'})
ON CREATE SET n:Regla, n += {id: 'GL09', estado_validacion: 'candidata', modulo: 'global', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-RD03'})
ON CREATE SET n:Regla, n += {id: 'EVI-RD03', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-RD04'})
ON CREATE SET n:Regla, n += {id: 'EVI-RD04', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-RD05'})
ON CREATE SET n:Regla, n += {id: 'EVI-RD05', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-RD06'})
ON CREATE SET n:Regla, n += {id: 'EVI-RD06', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-HC01'})
ON CREATE SET n:Regla, n += {id: 'EVI-HC01', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-HC02'})
ON CREATE SET n:Regla, n += {id: 'EVI-HC02', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-HC03'})
ON CREATE SET n:Regla, n += {id: 'EVI-HC03', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-HC04'})
ON CREATE SET n:Regla, n += {id: 'EVI-HC04', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-HC05'})
ON CREATE SET n:Regla, n += {id: 'EVI-HC05', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-HC06'})
ON CREATE SET n:Regla, n += {id: 'EVI-HC06', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-HC07'})
ON CREATE SET n:Regla, n += {id: 'EVI-HC07', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-HC08'})
ON CREATE SET n:Regla, n += {id: 'EVI-HC08', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-HC09'})
ON CREATE SET n:Regla, n += {id: 'EVI-HC09', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-HC10'})
ON CREATE SET n:Regla, n += {id: 'EVI-HC10', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'EVI-HC11'})
ON CREATE SET n:Regla, n += {id: 'EVI-HC11', estado_validacion: 'candidata', modulo: 'evaluacion_individual', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD03'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD03', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD04'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD04', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD05'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD05', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD06'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD06', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD07'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD07', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD08'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD08', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD09'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD09', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD10'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD10', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD11'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD11', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD12'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD12', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD13'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD13', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD14'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD14', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD15'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD15', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD16'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD16', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD18'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD18', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-RD19'})
ON CREATE SET n:Regla, n += {id: 'ACC-RD19', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-HC01'})
ON CREATE SET n:Regla, n += {id: 'ACC-HC01', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-HC02'})
ON CREATE SET n:Regla, n += {id: 'ACC-HC02', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-HC03'})
ON CREATE SET n:Regla, n += {id: 'ACC-HC03', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'ACC-HC04'})
ON CREATE SET n:Regla, n += {id: 'ACC-HC04', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'CAT-EX-SEG'})
ON CREATE SET n:Regla, n += {id: 'CAT-EX-SEG', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'CAT-EX-PARC'})
ON CREATE SET n:Regla, n += {id: 'CAT-EX-PARC', estado_validacion: 'candidata', modulo: 'analisis_cruzado', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-RD01'})
ON CREATE SET n:Regla, n += {id: 'PRC-RD01', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-RD02'})
ON CREATE SET n:Regla, n += {id: 'PRC-RD02', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-RD03'})
ON CREATE SET n:Regla, n += {id: 'PRC-RD03', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-RD04'})
ON CREATE SET n:Regla, n += {id: 'PRC-RD04', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-RD06'})
ON CREATE SET n:Regla, n += {id: 'PRC-RD06', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-RD07'})
ON CREATE SET n:Regla, n += {id: 'PRC-RD07', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-RD08'})
ON CREATE SET n:Regla, n += {id: 'PRC-RD08', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-RD09'})
ON CREATE SET n:Regla, n += {id: 'PRC-RD09', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-RD10'})
ON CREATE SET n:Regla, n += {id: 'PRC-RD10', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-RD11'})
ON CREATE SET n:Regla, n += {id: 'PRC-RD11', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-RD12'})
ON CREATE SET n:Regla, n += {id: 'PRC-RD12', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-RD13'})
ON CREATE SET n:Regla, n += {id: 'PRC-RD13', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-HC01'})
ON CREATE SET n:Regla, n += {id: 'PRC-HC01', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-HC02'})
ON CREATE SET n:Regla, n += {id: 'PRC-HC02', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-HC03'})
ON CREATE SET n:Regla, n += {id: 'PRC-HC03', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-HC04'})
ON CREATE SET n:Regla, n += {id: 'PRC-HC04', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-HC05'})
ON CREATE SET n:Regla, n += {id: 'PRC-HC05', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'implementada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-HC06'})
ON CREATE SET n:Regla, n += {id: 'PRC-HC06', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-HC07'})
ON CREATE SET n:Regla, n += {id: 'PRC-HC07', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'PRC-HC08'})
ON CREATE SET n:Regla, n += {id: 'PRC-HC08', estado_validacion: 'candidata', modulo: 'priorizacion_clarificacion', ejecucion: 'catalogada', version: 'PG1-1.0', localizador: 'PG1 sección 6'};

MERGE (n:AuditIA_PG2 {id: 'S-PG1'})
ON CREATE SET n:Fuente, n += {id: 'S-PG1', nombre: 'Grupo_10_PG1_U1.pdf', tipo: 'documento', validez: 'Alcance académico; sin validación experta adquirida', contacto: 'Grupo_10_PG1_U1.pdf', estado: 'consultada'};

MERGE (n:AuditIA_PG2 {id: 'S-PG2'})
ON CREATE SET n:Fuente, n += {id: 'S-PG2', nombre: 'Actividad PG2 (Grupal).pdf', tipo: 'consigna', validez: 'Alcance académico; sin validación experta adquirida', contacto: 'Actividad PG2 (Grupal).pdf', estado: 'consultada'};

MERGE (n:AuditIA_PG2 {id: 'S-CASOS'})
ON CREATE SET n:Fuente, n += {id: 'S-CASOS', nombre: 'Casos construidos del Grupo 10', tipo: 'ejemplo', validez: 'Alcance académico; sin validación experta adquirida', contacto: 'Casos construidos del Grupo 10', estado: 'consultada'};

MERGE (n:AuditIA_PG2 {id: 'S-DEV'})
ON CREATE SET n:Fuente, n += {id: 'S-DEV', nombre: 'Devolución docente de PG1', tipo: 'devolucion', validez: 'Alcance académico; sin validación experta adquirida', contacto: 'Devolución docente de PG1', estado: 'consultada'};

MERGE (n:AuditIA_PG2 {id: 'RESP-NEG'})
ON CREATE SET n:Responsable, n += {id: 'RESP-NEG', rol: 'referente_negocio', confirmado: true, nombre: 'Rol de negocio del caso construido'};

MERGE (n:AuditIA_PG2 {id: 'RESP-AN'})
ON CREATE SET n:Responsable, n += {id: 'RESP-AN', rol: 'analista_funcional', confirmado: true, nombre: 'Rol revisor del caso construido'};

MERGE (n:AuditIA_PG2 {id: 'CQ-atomicidad'})
ON CREATE SET n:CriterioCalidad, n += {id: 'CQ-atomicidad', nombre: 'atomicidad'};

MERGE (n:AuditIA_PG2 {id: 'CQ-ambiguedad'})
ON CREATE SET n:CriterioCalidad, n += {id: 'CQ-ambiguedad', nombre: 'ambiguedad'};

MERGE (n:AuditIA_PG2 {id: 'CQ-verificabilidad'})
ON CREATE SET n:CriterioCalidad, n += {id: 'CQ-verificabilidad', nombre: 'verificabilidad'};

MERGE (n:AuditIA_PG2 {id: 'CQ-completitud'})
ON CREATE SET n:CriterioCalidad, n += {id: 'CQ-completitud', nombre: 'completitud'};

MERGE (n:AuditIA_PG2 {id: 'DOC-CAT-v1'})
ON CREATE SET n:DocumentoVersion, n += {id: 'DOC-CAT-v1', documento_id: 'DOC-CAT', version: '1', titulo: 'Especificación académica DOC-CAT-v1', fecha: '2026-10-31T21:00:00-03:00', materiales_disponibles: ['Documento principal'], referencias_no_disponibles: []};

MERGE (n:AuditIA_PG2 {id: 'RQ-CAT-v1'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-CAT-v1', id_logico: 'RQ-CAT', texto_original: 'El sistema debe cargar rápidamente el catálogo.', tipo: 'funcional', localizador: 'RQ-CAT-v1', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-CAT-v1'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-CAT-v1', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-CAT-v1'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-CAT-v1', tipo: 'fragmento', contenido: 'El sistema debe cargar rápidamente el catálogo.', localizador: 'RQ-CAT-v1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-CAT-v1'};

MERGE (n:AuditIA_PG2 {id: 'EV-CAT-01'})
ON CREATE SET n:Evaluacion:EvaluacionIndividual, n += {id: 'EV-CAT-01', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', modulo_origen: 'evaluacion_individual'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-CAT-01'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-CAT-01', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-CAT-01', localizador: 'EV-CAT-01', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'J-EV-CAT-01-atomicidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-CAT-01-atomicidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Una obligación evaluable con unidad de aceptación confirmada.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, obligaciones_independientes: 1, unidad_aceptacion_confirmada: true};

MERGE (n:AuditIA_PG2 {id: 'J-EV-CAT-01-ambiguedad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-CAT-01-ambiguedad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Persisten dos lecturas: aprobación por percepción de rapidez o por un límite medido; falta delimitación del caso.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, lecturas_residuales: 2, delimitacion_confirmada: false, divergencia_lecturas: 8.5, delimitacion_contexto: 1, valoracion_confirmada: true, alcance_valoracion_revisado: true, severidad_propuesta: 'media', puntuacion_severidad_propuesta: 5.0};

MERGE (n:AuditIA_PG2 {id: 'J-EV-CAT-01-verificabilidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-CAT-01-verificabilidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'La aceptación necesaria no fue recibida; no se puede fijar una condición de aprobación.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, aceptacion_necesaria: true, aceptacion_disponible: false, comprobacion_definida: false};

MERGE (n:AuditIA_PG2 {id: 'J-EV-CAT-01-completitud'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-CAT-01-completitud', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'No se recibió la información necesaria para determinar las partes aplicables.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: false, contexto_suficiente: true, informacion_aplicable_identificada: false, omisiones_demostradas: null};

MERGE (n:AuditIA_PG2 {id: 'DOC-CAT-v2'})
ON CREATE SET n:DocumentoVersion, n += {id: 'DOC-CAT-v2', documento_id: 'DOC-CAT', version: '2', titulo: 'Especificación académica DOC-CAT-v2', fecha: '2026-10-31T21:02:00-03:00', materiales_disponibles: ['Documento principal'], referencias_no_disponibles: []};

MERGE (n:AuditIA_PG2 {id: 'RQ-CAT-v2'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-CAT-v2', id_logico: 'RQ-CAT', texto_original: 'El sistema debe cargar el catálogo de 100 productos con lista interactiva en menos de 2 segundos en el entorno de prueba acordado.', tipo: 'funcional', localizador: 'RQ-CAT-v2', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-CAT-v2'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-CAT-v2', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-CAT-v2'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-CAT-v2', tipo: 'fragmento', contenido: 'El sistema debe cargar el catálogo de 100 productos con lista interactiva en menos de 2 segundos en el entorno de prueba acordado.', localizador: 'RQ-CAT-v2', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:02:00-03:00', documento_version: 'DOC-CAT-v2'};

MERGE (n:AuditIA_PG2 {id: 'EV-CAT-02'})
ON CREATE SET n:Evaluacion:EvaluacionIndividual, n += {id: 'EV-CAT-02', fecha: '2026-10-31T21:02:30-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', modulo_origen: 'evaluacion_individual'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-CAT-02'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-CAT-02', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-CAT-02', localizador: 'EV-CAT-02', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:02:30-03:00'};

MERGE (n:AuditIA_PG2 {id: 'J-EV-CAT-02-atomicidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-CAT-02-atomicidad', fecha: '2026-10-31T21:02:30-03:00', justificacion: 'Una obligación evaluable con unidad de aceptación confirmada.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, obligaciones_independientes: 1, unidad_aceptacion_confirmada: true};

MERGE (n:AuditIA_PG2 {id: 'J-EV-CAT-02-ambiguedad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-CAT-02-ambiguedad', fecha: '2026-10-31T21:02:30-03:00', justificacion: 'La aceptación disponible delimita una sola lectura relevante.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, lecturas_residuales: 1, delimitacion_confirmada: true, divergencia_lecturas: 8.5, delimitacion_contexto: 9.5, valoracion_confirmada: true, alcance_valoracion_revisado: true};

MERGE (n:AuditIA_PG2 {id: 'J-EV-CAT-02-verificabilidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-CAT-02-verificabilidad', fecha: '2026-10-31T21:02:30-03:00', justificacion: 'Hay un método finito y una condición observable de aprobación.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, aceptacion_necesaria: true, aceptacion_disponible: true, comprobacion_definida: true};

MERGE (n:AuditIA_PG2 {id: 'J-EV-CAT-02-completitud'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-CAT-02-completitud', fecha: '2026-10-31T21:02:30-03:00', justificacion: 'Las partes aplicables se identificaron y no se demostraron omisiones en ese alcance.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, informacion_aplicable_identificada: true, omisiones_demostradas: 0};

MERGE (n:AuditIA_PG2 {id: 'CA-CAT-02'})
ON CREATE SET n:CriterioAceptacion, n += {id: 'CA-CAT-02', metodo: 'Medir carga en entorno controlado', condicion_aprobacion: '100 productos con lista interactiva en menos de 2 segundos', entorno_prueba: 'Caso académico del grupo'};

MERGE (n:AuditIA_PG2 {id: 'DOC-DESC-v1'})
ON CREATE SET n:DocumentoVersion, n += {id: 'DOC-DESC-v1', documento_id: 'DOC-DESC', version: '1', titulo: 'Especificación académica DOC-DESC-v1', fecha: '2026-10-31T21:00:00-03:00', materiales_disponibles: ['Documento principal'], referencias_no_disponibles: []};

MERGE (n:AuditIA_PG2 {id: 'RQ-DESC-A-v1'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-DESC-A-v1', id_logico: 'RQ-DESC-A', texto_original: 'En una venta de categoría A se debe aplicar el descuento del 10 %.', tipo: 'funcional', localizador: 'RQ-DESC-A-v1', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-DESC-A-v1'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-DESC-A-v1', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-DESC-A-v1'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-DESC-A-v1', tipo: 'fragmento', contenido: 'En una venta de categoría A se debe aplicar el descuento del 10 %.', localizador: 'RQ-DESC-A-v1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-DESC-v1'};

MERGE (n:AuditIA_PG2 {id: 'O-RQ-DESC-A-v1'})
ON CREATE SET n:Obligacion, n += {id: 'O-RQ-DESC-A-v1', sujeto: 'Sistema de ventas', accion: 'calcular', objeto: 'precio final', resultado: 'precio final con 10 % de descuento', modalidad: 'obligacion', aceptable_por_separado: true};

MERGE (n:AuditIA_PG2 {id: 'ESC-RQ-DESC-A-v1'})
ON CREATE SET n:Escenario, n += {id: 'ESC-RQ-DESC-A-v1', actor: 'Sistema de ventas', objeto: 'misma venta A', estado: 'confirmación'};

MERGE (n:AuditIA_PG2 {id: 'COND-RQ-DESC-A-v1'})
ON CREATE SET n:Condicion, n += {id: 'COND-RQ-DESC-A-v1', descripcion: 'categoría A y misma venta'};

MERGE (n:AuditIA_PG2 {id: 'RQ-DESC-B-v1'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-DESC-B-v1', id_logico: 'RQ-DESC-B', texto_original: 'En la misma venta de categoría A no se debe aplicar ningún descuento.', tipo: 'funcional', localizador: 'RQ-DESC-B-v1', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-DESC-B-v1'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-DESC-B-v1', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-DESC-B-v1'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-DESC-B-v1', tipo: 'fragmento', contenido: 'En la misma venta de categoría A no se debe aplicar ningún descuento.', localizador: 'RQ-DESC-B-v1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-DESC-v1'};

MERGE (n:AuditIA_PG2 {id: 'O-RQ-DESC-B-v1'})
ON CREATE SET n:Obligacion, n += {id: 'O-RQ-DESC-B-v1', sujeto: 'Sistema de ventas', accion: 'calcular', objeto: 'precio final', resultado: 'precio final sin descuento', modalidad: 'obligacion', aceptable_por_separado: true};

MERGE (n:AuditIA_PG2 {id: 'ESC-RQ-DESC-B-v1'})
ON CREATE SET n:Escenario, n += {id: 'ESC-RQ-DESC-B-v1', actor: 'Sistema de ventas', objeto: 'misma venta A', estado: 'confirmación'};

MERGE (n:AuditIA_PG2 {id: 'COND-RQ-DESC-B-v1'})
ON CREATE SET n:Condicion, n += {id: 'COND-RQ-DESC-B-v1', descripcion: 'categoría A y misma venta'};

MERGE (n:AuditIA_PG2 {id: 'EV-DESC'})
ON CREATE SET n:Evaluacion:EvaluacionCruzada, n += {id: 'EV-DESC', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', tipo_analisis: 'comparacion', modulo_origen: 'analisis_cruzado', datos_controlados: true, dato_necesario_faltante: false, escenarios: 'coincidentes', resultados_incompatibles: true, excepcion_resuelve: false, interpretacion_cerrada: true, validacion_operativa: 'candidata', solapamiento_escenario: 9.5, incompatibilidad_resultados: 9.5, valoracion_confirmada: true, severidad_propuesta: 'alta', puntuacion_severidad_propuesta: 9.0};

MERGE (n:AuditIA_PG2 {id: 'E-EV-DESC'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-DESC', tipo: 'analisis', contenido: 'RQ-DESC-A-v1 exige 10 % de descuento y RQ-DESC-B-v1 exige ningún descuento en la misma venta A. Se cotejaron sujeto, objeto y momento de confirmación. Los precios finales son incompatibles y no se declaró una excepción conciliadora. Interpretación cerrada para el caso construido.', localizador: 'EV-DESC', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'EV-DESC-CONTROL'})
ON CREATE SET n:Evaluacion:EvaluacionCruzada, n += {id: 'EV-DESC-CONTROL', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', tipo_analisis: 'comparacion', modulo_origen: 'analisis_cruzado', datos_controlados: true, dato_necesario_faltante: false, escenarios: 'excluyentes', resultados_incompatibles: true, excepcion_resuelve: false, interpretacion_cerrada: true, validacion_operativa: 'candidata', solapamiento_escenario: 1.0, incompatibilidad_resultados: 6.0, valoracion_confirmada: true};

MERGE (n:AuditIA_PG2 {id: 'E-EV-DESC-CONTROL'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-DESC-CONTROL', tipo: 'analisis', contenido: 'Control del par: las obligaciones se ubican en momentos excluyentes del escenario construido. La diferencia textual no demuestra contradicción simultánea.', localizador: 'EV-DESC-CONTROL', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'DOC-TASA-v1'})
ON CREATE SET n:DocumentoVersion, n += {id: 'DOC-TASA-v1', documento_id: 'DOC-TASA', version: '1', titulo: 'Especificación académica DOC-TASA-v1', fecha: '2026-10-31T21:00:00-03:00', materiales_disponibles: ['Documento principal'], referencias_no_disponibles: ['Anexo B']};

MERGE (n:AuditIA_PG2 {id: 'RQ-TASA-v1'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-TASA-v1', id_logico: 'RQ-TASA', texto_original: 'El sistema calcula el interés con la tasa del Anexo B.', tipo: 'funcional', localizador: 'RQ-TASA-v1', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-TASA-v1'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-TASA-v1', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-TASA-v1'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-TASA-v1', tipo: 'fragmento', contenido: 'El sistema calcula el interés con la tasa del Anexo B.', localizador: 'RQ-TASA-v1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-TASA-v1'};

MERGE (n:AuditIA_PG2 {id: 'EN-TASA-v1'})
ON CREATE SET n:ElementoNecesario, n += {id: 'EN-TASA-v1', concepto: 'tasa aplicable', referencia: 'Anexo B'};

MERGE (n:AuditIA_PG2 {id: 'DEP-TASA-v1'})
ON CREATE SET n:Dependencia, n += {id: 'DEP-TASA-v1', estado: 'en_revision'};

MERGE (n:AuditIA_PG2 {id: 'EV-TASA-1'})
ON CREATE SET n:Evaluacion:EvaluacionCruzada, n += {id: 'EV-TASA-1', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', tipo_analisis: 'dependencia', modulo_origen: 'analisis_cruzado', necesidad_confirmada: true, referencia_necesaria_disponible: false, busqueda_completa: false, cotejo_definicion: 'no_disponible', validacion_definicion: false, datos_controlados: true, dato_necesario_faltante: true, validacion_operativa: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-TASA-1'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-TASA-1', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-TASA-1', localizador: 'EV-TASA-1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'DOC-TASA-v2'})
ON CREATE SET n:DocumentoVersion, n += {id: 'DOC-TASA-v2', documento_id: 'DOC-TASA', version: '2', titulo: 'Especificación académica DOC-TASA-v2', fecha: '2026-10-31T21:00:00-03:00', materiales_disponibles: ['Documento principal'], referencias_no_disponibles: []};

MERGE (n:AuditIA_PG2 {id: 'RQ-TASA-v2'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-TASA-v2', id_logico: 'RQ-TASA', texto_original: 'El sistema calcula el interés con la tasa del Anexo B.', tipo: 'funcional', localizador: 'RQ-TASA-v2', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-TASA-v2'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-TASA-v2', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-TASA-v2'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-TASA-v2', tipo: 'fragmento', contenido: 'El sistema calcula el interés con la tasa del Anexo B.', localizador: 'RQ-TASA-v2', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-TASA-v2'};

MERGE (n:AuditIA_PG2 {id: 'EN-TASA-v2'})
ON CREATE SET n:ElementoNecesario, n += {id: 'EN-TASA-v2', concepto: 'tasa aplicable', referencia: 'Anexo B'};

MERGE (n:AuditIA_PG2 {id: 'DEP-TASA-v2'})
ON CREATE SET n:Dependencia, n += {id: 'DEP-TASA-v2', estado: 'en_revision'};

MERGE (n:AuditIA_PG2 {id: 'EV-TASA-2'})
ON CREATE SET n:Evaluacion:EvaluacionCruzada, n += {id: 'EV-TASA-2', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', tipo_analisis: 'dependencia', modulo_origen: 'analisis_cruzado', necesidad_confirmada: true, referencia_necesaria_disponible: true, busqueda_completa: true, cotejo_definicion: 'pertinente', validacion_definicion: true, datos_controlados: true, dato_necesario_faltante: false, validacion_operativa: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-TASA-2'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-TASA-2', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-TASA-2', localizador: 'EV-TASA-2', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'RQ-DEF-TASA-v2'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-DEF-TASA-v2', id_logico: 'RQ-DEF-TASA', texto_original: 'La tasa mensual aplicable es del 2 % en el escenario acordado del caso.', tipo: 'funcional', localizador: 'RQ-DEF-TASA-v2', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-DEF-TASA-v2'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-DEF-TASA-v2', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-DEF-TASA-v2'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-DEF-TASA-v2', tipo: 'fragmento', contenido: 'La tasa mensual aplicable es del 2 % en el escenario acordado del caso.', localizador: 'RQ-DEF-TASA-v2', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-TASA-v2'};

MERGE (n:AuditIA_PG2 {id: 'NFR-SEG'})
ON CREATE SET n:CategoriaNFR, n += {id: 'NFR-SEG', nombre: 'Seguridad', necesidades: ['protección de datos sensibles']};

MERGE (n:AuditIA_PG2 {id: 'DOC-SEG-BRECHA-v1'})
ON CREATE SET n:DocumentoVersion, n += {id: 'DOC-SEG-BRECHA-v1', documento_id: 'DOC-SEG-BRECHA', version: '1', titulo: 'Especificación académica DOC-SEG-BRECHA-v1', fecha: '2026-10-31T21:00:00-03:00', materiales_disponibles: ['Documento principal'], referencias_no_disponibles: []};

MERGE (n:AuditIA_PG2 {id: 'RQ-SEG-BRECHA-v1'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-SEG-BRECHA-v1', id_logico: 'RQ-SEG-BRECHA', texto_original: 'El sistema debe listar los productos.', tipo: 'funcional', localizador: 'RQ-SEG-BRECHA-v1', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-SEG-BRECHA-v1'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-SEG-BRECHA-v1', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-SEG-BRECHA-v1'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-SEG-BRECHA-v1', tipo: 'fragmento', contenido: 'El sistema debe listar los productos.', localizador: 'RQ-SEG-BRECHA-v1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-SEG-BRECHA-v1'};

MERGE (n:AuditIA_PG2 {id: 'PERFIL-BRECHA'})
ON CREATE SET n:PerfilSistema, n += {id: 'PERFIL-BRECHA', datos_sensibles: true, confirmado: true, operaciones_esenciales: ['acceso a datos']};

MERGE (n:AuditIA_PG2 {id: 'E-PERFIL-BRECHA'})
ON CREATE SET n:Evidencia, n += {id: 'E-PERFIL-BRECHA', tipo: 'declaracion', contenido: 'Perfil construido; datos sensibles True', localizador: 'PERFIL-BRECHA', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'EV-SEG-BRECHA'})
ON CREATE SET n:Evaluacion:EvaluacionCruzada, n += {id: 'EV-SEG-BRECHA', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', tipo_analisis: 'cobertura', modulo_origen: 'analisis_cruzado', datos_controlados: true, condicion_catalogo: true, busqueda_completa: true, mapa_cobertura_validado: true, cobertura: 'ninguna', necesidades: ['protección de datos sensibles'], partes_cubiertas: [], validacion_operativa: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-SEG-BRECHA'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-SEG-BRECHA', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-SEG-BRECHA', localizador: 'EV-SEG-BRECHA', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'DOC-SEG-OK-v1'})
ON CREATE SET n:DocumentoVersion, n += {id: 'DOC-SEG-OK-v1', documento_id: 'DOC-SEG-OK', version: '1', titulo: 'Especificación académica DOC-SEG-OK-v1', fecha: '2026-10-31T21:00:00-03:00', materiales_disponibles: ['Documento principal'], referencias_no_disponibles: []};

MERGE (n:AuditIA_PG2 {id: 'RQ-SEG-OK-v1'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-SEG-OK-v1', id_logico: 'RQ-SEG-OK', texto_original: 'El sistema debe registrar cada acceso autorizado a los datos sensibles.', tipo: 'funcional', localizador: 'RQ-SEG-OK-v1', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-SEG-OK-v1'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-SEG-OK-v1', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-SEG-OK-v1'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-SEG-OK-v1', tipo: 'fragmento', contenido: 'El sistema debe registrar cada acceso autorizado a los datos sensibles.', localizador: 'RQ-SEG-OK-v1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-SEG-OK-v1'};

MERGE (n:AuditIA_PG2 {id: 'PERFIL-OK'})
ON CREATE SET n:PerfilSistema, n += {id: 'PERFIL-OK', datos_sensibles: true, confirmado: true, operaciones_esenciales: ['acceso a datos']};

MERGE (n:AuditIA_PG2 {id: 'E-PERFIL-OK'})
ON CREATE SET n:Evidencia, n += {id: 'E-PERFIL-OK', tipo: 'declaracion', contenido: 'Perfil construido; datos sensibles True', localizador: 'PERFIL-OK', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'EV-SEG-OK'})
ON CREATE SET n:Evaluacion:EvaluacionCruzada, n += {id: 'EV-SEG-OK', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', tipo_analisis: 'cobertura', modulo_origen: 'analisis_cruzado', datos_controlados: true, condicion_catalogo: true, busqueda_completa: true, mapa_cobertura_validado: true, cobertura: 'completa', necesidades: ['protección de datos sensibles'], partes_cubiertas: ['protección de datos sensibles'], validacion_operativa: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-SEG-OK'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-SEG-OK', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-SEG-OK', localizador: 'EV-SEG-OK', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'DOC-SEG-DESCONOCIDO-v1'})
ON CREATE SET n:DocumentoVersion, n += {id: 'DOC-SEG-DESCONOCIDO-v1', documento_id: 'DOC-SEG-DESCONOCIDO', version: '1', titulo: 'Especificación académica DOC-SEG-DESCONOCIDO-v1', fecha: '2026-10-31T21:00:00-03:00', materiales_disponibles: ['Documento principal'], referencias_no_disponibles: []};

MERGE (n:AuditIA_PG2 {id: 'RQ-SEG-DESCONOCIDO-v1'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-SEG-DESCONOCIDO-v1', id_logico: 'RQ-SEG-DESCONOCIDO', texto_original: 'El sistema debe listar los productos.', tipo: 'funcional', localizador: 'RQ-SEG-DESCONOCIDO-v1', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-SEG-DESCONOCIDO-v1'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-SEG-DESCONOCIDO-v1', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-SEG-DESCONOCIDO-v1'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-SEG-DESCONOCIDO-v1', tipo: 'fragmento', contenido: 'El sistema debe listar los productos.', localizador: 'RQ-SEG-DESCONOCIDO-v1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-SEG-DESCONOCIDO-v1'};

MERGE (n:AuditIA_PG2 {id: 'PERFIL-DESCONOCIDO'})
ON CREATE SET n:PerfilSistema, n += {id: 'PERFIL-DESCONOCIDO', datos_sensibles: null, confirmado: false, operaciones_esenciales: ['acceso a datos']};

MERGE (n:AuditIA_PG2 {id: 'E-PERFIL-DESCONOCIDO'})
ON CREATE SET n:Evidencia, n += {id: 'E-PERFIL-DESCONOCIDO', tipo: 'declaracion', contenido: 'Perfil construido; datos sensibles None', localizador: 'PERFIL-DESCONOCIDO', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'EV-SEG-DESCONOCIDO'})
ON CREATE SET n:Evaluacion:EvaluacionCruzada, n += {id: 'EV-SEG-DESCONOCIDO', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', tipo_analisis: 'cobertura', modulo_origen: 'analisis_cruzado', datos_controlados: true, condicion_catalogo: null, busqueda_completa: true, mapa_cobertura_validado: false, cobertura: 'indeterminada', necesidades: ['protección de datos sensibles'], partes_cubiertas: [], validacion_operativa: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-SEG-DESCONOCIDO'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-SEG-DESCONOCIDO', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-SEG-DESCONOCIDO', localizador: 'EV-SEG-DESCONOCIDO', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'DOC-ERROR-v1'})
ON CREATE SET n:DocumentoVersion, n += {id: 'DOC-ERROR-v1', documento_id: 'DOC-ERROR', version: '1', titulo: 'Especificación académica DOC-ERROR-v1', fecha: '2026-10-31T21:00:00-03:00', materiales_disponibles: ['Documento principal'], referencias_no_disponibles: []};

MERGE (n:AuditIA_PG2 {id: 'RQ-ERROR-v1'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-ERROR-v1', id_logico: 'RQ-ERROR', texto_original: 'El sistema no debe publicar datos privados.', tipo: 'funcional', localizador: 'RQ-ERROR-v1', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-ERROR-v1'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-ERROR-v1', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-ERROR-v1'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-ERROR-v1', tipo: 'fragmento', contenido: 'El sistema no debe publicar datos privados.', localizador: 'RQ-ERROR-v1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-ERROR-v1'};

MERGE (n:AuditIA_PG2 {id: 'EV-ERROR'})
ON CREATE SET n:Evaluacion:EvaluacionIndividual, n += {id: 'EV-ERROR', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: false, publicado: false, estado: 'en_revision', modulo_origen: 'evaluacion_individual'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-ERROR'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-ERROR', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-ERROR', localizador: 'EV-ERROR', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'X-CAT'})
ON CREATE SET n:ContextoPrioridad, n += {id: 'X-CAT', observacion_id: 'H-CAT-B', info_para_priorizar_suficiente: false, necesidad_dato_confirmada: true, dato_para_priorizar_disponible: false, dato_para_resolver_identificado: true, dato_para_resolver: 'Confirmar condición y alcance de CAT', obligacion_esencial_indefinida: false, bloqueo_sustantivo_confirmado: false, hito_acordado: false, diferimiento_aceptado: false, impacto_acotado: false, mapeo_alta_bloqueante: 'candidato_activo', criticidad_valor: null};

MERGE (n:AuditIA_PG2 {id: 'E-X-CAT'})
ON CREATE SET n:Evidencia, n += {id: 'E-X-CAT', tipo: 'declaracion', contenido: 'Contexto de prioridad construido de CAT', localizador: 'X-CAT', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'CR-CAT'})
ON CREATE SET n:Criticidad, n += {id: 'CR-CAT', valor: null, grado_criticidad: null, ambito: 'Operación del caso CAT', fundamento: 'Declaración construida', declarante_rol: 'referente_negocio', modelo_difuso_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'X-CAT-PV'})
ON CREATE SET n:ContextoPrioridad, n += {id: 'X-CAT-PV', observacion_id: 'P-CAT-V', info_para_priorizar_suficiente: false, necesidad_dato_confirmada: true, dato_para_priorizar_disponible: false, dato_para_resolver_identificado: true, dato_para_resolver: 'Confirmar condición y alcance de CAT-PV', obligacion_esencial_indefinida: false, bloqueo_sustantivo_confirmado: false, hito_acordado: false, diferimiento_aceptado: false, impacto_acotado: false, mapeo_alta_bloqueante: 'candidato_activo', criticidad_valor: null};

MERGE (n:AuditIA_PG2 {id: 'E-X-CAT-PV'})
ON CREATE SET n:Evidencia, n += {id: 'E-X-CAT-PV', tipo: 'declaracion', contenido: 'Contexto de prioridad construido de CAT-PV', localizador: 'X-CAT-PV', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'CR-CAT-PV'})
ON CREATE SET n:Criticidad, n += {id: 'CR-CAT-PV', valor: null, grado_criticidad: null, ambito: 'Operación del caso CAT-PV', fundamento: 'Declaración construida', declarante_rol: 'referente_negocio', modelo_difuso_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'X-CAT-PC'})
ON CREATE SET n:ContextoPrioridad, n += {id: 'X-CAT-PC', observacion_id: 'P-CAT-C', info_para_priorizar_suficiente: false, necesidad_dato_confirmada: true, dato_para_priorizar_disponible: false, dato_para_resolver_identificado: true, dato_para_resolver: 'Confirmar condición y alcance de CAT-PC', obligacion_esencial_indefinida: false, bloqueo_sustantivo_confirmado: false, hito_acordado: false, diferimiento_aceptado: false, impacto_acotado: false, mapeo_alta_bloqueante: 'candidato_activo', criticidad_valor: null};

MERGE (n:AuditIA_PG2 {id: 'E-X-CAT-PC'})
ON CREATE SET n:Evidencia, n += {id: 'E-X-CAT-PC', tipo: 'declaracion', contenido: 'Contexto de prioridad construido de CAT-PC', localizador: 'X-CAT-PC', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'CR-CAT-PC'})
ON CREATE SET n:Criticidad, n += {id: 'CR-CAT-PC', valor: null, grado_criticidad: null, ambito: 'Operación del caso CAT-PC', fundamento: 'Declaración construida', declarante_rol: 'referente_negocio', modelo_difuso_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'X-DESC'})
ON CREATE SET n:ContextoPrioridad, n += {id: 'X-DESC', observacion_id: 'H-DESC', info_para_priorizar_suficiente: true, necesidad_dato_confirmada: false, dato_para_priorizar_disponible: true, dato_para_resolver_identificado: true, dato_para_resolver: 'Confirmar condición y alcance de DESC', obligacion_esencial_indefinida: true, bloqueo_sustantivo_confirmado: true, hito_acordado: false, diferimiento_aceptado: false, impacto_acotado: false, mapeo_alta_bloqueante: 'candidato_activo', criticidad_valor: 'alta'};

MERGE (n:AuditIA_PG2 {id: 'E-X-DESC'})
ON CREATE SET n:Evidencia, n += {id: 'E-X-DESC', tipo: 'declaracion', contenido: 'Contexto de prioridad construido de DESC', localizador: 'X-DESC', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'CR-DESC'})
ON CREATE SET n:Criticidad, n += {id: 'CR-DESC', valor: 'alta', grado_criticidad: 9.0, ambito: 'Operación del caso DESC', fundamento: 'Declaración construida', declarante_rol: 'referente_negocio', modelo_difuso_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'X-TASA'})
ON CREATE SET n:ContextoPrioridad, n += {id: 'X-TASA', observacion_id: 'P-TASA', info_para_priorizar_suficiente: false, necesidad_dato_confirmada: true, dato_para_priorizar_disponible: false, dato_para_resolver_identificado: true, dato_para_resolver: 'Confirmar condición y alcance de TASA', obligacion_esencial_indefinida: false, bloqueo_sustantivo_confirmado: false, hito_acordado: false, diferimiento_aceptado: false, impacto_acotado: false, mapeo_alta_bloqueante: 'candidato_activo', criticidad_valor: null};

MERGE (n:AuditIA_PG2 {id: 'E-X-TASA'})
ON CREATE SET n:Evidencia, n += {id: 'E-X-TASA', tipo: 'declaracion', contenido: 'Contexto de prioridad construido de TASA', localizador: 'X-TASA', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'CR-TASA'})
ON CREATE SET n:Criticidad, n += {id: 'CR-TASA', valor: null, grado_criticidad: null, ambito: 'Operación del caso TASA', fundamento: 'Declaración construida', declarante_rol: 'referente_negocio', modelo_difuso_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'X-SEG'})
ON CREATE SET n:ContextoPrioridad, n += {id: 'X-SEG', observacion_id: 'H-SEG', info_para_priorizar_suficiente: false, necesidad_dato_confirmada: true, dato_para_priorizar_disponible: false, dato_para_resolver_identificado: true, dato_para_resolver: 'Confirmar condición y alcance de SEG', obligacion_esencial_indefinida: false, bloqueo_sustantivo_confirmado: false, hito_acordado: false, diferimiento_aceptado: false, impacto_acotado: false, mapeo_alta_bloqueante: 'candidato_activo', criticidad_valor: 'alta'};

MERGE (n:AuditIA_PG2 {id: 'E-X-SEG'})
ON CREATE SET n:Evidencia, n += {id: 'E-X-SEG', tipo: 'declaracion', contenido: 'Contexto de prioridad construido de SEG', localizador: 'X-SEG', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'CR-SEG'})
ON CREATE SET n:Criticidad, n += {id: 'CR-SEG', valor: 'alta', grado_criticidad: 8.0, ambito: 'Operación del caso SEG', fundamento: 'Declaración construida', declarante_rol: 'referente_negocio', modelo_difuso_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'X-SEG-P'})
ON CREATE SET n:ContextoPrioridad, n += {id: 'X-SEG-P', observacion_id: 'P-SEG', info_para_priorizar_suficiente: false, necesidad_dato_confirmada: true, dato_para_priorizar_disponible: false, dato_para_resolver_identificado: true, dato_para_resolver: 'Confirmar condición y alcance de SEG-P', obligacion_esencial_indefinida: false, bloqueo_sustantivo_confirmado: false, hito_acordado: false, diferimiento_aceptado: false, impacto_acotado: false, mapeo_alta_bloqueante: 'candidato_activo', criticidad_valor: null};

MERGE (n:AuditIA_PG2 {id: 'E-X-SEG-P'})
ON CREATE SET n:Evidencia, n += {id: 'E-X-SEG-P', tipo: 'declaracion', contenido: 'Contexto de prioridad construido de SEG-P', localizador: 'X-SEG-P', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'CR-SEG-P'})
ON CREATE SET n:Criticidad, n += {id: 'CR-SEG-P', valor: null, grado_criticidad: null, ambito: 'Operación del caso SEG-P', fundamento: 'Declaración construida', declarante_rol: 'referente_negocio', modelo_difuso_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'DOC-PRIO-v1'})
ON CREATE SET n:DocumentoVersion, n += {id: 'DOC-PRIO-v1', documento_id: 'DOC-PRIO', version: '1', titulo: 'Especificación académica DOC-PRIO-v1', fecha: '2026-10-31T21:00:00-03:00', materiales_disponibles: ['Documento principal'], referencias_no_disponibles: []};

MERGE (n:AuditIA_PG2 {id: 'RQ-PRIO-v1'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-PRIO-v1', id_logico: 'RQ-PRIO', texto_original: 'El sistema debe exportar el informe en un formato estándar.', tipo: 'funcional', localizador: 'RQ-PRIO-v1', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-PRIO-v1'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-PRIO-v1', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-PRIO-v1', tipo: 'fragmento', contenido: 'El sistema debe exportar el informe en un formato estándar.', localizador: 'RQ-PRIO-v1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-PRIO-v1'};

MERGE (n:AuditIA_PG2 {id: 'EV-PRIO-MAYOR'})
ON CREATE SET n:Evaluacion:EvaluacionIndividual, n += {id: 'EV-PRIO-MAYOR', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', modulo_origen: 'evaluacion_individual'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-PRIO-MAYOR'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-PRIO-MAYOR', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-PRIO-MAYOR', localizador: 'EV-PRIO-MAYOR', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-atomicidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-MAYOR-atomicidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Una obligación evaluable con unidad de aceptación confirmada.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, obligaciones_independientes: 1, unidad_aceptacion_confirmada: true};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-ambiguedad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-MAYOR-ambiguedad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Lecturas CSV y PDF para formato estándar, sin una definición que seleccione una; análisis construido para probar el tratamiento de SM3.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, lecturas_residuales: 2, delimitacion_confirmada: false, severidad_propuesta: 'media', puntuacion_severidad_propuesta: 5};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-verificabilidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-MAYOR-verificabilidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'La aceptación necesaria no fue recibida; no se puede fijar una condición de aprobación.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, aceptacion_necesaria: true, aceptacion_disponible: false, comprobacion_definida: false};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-completitud'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-MAYOR-completitud', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'No se recibió la información necesaria para determinar las partes aplicables.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: false, contexto_suficiente: true, informacion_aplicable_identificada: false, omisiones_demostradas: null};

MERGE (n:AuditIA_PG2 {id: 'X-MAYOR'})
ON CREATE SET n:ContextoPrioridad, n += {id: 'X-MAYOR', observacion_id: 'H-PRIO-MAYOR', info_para_priorizar_suficiente: true, necesidad_dato_confirmada: true, dato_para_priorizar_disponible: true, obligacion_esencial_indefinida: false, bloqueo_sustantivo_confirmado: false, hito_acordado: true, diferimiento_aceptado: false, impacto_acotado: false, mapeo_alta_bloqueante: 'candidato_activo', criticidad_valor: 'baja', criticidad_grado: 2};

MERGE (n:AuditIA_PG2 {id: 'E-X-MAYOR'})
ON CREATE SET n:Evidencia, n += {id: 'E-X-MAYOR', tipo: 'acuerdo', contenido: 'Hito/diferimiento del caso construido MAYOR', localizador: 'X-MAYOR', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'CR-MAYOR'})
ON CREATE SET n:Criticidad, n += {id: 'CR-MAYOR', valor: 'baja', grado_criticidad: 2, ambito: 'Formato de exportación', fundamento: 'Importancia construida para prueba', modelo_difuso_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'EV-PRIO-MENOR'})
ON CREATE SET n:Evaluacion:EvaluacionIndividual, n += {id: 'EV-PRIO-MENOR', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', modulo_origen: 'evaluacion_individual'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-PRIO-MENOR'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-PRIO-MENOR', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-PRIO-MENOR', localizador: 'EV-PRIO-MENOR', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-atomicidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-MENOR-atomicidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Una obligación evaluable con unidad de aceptación confirmada.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, obligaciones_independientes: 1, unidad_aceptacion_confirmada: true};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-ambiguedad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-MENOR-ambiguedad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Lecturas CSV y PDF para formato estándar, sin una definición que seleccione una; análisis construido para probar el tratamiento de SM3.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, lecturas_residuales: 2, delimitacion_confirmada: false, severidad_propuesta: 'baja', puntuacion_severidad_propuesta: 1};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-verificabilidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-MENOR-verificabilidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'La aceptación necesaria no fue recibida; no se puede fijar una condición de aprobación.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, aceptacion_necesaria: true, aceptacion_disponible: false, comprobacion_definida: false};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-completitud'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-MENOR-completitud', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'No se recibió la información necesaria para determinar las partes aplicables.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: false, contexto_suficiente: true, informacion_aplicable_identificada: false, omisiones_demostradas: null};

MERGE (n:AuditIA_PG2 {id: 'X-MENOR'})
ON CREATE SET n:ContextoPrioridad, n += {id: 'X-MENOR', observacion_id: 'H-PRIO-MENOR', info_para_priorizar_suficiente: true, necesidad_dato_confirmada: true, dato_para_priorizar_disponible: true, obligacion_esencial_indefinida: false, bloqueo_sustantivo_confirmado: false, hito_acordado: false, diferimiento_aceptado: true, impacto_acotado: true, mapeo_alta_bloqueante: 'candidato_activo', criticidad_valor: 'baja', criticidad_grado: 1};

MERGE (n:AuditIA_PG2 {id: 'E-X-MENOR'})
ON CREATE SET n:Evidencia, n += {id: 'E-X-MENOR', tipo: 'acuerdo', contenido: 'Hito/diferimiento del caso construido MENOR', localizador: 'X-MENOR', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'CR-MENOR'})
ON CREATE SET n:Criticidad, n += {id: 'CR-MENOR', valor: 'baja', grado_criticidad: 1, ambito: 'Formato de exportación', fundamento: 'Importancia construida para prueba', modelo_difuso_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'EV-PRIO-EXCEPCION'})
ON CREATE SET n:Evaluacion:EvaluacionIndividual, n += {id: 'EV-PRIO-EXCEPCION', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', modulo_origen: 'evaluacion_individual'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-PRIO-EXCEPCION'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-PRIO-EXCEPCION', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-PRIO-EXCEPCION', localizador: 'EV-PRIO-EXCEPCION', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-atomicidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-EXCEPCION-atomicidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Una obligación evaluable con unidad de aceptación confirmada.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, obligaciones_independientes: 1, unidad_aceptacion_confirmada: true};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-ambiguedad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-EXCEPCION-ambiguedad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Lecturas CSV y PDF para formato estándar, sin una definición que seleccione una; análisis construido para probar el tratamiento de SM3.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, lecturas_residuales: 2, delimitacion_confirmada: false, severidad_propuesta: 'baja', puntuacion_severidad_propuesta: 2};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-verificabilidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-EXCEPCION-verificabilidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'La aceptación necesaria no fue recibida; no se puede fijar una condición de aprobación.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, aceptacion_necesaria: true, aceptacion_disponible: false, comprobacion_definida: false};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-completitud'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-EXCEPCION-completitud', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'No se recibió la información necesaria para determinar las partes aplicables.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: false, contexto_suficiente: true, informacion_aplicable_identificada: false, omisiones_demostradas: null};

MERGE (n:AuditIA_PG2 {id: 'X-EXCEPCION'})
ON CREATE SET n:ContextoPrioridad, n += {id: 'X-EXCEPCION', observacion_id: 'H-PRIO-EXCEPCION', info_para_priorizar_suficiente: true, necesidad_dato_confirmada: true, dato_para_priorizar_disponible: true, obligacion_esencial_indefinida: false, bloqueo_sustantivo_confirmado: false, hito_acordado: false, diferimiento_aceptado: false, impacto_acotado: false, mapeo_alta_bloqueante: 'candidato_activo', criticidad_valor: 'alta', criticidad_grado: 8.5};

MERGE (n:AuditIA_PG2 {id: 'E-X-EXCEPCION'})
ON CREATE SET n:Evidencia, n += {id: 'E-X-EXCEPCION', tipo: 'acuerdo', contenido: 'Hito/diferimiento del caso construido EXCEPCION', localizador: 'X-EXCEPCION', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'CR-EXCEPCION'})
ON CREATE SET n:Criticidad, n += {id: 'CR-EXCEPCION', valor: 'alta', grado_criticidad: 8.5, ambito: 'Formato de exportación', fundamento: 'Importancia construida para prueba', modelo_difuso_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'EV-PRIO-FRONTERA'})
ON CREATE SET n:Evaluacion:EvaluacionIndividual, n += {id: 'EV-PRIO-FRONTERA', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', modulo_origen: 'evaluacion_individual'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-PRIO-FRONTERA'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-PRIO-FRONTERA', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-PRIO-FRONTERA', localizador: 'EV-PRIO-FRONTERA', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-atomicidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-FRONTERA-atomicidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Una obligación evaluable con unidad de aceptación confirmada.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, obligaciones_independientes: 1, unidad_aceptacion_confirmada: true};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-ambiguedad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-FRONTERA-ambiguedad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Lecturas CSV y PDF para formato estándar, sin una definición que seleccione una; análisis construido para probar el tratamiento de SM3.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, lecturas_residuales: 2, delimitacion_confirmada: false, severidad_propuesta: 'media', puntuacion_severidad_propuesta: 6.5};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-verificabilidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-FRONTERA-verificabilidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'La aceptación necesaria no fue recibida; no se puede fijar una condición de aprobación.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, aceptacion_necesaria: true, aceptacion_disponible: false, comprobacion_definida: false};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-completitud'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-FRONTERA-completitud', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'No se recibió la información necesaria para determinar las partes aplicables.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: false, contexto_suficiente: true, informacion_aplicable_identificada: false, omisiones_demostradas: null};

MERGE (n:AuditIA_PG2 {id: 'X-FRONTERA'})
ON CREATE SET n:ContextoPrioridad, n += {id: 'X-FRONTERA', observacion_id: 'H-PRIO-FRONTERA', info_para_priorizar_suficiente: true, necesidad_dato_confirmada: true, dato_para_priorizar_disponible: true, obligacion_esencial_indefinida: false, bloqueo_sustantivo_confirmado: false, hito_acordado: true, diferimiento_aceptado: false, impacto_acotado: false, mapeo_alta_bloqueante: 'candidato_activo', criticidad_valor: 'media', criticidad_grado: 6.5};

MERGE (n:AuditIA_PG2 {id: 'E-X-FRONTERA'})
ON CREATE SET n:Evidencia, n += {id: 'E-X-FRONTERA', tipo: 'acuerdo', contenido: 'Hito/diferimiento del caso construido FRONTERA', localizador: 'X-FRONTERA', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'CR-FRONTERA'})
ON CREATE SET n:Criticidad, n += {id: 'CR-FRONTERA', valor: 'media', grado_criticidad: 6.5, ambito: 'Formato de exportación', fundamento: 'Importancia construida para prueba', modelo_difuso_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'EV-PRIO-SIN-HITO'})
ON CREATE SET n:Evaluacion:EvaluacionIndividual, n += {id: 'EV-PRIO-SIN-HITO', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', modulo_origen: 'evaluacion_individual'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-PRIO-SIN-HITO'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-PRIO-SIN-HITO', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-PRIO-SIN-HITO', localizador: 'EV-PRIO-SIN-HITO', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-atomicidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-SIN-HITO-atomicidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Una obligación evaluable con unidad de aceptación confirmada.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, obligaciones_independientes: 1, unidad_aceptacion_confirmada: true};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-ambiguedad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-SIN-HITO-ambiguedad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Lecturas CSV y PDF para formato estándar, sin una definición que seleccione una; análisis construido para probar el tratamiento de SM3.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, lecturas_residuales: 2, delimitacion_confirmada: false, severidad_propuesta: 'media', puntuacion_severidad_propuesta: 5};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-verificabilidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-SIN-HITO-verificabilidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'La aceptación necesaria no fue recibida; no se puede fijar una condición de aprobación.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, aceptacion_necesaria: true, aceptacion_disponible: false, comprobacion_definida: false};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-completitud'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-SIN-HITO-completitud', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'No se recibió la información necesaria para determinar las partes aplicables.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: false, contexto_suficiente: true, informacion_aplicable_identificada: false, omisiones_demostradas: null};

MERGE (n:AuditIA_PG2 {id: 'X-SIN-HITO'})
ON CREATE SET n:ContextoPrioridad, n += {id: 'X-SIN-HITO', observacion_id: 'H-PRIO-SIN-HITO', info_para_priorizar_suficiente: true, necesidad_dato_confirmada: true, dato_para_priorizar_disponible: true, obligacion_esencial_indefinida: false, bloqueo_sustantivo_confirmado: false, hito_acordado: false, diferimiento_aceptado: false, impacto_acotado: false, mapeo_alta_bloqueante: 'candidato_activo', criticidad_valor: 'baja', criticidad_grado: 2};

MERGE (n:AuditIA_PG2 {id: 'E-X-SIN-HITO'})
ON CREATE SET n:Evidencia, n += {id: 'E-X-SIN-HITO', tipo: 'acuerdo', contenido: 'Hito/diferimiento del caso construido SIN-HITO', localizador: 'X-SIN-HITO', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'CR-SIN-HITO'})
ON CREATE SET n:Criticidad, n += {id: 'CR-SIN-HITO', valor: 'baja', grado_criticidad: 2, ambito: 'Formato de exportación', fundamento: 'Importancia construida para prueba', modelo_difuso_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'EV-PRIO-FUERA-RANGO'})
ON CREATE SET n:Evaluacion:EvaluacionIndividual, n += {id: 'EV-PRIO-FUERA-RANGO', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', modulo_origen: 'evaluacion_individual'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-PRIO-FUERA-RANGO'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-PRIO-FUERA-RANGO', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-PRIO-FUERA-RANGO', localizador: 'EV-PRIO-FUERA-RANGO', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-atomicidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-FUERA-RANGO-atomicidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Una obligación evaluable con unidad de aceptación confirmada.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, obligaciones_independientes: 1, unidad_aceptacion_confirmada: true};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-ambiguedad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-FUERA-RANGO-ambiguedad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Lecturas CSV y PDF para formato estándar, sin una definición que seleccione una; análisis construido para probar el tratamiento de SM3.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, lecturas_residuales: 2, delimitacion_confirmada: false, severidad_propuesta: 'media', puntuacion_severidad_propuesta: 12};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-verificabilidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-FUERA-RANGO-verificabilidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'La aceptación necesaria no fue recibida; no se puede fijar una condición de aprobación.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, aceptacion_necesaria: true, aceptacion_disponible: false, comprobacion_definida: false};

MERGE (n:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-completitud'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-PRIO-FUERA-RANGO-completitud', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'No se recibió la información necesaria para determinar las partes aplicables.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: false, contexto_suficiente: true, informacion_aplicable_identificada: false, omisiones_demostradas: null};

MERGE (n:AuditIA_PG2 {id: 'X-FUERA-RANGO'})
ON CREATE SET n:ContextoPrioridad, n += {id: 'X-FUERA-RANGO', observacion_id: 'H-PRIO-FUERA-RANGO', info_para_priorizar_suficiente: true, necesidad_dato_confirmada: true, dato_para_priorizar_disponible: true, obligacion_esencial_indefinida: false, bloqueo_sustantivo_confirmado: false, hito_acordado: true, diferimiento_aceptado: false, impacto_acotado: false, mapeo_alta_bloqueante: 'candidato_activo', criticidad_valor: 'media', criticidad_grado: 5};

MERGE (n:AuditIA_PG2 {id: 'E-X-FUERA-RANGO'})
ON CREATE SET n:Evidencia, n += {id: 'E-X-FUERA-RANGO', tipo: 'acuerdo', contenido: 'Hito/diferimiento del caso construido FUERA-RANGO', localizador: 'X-FUERA-RANGO', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'CR-FUERA-RANGO'})
ON CREATE SET n:Criticidad, n += {id: 'CR-FUERA-RANGO', valor: 'media', grado_criticidad: 5, ambito: 'Formato de exportación', fundamento: 'Importancia construida para prueba', modelo_difuso_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'MPR-baja-baja'})
ON CREATE SET n:CeldaMatriz, n += {id: 'MPR-baja-baja', severidad: 'baja', criticidad: 'baja', categoria: 'menor', version: 'MPR-01-1.0', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MPR-baja-media'})
ON CREATE SET n:CeldaMatriz, n += {id: 'MPR-baja-media', severidad: 'baja', criticidad: 'media', categoria: 'mayor', version: 'MPR-01-1.0', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MPR-baja-alta'})
ON CREATE SET n:CeldaMatriz, n += {id: 'MPR-baja-alta', severidad: 'baja', criticidad: 'alta', categoria: 'bloqueante', version: 'MPR-01-1.0', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MPR-media-baja'})
ON CREATE SET n:CeldaMatriz, n += {id: 'MPR-media-baja', severidad: 'media', criticidad: 'baja', categoria: 'mayor', version: 'MPR-01-1.0', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MPR-media-media'})
ON CREATE SET n:CeldaMatriz, n += {id: 'MPR-media-media', severidad: 'media', criticidad: 'media', categoria: 'mayor', version: 'MPR-01-1.0', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MPR-media-alta'})
ON CREATE SET n:CeldaMatriz, n += {id: 'MPR-media-alta', severidad: 'media', criticidad: 'alta', categoria: 'bloqueante', version: 'MPR-01-1.0', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MPR-alta-baja'})
ON CREATE SET n:CeldaMatriz, n += {id: 'MPR-alta-baja', severidad: 'alta', criticidad: 'baja', categoria: 'mayor', version: 'MPR-01-1.0', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MPR-alta-media'})
ON CREATE SET n:CeldaMatriz, n += {id: 'MPR-alta-media', severidad: 'alta', criticidad: 'media', categoria: 'bloqueante', version: 'MPR-01-1.0', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MPR-alta-alta'})
ON CREATE SET n:CeldaMatriz, n += {id: 'MPR-alta-alta', severidad: 'alta', criticidad: 'alta', categoria: 'bloqueante', version: 'MPR-01-1.0', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'CONTROL-SIN-ANEXO'})
ON CREATE SET n:CasoMetrica, n += {id: 'CONTROL-SIN-ANEXO', hallazgos_demostrados: 0, juicios_cerrados: 3, juicios_aplicables: 4, pendientes_contexto: 1, calidad_observada: 'sin_defectos_demostrados'};

MERGE (n:AuditIA_PG2 {id: 'CONTROL-ANEXO-RECIBIDO'})
ON CREATE SET n:CasoMetrica, n += {id: 'CONTROL-ANEXO-RECIBIDO', hallazgos_demostrados: 0, juicios_cerrados: 4, juicios_aplicables: 4, pendientes_contexto: 0, calidad_observada: 'sin_defectos_demostrados'};

MERGE (n:AuditIA_PG2 {id: 'CONTROL-CON-DEFECTO'})
ON CREATE SET n:CasoMetrica, n += {id: 'CONTROL-CON-DEFECTO', hallazgos_demostrados: 1, juicios_cerrados: 4, juicios_aplicables: 4, pendientes_contexto: 0, calidad_observada: 'con_defectos_demostrados'};

MERGE (n:AuditIA_PG2 {id: 'DOC-HAB-v1'})
ON CREATE SET n:DocumentoVersion, n += {id: 'DOC-HAB-v1', documento_id: 'DOC-HAB', version: '1', titulo: 'Especificación académica DOC-HAB-v1', fecha: '2026-10-31T21:00:00-03:00', materiales_disponibles: ['Documento principal'], referencias_no_disponibles: []};

MERGE (n:AuditIA_PG2 {id: 'RQ-HAB-v1'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-HAB-v1', id_logico: 'RQ-HAB', texto_original: 'El sistema debe notificar a los clientes habituales.', tipo: 'funcional', localizador: 'RQ-HAB-v1', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-HAB-v1'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-HAB-v1', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-HAB-v1'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-HAB-v1', tipo: 'fragmento', contenido: 'El sistema debe notificar a los clientes habituales.', localizador: 'RQ-HAB-v1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-HAB-v1'};

MERGE (n:AuditIA_PG2 {id: 'EV-HAB'})
ON CREATE SET n:Evaluacion:EvaluacionIndividual, n += {id: 'EV-HAB', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', modulo_origen: 'evaluacion_individual'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-HAB'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-HAB', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-HAB', localizador: 'EV-HAB', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'J-EV-HAB-atomicidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-HAB-atomicidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Cotejo construido de atomicidad', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, obligaciones_independientes: 1, unidad_aceptacion_confirmada: true};

MERGE (n:AuditIA_PG2 {id: 'J-EV-HAB-ambiguedad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-HAB-ambiguedad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'El glosario define compras frecuentes sin fijar frecuencia; valoración 6/5, pero falta cerrar la interpretación para el juicio.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: false, contexto_suficiente: true, lecturas_residuales: 2, delimitacion_confirmada: false, divergencia_lecturas: 6, delimitacion_contexto: 5, valoracion_confirmada: true, alcance_valoracion_revisado: true};

MERGE (n:AuditIA_PG2 {id: 'J-EV-HAB-verificabilidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-HAB-verificabilidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Cotejo construido de verificabilidad', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, aceptacion_necesaria: true, aceptacion_disponible: false, comprobacion_definida: false};

MERGE (n:AuditIA_PG2 {id: 'J-EV-HAB-completitud'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-HAB-completitud', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Cotejo construido de completitud', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: false, contexto_suficiente: true, informacion_aplicable_identificada: false, omisiones_demostradas: null};

MERGE (n:AuditIA_PG2 {id: 'E-HAB-GLOSARIO'})
ON CREATE SET n:Evidencia, n += {id: 'E-HAB-GLOSARIO', tipo: 'documento', contenido: 'Cliente habitual: cliente con compras frecuentes. No fija una frecuencia.', localizador: 'Glosario construido de DOC-HAB-v1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-HAB-v1'};

MERGE (n:AuditIA_PG2 {id: 'DOC-AMB-SIN-DATO-v1'})
ON CREATE SET n:DocumentoVersion, n += {id: 'DOC-AMB-SIN-DATO-v1', documento_id: 'DOC-AMB-SIN-DATO', version: '1', titulo: 'Especificación académica DOC-AMB-SIN-DATO-v1', fecha: '2026-10-31T21:00:00-03:00', materiales_disponibles: ['Documento principal'], referencias_no_disponibles: []};

MERGE (n:AuditIA_PG2 {id: 'RQ-AMB-SIN-DATO-v1'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-AMB-SIN-DATO-v1', id_logico: 'RQ-AMB-SIN-DATO', texto_original: 'El sistema debe responder de forma adecuada.', tipo: 'funcional', localizador: 'RQ-AMB-SIN-DATO-v1', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-AMB-SIN-DATO-v1'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-AMB-SIN-DATO-v1', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-AMB-SIN-DATO-v1'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-AMB-SIN-DATO-v1', tipo: 'fragmento', contenido: 'El sistema debe responder de forma adecuada.', localizador: 'RQ-AMB-SIN-DATO-v1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-AMB-SIN-DATO-v1'};

MERGE (n:AuditIA_PG2 {id: 'EV-AMB-SIN-DATO'})
ON CREATE SET n:Evaluacion:EvaluacionIndividual, n += {id: 'EV-AMB-SIN-DATO', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', modulo_origen: 'evaluacion_individual'};

MERGE (n:AuditIA_PG2 {id: 'E-EV-AMB-SIN-DATO'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-AMB-SIN-DATO', tipo: 'analisis', contenido: 'Premisas registradas por el grupo para EV-AMB-SIN-DATO', localizador: 'EV-AMB-SIN-DATO', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-atomicidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-AMB-SIN-DATO-atomicidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Cotejo construido de atomicidad', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, obligaciones_independientes: 1, unidad_aceptacion_confirmada: true};

MERGE (n:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-ambiguedad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-AMB-SIN-DATO-ambiguedad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'No hay valoración fundamentada de divergencia y delimitación.', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: false, contexto_suficiente: true, lecturas_residuales: 2, delimitacion_confirmada: false};

MERGE (n:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-verificabilidad'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-AMB-SIN-DATO-verificabilidad', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Cotejo construido de verificabilidad', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: true, contexto_suficiente: true, aceptacion_necesaria: true, aceptacion_disponible: false, comprobacion_definida: false};

MERGE (n:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-completitud'})
ON CREATE SET n:JuicioCriterio, n += {id: 'J-EV-AMB-SIN-DATO-completitud', fecha: '2026-10-31T21:00:00-03:00', justificacion: 'Cotejo construido de completitud', revision_semantica_completa: true, info_necesaria_identificada: true, info_disponible: false, contexto_suficiente: true, informacion_aplicable_identificada: false, omisiones_demostradas: null};

MERGE (n:AuditIA_PG2 {id: 'DOC-PED-v1'})
ON CREATE SET n:DocumentoVersion, n += {id: 'DOC-PED-v1', documento_id: 'DOC-PED', version: '1', titulo: 'Especificación académica DOC-PED-v1', fecha: '2026-10-31T21:00:00-03:00', materiales_disponibles: ['Documento principal'], referencias_no_disponibles: []};

MERGE (n:AuditIA_PG2 {id: 'RQ-PED-A-v1'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-PED-A-v1', id_logico: 'RQ-PED-A', texto_original: 'Se permite modificar el pedido antes del despacho.', tipo: 'funcional', localizador: 'RQ-PED-A-v1', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-PED-A-v1'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-PED-A-v1', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-PED-A-v1'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-PED-A-v1', tipo: 'fragmento', contenido: 'Se permite modificar el pedido antes del despacho.', localizador: 'RQ-PED-A-v1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-PED-v1'};

MERGE (n:AuditIA_PG2 {id: 'RQ-PED-B-v1'})
ON CREATE SET n:Requerimiento, n += {id: 'RQ-PED-B-v1', id_logico: 'RQ-PED-B', texto_original: 'Se prohíbe modificar el pedido después de la preparación.', tipo: 'funcional', localizador: 'RQ-PED-B-v1', entrada_valida: true};

MERGE (n:AuditIA_PG2 {id: 'CTX-RQ-PED-B-v1'})
ON CREATE SET n:ContextoRequerimiento, n += {id: 'CTX-RQ-PED-B-v1', referencias_disponibles: [], alcance_controlado: true};

MERGE (n:AuditIA_PG2 {id: 'E-RQ-PED-B-v1'})
ON CREATE SET n:Evidencia, n += {id: 'E-RQ-PED-B-v1', tipo: 'fragmento', contenido: 'Se prohíbe modificar el pedido después de la preparación.', localizador: 'RQ-PED-B-v1', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00', documento_version: 'DOC-PED-v1'};

MERGE (n:AuditIA_PG2 {id: 'EV-PED-FRONTERA'})
ON CREATE SET n:Evaluacion:EvaluacionCruzada, n += {id: 'EV-PED-FRONTERA', fecha: '2026-10-31T21:00:00-03:00', entrada_valida: true, publicado: false, estado: 'en_revision', tipo_analisis: 'comparacion', modulo_origen: 'analisis_cruzado', datos_controlados: true, dato_necesario_faltante: false, escenarios: 'parciales', resultados_incompatibles: true, excepcion_resuelve: false, interpretacion_cerrada: false, region_comun_definida: false, validacion_operativa: 'candidata', solapamiento_escenario: 5.0, incompatibilidad_resultados: 8.0, valoracion_confirmada: true};

MERGE (n:AuditIA_PG2 {id: 'E-EV-PED-FRONTERA'})
ON CREATE SET n:Evidencia, n += {id: 'E-EV-PED-FRONTERA', tipo: 'analisis', contenido: 'Antes del despacho y después de la preparación pueden compartir un intervalo no delimitado. Las valoraciones 5 y 8 describen el conflicto; no prueban su región exacta.', localizador: 'EV-PED-FRONTERA', naturaleza: 'caso_construido', autor_registro: 'Grupo 10', fecha: '2026-10-31T21:00:00-03:00'};

MERGE (n:AuditIA_PG2 {id: 'S-PI3-AMB'})
ON CREATE SET n:Fuente, n += {id: 'S-PI3-AMB', nombre: 'Costa_Juan_Pablo_PI3_U1.pdf', tipo: 'documento', estado: 'consultada', contacto: 'Costa_Juan_Pablo_PI3_U1.pdf', validez: 'Formalización candidata; sin calibración con expertos reales'};

MERGE (n:AuditIA_PG2 {id: 'MD-AMB-1.0'})
ON CREATE SET n:ModeloDifuso, n += {id: 'MD-AMB-1.0', nombre: 'Ambigüedad residual', version: '1.0', estado_validacion: 'candidata', tipo: 'Mamdani', operador_and: 'min', operador_or: 'max', agregacion: 'max', desdifusificacion: 'centroide discreto', puntos: 1001, paso: 0.001, pi3_adjuntado: true, localizador: 'Costa PI3 §§2-3'};

MERGE (n:AuditIA_PG2 {id: 'MD-AMB-1.0-x'})
ON CREATE SET n:VariableDifusa, n += {id: 'MD-AMB-1.0-x', nombre: 'Divergencia_Lecturas', rol: 'entrada', min: 0.0, max: 10.0, slot: 'premisa_x', modelo_version: 'MD-AMB-1.0'};

MERGE (n:AuditIA_PG2 {id: 'MD-AMB-1.0-x-baja'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-AMB-1.0-x-baja', nombre: 'Baja', codigo: 'baja', centro: 0.0, sigma: 1.8, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-AMB-1.0-x-media'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-AMB-1.0-x-media', nombre: 'Media', codigo: 'media', centro: 5.0, sigma: 1.5, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-AMB-1.0-x-alta'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-AMB-1.0-x-alta', nombre: 'Alta', codigo: 'alta', centro: 10.0, sigma: 1.9, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-AMB-1.0-y'})
ON CREATE SET n:VariableDifusa, n += {id: 'MD-AMB-1.0-y', nombre: 'Delimitacion_Contexto', rol: 'entrada', min: 0.0, max: 10.0, slot: 'premisa_y', modelo_version: 'MD-AMB-1.0'};

MERGE (n:AuditIA_PG2 {id: 'MD-AMB-1.0-y-baja'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-AMB-1.0-y-baja', nombre: 'Débil', codigo: 'baja', centro: 0.0, sigma: 1.9, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-AMB-1.0-y-media'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-AMB-1.0-y-media', nombre: 'Parcial', codigo: 'media', centro: 5.0, sigma: 1.5, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-AMB-1.0-y-alta'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-AMB-1.0-y-alta', nombre: 'Fuerte', codigo: 'alta', centro: 10.0, sigma: 1.8, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-AMB-1.0-z'})
ON CREATE SET n:VariableDifusa, n += {id: 'MD-AMB-1.0-z', nombre: 'Ambiguedad_Residual', rol: 'salida', min: 0.0, max: 1.0, slot: 'F11.grado_ambiguedad', modelo_version: 'MD-AMB-1.0'};

MERGE (n:AuditIA_PG2 {id: 'MD-AMB-1.0-z-baja'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-AMB-1.0-z-baja', nombre: 'Baja', codigo: 'baja', centro: 0.0, sigma: 0.18, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-AMB-1.0-z-media'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-AMB-1.0-z-media', nombre: 'Media', codigo: 'media', centro: 0.5, sigma: 0.15, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-AMB-1.0-z-alta'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-AMB-1.0-z-alta', nombre: 'Alta', codigo: 'alta', centro: 1.0, sigma: 0.18, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'AMB-RB1'})
ON CREATE SET n:ReglaDifusa, n += {id: 'AMB-RB1', antecedente: 'min(xa, yb)', salida: 'alta', estado_validacion: 'candidata', origen: 'Costa PI3 §§2-3', regla_crisp: 'EVI-HC02', orden: 1};

MERGE (n:AuditIA_PG2 {id: 'AMB-RB2'})
ON CREATE SET n:ReglaDifusa, n += {id: 'AMB-RB2', antecedente: 'min(xa, ym)', salida: 'media', estado_validacion: 'candidata', origen: 'Costa PI3 §§2-3', regla_crisp: 'EVI-HC02/HC03', orden: 2};

MERGE (n:AuditIA_PG2 {id: 'AMB-RB3'})
ON CREATE SET n:ReglaDifusa, n += {id: 'AMB-RB3', antecedente: 'min(xm, max(yb, ym))', salida: 'media', estado_validacion: 'candidata', origen: 'Costa PI3 §§2-3', regla_crisp: 'EVI-HC02', orden: 3};

MERGE (n:AuditIA_PG2 {id: 'AMB-RB4'})
ON CREATE SET n:ReglaDifusa, n += {id: 'AMB-RB4', antecedente: 'max(xb, ya)', salida: 'baja', estado_validacion: 'candidata', origen: 'Costa PI3 §§2-3', regla_crisp: 'EVI-HC03/HC09', orden: 4};

MERGE (n:AuditIA_PG2 {id: 'S-PI3-CONTR'})
ON CREATE SET n:Fuente, n += {id: 'S-PI3-CONTR', nombre: 'Isgro_Tomas_Valentino_PI3_U1.pdf', tipo: 'documento', estado: 'consultada', contacto: 'Isgro_Tomas_Valentino_PI3_U1.pdf', validez: 'Formalización candidata; sin calibración con expertos reales'};

MERGE (n:AuditIA_PG2 {id: 'MD-CONTR-1.0'})
ON CREATE SET n:ModeloDifuso, n += {id: 'MD-CONTR-1.0', nombre: 'Pertenencia a contradicción', version: '1.0', estado_validacion: 'candidata', tipo: 'Mamdani', operador_and: 'min', operador_or: 'max', agregacion: 'max', desdifusificacion: 'centroide discreto', puntos: 1001, paso: 0.001, pi3_adjuntado: true, localizador: 'Isgró PI3 §§2-3'};

MERGE (n:AuditIA_PG2 {id: 'MD-CONTR-1.0-x'})
ON CREATE SET n:VariableDifusa, n += {id: 'MD-CONTR-1.0-x', nombre: 'Solapamiento_Escenario', rol: 'entrada', min: 0.0, max: 10.0, slot: 'premisa_x', modelo_version: 'MD-CONTR-1.0'};

MERGE (n:AuditIA_PG2 {id: 'MD-CONTR-1.0-x-baja'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-CONTR-1.0-x-baja', nombre: 'Bajo', codigo: 'baja', centro: 0.0, sigma: 1.8, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-CONTR-1.0-x-media'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-CONTR-1.0-x-media', nombre: 'Medio', codigo: 'media', centro: 5.0, sigma: 1.5, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-CONTR-1.0-x-alta'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-CONTR-1.0-x-alta', nombre: 'Alto', codigo: 'alta', centro: 10.0, sigma: 1.8, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-CONTR-1.0-y'})
ON CREATE SET n:VariableDifusa, n += {id: 'MD-CONTR-1.0-y', nombre: 'Incompatibilidad_Resultados', rol: 'entrada', min: 0.0, max: 10.0, slot: 'premisa_y', modelo_version: 'MD-CONTR-1.0'};

MERGE (n:AuditIA_PG2 {id: 'MD-CONTR-1.0-y-baja'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-CONTR-1.0-y-baja', nombre: 'Baja', codigo: 'baja', centro: 0.0, sigma: 2, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-CONTR-1.0-y-media'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-CONTR-1.0-y-media', nombre: 'Media', codigo: 'media', centro: 5.0, sigma: 1.5, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-CONTR-1.0-y-alta'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-CONTR-1.0-y-alta', nombre: 'Alta', codigo: 'alta', centro: 10.0, sigma: 1.8, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-CONTR-1.0-z'})
ON CREATE SET n:VariableDifusa, n += {id: 'MD-CONTR-1.0-z', nombre: 'Pertenencia_Contradiccion', rol: 'salida', min: 0.0, max: 1.0, slot: 'F15.grado_contradiccion', modelo_version: 'MD-CONTR-1.0'};

MERGE (n:AuditIA_PG2 {id: 'MD-CONTR-1.0-z-baja'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-CONTR-1.0-z-baja', nombre: 'Baja', codigo: 'baja', centro: 0.0, sigma: 0.18, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-CONTR-1.0-z-media'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-CONTR-1.0-z-media', nombre: 'Intermedia', codigo: 'media', centro: 0.5, sigma: 0.15, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-CONTR-1.0-z-alta'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-CONTR-1.0-z-alta', nombre: 'Alta', codigo: 'alta', centro: 1.0, sigma: 0.18, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'CONTR-RB1'})
ON CREATE SET n:ReglaDifusa, n += {id: 'CONTR-RB1', antecedente: 'min(xa, ya)', salida: 'alta', estado_validacion: 'candidata', origen: 'Isgró PI3 §§2-3', regla_crisp: 'ACC-RD05', orden: 1};

MERGE (n:AuditIA_PG2 {id: 'CONTR-RB2'})
ON CREATE SET n:ReglaDifusa, n += {id: 'CONTR-RB2', antecedente: 'min(xm, ya)', salida: 'media', estado_validacion: 'candidata', origen: 'Isgró PI3 §§2-3', regla_crisp: 'ACC-RD06/RD07', orden: 2};

MERGE (n:AuditIA_PG2 {id: 'CONTR-RB3'})
ON CREATE SET n:ReglaDifusa, n += {id: 'CONTR-RB3', antecedente: 'min(xa, ym)', salida: 'media', estado_validacion: 'candidata', origen: 'Isgró PI3 §§2-3', regla_crisp: 'ACC-RD05', orden: 3};

MERGE (n:AuditIA_PG2 {id: 'CONTR-RB4'})
ON CREATE SET n:ReglaDifusa, n += {id: 'CONTR-RB4', antecedente: 'max(xb, yb)', salida: 'baja', estado_validacion: 'candidata', origen: 'Isgró PI3 §§2-3', regla_crisp: 'ACC-RD03/RD18/RD19', orden: 4};

MERGE (n:AuditIA_PG2 {id: 'S-PI3-URG'})
ON CREATE SET n:Fuente, n += {id: 'S-PI3-URG', nombre: 'Lucero_Bruno_PI3_U1.pdf', tipo: 'documento', estado: 'consultada', contacto: 'Lucero_Bruno_PI3_U1.pdf', validez: 'Formalización candidata; sin calibración con expertos reales'};

MERGE (n:AuditIA_PG2 {id: 'MD-URG-1.0'})
ON CREATE SET n:ModeloDifuso, n += {id: 'MD-URG-1.0', nombre: 'Urgencia de atención', version: '1.0', estado_validacion: 'candidata', tipo: 'Mamdani', operador_and: 'min', operador_or: 'max', agregacion: 'max', desdifusificacion: 'centroide discreto', puntos: 1001, paso: 0.01, pi3_adjuntado: true, localizador: 'Lucero PI3 §§2-3'};

MERGE (n:AuditIA_PG2 {id: 'MD-URG-1.0-x'})
ON CREATE SET n:VariableDifusa, n += {id: 'MD-URG-1.0-x', nombre: 'Severidad_Base', rol: 'entrada', min: 0.0, max: 10.0, slot: 'F26.grado_severidad', modelo_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'MD-URG-1.0-x-baja'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-URG-1.0-x-baja', nombre: 'Baja', codigo: 'baja', centro: 0.0, sigma: 1.8, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-URG-1.0-x-media'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-URG-1.0-x-media', nombre: 'Media', codigo: 'media', centro: 5.0, sigma: 1.6, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-URG-1.0-x-alta'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-URG-1.0-x-alta', nombre: 'Alta', codigo: 'alta', centro: 10.0, sigma: 1.8, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-URG-1.0-y'})
ON CREATE SET n:VariableDifusa, n += {id: 'MD-URG-1.0-y', nombre: 'Criticidad_Requerimiento', rol: 'entrada', min: 0.0, max: 10.0, slot: 'F27.grado_criticidad', modelo_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'MD-URG-1.0-y-baja'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-URG-1.0-y-baja', nombre: 'Baja', codigo: 'baja', centro: 0.0, sigma: 1.8, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-URG-1.0-y-media'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-URG-1.0-y-media', nombre: 'Media', codigo: 'media', centro: 5.0, sigma: 1.6, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-URG-1.0-y-alta'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-URG-1.0-y-alta', nombre: 'Alta', codigo: 'alta', centro: 10.0, sigma: 1.8, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-URG-1.0-z'})
ON CREATE SET n:VariableDifusa, n += {id: 'MD-URG-1.0-z', nombre: 'Urgencia_Atencion', rol: 'salida', min: 0.0, max: 10.0, slot: 'F29.grado_urgencia', modelo_version: 'MD-URG-1.0'};

MERGE (n:AuditIA_PG2 {id: 'MD-URG-1.0-z-baja'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-URG-1.0-z-baja', nombre: 'Baja', codigo: 'baja', centro: 0.0, sigma: 1.8, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-URG-1.0-z-media'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-URG-1.0-z-media', nombre: 'Media', codigo: 'media', centro: 5.0, sigma: 1.5, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'MD-URG-1.0-z-alta'})
ON CREATE SET n:EtiquetaDifusa, n += {id: 'MD-URG-1.0-z-alta', nombre: 'Alta', codigo: 'alta', centro: 10.0, sigma: 1.8, funcion: 'gaussiana', estado_validacion: 'candidata'};

MERGE (n:AuditIA_PG2 {id: 'URG-RB1'})
ON CREATE SET n:ReglaDifusa, n += {id: 'URG-RB1', antecedente: 'min(ya, max(xm, xa))', salida: 'alta', estado_validacion: 'candidata', origen: 'Lucero PI3 §§2-3', regla_crisp: 'PRC-HC03', orden: 1};

MERGE (n:AuditIA_PG2 {id: 'URG-RB2'})
ON CREATE SET n:ReglaDifusa, n += {id: 'URG-RB2', antecedente: 'min(xa, ym)', salida: 'alta', estado_validacion: 'candidata', origen: 'Lucero PI3 §§2-3', regla_crisp: 'PRC-HC03', orden: 2};

MERGE (n:AuditIA_PG2 {id: 'URG-RB3'})
ON CREATE SET n:ReglaDifusa, n += {id: 'URG-RB3', antecedente: 'min(xb, ya)', salida: 'alta', estado_validacion: 'candidata', origen: 'Lucero PI3 §§2-3', regla_crisp: 'PRC-HC02', orden: 3};

MERGE (n:AuditIA_PG2 {id: 'URG-RB4'})
ON CREATE SET n:ReglaDifusa, n += {id: 'URG-RB4', antecedente: 'min(xm, max(ym, yb))', salida: 'media', estado_validacion: 'candidata', origen: 'Lucero PI3 §§2-3', regla_crisp: 'PRC-HC04', orden: 4};

MERGE (n:AuditIA_PG2 {id: 'URG-RB5'})
ON CREATE SET n:ReglaDifusa, n += {id: 'URG-RB5', antecedente: 'max(min(xa, yb), min(xb, ym))', salida: 'media', estado_validacion: 'candidata', origen: 'Lucero PI3 §§2-3', regla_crisp: 'MPR-01', orden: 5};

MERGE (n:AuditIA_PG2 {id: 'URG-RB6'})
ON CREATE SET n:ReglaDifusa, n += {id: 'URG-RB6', antecedente: 'min(xb, yb)', salida: 'baja', estado_validacion: 'candidata', origen: 'Lucero PI3 §§2-3', regla_crisp: 'PRC-HC05', orden: 6};

MATCH (a:AuditIA_PG2 {id: 'F10'}), (b:AuditIA_PG2 {id: 'F09'})
MERGE (a)-[r:ES_UN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'F15'}), (b:AuditIA_PG2 {id: 'F09'})
MERGE (a)-[r:ES_UN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'F23'}), (b:AuditIA_PG2 {id: 'F22'})
MERGE (a)-[r:ES_UN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'F24'}), (b:AuditIA_PG2 {id: 'F22'})
MERGE (a)-[r:ES_UN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'F25'}), (b:AuditIA_PG2 {id: 'F22'})
MERGE (a)-[r:ES_UN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'GL01'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'GL02'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'GL03'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'GL04'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'GL05'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'GL06'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'GL07'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'GL08'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'GL09'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-RD03'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-RD04'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-RD05'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-RD06'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-HC01'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-HC02'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-HC03'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-HC04'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-HC05'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-HC06'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-HC07'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-HC08'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-HC09'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-HC10'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EVI-HC11'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD03'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD04'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD05'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD06'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD07'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD08'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD09'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD10'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD11'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD12'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD13'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD14'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD15'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD16'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD18'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-RD19'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-HC01'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-HC02'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-HC03'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ACC-HC04'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CAT-EX-SEG'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CAT-EX-PARC'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-RD01'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-RD02'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-RD03'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-RD04'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-RD06'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-RD07'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-RD08'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-RD09'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-RD10'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-RD11'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-RD12'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-RD13'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-HC01'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-HC02'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-HC03'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-HC04'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-HC05'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-HC06'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-HC07'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PRC-HC08'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CQ-atomicidad'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CQ-ambiguedad'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CQ-verificabilidad'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CQ-completitud'}), (b:AuditIA_PG2 {id: 'S-PG1'})
MERGE (a)-[r:SE_FUNDAMENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-CAT-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-CAT-v1'}), (b:AuditIA_PG2 {id: 'RQ-CAT-v1'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-CAT-v1'}), (b:AuditIA_PG2 {id: 'CTX-RQ-CAT-v1'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-CAT-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-CAT-01'}), (b:AuditIA_PG2 {id: 'DOC-CAT-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-CAT-01'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-CAT-01'}), (b:AuditIA_PG2 {id: 'E-EV-CAT-01'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-CAT-01'}), (b:AuditIA_PG2 {id: 'RQ-CAT-v1'})
MERGE (a)-[r:EVALUA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-CAT-01'}), (b:AuditIA_PG2 {id: 'J-EV-CAT-01-atomicidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-01-atomicidad'}), (b:AuditIA_PG2 {id: 'CQ-atomicidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-01-atomicidad'}), (b:AuditIA_PG2 {id: 'E-RQ-CAT-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-CAT-01'}), (b:AuditIA_PG2 {id: 'J-EV-CAT-01-ambiguedad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-01-ambiguedad'}), (b:AuditIA_PG2 {id: 'CQ-ambiguedad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-01-ambiguedad'}), (b:AuditIA_PG2 {id: 'E-RQ-CAT-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-CAT-01'}), (b:AuditIA_PG2 {id: 'J-EV-CAT-01-verificabilidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-01-verificabilidad'}), (b:AuditIA_PG2 {id: 'CQ-verificabilidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-01-verificabilidad'}), (b:AuditIA_PG2 {id: 'E-RQ-CAT-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-CAT-01'}), (b:AuditIA_PG2 {id: 'J-EV-CAT-01-completitud'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-01-completitud'}), (b:AuditIA_PG2 {id: 'CQ-completitud'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-01-completitud'}), (b:AuditIA_PG2 {id: 'E-RQ-CAT-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-CAT-v2'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-CAT-v2'}), (b:AuditIA_PG2 {id: 'DOC-CAT-v1'})
MERGE (a)-[r:ACTUALIZA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-CAT-v2'}), (b:AuditIA_PG2 {id: 'RQ-CAT-v2'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-CAT-v2'}), (b:AuditIA_PG2 {id: 'CTX-RQ-CAT-v2'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-CAT-v2'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-CAT-02'}), (b:AuditIA_PG2 {id: 'DOC-CAT-v2'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-CAT-02'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-CAT-02'}), (b:AuditIA_PG2 {id: 'E-EV-CAT-02'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-CAT-02'}), (b:AuditIA_PG2 {id: 'RQ-CAT-v2'})
MERGE (a)-[r:EVALUA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-CAT-02'}), (b:AuditIA_PG2 {id: 'J-EV-CAT-02-atomicidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-02-atomicidad'}), (b:AuditIA_PG2 {id: 'CQ-atomicidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-02-atomicidad'}), (b:AuditIA_PG2 {id: 'E-RQ-CAT-v2'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-CAT-02'}), (b:AuditIA_PG2 {id: 'J-EV-CAT-02-ambiguedad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-02-ambiguedad'}), (b:AuditIA_PG2 {id: 'CQ-ambiguedad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-02-ambiguedad'}), (b:AuditIA_PG2 {id: 'E-RQ-CAT-v2'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-CAT-02'}), (b:AuditIA_PG2 {id: 'J-EV-CAT-02-verificabilidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-02-verificabilidad'}), (b:AuditIA_PG2 {id: 'CQ-verificabilidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-02-verificabilidad'}), (b:AuditIA_PG2 {id: 'E-RQ-CAT-v2'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-CAT-02'}), (b:AuditIA_PG2 {id: 'J-EV-CAT-02-completitud'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-02-completitud'}), (b:AuditIA_PG2 {id: 'CQ-completitud'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-CAT-02-completitud'}), (b:AuditIA_PG2 {id: 'E-RQ-CAT-v2'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CTX-RQ-CAT-v2'}), (b:AuditIA_PG2 {id: 'CA-CAT-02'})
MERGE (a)-[r:DECLARA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CA-CAT-02'}), (b:AuditIA_PG2 {id: 'E-RQ-CAT-v2'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-DESC-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-DESC-v1'}), (b:AuditIA_PG2 {id: 'RQ-DESC-A-v1'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-DESC-A-v1'}), (b:AuditIA_PG2 {id: 'CTX-RQ-DESC-A-v1'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-DESC-A-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-DESC-A-v1'}), (b:AuditIA_PG2 {id: 'O-RQ-DESC-A-v1'})
MERGE (a)-[r:EXPRESA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'O-RQ-DESC-A-v1'}), (b:AuditIA_PG2 {id: 'ESC-RQ-DESC-A-v1'})
MERGE (a)-[r:APLICA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'O-RQ-DESC-A-v1'}), (b:AuditIA_PG2 {id: 'E-RQ-DESC-A-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ESC-RQ-DESC-A-v1'}), (b:AuditIA_PG2 {id: 'COND-RQ-DESC-A-v1'})
MERGE (a)-[r:DELIMITADO_POR]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'COND-RQ-DESC-A-v1'}), (b:AuditIA_PG2 {id: 'E-RQ-DESC-A-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-DESC-v1'}), (b:AuditIA_PG2 {id: 'RQ-DESC-B-v1'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-DESC-B-v1'}), (b:AuditIA_PG2 {id: 'CTX-RQ-DESC-B-v1'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-DESC-B-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-DESC-B-v1'}), (b:AuditIA_PG2 {id: 'O-RQ-DESC-B-v1'})
MERGE (a)-[r:EXPRESA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'O-RQ-DESC-B-v1'}), (b:AuditIA_PG2 {id: 'ESC-RQ-DESC-B-v1'})
MERGE (a)-[r:APLICA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'O-RQ-DESC-B-v1'}), (b:AuditIA_PG2 {id: 'E-RQ-DESC-B-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'ESC-RQ-DESC-B-v1'}), (b:AuditIA_PG2 {id: 'COND-RQ-DESC-B-v1'})
MERGE (a)-[r:DELIMITADO_POR]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'COND-RQ-DESC-B-v1'}), (b:AuditIA_PG2 {id: 'E-RQ-DESC-B-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-DESC'}), (b:AuditIA_PG2 {id: 'DOC-DESC-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-DESC'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-DESC'}), (b:AuditIA_PG2 {id: 'E-EV-DESC'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-DESC'}), (b:AuditIA_PG2 {id: 'RQ-DESC-A-v1'})
MERGE (a)-[r:COMPARA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-DESC'}), (b:AuditIA_PG2 {id: 'RQ-DESC-B-v1'})
MERGE (a)-[r:COMPARA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-DESC-CONTROL'}), (b:AuditIA_PG2 {id: 'DOC-DESC-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-DESC-CONTROL'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-DESC-CONTROL'}), (b:AuditIA_PG2 {id: 'E-EV-DESC-CONTROL'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-DESC-CONTROL'}), (b:AuditIA_PG2 {id: 'RQ-DESC-A-v1'})
MERGE (a)-[r:COMPARA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-DESC-CONTROL'}), (b:AuditIA_PG2 {id: 'RQ-DESC-B-v1'})
MERGE (a)-[r:COMPARA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-TASA-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-TASA-v1'}), (b:AuditIA_PG2 {id: 'RQ-TASA-v1'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-TASA-v1'}), (b:AuditIA_PG2 {id: 'CTX-RQ-TASA-v1'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-TASA-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EN-TASA-v1'}), (b:AuditIA_PG2 {id: 'E-RQ-TASA-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DEP-TASA-v1'}), (b:AuditIA_PG2 {id: 'RQ-TASA-v1'})
MERGE (a)-[r:TIENE_ORIGEN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DEP-TASA-v1'}), (b:AuditIA_PG2 {id: 'EN-TASA-v1'})
MERGE (a)-[r:REQUIERE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-TASA-1'}), (b:AuditIA_PG2 {id: 'DOC-TASA-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-TASA-1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-TASA-1'}), (b:AuditIA_PG2 {id: 'E-EV-TASA-1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-TASA-1'}), (b:AuditIA_PG2 {id: 'DEP-TASA-v1'})
MERGE (a)-[r:RASTREA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-TASA-v2'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-TASA-v2'}), (b:AuditIA_PG2 {id: 'RQ-TASA-v2'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-TASA-v2'}), (b:AuditIA_PG2 {id: 'CTX-RQ-TASA-v2'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-TASA-v2'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EN-TASA-v2'}), (b:AuditIA_PG2 {id: 'E-RQ-TASA-v2'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DEP-TASA-v2'}), (b:AuditIA_PG2 {id: 'RQ-TASA-v2'})
MERGE (a)-[r:TIENE_ORIGEN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DEP-TASA-v2'}), (b:AuditIA_PG2 {id: 'EN-TASA-v2'})
MERGE (a)-[r:REQUIERE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-TASA-2'}), (b:AuditIA_PG2 {id: 'DOC-TASA-v2'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-TASA-2'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-TASA-2'}), (b:AuditIA_PG2 {id: 'E-EV-TASA-2'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-TASA-2'}), (b:AuditIA_PG2 {id: 'DEP-TASA-v2'})
MERGE (a)-[r:RASTREA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-TASA-v2'}), (b:AuditIA_PG2 {id: 'DOC-TASA-v1'})
MERGE (a)-[r:ACTUALIZA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-TASA-v2'}), (b:AuditIA_PG2 {id: 'RQ-DEF-TASA-v2'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-DEF-TASA-v2'}), (b:AuditIA_PG2 {id: 'CTX-RQ-DEF-TASA-v2'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-DEF-TASA-v2'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DEP-TASA-v2'}), (b:AuditIA_PG2 {id: 'RQ-DEF-TASA-v2'})
MERGE (a)-[r:RESUELTA_POR]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-SEG-BRECHA-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-SEG-BRECHA-v1'}), (b:AuditIA_PG2 {id: 'RQ-SEG-BRECHA-v1'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-SEG-BRECHA-v1'}), (b:AuditIA_PG2 {id: 'CTX-RQ-SEG-BRECHA-v1'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-SEG-BRECHA-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-PERFIL-BRECHA'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PERFIL-BRECHA'}), (b:AuditIA_PG2 {id: 'E-PERFIL-BRECHA'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-SEG-BRECHA'}), (b:AuditIA_PG2 {id: 'DOC-SEG-BRECHA-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-SEG-BRECHA'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-SEG-BRECHA'}), (b:AuditIA_PG2 {id: 'E-EV-SEG-BRECHA'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-SEG-BRECHA'}), (b:AuditIA_PG2 {id: 'PERFIL-BRECHA'})
MERGE (a)-[r:USA_PERFIL]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-SEG-BRECHA'}), (b:AuditIA_PG2 {id: 'NFR-SEG'})
MERGE (a)-[r:EVALUA_CATEGORIA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-SEG-OK-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-SEG-OK-v1'}), (b:AuditIA_PG2 {id: 'RQ-SEG-OK-v1'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-SEG-OK-v1'}), (b:AuditIA_PG2 {id: 'CTX-RQ-SEG-OK-v1'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-SEG-OK-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-PERFIL-OK'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PERFIL-OK'}), (b:AuditIA_PG2 {id: 'E-PERFIL-OK'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-SEG-OK'}), (b:AuditIA_PG2 {id: 'DOC-SEG-OK-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-SEG-OK'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-SEG-OK'}), (b:AuditIA_PG2 {id: 'E-EV-SEG-OK'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-SEG-OK'}), (b:AuditIA_PG2 {id: 'PERFIL-OK'})
MERGE (a)-[r:USA_PERFIL]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-SEG-OK'}), (b:AuditIA_PG2 {id: 'NFR-SEG'})
MERGE (a)-[r:EVALUA_CATEGORIA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-SEG-OK'}), (b:AuditIA_PG2 {id: 'RQ-SEG-OK-v1'})
MERGE (a)-[r:VINCULA_COBERTURA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-SEG-DESCONOCIDO-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-SEG-DESCONOCIDO-v1'}), (b:AuditIA_PG2 {id: 'RQ-SEG-DESCONOCIDO-v1'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-SEG-DESCONOCIDO-v1'}), (b:AuditIA_PG2 {id: 'CTX-RQ-SEG-DESCONOCIDO-v1'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-SEG-DESCONOCIDO-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-PERFIL-DESCONOCIDO'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'PERFIL-DESCONOCIDO'}), (b:AuditIA_PG2 {id: 'E-PERFIL-DESCONOCIDO'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-SEG-DESCONOCIDO'}), (b:AuditIA_PG2 {id: 'DOC-SEG-DESCONOCIDO-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-SEG-DESCONOCIDO'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-SEG-DESCONOCIDO'}), (b:AuditIA_PG2 {id: 'E-EV-SEG-DESCONOCIDO'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-SEG-DESCONOCIDO'}), (b:AuditIA_PG2 {id: 'PERFIL-DESCONOCIDO'})
MERGE (a)-[r:USA_PERFIL]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-SEG-DESCONOCIDO'}), (b:AuditIA_PG2 {id: 'NFR-SEG'})
MERGE (a)-[r:EVALUA_CATEGORIA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-ERROR-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-ERROR-v1'}), (b:AuditIA_PG2 {id: 'RQ-ERROR-v1'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-ERROR-v1'}), (b:AuditIA_PG2 {id: 'CTX-RQ-ERROR-v1'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-ERROR-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-ERROR'}), (b:AuditIA_PG2 {id: 'DOC-ERROR-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-ERROR'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-ERROR'}), (b:AuditIA_PG2 {id: 'E-EV-ERROR'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-ERROR'}), (b:AuditIA_PG2 {id: 'RQ-ERROR-v1'})
MERGE (a)-[r:EVALUA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-X-CAT'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'X-CAT'}), (b:AuditIA_PG2 {id: 'E-X-CAT'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CR-CAT'}), (b:AuditIA_PG2 {id: 'E-X-CAT'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-X-CAT-PV'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'X-CAT-PV'}), (b:AuditIA_PG2 {id: 'E-X-CAT-PV'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CR-CAT-PV'}), (b:AuditIA_PG2 {id: 'E-X-CAT-PV'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-X-CAT-PC'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'X-CAT-PC'}), (b:AuditIA_PG2 {id: 'E-X-CAT-PC'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CR-CAT-PC'}), (b:AuditIA_PG2 {id: 'E-X-CAT-PC'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-X-DESC'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'X-DESC'}), (b:AuditIA_PG2 {id: 'E-X-DESC'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CR-DESC'}), (b:AuditIA_PG2 {id: 'E-X-DESC'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-X-TASA'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'X-TASA'}), (b:AuditIA_PG2 {id: 'E-X-TASA'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CR-TASA'}), (b:AuditIA_PG2 {id: 'E-X-TASA'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-X-SEG'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'X-SEG'}), (b:AuditIA_PG2 {id: 'E-X-SEG'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CR-SEG'}), (b:AuditIA_PG2 {id: 'E-X-SEG'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-X-SEG-P'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'X-SEG-P'}), (b:AuditIA_PG2 {id: 'E-X-SEG-P'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CR-SEG-P'}), (b:AuditIA_PG2 {id: 'E-X-SEG-P'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-PRIO-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-PRIO-v1'}), (b:AuditIA_PG2 {id: 'RQ-PRIO-v1'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-PRIO-v1'}), (b:AuditIA_PG2 {id: 'CTX-RQ-PRIO-v1'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-MAYOR'}), (b:AuditIA_PG2 {id: 'DOC-PRIO-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-PRIO-MAYOR'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-MAYOR'}), (b:AuditIA_PG2 {id: 'E-EV-PRIO-MAYOR'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-MAYOR'}), (b:AuditIA_PG2 {id: 'RQ-PRIO-v1'})
MERGE (a)-[r:EVALUA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-MAYOR'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-atomicidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-atomicidad'}), (b:AuditIA_PG2 {id: 'CQ-atomicidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-atomicidad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-MAYOR'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-ambiguedad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-ambiguedad'}), (b:AuditIA_PG2 {id: 'CQ-ambiguedad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-ambiguedad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-MAYOR'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-verificabilidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-verificabilidad'}), (b:AuditIA_PG2 {id: 'CQ-verificabilidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-verificabilidad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-MAYOR'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-completitud'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-completitud'}), (b:AuditIA_PG2 {id: 'CQ-completitud'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MAYOR-completitud'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-X-MAYOR'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'X-MAYOR'}), (b:AuditIA_PG2 {id: 'E-X-MAYOR'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CR-MAYOR'}), (b:AuditIA_PG2 {id: 'E-X-MAYOR'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-MENOR'}), (b:AuditIA_PG2 {id: 'DOC-PRIO-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-PRIO-MENOR'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-MENOR'}), (b:AuditIA_PG2 {id: 'E-EV-PRIO-MENOR'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-MENOR'}), (b:AuditIA_PG2 {id: 'RQ-PRIO-v1'})
MERGE (a)-[r:EVALUA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-MENOR'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-atomicidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-atomicidad'}), (b:AuditIA_PG2 {id: 'CQ-atomicidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-atomicidad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-MENOR'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-ambiguedad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-ambiguedad'}), (b:AuditIA_PG2 {id: 'CQ-ambiguedad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-ambiguedad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-MENOR'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-verificabilidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-verificabilidad'}), (b:AuditIA_PG2 {id: 'CQ-verificabilidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-verificabilidad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-MENOR'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-completitud'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-completitud'}), (b:AuditIA_PG2 {id: 'CQ-completitud'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-MENOR-completitud'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-X-MENOR'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'X-MENOR'}), (b:AuditIA_PG2 {id: 'E-X-MENOR'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CR-MENOR'}), (b:AuditIA_PG2 {id: 'E-X-MENOR'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-EXCEPCION'}), (b:AuditIA_PG2 {id: 'DOC-PRIO-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-PRIO-EXCEPCION'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-EXCEPCION'}), (b:AuditIA_PG2 {id: 'E-EV-PRIO-EXCEPCION'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-EXCEPCION'}), (b:AuditIA_PG2 {id: 'RQ-PRIO-v1'})
MERGE (a)-[r:EVALUA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-EXCEPCION'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-atomicidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-atomicidad'}), (b:AuditIA_PG2 {id: 'CQ-atomicidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-atomicidad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-EXCEPCION'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-ambiguedad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-ambiguedad'}), (b:AuditIA_PG2 {id: 'CQ-ambiguedad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-ambiguedad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-EXCEPCION'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-verificabilidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-verificabilidad'}), (b:AuditIA_PG2 {id: 'CQ-verificabilidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-verificabilidad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-EXCEPCION'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-completitud'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-completitud'}), (b:AuditIA_PG2 {id: 'CQ-completitud'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-EXCEPCION-completitud'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-X-EXCEPCION'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'X-EXCEPCION'}), (b:AuditIA_PG2 {id: 'E-X-EXCEPCION'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CR-EXCEPCION'}), (b:AuditIA_PG2 {id: 'E-X-EXCEPCION'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-FRONTERA'}), (b:AuditIA_PG2 {id: 'DOC-PRIO-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-PRIO-FRONTERA'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-FRONTERA'}), (b:AuditIA_PG2 {id: 'E-EV-PRIO-FRONTERA'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-FRONTERA'}), (b:AuditIA_PG2 {id: 'RQ-PRIO-v1'})
MERGE (a)-[r:EVALUA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-FRONTERA'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-atomicidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-atomicidad'}), (b:AuditIA_PG2 {id: 'CQ-atomicidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-atomicidad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-FRONTERA'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-ambiguedad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-ambiguedad'}), (b:AuditIA_PG2 {id: 'CQ-ambiguedad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-ambiguedad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-FRONTERA'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-verificabilidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-verificabilidad'}), (b:AuditIA_PG2 {id: 'CQ-verificabilidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-verificabilidad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-FRONTERA'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-completitud'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-completitud'}), (b:AuditIA_PG2 {id: 'CQ-completitud'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FRONTERA-completitud'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-X-FRONTERA'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'X-FRONTERA'}), (b:AuditIA_PG2 {id: 'E-X-FRONTERA'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CR-FRONTERA'}), (b:AuditIA_PG2 {id: 'E-X-FRONTERA'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-SIN-HITO'}), (b:AuditIA_PG2 {id: 'DOC-PRIO-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-PRIO-SIN-HITO'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-SIN-HITO'}), (b:AuditIA_PG2 {id: 'E-EV-PRIO-SIN-HITO'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-SIN-HITO'}), (b:AuditIA_PG2 {id: 'RQ-PRIO-v1'})
MERGE (a)-[r:EVALUA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-SIN-HITO'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-atomicidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-atomicidad'}), (b:AuditIA_PG2 {id: 'CQ-atomicidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-atomicidad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-SIN-HITO'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-ambiguedad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-ambiguedad'}), (b:AuditIA_PG2 {id: 'CQ-ambiguedad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-ambiguedad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-SIN-HITO'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-verificabilidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-verificabilidad'}), (b:AuditIA_PG2 {id: 'CQ-verificabilidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-verificabilidad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-SIN-HITO'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-completitud'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-completitud'}), (b:AuditIA_PG2 {id: 'CQ-completitud'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-SIN-HITO-completitud'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-X-SIN-HITO'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'X-SIN-HITO'}), (b:AuditIA_PG2 {id: 'E-X-SIN-HITO'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CR-SIN-HITO'}), (b:AuditIA_PG2 {id: 'E-X-SIN-HITO'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-FUERA-RANGO'}), (b:AuditIA_PG2 {id: 'DOC-PRIO-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-PRIO-FUERA-RANGO'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-FUERA-RANGO'}), (b:AuditIA_PG2 {id: 'E-EV-PRIO-FUERA-RANGO'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-FUERA-RANGO'}), (b:AuditIA_PG2 {id: 'RQ-PRIO-v1'})
MERGE (a)-[r:EVALUA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-FUERA-RANGO'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-atomicidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-atomicidad'}), (b:AuditIA_PG2 {id: 'CQ-atomicidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-atomicidad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-FUERA-RANGO'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-ambiguedad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-ambiguedad'}), (b:AuditIA_PG2 {id: 'CQ-ambiguedad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-ambiguedad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-FUERA-RANGO'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-verificabilidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-verificabilidad'}), (b:AuditIA_PG2 {id: 'CQ-verificabilidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-verificabilidad'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PRIO-FUERA-RANGO'}), (b:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-completitud'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-completitud'}), (b:AuditIA_PG2 {id: 'CQ-completitud'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-PRIO-FUERA-RANGO-completitud'}), (b:AuditIA_PG2 {id: 'E-RQ-PRIO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-X-FUERA-RANGO'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'X-FUERA-RANGO'}), (b:AuditIA_PG2 {id: 'E-X-FUERA-RANGO'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CR-FUERA-RANGO'}), (b:AuditIA_PG2 {id: 'E-X-FUERA-RANGO'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-HAB-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-HAB-v1'}), (b:AuditIA_PG2 {id: 'RQ-HAB-v1'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-HAB-v1'}), (b:AuditIA_PG2 {id: 'CTX-RQ-HAB-v1'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-HAB-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-HAB'}), (b:AuditIA_PG2 {id: 'DOC-HAB-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-HAB'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-HAB'}), (b:AuditIA_PG2 {id: 'E-EV-HAB'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-HAB'}), (b:AuditIA_PG2 {id: 'RQ-HAB-v1'})
MERGE (a)-[r:EVALUA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-HAB'}), (b:AuditIA_PG2 {id: 'J-EV-HAB-atomicidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-HAB-atomicidad'}), (b:AuditIA_PG2 {id: 'CQ-atomicidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-HAB-atomicidad'}), (b:AuditIA_PG2 {id: 'E-RQ-HAB-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-HAB'}), (b:AuditIA_PG2 {id: 'J-EV-HAB-ambiguedad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-HAB-ambiguedad'}), (b:AuditIA_PG2 {id: 'CQ-ambiguedad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-HAB-ambiguedad'}), (b:AuditIA_PG2 {id: 'E-RQ-HAB-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-HAB'}), (b:AuditIA_PG2 {id: 'J-EV-HAB-verificabilidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-HAB-verificabilidad'}), (b:AuditIA_PG2 {id: 'CQ-verificabilidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-HAB-verificabilidad'}), (b:AuditIA_PG2 {id: 'E-RQ-HAB-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-HAB'}), (b:AuditIA_PG2 {id: 'J-EV-HAB-completitud'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-HAB-completitud'}), (b:AuditIA_PG2 {id: 'CQ-completitud'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-HAB-completitud'}), (b:AuditIA_PG2 {id: 'E-RQ-HAB-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-HAB-GLOSARIO'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-HAB-ambiguedad'}), (b:AuditIA_PG2 {id: 'E-HAB-GLOSARIO'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-AMB-SIN-DATO-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-AMB-SIN-DATO-v1'}), (b:AuditIA_PG2 {id: 'RQ-AMB-SIN-DATO-v1'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-AMB-SIN-DATO-v1'}), (b:AuditIA_PG2 {id: 'CTX-RQ-AMB-SIN-DATO-v1'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-AMB-SIN-DATO-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-AMB-SIN-DATO'}), (b:AuditIA_PG2 {id: 'DOC-AMB-SIN-DATO-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-AMB-SIN-DATO'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-AMB-SIN-DATO'}), (b:AuditIA_PG2 {id: 'E-EV-AMB-SIN-DATO'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-AMB-SIN-DATO'}), (b:AuditIA_PG2 {id: 'RQ-AMB-SIN-DATO-v1'})
MERGE (a)-[r:EVALUA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-AMB-SIN-DATO'}), (b:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-atomicidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-atomicidad'}), (b:AuditIA_PG2 {id: 'CQ-atomicidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-atomicidad'}), (b:AuditIA_PG2 {id: 'E-RQ-AMB-SIN-DATO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-AMB-SIN-DATO'}), (b:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-ambiguedad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-ambiguedad'}), (b:AuditIA_PG2 {id: 'CQ-ambiguedad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-ambiguedad'}), (b:AuditIA_PG2 {id: 'E-RQ-AMB-SIN-DATO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-AMB-SIN-DATO'}), (b:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-verificabilidad'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-verificabilidad'}), (b:AuditIA_PG2 {id: 'CQ-verificabilidad'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-verificabilidad'}), (b:AuditIA_PG2 {id: 'E-RQ-AMB-SIN-DATO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-AMB-SIN-DATO'}), (b:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-completitud'})
MERGE (a)-[r:CONTIENE_JUICIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-completitud'}), (b:AuditIA_PG2 {id: 'CQ-completitud'})
MERGE (a)-[r:APLICA_CRITERIO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'J-EV-AMB-SIN-DATO-completitud'}), (b:AuditIA_PG2 {id: 'E-RQ-AMB-SIN-DATO-v1'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-PED-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-PED-v1'}), (b:AuditIA_PG2 {id: 'RQ-PED-A-v1'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-PED-A-v1'}), (b:AuditIA_PG2 {id: 'CTX-RQ-PED-A-v1'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-PED-A-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'DOC-PED-v1'}), (b:AuditIA_PG2 {id: 'RQ-PED-B-v1'})
MERGE (a)-[r:CONTIENE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'RQ-PED-B-v1'}), (b:AuditIA_PG2 {id: 'CTX-RQ-PED-B-v1'})
MERGE (a)-[r:SE_INTERPRETA_CON]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-RQ-PED-B-v1'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PED-FRONTERA'}), (b:AuditIA_PG2 {id: 'DOC-PED-v1'})
MERGE (a)-[r:REVISA_DOCUMENTO]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'E-EV-PED-FRONTERA'}), (b:AuditIA_PG2 {id: 'S-CASOS'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PED-FRONTERA'}), (b:AuditIA_PG2 {id: 'E-EV-PED-FRONTERA'})
MERGE (a)-[r:SE_SUSTENTA_EN]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PED-FRONTERA'}), (b:AuditIA_PG2 {id: 'RQ-PED-A-v1'})
MERGE (a)-[r:COMPARA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'EV-PED-FRONTERA'}), (b:AuditIA_PG2 {id: 'RQ-PED-B-v1'})
MERGE (a)-[r:COMPARA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0'}), (b:AuditIA_PG2 {id: 'S-PI3-AMB'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-x'})
MERGE (a)-[r:DEFINE_VARIABLE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0-x'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-x-baja'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0-x'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-x-media'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0-x'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-x-alta'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-y'})
MERGE (a)-[r:DEFINE_VARIABLE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0-y'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-y-baja'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0-y'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-y-media'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0-y'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-y-alta'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-z'})
MERGE (a)-[r:DEFINE_VARIABLE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0-z'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-z-baja'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0-z'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-z-media'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0-z'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-z-alta'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0'}), (b:AuditIA_PG2 {id: 'AMB-RB1'})
MERGE (a)-[r:DEFINE_REGLA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'AMB-RB1'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-z-alta'})
MERGE (a)-[r:CONSECUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'AMB-RB1'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-x-alta'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'AMB-RB1'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-y-baja'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0'}), (b:AuditIA_PG2 {id: 'AMB-RB2'})
MERGE (a)-[r:DEFINE_REGLA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'AMB-RB2'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-z-media'})
MERGE (a)-[r:CONSECUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'AMB-RB2'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-x-alta'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'AMB-RB2'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-y-media'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0'}), (b:AuditIA_PG2 {id: 'AMB-RB3'})
MERGE (a)-[r:DEFINE_REGLA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'AMB-RB3'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-z-media'})
MERGE (a)-[r:CONSECUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'AMB-RB3'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-x-media'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'AMB-RB3'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-y-baja'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'AMB-RB3'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-y-media'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-AMB-1.0'}), (b:AuditIA_PG2 {id: 'AMB-RB4'})
MERGE (a)-[r:DEFINE_REGLA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'AMB-RB4'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-z-baja'})
MERGE (a)-[r:CONSECUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'AMB-RB4'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-x-baja'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'AMB-RB4'}), (b:AuditIA_PG2 {id: 'MD-AMB-1.0-y-alta'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0'}), (b:AuditIA_PG2 {id: 'S-PI3-CONTR'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-x'})
MERGE (a)-[r:DEFINE_VARIABLE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0-x'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-x-baja'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0-x'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-x-media'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0-x'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-x-alta'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-y'})
MERGE (a)-[r:DEFINE_VARIABLE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0-y'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-y-baja'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0-y'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-y-media'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0-y'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-y-alta'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-z'})
MERGE (a)-[r:DEFINE_VARIABLE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0-z'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-z-baja'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0-z'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-z-media'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0-z'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-z-alta'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0'}), (b:AuditIA_PG2 {id: 'CONTR-RB1'})
MERGE (a)-[r:DEFINE_REGLA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CONTR-RB1'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-z-alta'})
MERGE (a)-[r:CONSECUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CONTR-RB1'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-x-alta'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CONTR-RB1'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-y-alta'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0'}), (b:AuditIA_PG2 {id: 'CONTR-RB2'})
MERGE (a)-[r:DEFINE_REGLA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CONTR-RB2'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-z-media'})
MERGE (a)-[r:CONSECUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CONTR-RB2'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-x-media'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CONTR-RB2'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-y-alta'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0'}), (b:AuditIA_PG2 {id: 'CONTR-RB3'})
MERGE (a)-[r:DEFINE_REGLA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CONTR-RB3'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-z-media'})
MERGE (a)-[r:CONSECUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CONTR-RB3'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-x-alta'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CONTR-RB3'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-y-media'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-CONTR-1.0'}), (b:AuditIA_PG2 {id: 'CONTR-RB4'})
MERGE (a)-[r:DEFINE_REGLA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CONTR-RB4'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-z-baja'})
MERGE (a)-[r:CONSECUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CONTR-RB4'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-x-baja'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'CONTR-RB4'}), (b:AuditIA_PG2 {id: 'MD-CONTR-1.0-y-baja'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0'}), (b:AuditIA_PG2 {id: 'S-PI3-URG'})
MERGE (a)-[r:CITA_FUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-x'})
MERGE (a)-[r:DEFINE_VARIABLE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0-x'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-x-baja'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0-x'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-x-media'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0-x'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-x-alta'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-y'})
MERGE (a)-[r:DEFINE_VARIABLE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0-y'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-y-baja'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0-y'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-y-media'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0-y'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-y-alta'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-z'})
MERGE (a)-[r:DEFINE_VARIABLE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0-z'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-z-baja'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0-z'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-z-media'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0-z'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-z-alta'})
MERGE (a)-[r:TIENE_ETIQUETA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0'}), (b:AuditIA_PG2 {id: 'URG-RB1'})
MERGE (a)-[r:DEFINE_REGLA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB1'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-z-alta'})
MERGE (a)-[r:CONSECUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB1'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-x-media'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB1'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-x-alta'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB1'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-y-alta'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0'}), (b:AuditIA_PG2 {id: 'URG-RB2'})
MERGE (a)-[r:DEFINE_REGLA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB2'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-z-alta'})
MERGE (a)-[r:CONSECUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB2'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-x-alta'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB2'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-y-media'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0'}), (b:AuditIA_PG2 {id: 'URG-RB3'})
MERGE (a)-[r:DEFINE_REGLA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB3'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-z-alta'})
MERGE (a)-[r:CONSECUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB3'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-x-baja'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB3'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-y-alta'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0'}), (b:AuditIA_PG2 {id: 'URG-RB4'})
MERGE (a)-[r:DEFINE_REGLA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB4'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-z-media'})
MERGE (a)-[r:CONSECUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB4'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-x-media'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB4'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-y-baja'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB4'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-y-media'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0'}), (b:AuditIA_PG2 {id: 'URG-RB5'})
MERGE (a)-[r:DEFINE_REGLA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB5'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-z-media'})
MERGE (a)-[r:CONSECUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB5'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-x-baja'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB5'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-x-alta'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB5'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-y-baja'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB5'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-y-media'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'MD-URG-1.0'}), (b:AuditIA_PG2 {id: 'URG-RB6'})
MERGE (a)-[r:DEFINE_REGLA]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB6'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-z-baja'})
MERGE (a)-[r:CONSECUENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB6'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-x-baja'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};

MATCH (a:AuditIA_PG2 {id: 'URG-RB6'}), (b:AuditIA_PG2 {id: 'MD-URG-1.0-y-baja'})
MERGE (a)-[r:ANTECEDENTE]->(b) ON CREATE SET r += {};
MATCH (n:AuditIA_PG2) WHERE n.fecha IS NOT NULL SET n.fecha=datetime(toString(n.fecha));

// ARCHIVO 03_inferencia_crisp.cypher
// GL01. Una entrada no fiel produce incidencia, nunca un hallazgo ni una prioridad.
MATCH (ev:AuditIA_PG2:Evaluacion {publicado:false, entrada_valida:false})
MERGE (i:AuditIA_PG2 {id:'IE-'+ev.id})
ON CREATE SET i:ResultadoAnalisis:IncidenciaEntrada, i.fecha=ev.fecha, i.version='1',
 i.modulo_origen=ev.modulo_origen, i.ambito='extraccion_documento',
 i.causa='perdida_negacion', i.descripcion='Normalización no fiel al original',
 i.accion_correccion='Cotejar y corregir la extracción', i.destinatario_rol='correccion_entrada'
MERGE (ev)-[:GENERA]->(i)
WITH ev,i MATCH (ev)-[:SE_SUSTENTA_EN]->(e:Evidencia),(r:AuditIA_PG2:Regla {id:'GL01'})
MERGE (i)-[:SE_SUSTENTA_EN]->(e) MERGE (i)-[:APLICA_REGLA]->(r)
MERGE (ev)-[:APLICA_REGLA]->(r) SET ev.estado='no_evaluable';

// SM1. Las premisas semánticas se cargan con evidencia explícita.
MATCH (ev:AuditIA_PG2:EvaluacionIndividual {publicado:false,entrada_valida:true})-[:CONTIENE_JUICIO]->(j)-[:APLICA_CRITERIO]->(c)
WITH ev,j,c, CASE
 WHEN c.nombre='verificabilidad' AND j.aceptacion_necesaria=true AND j.aceptacion_disponible=false THEN 'EVI-RD03'
 WHEN j.info_necesaria_identificada=true AND j.info_disponible=false THEN 'GL02'
 WHEN c.nombre='atomicidad' AND j.obligaciones_independientes=1 AND j.unidad_aceptacion_confirmada=true THEN 'EVI-HC08'
 WHEN c.nombre='ambiguedad' AND j.revision_semantica_completa=true AND j.lecturas_residuales>=2 AND j.delimitacion_confirmada=false THEN 'EVI-HC02'
 WHEN c.nombre='ambiguedad' AND j.revision_semantica_completa=true AND j.lecturas_residuales=1 THEN 'EVI-HC09'
 WHEN c.nombre='verificabilidad' AND j.comprobacion_definida=true THEN 'EVI-HC04'
 WHEN c.nombre='completitud' AND j.informacion_aplicable_identificada=true AND j.omisiones_demostradas=0 THEN 'EVI-HC10'
 ELSE null END AS regla
WHERE regla IS NOT NULL
MATCH (r:AuditIA_PG2:Regla {id:regla})
SET j.estado=CASE WHEN regla IN ['EVI-RD03','GL02'] THEN 'pendiente' WHEN regla='EVI-HC02' THEN 'incumple' ELSE 'cumple' END
MERGE (j)-[:APLICA_REGLA]->(r);

MATCH (ev:AuditIA_PG2:EvaluacionIndividual {publicado:false,entrada_valida:true})-[:CONTIENE_JUICIO]->(j)
WITH ev,collect(j) AS js
WHERE size(js)=4 AND all(x IN js WHERE x.estado IN ['cumple','incumple','pendiente'])
WITH ev,js,CASE WHEN any(x IN js WHERE x.estado='incumple') THEN 'EVI-RD04'
 WHEN any(x IN js WHERE x.estado='pendiente') THEN 'EVI-RD05' ELSE 'EVI-RD06' END AS rid
MATCH (r:AuditIA_PG2:Regla {id:rid})
SET ev.estado=CASE rid WHEN 'EVI-RD04' THEN 'observado' WHEN 'EVI-RD05' THEN 'pendiente' ELSE 'sin_hallazgo' END
MERGE (ev)-[:APLICA_REGLA]->(r);

// Materialización local. Se preserva un resultado por juicio que requiere tratamiento.
MATCH (ev:AuditIA_PG2:EvaluacionIndividual {publicado:false,entrada_valida:true})-[:CONTIENE_JUICIO]->(j)-[:APLICA_CRITERIO]->(c), (ev)-[:EVALUA]->(rq)
WHERE j.estado IN ['incumple','pendiente']
WITH ev,j,c,rq,CASE
 WHEN ev.id='EV-CAT-01' THEN CASE c.nombre WHEN 'ambiguedad' THEN 'H-CAT-B' WHEN 'verificabilidad' THEN 'P-CAT-V' ELSE 'P-CAT-C' END
 WHEN ev.id STARTS WITH 'EV-PRIO-' AND j.estado='incumple' THEN replace(ev.id,'EV-','H-')
 ELSE 'R-'+j.id END AS oid
MERGE (o:AuditIA_PG2 {id:oid})
ON CREATE SET o:ResultadoAnalisis, o.fecha=ev.fecha, o.version='1',o.modulo_origen='evaluacion_individual',
 o.descripcion=j.justificacion,o.procedencia_coherente=true,o.destinatario_rol='priorizacion_clarificacion'
FOREACH (_ IN CASE WHEN j.estado='incumple' THEN [1] ELSE [] END | SET o:Hallazgo,o.tipo_defecto=c.nombre,o.descripcion_defecto='Dos lecturas con aceptación diferente')
FOREACH (_ IN CASE WHEN j.estado='pendiente' THEN [1] ELSE [] END | SET o:Pendiente,o.motivo_pendiente='aceptacion_no_recibida',o.dato_faltante='Criterio de aceptación y alcance',o.interpretaciones=[])
MERGE (ev)-[:GENERA]->(o) MERGE (o)-[:DERIVA_DE_JUICIO]->(j) MERGE (o)-[:AFECTA_REQUERIMIENTO]->(rq)
WITH ev,j,o MATCH (j)-[:SE_SUSTENTA_EN]->(e),(j)-[:APLICA_REGLA]->(r)
MERGE (o)-[:SE_SUSTENTA_EN]->(e) MERGE (o)-[:APLICA_REGLA]->(r);

// SM2 comparación. Excepciones y control semántico preceden al defecto.
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {tipo_analisis:'comparacion',publicado:false,entrada_valida:true})
WHERE ev.datos_controlados=true AND ev.interpretacion_cerrada=true
WITH ev,CASE WHEN ev.escenarios='excluyentes' THEN 'ACC-RD03'
 WHEN ev.escenarios='coincidentes' AND ev.resultados_incompatibles=true AND ev.excepcion_resuelve=false THEN 'ACC-RD05' ELSE null END AS rid
WHERE rid IS NOT NULL MATCH (r:AuditIA_PG2:Regla {id:rid})
SET ev.estado=CASE rid WHEN 'ACC-RD05' THEN 'observado' ELSE 'sin_hallazgo' END
MERGE (ev)-[:APLICA_REGLA]->(r);
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {id:'EV-DESC',publicado:false,estado:'observado'})-[:COMPARA]->(rq)
MERGE (h:AuditIA_PG2 {id:'H-DESC'}) ON CREATE SET h:ResultadoAnalisis:Hallazgo,
 h.fecha=ev.fecha,h.version='1',h.modulo_origen='analisis_cruzado',h.tipo_defecto='contradiccion',
 h.descripcion='La misma venta exige precio con y sin descuento',h.descripcion_defecto='Resultados incompatibles en el mismo escenario',h.destinatario_rol='priorizacion_clarificacion',h.procedencia_coherente=true
MERGE (ev)-[:GENERA]->(h) MERGE (h)-[:AFECTA_REQUERIMIENTO]->(rq)
WITH ev,h MATCH (ev)-[:APLICA_REGLA]->(r),(ev)-[:SE_SUSTENTA_EN]->(e)
MERGE (h)-[:APLICA_REGLA]->(r) MERGE (h)-[:SE_SUSTENTA_EN]->(e);
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {id:'EV-DESC',estado:'observado'})-[:COMPARA]->(a),(ev)-[:COMPARA]->(b)
WHERE a.id<b.id
MERGE (a)-[:CONTRADICE {evaluacion_id:ev.id,regla_id:'ACC-RD05',version:'1',ambito:'misma venta A'}]->(b);

// Fragmentos literales del par como evidencia adicional del hallazgo.
MATCH (ev:AuditIA_PG2:Evaluacion {id:'EV-DESC'})-[:GENERA]->(h),
      (ev)-[:COMPARA]->(rq),(e:AuditIA_PG2:Evidencia {id:'E-'+rq.id})
MERGE (h)-[:SE_SUSTENTA_EN]->(e);

// ACC-RD07. La frontera no se confirma como hallazgo por un grado intermedio.
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {tipo_analisis:'comparacion',publicado:false,entrada_valida:true,interpretacion_cerrada:false})
MATCH (r:AuditIA_PG2:Regla {id:'ACC-RD07'})
SET ev.estado='pendiente' MERGE (ev)-[:APLICA_REGLA]->(r)
MERGE (o:AuditIA_PG2 {id:'P-PED-FRONTERA'})
ON CREATE SET o:ResultadoAnalisis:Pendiente,o.fecha=ev.fecha,o.version='1',o.modulo_origen='analisis_cruzado',o.motivo_pendiente='frontera_semantica',o.dato_faltante='Precisar el intervalo entre preparación y despacho',o.descripcion='Solapamiento temporal no delimitado',o.destinatario_rol='revision_experta',o.procedencia_coherente=true
MERGE (ev)-[:GENERA]->(o) MERGE (o)-[:APLICA_REGLA]->(r)
WITH ev,o MATCH (ev)-[:COMPARA]->(rq),(ev)-[:SE_SUSTENTA_EN]->(e)
MERGE (o)-[:AFECTA_REQUERIMIENTO]->(rq) MERGE (o)-[:SE_SUSTENTA_EN]->(e);

// Dependencia. Un anexo no recibido no prueba ausencia de definición.
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {tipo_analisis:'dependencia',publicado:false,entrada_valida:true})-[:RASTREA]->(dep)-[:TIENE_ORIGEN]->(rq),(dep)-[:REQUIERE]->(en)
MERGE (rq)-[:DEPENDE_DE {evaluacion_id:ev.id}]->(en)
WITH ev,dep,rq,CASE
 WHEN ev.necesidad_confirmada=true AND ev.referencia_necesaria_disponible=false THEN 'GL02'
 WHEN ev.necesidad_confirmada=true AND ev.referencia_necesaria_disponible=true AND ev.cotejo_definicion='pertinente' AND ev.validacion_definicion=true THEN 'ACC-RD08'
 WHEN ev.necesidad_confirmada=true AND ev.busqueda_completa=true AND ev.cotejo_definicion='ausente' THEN 'ACC-RD09' ELSE null END AS rid
WHERE rid IS NOT NULL MATCH (r:AuditIA_PG2:Regla {id:rid})
SET ev.estado=CASE rid WHEN 'GL02' THEN 'pendiente' WHEN 'ACC-RD08' THEN 'sin_hallazgo' ELSE 'observado' END,
 dep.estado=CASE rid WHEN 'ACC-RD08' THEN 'resuelta' WHEN 'GL02' THEN 'pendiente' ELSE 'no_resuelta' END
MERGE (ev)-[:APLICA_REGLA]->(r);
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {id:'EV-TASA-1',publicado:false,estado:'pendiente'})-[:RASTREA]->(dep)-[:TIENE_ORIGEN]->(rq)
MERGE (p:AuditIA_PG2 {id:'P-TASA'}) ON CREATE SET p:ResultadoAnalisis:Pendiente,p.fecha=ev.fecha,p.version='1',p.modulo_origen='analisis_cruzado',p.descripcion='El Anexo B citado no fue recibido',p.motivo_pendiente='referencia_no_disponible',p.dato_faltante='Anexo B',p.interpretaciones=[],p.procedencia_coherente=true,p.destinatario_rol='priorizacion_clarificacion'
MERGE (ev)-[:GENERA]->(p) MERGE (p)-[:AFECTA_REQUERIMIENTO]->(rq)
WITH ev,p MATCH (ev)-[:APLICA_REGLA]->(r),(ev)-[:SE_SUSTENTA_EN]->(e)
MERGE (p)-[:APLICA_REGLA]->(r) MERGE (p)-[:SE_SUSTENTA_EN]->(e);

// Cobertura de una necesidad explícita del catálogo, nunca cobertura total del documento.
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {tipo_analisis:'cobertura',publicado:false,entrada_valida:true})-[:USA_PERFIL]->(pf),(ev)-[:EVALUA_CATEGORIA]->(cat)
WITH ev,pf,cat,CASE WHEN ev.condicion_catalogo IS NULL THEN 'ACC-RD12' WHEN ev.condicion_catalogo=false THEN 'ACC-RD11'
 WHEN ev.mapa_cobertura_validado=false THEN 'ACC-RD16'
 WHEN ev.busqueda_completa=true AND ev.cobertura='ninguna' THEN 'ACC-RD13'
 WHEN ev.mapa_cobertura_validado=true AND ev.cobertura='completa' THEN 'ACC-RD14' ELSE null END AS rid
WHERE rid IS NOT NULL MATCH (r:AuditIA_PG2:Regla {id:rid})
SET ev.estado=CASE WHEN rid IN ['ACC-RD12','ACC-RD16'] THEN 'pendiente' WHEN rid='ACC-RD13' THEN 'observado' ELSE 'sin_hallazgo' END
MERGE (ev)-[:APLICA_REGLA]->(r)
FOREACH (_ IN CASE WHEN ev.condicion_catalogo=true THEN [1] ELSE [] END |
 MERGE (pf)-[:EXIGE {evaluacion_id:ev.id,regla_id:'ACC-RD10',necesidad:'protección de datos sensibles'}]->(cat));
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {tipo_analisis:'cobertura',publicado:false,estado:'sin_hallazgo',cobertura:'completa'})-[:VINCULA_COBERTURA]->(rq),(ev)-[:EVALUA_CATEGORIA]->(cat)
MERGE (rq)-[:CUBRE {evaluacion_id:ev.id,regla_id:'ACC-RD14',necesidad:'protección de datos sensibles'}]->(cat);
MATCH (ev:AuditIA_PG2:EvaluacionCruzada {tipo_analisis:'cobertura',publicado:false})-[:EVALUA_CATEGORIA]->(cat)
WHERE ev.estado IN ['observado','pendiente']
WITH ev,cat,CASE WHEN ev.estado='observado' THEN 'H-SEG' ELSE 'P-SEG' END AS oid
MERGE (o:AuditIA_PG2 {id:oid}) ON CREATE SET o:ResultadoAnalisis,o.fecha=ev.fecha,o.version='1',o.modulo_origen='analisis_cruzado',o.descripcion='Resultado de cobertura de protección de datos sensibles',o.procedencia_coherente=true,o.destinatario_rol='priorizacion_clarificacion'
FOREACH (_ IN CASE WHEN ev.estado='observado' THEN [1] ELSE [] END | SET o:Hallazgo,o.tipo_defecto='brecha_cobertura',o.descripcion_defecto='Necesidad exigible sin compromiso pertinente en el alcance buscado')
FOREACH (_ IN CASE WHEN ev.estado='pendiente' THEN [1] ELSE [] END | SET o:Pendiente,o.motivo_pendiente='perfil_insuficiente',o.dato_faltante='Confirmar existencia de datos sensibles',o.interpretaciones=[])
MERGE (ev)-[:GENERA]->(o) MERGE (o)-[:AFECTA_CATEGORIA]->(cat)
WITH ev,o MATCH (ev)-[:APLICA_REGLA]->(r),(ev)-[:SE_SUSTENTA_EN]->(e)
MERGE (o)-[:APLICA_REGLA]->(r) MERGE (o)-[:SE_SUSTENTA_EN]->(e);

// GL06/GL07. Todo hallazgo o pendiente recibe Severidad; valor desconocido queda ausente (null).
MATCH (ev:AuditIA_PG2:Evaluacion {publicado:false})-[:GENERA]->(o)
WHERE o:Hallazgo OR o:Pendiente
OPTIONAL MATCH (o)-[:DERIVA_DE_JUICIO]->(j:JuicioCriterio)
WITH ev,o,j
MERGE (sv:AuditIA_PG2 {id:'SV-'+o.id})
ON CREATE SET sv:Severidad,sv.propuesta_por=o.modulo_origen,sv.validacion='candidata',sv.normalizacion='candidata',
 sv.valor=CASE WHEN o:Pendiente THEN null ELSE coalesce(j.severidad_propuesta,ev.severidad_propuesta) END,
 sv.grado_severidad=CASE WHEN o:Pendiente THEN null ELSE coalesce(j.puntuacion_severidad_propuesta,ev.puntuacion_severidad_propuesta) END,
 sv.modelo_difuso_version='MD-URG-1.0',sv.fundamento='Valor construido por el módulo de origen para la prueba'
MERGE (o)-[:TIENE_SEVERIDAD]->(sv)
WITH ev,o,sv MATCH (o)-[:SE_SUSTENTA_EN]->(e),(r:AuditIA_PG2:Regla {id:'GL07'})
MERGE (sv)-[:SE_SUSTENTA_EN]->(e) MERGE (o)-[:APLICA_REGLA]->(r);

// GL06. Contrato de derivación completo; datos desconocidos explícitos.
MATCH (o:AuditIA_PG2:ResultadoAnalisis)-[:TIENE_SEVERIDAD]->(sv)
WHERE (o:Hallazgo OR o:Pendiente) AND NOT EXISTS {MATCH (x:ContextoPrioridad) WHERE x.observacion_id=o.id}
MERGE (x:AuditIA_PG2 {id:'X-AUTO-'+o.id}) ON CREATE SET x:ContextoPrioridad,x.observacion_id=o.id,x.info_para_priorizar_suficiente=false,x.necesidad_dato_confirmada=true,x.dato_para_priorizar_disponible=false,x.dato_para_resolver_identificado=true,x.dato_para_resolver=coalesce(o.dato_faltante,'Confirmar criticidad y condiciones de tratamiento'),x.mapeo_alta_bloqueante='candidato_activo'
MERGE (cr:AuditIA_PG2 {id:'CR-AUTO-'+o.id}) ON CREATE SET cr:Criticidad,cr.ambito=o.id,cr.fundamento='Declaración todavía no recibida'
WITH x,cr,o MATCH (o)-[:SE_SUSTENTA_EN]->(e),(r:AuditIA_PG2:Regla {id:'GL06'})
MERGE (x)-[:SE_SUSTENTA_EN]->(e) MERGE (cr)-[:SE_SUSTENTA_EN]->(e) MERGE (o)-[:APLICA_REGLA]->(r);

// SM3. La matriz no completa null y la prioridad no modifica la severidad.
MATCH (x:AuditIA_PG2:ContextoPrioridad),(o:AuditIA_PG2:ResultadoAnalisis)-[:TIENE_SEVERIDAD]->(sv)
WHERE x.observacion_id=o.id AND o.procedencia_coherente=true AND (o:Hallazgo OR o:Pendiente)
MATCH (cr:AuditIA_PG2:Criticidad {id:'CR-'+substring(x.id,2)})
OPTIONAL MATCH (m:AuditIA_PG2:CeldaMatriz {severidad:sv.valor,criticidad:cr.valor})
WITH x,o,sv,cr,m,CASE
 WHEN x.necesidad_dato_confirmada=true AND x.dato_para_priorizar_disponible=false THEN 'PRC-RD02'
 WHEN x.obligacion_esencial_indefinida=true AND o:Hallazgo THEN 'PRC-HC01'
 WHEN sv.valor IS NULL OR cr.valor IS NULL THEN 'PRC-RD02'
 WHEN m.categoria='bloqueante' AND sv.valor='baja' AND cr.valor='alta' THEN 'PRC-HC02'
 WHEN m.categoria='bloqueante' THEN 'PRC-HC03'
 WHEN m.categoria='mayor' AND x.hito_acordado=true AND x.bloqueo_sustantivo_confirmado=false THEN 'PRC-HC04'
 WHEN m.categoria='menor' AND x.diferimiento_aceptado=true AND x.impacto_acotado=true THEN 'PRC-HC05'
 WHEN m.categoria IN ['mayor','menor'] THEN 'PRC-RD02' ELSE null END AS rid
WHERE rid IS NOT NULL MATCH (r:AuditIA_PG2:Regla {id:rid})
MERGE (d:AuditIA_PG2 {id:'D-'+o.id}) ON CREATE SET d:DecisionPrioridad,d.fecha=o.fecha,d.provisional=true,
 d.prioridad=CASE rid WHEN 'PRC-HC04' THEN 'mayor' WHEN 'PRC-HC05' THEN 'menor' ELSE 'bloqueante' END,
 d.motivo=CASE rid WHEN 'PRC-RD02' THEN 'preventivo' WHEN 'PRC-HC04' THEN 'en_hito' WHEN 'PRC-HC05' THEN 'diferimiento' ELSE 'sustantivo' END,
 d.categoria_matriz=m.categoria,d.matriz_id_version=CASE WHEN m IS NOT NULL THEN 'MPR-01-1.0' END,
 d.revisada_humanamente=false,d.emitible=false,d.criticidad_id=cr.id
MERGE (d)-[:PRIORIZA]->(o) MERGE (d)-[:USA_CONTEXTO]->(x) MERGE (d)-[:APLICA_REGLA]->(r)
MERGE (er:AuditIA_PG2 {id:'ER-'+o.id}) ON CREATE SET er:EstadoResolucion,er.valor='por_consultar',er.fecha=o.fecha,er.motivo='Recomendación académica pendiente de revisión'
MERGE (d)-[:TIENE_ESTADO]->(er)
WITH d,x,o MATCH (x)-[:SE_SUSTENTA_EN]->(e)
MERGE (d)-[:SE_SUSTENTA_EN]->(e)
WITH d,o OPTIONAL MATCH (o)-[:AFECTA_REQUERIMIENTO]->(rq)
WITH d,o,collect(rq) AS rqs MATCH (cr:AuditIA_PG2:Criticidad {id:d.criticidad_id})
FOREACH (rq IN rqs | MERGE (rq)-[:TIENE_CRITICIDAD]->(cr));


// ARCHIVO 04_difusa.cypher
// Modelos y parámetros de los tres PI3. Mamdani MIN/MAX; 1001 puntos.
// El grado no sustituye los estados crisp ni la autorización de retorno.

MATCH (ev:AuditIA_PG2:EvaluacionIndividual {entrada_valida:true})-[:CONTIENE_JUICIO]->(n:JuicioCriterio)-[:APLICA_CRITERIO]->(:CriterioCalidad {nombre:'ambiguedad'})
WHERE n.valoracion_confirmada=true AND n.alcance_valoracion_revisado=true
WITH n,n.divergencia_lecturas AS x,n.delimitacion_contexto AS y
MATCH (md:AuditIA_PG2:ModeloDifuso {id:'MD-AMB-1.0'})
SET n.estado_calculo_difuso=CASE WHEN x IS NULL OR y IS NULL THEN 'datos_desconocidos' WHEN x<0 OR x>10 OR y<0 OR y>10 THEN 'dato_fuera_de_rango' ELSE 'calculable' END
WITH n,x,y,md WHERE x>=0 AND x<=10 AND y>=0 AND y<=10
MATCH (exb:AuditIA_PG2:EtiquetaDifusa {id:'MD-AMB-1.0-x-baja'}),
 (exm:AuditIA_PG2:EtiquetaDifusa {id:'MD-AMB-1.0-x-media'}),
 (exa:AuditIA_PG2:EtiquetaDifusa {id:'MD-AMB-1.0-x-alta'}),
 (eyb:AuditIA_PG2:EtiquetaDifusa {id:'MD-AMB-1.0-y-baja'}),
 (eym:AuditIA_PG2:EtiquetaDifusa {id:'MD-AMB-1.0-y-media'}),
 (eya:AuditIA_PG2:EtiquetaDifusa {id:'MD-AMB-1.0-y-alta'})
WHERE exb.sigma>0 AND exm.sigma>0 AND exa.sigma>0 AND eyb.sigma>0 AND eym.sigma>0 AND eya.sigma>0
WITH n,x,y,md,exp(-0.5*((x-exb.centro)/exb.sigma)^2) AS xb,
 exp(-0.5*((x-exm.centro)/exm.sigma)^2) AS xm,
 exp(-0.5*((x-exa.centro)/exa.sigma)^2) AS xa,
 exp(-0.5*((y-eyb.centro)/eyb.sigma)^2) AS yb,
 exp(-0.5*((y-eym.centro)/eym.sigma)^2) AS ym,
 exp(-0.5*((y-eya.centro)/eya.sigma)^2) AS ya
WITH n,x,y,md,[{id:'AMB-RB1',alpha:(CASE WHEN xa<yb THEN xa ELSE yb END)},
 {id:'AMB-RB2',alpha:(CASE WHEN xa<ym THEN xa ELSE ym END)},
 {id:'AMB-RB3',alpha:(CASE WHEN xm<(CASE WHEN yb>ym THEN yb ELSE ym END) THEN xm ELSE (CASE WHEN yb>ym THEN yb ELSE ym END) END)},
 {id:'AMB-RB4',alpha:(CASE WHEN xb>ya THEN xb ELSE ya END)}] AS activaciones
UNWIND activaciones AS act
MATCH (r:AuditIA_PG2:ReglaDifusa {id:act.id})-[:CONSECUENTE]->(et:EtiquetaDifusa)
WHERE et.sigma>0
WITH n,x,y,md,collect({id:act.id,alpha:act.alpha,c:et.centro,s:et.sigma}) AS reglas
UNWIND range(0,1000) AS k
WITH n,x,y,md,reglas,k*0.001 AS z
WITH n,x,y,md,reglas,z,reduce(maximo=0.0,r IN reglas |
 CASE WHEN (CASE WHEN r.alpha<exp(-0.5*((z-r.c)/r.s)^2) THEN r.alpha ELSE exp(-0.5*((z-r.c)/r.s)^2) END)>maximo
 THEN CASE WHEN r.alpha<exp(-0.5*((z-r.c)/r.s)^2) THEN r.alpha ELSE exp(-0.5*((z-r.c)/r.s)^2) END ELSE maximo END) AS mu
WITH n,x,y,md,reglas,sum(z*mu) AS num,sum(mu) AS den
WHERE den>0
SET n.grado_ambiguedad=num/den,n.modelo_difuso_version=md.id,n.input_x=x,n.input_y=y,
 n.reglas_difusas_ids=[r IN reglas | r.id],n.activaciones=[r IN reglas | r.alpha],
 n.estado_calculo_difuso='calculado',n.resultado_difuso_provisional=true,
 n.banda_difusa=CASE WHEN num/den<0.273 THEN 'baja' WHEN num/den<0.727 THEN 'media' ELSE 'alta' END
MERGE (n)-[:APLICA_MODELO]->(md);


MATCH (n:AuditIA_PG2:EvaluacionCruzada {entrada_valida:true,tipo_analisis:'comparacion'})
WHERE n.valoracion_confirmada=true AND n.excepcion_resuelve=false
 AND n.escenarios<>'excluyentes' AND n.dato_necesario_faltante=false
 AND NOT EXISTS {MATCH (n)-[:COMPARA]->(:Requerimiento {entrada_valida:false})}
WITH n,n.solapamiento_escenario AS x,n.incompatibilidad_resultados AS y
MATCH (md:AuditIA_PG2:ModeloDifuso {id:'MD-CONTR-1.0'})
SET n.estado_calculo_difuso=CASE WHEN x IS NULL OR y IS NULL THEN 'datos_desconocidos' WHEN x<0 OR x>10 OR y<0 OR y>10 THEN 'dato_fuera_de_rango' ELSE 'calculable' END
WITH n,x,y,md WHERE x>=0 AND x<=10 AND y>=0 AND y<=10
MATCH (exb:AuditIA_PG2:EtiquetaDifusa {id:'MD-CONTR-1.0-x-baja'}),
 (exm:AuditIA_PG2:EtiquetaDifusa {id:'MD-CONTR-1.0-x-media'}),
 (exa:AuditIA_PG2:EtiquetaDifusa {id:'MD-CONTR-1.0-x-alta'}),
 (eyb:AuditIA_PG2:EtiquetaDifusa {id:'MD-CONTR-1.0-y-baja'}),
 (eym:AuditIA_PG2:EtiquetaDifusa {id:'MD-CONTR-1.0-y-media'}),
 (eya:AuditIA_PG2:EtiquetaDifusa {id:'MD-CONTR-1.0-y-alta'})
WHERE exb.sigma>0 AND exm.sigma>0 AND exa.sigma>0 AND eyb.sigma>0 AND eym.sigma>0 AND eya.sigma>0
WITH n,x,y,md,exp(-0.5*((x-exb.centro)/exb.sigma)^2) AS xb,
 exp(-0.5*((x-exm.centro)/exm.sigma)^2) AS xm,
 exp(-0.5*((x-exa.centro)/exa.sigma)^2) AS xa,
 exp(-0.5*((y-eyb.centro)/eyb.sigma)^2) AS yb,
 exp(-0.5*((y-eym.centro)/eym.sigma)^2) AS ym,
 exp(-0.5*((y-eya.centro)/eya.sigma)^2) AS ya
WITH n,x,y,md,[{id:'CONTR-RB1',alpha:(CASE WHEN xa<ya THEN xa ELSE ya END)},
 {id:'CONTR-RB2',alpha:(CASE WHEN xm<ya THEN xm ELSE ya END)},
 {id:'CONTR-RB3',alpha:(CASE WHEN xa<ym THEN xa ELSE ym END)},
 {id:'CONTR-RB4',alpha:(CASE WHEN xb>yb THEN xb ELSE yb END)}] AS activaciones
UNWIND activaciones AS act
MATCH (r:AuditIA_PG2:ReglaDifusa {id:act.id})-[:CONSECUENTE]->(et:EtiquetaDifusa)
WHERE et.sigma>0
WITH n,x,y,md,collect({id:act.id,alpha:act.alpha,c:et.centro,s:et.sigma}) AS reglas
UNWIND range(0,1000) AS k
WITH n,x,y,md,reglas,k*0.001 AS z
WITH n,x,y,md,reglas,z,reduce(maximo=0.0,r IN reglas |
 CASE WHEN (CASE WHEN r.alpha<exp(-0.5*((z-r.c)/r.s)^2) THEN r.alpha ELSE exp(-0.5*((z-r.c)/r.s)^2) END)>maximo
 THEN CASE WHEN r.alpha<exp(-0.5*((z-r.c)/r.s)^2) THEN r.alpha ELSE exp(-0.5*((z-r.c)/r.s)^2) END ELSE maximo END) AS mu
WITH n,x,y,md,reglas,sum(z*mu) AS num,sum(mu) AS den
WHERE den>0
SET n.grado_contradiccion=num/den,n.modelo_difuso_version=md.id,n.input_x=x,n.input_y=y,
 n.reglas_difusas_ids=[r IN reglas | r.id],n.activaciones=[r IN reglas | r.alpha],
 n.estado_calculo_difuso='calculado',n.resultado_difuso_provisional=true,
 n.banda_difusa=CASE WHEN num/den<0.273 THEN 'baja' WHEN num/den<0.727 THEN 'intermedia' ELSE 'alta' END
MERGE (n)-[:APLICA_MODELO]->(md);


MATCH (n:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]->()-[:TIENE_SEVERIDAD]->(sv),
      (cr:AuditIA_PG2:Criticidad {id:n.criticidad_id})
WITH n,sv.grado_severidad AS x,cr.grado_criticidad AS y
MATCH (md:AuditIA_PG2:ModeloDifuso {id:'MD-URG-1.0'})
SET n.estado_calculo_difuso=CASE WHEN x IS NULL OR y IS NULL THEN 'datos_desconocidos' WHEN x<0 OR x>10 OR y<0 OR y>10 THEN 'dato_fuera_de_rango' ELSE 'calculable' END
WITH n,x,y,md WHERE x>=0 AND x<=10 AND y>=0 AND y<=10
MATCH (exb:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-x-baja'}),
 (exm:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-x-media'}),
 (exa:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-x-alta'}),
 (eyb:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-y-baja'}),
 (eym:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-y-media'}),
 (eya:AuditIA_PG2:EtiquetaDifusa {id:'MD-URG-1.0-y-alta'})
WHERE exb.sigma>0 AND exm.sigma>0 AND exa.sigma>0 AND eyb.sigma>0 AND eym.sigma>0 AND eya.sigma>0
WITH n,x,y,md,exp(-0.5*((x-exb.centro)/exb.sigma)^2) AS xb,
 exp(-0.5*((x-exm.centro)/exm.sigma)^2) AS xm,
 exp(-0.5*((x-exa.centro)/exa.sigma)^2) AS xa,
 exp(-0.5*((y-eyb.centro)/eyb.sigma)^2) AS yb,
 exp(-0.5*((y-eym.centro)/eym.sigma)^2) AS ym,
 exp(-0.5*((y-eya.centro)/eya.sigma)^2) AS ya
WITH n,x,y,md,[{id:'URG-RB1',alpha:(CASE WHEN ya<(CASE WHEN xm>xa THEN xm ELSE xa END) THEN ya ELSE (CASE WHEN xm>xa THEN xm ELSE xa END) END)},
 {id:'URG-RB2',alpha:(CASE WHEN xa<ym THEN xa ELSE ym END)},
 {id:'URG-RB3',alpha:(CASE WHEN xb<ya THEN xb ELSE ya END)},
 {id:'URG-RB4',alpha:(CASE WHEN xm<(CASE WHEN ym>yb THEN ym ELSE yb END) THEN xm ELSE (CASE WHEN ym>yb THEN ym ELSE yb END) END)},
 {id:'URG-RB5',alpha:(CASE WHEN (CASE WHEN xa<yb THEN xa ELSE yb END)>(CASE WHEN xb<ym THEN xb ELSE ym END) THEN (CASE WHEN xa<yb THEN xa ELSE yb END) ELSE (CASE WHEN xb<ym THEN xb ELSE ym END) END)},
 {id:'URG-RB6',alpha:(CASE WHEN xb<yb THEN xb ELSE yb END)}] AS activaciones
UNWIND activaciones AS act
MATCH (r:AuditIA_PG2:ReglaDifusa {id:act.id})-[:CONSECUENTE]->(et:EtiquetaDifusa)
WHERE et.sigma>0
WITH n,x,y,md,collect({id:act.id,alpha:act.alpha,c:et.centro,s:et.sigma}) AS reglas
UNWIND range(0,1000) AS k
WITH n,x,y,md,reglas,k*0.01 AS z
WITH n,x,y,md,reglas,z,reduce(maximo=0.0,r IN reglas |
 CASE WHEN (CASE WHEN r.alpha<exp(-0.5*((z-r.c)/r.s)^2) THEN r.alpha ELSE exp(-0.5*((z-r.c)/r.s)^2) END)>maximo
 THEN CASE WHEN r.alpha<exp(-0.5*((z-r.c)/r.s)^2) THEN r.alpha ELSE exp(-0.5*((z-r.c)/r.s)^2) END ELSE maximo END) AS mu
WITH n,x,y,md,reglas,sum(z*mu) AS num,sum(mu) AS den
WHERE den>0
SET n.grado_urgencia=num/den,n.modelo_difuso_version=md.id,n.input_x=x,n.input_y=y,
 n.reglas_difusas_ids=[r IN reglas | r.id],n.activaciones=[r IN reglas | r.alpha],
 n.estado_calculo_difuso='calculado',n.resultado_difuso_provisional=true,
 n.banda_difusa=CASE WHEN num/den<2.73 THEN 'baja' WHEN num/den<7.27 THEN 'media' ELSE 'alta' END
MERGE (n)-[:APLICA_MODELO]->(md);


// Bandas de frontera solicitan revisión, sin simular que ya se realizó.
MATCH (n:AuditIA_PG2) WHERE n.banda_difusa IN ['media','intermedia'] SET n.revision_senior_requerida=true;


// Publicación técnica posterior al enriquecimiento difuso.
MATCH (ev:AuditIA_PG2:Evaluacion {publicado:false}) WHERE ev.estado<>'en_revision' SET ev.publicado=true;

// ARCHIVO 05_retorno.cypher
// Casos construidos: una respuesta parcial no cierra y una completa exige reevaluación.
MATCH (q0:AuditIA_PG2:Fuente {id:'S-CASOS'}),(resp:AuditIA_PG2:Responsable {id:'RESP-NEG'})
MERGE (q:AuditIA_PG2 {id:'Q-CAT'}) ON CREATE SET q:Pregunta,q.texto='¿En qué escenario, con qué volumen y condición se acepta la carga del catálogo?',q.dato_clave='aceptacion_catalogo',q.asignacion='confirmada',q.revision_neutralidad='pendiente',q.propuesta_aceptada=false
MERGE (q)-[:SE_DIRIGE_A]->(resp)
WITH q,resp
MATCH (d:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]->(o) WHERE o.id IN ['H-CAT-B','P-CAT-V','P-CAT-C'] AND NOT EXISTS {MATCH (d)-[:SUSTITUYE_A]->()}
MERGE (q)-[:ACLARA]->(o) MERGE (q)-[:SE_ORIGINA_EN]->(d);
MATCH (q:AuditIA_PG2:Pregunta {id:'Q-CAT'}),(p:AuditIA_PG2:Responsable {id:'RESP-NEG'})
MERGE (a:AuditIA_PG2 {id:'A-CAT-P'}) ON CREATE SET a:Respuesta,a.fecha=datetime('2026-10-31T21:01:00-03:00'),a.contenido='Debe tardar poco',a.estado_validacion='parcial',a.datos_suficientes=false,a.discordancia_confirmada=false
MERGE (a)-[:RESPONDE_A]->(q) MERGE (a)-[:APORTADA_POR]->(p)
MERGE (b:AuditIA_PG2 {id:'A-CAT-C'}) ON CREATE SET b:Respuesta,b.fecha=datetime('2026-10-31T21:02:00-03:00'),b.contenido='100 productos con lista interactiva en menos de 2 segundos en el entorno acordado del caso',b.estado_validacion='validada',b.datos_suficientes=true,b.discordancia_confirmada=false
MERGE (b)-[:RESPONDE_A]->(q) MERGE (b)-[:APORTADA_POR]->(p)
WITH a,b
UNWIND [a,b] AS respuesta
MATCH (fuente:AuditIA_PG2:Fuente {id:'S-CASOS'})
MERGE (e:AuditIA_PG2 {id:'E-'+respuesta.id})
ON CREATE SET e:Evidencia,e.tipo='fragmento',e.contenido=respuesta.contenido,
 e.localizador=respuesta.id,e.naturaleza='caso_construido',e.autor_registro='Grupo 10',e.fecha=respuesta.fecha
MERGE (respuesta)-[:SE_SUSTENTA_EN]->(e) MERGE (e)-[:CITA_FUENTE]->(fuente);
// La revisión siguiente es parte del escenario construido, no una entrevista ni validación senior.
MATCH (old:AuditIA_PG2:Evaluacion {id:'EV-CAT-01',publicado:true}),
 (new:AuditIA_PG2:Evaluacion {id:'EV-CAT-02',publicado:true,estado:'sin_hallazgo'}),
 (a:AuditIA_PG2:Respuesta {id:'A-CAT-C',estado_validacion:'validada',datos_suficientes:true,discordancia_confirmada:false}),
 (r:AuditIA_PG2:Regla {id:'GL03'})
MERGE (new)-[:REEVALUA {evento_id:'RET-CAT-01'}]->(old) MERGE (new)-[:CONSIDERA_RESPUESTA]->(a)
MERGE (new)-[:APLICA_REGLA]->(r)
SET new.resultado_reevaluacion='resuelta',new.autorizada_por_origen=true,new.correspondencia_version=true;
MATCH (old:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]->(o),(old)-[:USA_CONTEXTO]->(x),
 (new:AuditIA_PG2:Evaluacion {id:'EV-CAT-02',resultado_reevaluacion:'resuelta',autorizada_por_origen:true,correspondencia_version:true}),
 (r:AuditIA_PG2:Regla {id:'PRC-RD09'}),(rv:AuditIA_PG2:Responsable {id:'RESP-AN'})
WHERE o.id IN ['H-CAT-B','P-CAT-V','P-CAT-C']
 AND NOT EXISTS { MATCH (old)-[:SUSTITUYE_A]->() }
MERGE (rev:AuditIA_PG2 {id:'REV-RET-CAT'}) ON CREATE SET rev:RevisionHumana,rev.resultado='conforme',rev.naturaleza='caso_construido',rev.fecha=datetime('2026-10-31T21:03:00-03:00'),rev.alcance='Ensayo del protocolo de retorno; no validación experta'
MERGE (rev)-[:REALIZADA_POR]->(rv) MERGE (rev)-[:REVISA]->(new)
MERGE (d:AuditIA_PG2 {id:old.id+'-R2'}) ON CREATE SET d:DecisionPrioridad,d.fecha=rev.fecha,d.prioridad=old.prioridad,d.motivo=old.motivo,d.provisional=true,d.emitible=false,d.revisada_humanamente=true,d.criticidad_id=old.criticidad_id
MERGE (d)-[:SUSTITUYE_A]->(old) MERGE (d)-[:PRIORIZA]->(o) MERGE (d)-[:USA_CONTEXTO]->(x) MERGE (d)-[:SE_BASA_EN_REEVALUACION]->(new) MERGE (d)-[:APLICA_REGLA]->(r)
MERGE (rev)-[:REVISA]->(d)
MERGE (er:AuditIA_PG2 {id:'ER-'+d.id}) ON CREATE SET er:EstadoResolucion,er.valor='resuelto',er.fecha=rev.fecha,er.motivo='Respuesta validada y reevaluación autorizada del caso construido'
MERGE (d)-[:TIENE_ESTADO]->(er)
WITH d,new MATCH (new)-[:SE_SUSTENTA_EN]->(e) MERGE (d)-[:SE_SUSTENTA_EN]->(e);
MATCH (old:AuditIA_PG2:Evaluacion {id:'EV-TASA-1',publicado:true}),(new:AuditIA_PG2:Evaluacion {id:'EV-TASA-2',estado:'sin_hallazgo'}),(r:AuditIA_PG2:Regla {id:'GL03'})
MERGE (new)-[:REEVALUA {evento_id:'RET-TASA-01'}]->(old) MERGE (new)-[:APLICA_REGLA]->(r)
SET new.resultado_reevaluacion='resuelta',new.autorizada_por_origen=true,new.correspondencia_version=true;

// ARCHIVO 06_informes.cypher
// Agregados descriptivos. Calidad observada y completitud de auditoría son ejes separados.
MATCH (doc:AuditIA_PG2:DocumentoVersion)<-[:REVISA_DOCUMENTO]-(ev:Evaluacion)
WHERE ev.publicado=true
WITH doc,collect(DISTINCT ev) AS evaluaciones
UNWIND evaluaciones AS ev
OPTIONAL MATCH (ev)-[:CONTIENE_JUICIO]->(j)
WITH doc,evaluaciones,collect(DISTINCT j) AS juicios,
 collect(DISTINCT CASE WHEN ev:EvaluacionCruzada THEN ev END) AS cruzadas
WITH doc,evaluaciones,juicios,cruzadas,
 size(juicios)+size(cruzadas) AS unidades,
 size([j IN juicios WHERE j.estado IN ['cumple','incumple']])+
 size([ev IN cruzadas WHERE ev.estado IN ['observado','sin_hallazgo']]) AS concluyentes
UNWIND evaluaciones AS ev
OPTIONAL MATCH (ev)-[:GENERA]->(h:Hallazgo)
WITH doc,evaluaciones,unidades,concluyentes,collect(DISTINCT h) AS hallazgos
MERGE (informe:AuditIA_PG2 {id:'INF-'+doc.id})
ON CREATE SET informe:InformeAuditoria,informe.fecha=datetime('2026-10-31T21:05:00-03:00'),
 informe.hallazgos_demostrados=size(hallazgos),informe.unidades_aplicables=unidades,
 informe.unidades_concluyentes=concluyentes,
 informe.completitud_auditoria=CASE WHEN unidades>0 THEN 1.0*concluyentes/unidades ELSE null END,
 informe.calidad_observada=CASE WHEN size(hallazgos)>0 THEN 'con_defectos_demostrados'
                          WHEN concluyentes=0 THEN 'no_determinable'
                          ELSE 'sin_defectos_demostrados_en_alcance_revisado' END,
 informe.confianza_auditoria=CASE WHEN unidades=0 THEN 'no_determinable' WHEN concluyentes<unidades THEN 'limitada_por_informacion_pendiente' ELSE 'alcance_revisado_concluyente' END,
 informe.validacion_experta='pendiente',informe.emitible=false
MERGE (informe)-[:CONSOLIDA]->(doc)
WITH informe,doc
OPTIONAL MATCH (d:AuditIA_PG2:DecisionPrioridad)-[:PRIORIZA]->(o)<-[:GENERA]-(origen:Evaluacion)
OPTIONAL MATCH (d)-[:SE_BASA_EN_REEVALUACION]->(reevaluacion:Evaluacion)
WITH informe,doc,d,coalesce(reevaluacion,origen) AS evaluacion_decision
WHERE (evaluacion_decision)-[:REVISA_DOCUMENTO]->(doc)
 AND NOT EXISTS {
  MATCH (sucesora:DecisionPrioridad)-[:SUSTITUYE_A]->(d),
        (sucesora)-[:SE_BASA_EN_REEVALUACION]->(:Evaluacion)-[:REVISA_DOCUMENTO]->(doc)
 }
WITH informe,collect(DISTINCT d) AS decisiones
FOREACH (d IN decisiones | MERGE (informe)-[:INCLUYE]->(d));

// ARCHIVO 07_controles.cypher
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

