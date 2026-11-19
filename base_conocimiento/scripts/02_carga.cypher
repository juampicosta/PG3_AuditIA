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
