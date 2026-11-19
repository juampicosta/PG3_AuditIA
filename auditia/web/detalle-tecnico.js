/* Presentación de la evidencia guardada en Neo4j. No asigna estados ni prioridades. */
const DetalleTecnico = (() => {
  const e = t => String(t ?? "").replace(/[&<>"]/g, c => ({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;"}[c]));
  const n = (v, d=3) => typeof v === "number" && Number.isFinite(v) ? v.toLocaleString("es-AR", {maximumFractionDigits:d}) : "Sin dato";
  const valor = v => v == null || v === "" ? "Sin dato" : typeof v === "boolean" ? (v ? "Sí" : "No") : Array.isArray(v) ? (v.length ? v.join(" · ") : "Ninguno registrado") : String(v);
  const tit = t => String(t || "Sin dato").replaceAll("_", " ");
  const nombreCrit = {atomicidad:"Atomicidad", ambiguedad:"Ambigüedad", verificabilidad:"Verificabilidad", completitud:"Completitud"};
  const campos = {
    revision_semantica_completa:"Revisión semántica completa", info_necesaria_identificada:"Información necesaria identificada",
    info_disponible:"Información disponible", contexto_suficiente:"Contexto suficiente", obligaciones_independientes:"Obligaciones independientes",
    unidad_aceptacion_confirmada:"Unidad de aceptación confirmada", lecturas_residuales:"Lecturas posibles",
    delimitacion_confirmada:"Interpretación delimitada", aceptacion_delimita:"La aceptación delimita las lecturas",
    aceptacion_necesaria:"Aceptación necesaria", aceptacion_disponible:"Aceptación disponible", comprobacion_definida:"Comprobación definida",
    metodo_discrimina:"El método permite distinguir si cumple", informacion_aplicable_identificada:"Información aplicable identificada",
    omisiones_demostradas:"Omisiones demostradas", lecturas:"Lecturas consideradas", metodo:"Método de comprobación", fragmentos:"Fragmentos citados",
    omisiones:"Omisiones identificadas", dato_faltante:"Dato faltante", divergencia_lecturas:"Divergencia de lecturas (0 a 10)",
    delimitacion_contexto:"Delimitación del contexto (0 a 10)", severidad_propuesta:"Severidad propuesta", puntuacion_severidad_propuesta:"Puntaje de severidad (0 a 10)",
    escenarios:"Relación entre escenarios", resultados_incompatibles:"Resultados incompatibles", excepcion_resuelve:"Una excepción concilia el par",
    region_comun_definida:"Región común definida", ambito_comun:"Región común", interpretacion_cerrada:"Interpretación cerrada", datos_controlados:"Datos controlados",
    solapamiento_escenario:"Solapamiento de escenarios (0 a 10)", incompatibilidad_resultados:"Incompatibilidad de resultados (0 a 10)",
    criticidad_valor:"Importancia para el negocio", grado_criticidad:"Puntaje de importancia (0 a 10)", fundamento_criticidad:"Fundamento de la importancia",
    obligacion_esencial_indefinida:"Queda una obligación esencial sin definir", bloqueo_sustantivo_confirmado:"Bloqueo sustantivo confirmado",
    hito_acordado:"Fecha de resolución acordada", diferimiento_aceptado:"El cliente aceptó dejarlo para después", impacto_acotado:"Impacto acotado",
    info_para_priorizar_suficiente:"Información suficiente para priorizar", necesidad_dato_confirmada:"Hace falta un dato para priorizar",
    dato_para_priorizar_disponible:"Dato para priorizar disponible", dato_para_resolver:"Dato que se necesita resolver",
    sujeto:"Sujeto", accion:"Acción", objeto:"Objeto", resultado:"Resultado esperado", modalidad:"Modalidad", actor:"Actor", estado:"Estado o condición",
    condicion:"Condición", obligaciones:"Obligaciones detectadas", unidad_aceptacion_unica:"Una sola unidad de aceptación",
    terminos_vagos:"Términos vagos", criterio_medible:"Criterio medible", justificacion:"Fundamento de la lectura"
  };
  const critKeys = ["obligaciones_independientes","unidad_aceptacion_confirmada","lecturas_residuales","delimitacion_confirmada","aceptacion_delimita",
    "aceptacion_necesaria","aceptacion_disponible","comprobacion_definida","metodo_discrimina","informacion_aplicable_identificada","omisiones_demostradas",
    "revision_semantica_completa","info_necesaria_identificada","info_disponible","contexto_suficiente","lecturas","dato_faltante"];
  const cmpKeys = ["escenarios","resultados_incompatibles","excepcion_resuelve","region_comun_definida","ambito_comun","interpretacion_cerrada","datos_controlados"];
  const condiciones = ["hito_acordado","bloqueo_sustantivo_confirmado","diferimiento_aceptado","impacto_acotado","obligacion_esencial_indefinida"];
  const controles = {
    resultados_sin_trazabilidad:"Resultados sin evidencia o regla", decisiones_candidatas_no_provisionales:"Decisiones sin marcar como provisionales",
    incidencias_priorizadas:"Incidencias de entrada priorizadas", cardinalidades_incorrectas:"Evaluaciones sin los cuatro criterios",
    cierres_sin_reevaluacion:"Cierres sin reevaluación válida", sigmas_invalidos:"Parámetros gaussianos inválidos",
    grados_fuera_de_rango:"Urgencias fuera de 0 a 10", ciclos_de_reevaluacion:"Ciclos en las reevaluaciones"
  };
  const glosario = {
    revision_semantica_completa:"Se terminó de revisar qué puede significar el texto y cómo se interpreta.",
    info_necesaria_identificada:"Se sabe qué información hace falta para evaluar este aspecto.",
    info_disponible:"La información necesaria ya está disponible para poder decidir.",
    contexto_suficiente:"Se conoce lo necesario sobre el caso para interpretar el requerimiento.",
    obligaciones_independientes:"Cantidad de cosas que se podrían cumplir o probar por separado.",
    unidad_aceptacion_confirmada:"Se confirmó que las acciones se aceptan juntas como una sola obligación.",
    lecturas_residuales:"Cantidad de interpretaciones que siguen siendo posibles después de revisar el texto.",
    delimitacion_confirmada:"Se confirmó cuál interpretación corresponde y hasta dónde llega.",
    aceptacion_delimita:"El criterio de aceptación permite descartar interpretaciones alternativas.",
    aceptacion_necesaria:"Hace falta acordar cómo se dará por cumplido el requerimiento para evaluarlo.",
    aceptacion_disponible:"Ya se recibió el criterio necesario para dar el requerimiento por cumplido.",
    comprobacion_definida:"Existe una manera concreta de comprobar si el requerimiento se cumple.",
    metodo_discrimina:"La prueba permite distinguir entre un resultado que cumple y uno que no.",
    informacion_aplicable_identificada:"Se identificaron los datos que este requerimiento necesita incluir.",
    omisiones_demostradas:"Cantidad de datos indispensables que se comprobó que faltan.",
    lecturas:"Distintas formas de entender el mismo texto que se tuvieron en cuenta.",
    metodo:"La prueba o procedimiento que se usaría para comprobar el cumplimiento.",
    fragmentos:"Partes del texto usadas como respaldo de la interpretación.",
    omisiones:"Información que se detectó como ausente en el requerimiento.",
    dato_faltante:"Información concreta que hay que conseguir para poder seguir evaluando.",
    divergencia_lecturas:"Cuánto se diferencian las interpretaciones posibles. Un puntaje mayor indica más diferencia.",
    delimitacion_contexto:"Cuánto ayuda el contexto a aclarar el significado. Un puntaje mayor indica más claridad.",
    severidad_propuesta:"Gravedad del defecto propuesta y revisada al confirmar las premisas.",
    puntuacion_severidad_propuesta:"Puntaje de gravedad que se usa como entrada del cálculo difuso de urgencia.",
    escenarios:"Indica si los requerimientos se aplican a la misma situación, a situaciones parcialmente comunes o a situaciones distintas.",
    resultados_incompatibles:"Los dos resultados exigidos no pueden cumplirse al mismo tiempo en la situación comparada.",
    excepcion_resuelve:"Una excepción o regla de precedencia explica por qué los dos textos pueden convivir.",
    region_comun_definida:"Se sabe exactamente en qué situaciones se superponen los requerimientos.",
    ambito_comun:"La parte de la situación que comparten los dos requerimientos.",
    interpretacion_cerrada:"Se aclaró el significado de ambos textos lo suficiente como para compararlos.",
    datos_controlados:"Se revisó que los datos del par sean adecuados para hacer la comparación.",
    solapamiento_escenario:"Cuánto coinciden las situaciones donde se aplican ambos requerimientos.",
    incompatibilidad_resultados:"Cuánto se oponen los resultados que piden los dos requerimientos.",
    criticidad_valor:"Importancia del requerimiento para el negocio. Es uno de los datos usados para decidir qué atender primero.",
    grado_criticidad:"Puntaje de importancia para el negocio usado en el cálculo difuso de urgencia.",
    fundamento_criticidad:"La razón por la que se asignó ese nivel de importancia para el negocio.",
    obligacion_esencial_indefinida:"Falta definir algo indispensable de la obligación. En un hallazgo, esta condición puede determinar un bloqueo sustantivo.",
    bloqueo_sustantivo_confirmado:"Se confirmó que el problema de fondo impide avanzar con el cierre.",
    hito_acordado:"Se acordó una fecha o un momento concreto para resolver la observación.",
    diferimiento_aceptado:"El cliente aceptó expresamente que la resolución quede para más adelante.",
    impacto_acotado:"Se confirmó que las consecuencias del problema tienen un alcance limitado.",
    info_para_priorizar_suficiente:"Hay información suficiente para elegir cómo tratar la observación.",
    necesidad_dato_confirmada:"Se confirmó que falta un dato necesario para elegir el tratamiento.",
    dato_para_priorizar_disponible:"Ya se dispone del dato necesario para decidir el tratamiento.",
    dato_para_resolver:"El dato o la aclaración que se necesita conseguir para avanzar.",
    sujeto:"Quién debe cumplir la obligación descrita en el requerimiento.",
    accion:"Lo que se pide que haga el sujeto.",
    objeto:"El elemento sobre el que recae la acción o que interviene en la situación descrita.",
    "Objeto de la obligación":"Sobre qué elemento recae la acción que se pide realizar.",
    "Objeto del escenario":"El elemento que interviene en la situación donde se aplica la obligación. Puede coincidir con el objeto de la obligación.",
    resultado:"Lo que se espera obtener al cumplir la obligación.",
    modalidad:"Indica cómo se exige la acción; por ejemplo, como una obligación.",
    actor:"Quién interviene en la situación donde se aplica el requerimiento.",
    estado:"La situación o condición en la que se aplica la obligación.",
    condicion:"Cuándo o bajo qué condición se aplica el requerimiento.",
    obligaciones:"Las acciones u obligaciones que se identificaron al leer el texto.",
    unidad_aceptacion_unica:"Indica si lo pedido puede darse por cumplido mediante una sola unidad de aceptación.",
    terminos_vagos:"Palabras como «rápido» o «fácil» cuyo significado puede variar si no se precisan.",
    criterio_medible:"Una condición concreta que permite medir o comprobar el cumplimiento.",
    justificacion:"La explicación que respalda la lectura o evaluación del texto.",
    pendiente:"Falta información para decidir sobre este aspecto. Hay que conseguir o aclarar el dato indicado.",
    observado:"Se encontró al menos un defecto. El requerimiento también puede tener otros aspectos pendientes.",
    incumple:"Se comprobó un defecto en este criterio con la información confirmada.",
    cumple:"La información confirmada satisface la regla aplicada para este criterio.",
    sin_hallazgo:"Las reglas aplicadas no detectaron un defecto en el alcance revisado.",
    Hallazgo:"Un defecto que quedó demostrado con los hechos y reglas de la evaluación.",
    Pendiente:"Falta información para decidir sobre este aspecto. Hay que conseguir o aclarar el dato indicado.",
    atomicidad:"Revisa si el requerimiento pide una sola cosa que se pueda aceptar como una unidad.",
    ambiguedad:"Revisa si el texto admite interpretaciones distintas que cambien lo que se considera cumplido.",
    verificabilidad:"Revisa si existe una forma clara de comprobar que el requerimiento se cumple.",
    completitud:"Revisa si el requerimiento incluye la información indispensable que le corresponde.",
    bloqueante:"Prioridad que exige atención antes de avanzar con el cierre. El fundamento indica si se debe a un defecto o a información pendiente.",
    mayor:"Categoría intermedia. Para usarla como prioridad final, se revisa que haya un hito acordado y que no exista bloqueo sustantivo confirmado.",
    menor:"Categoría que permite diferir el tratamiento cuando el cliente lo acepta y el impacto es acotado.",
    "Sin dato":"Este dato no quedó registrado o todavía no se conoce.",
    "Sin cálculo":"No hay un resultado calculado disponible. El detalle indica qué dato falta o por qué no corresponde calcularlo.",
    Lectura:"Cómo se obtuvo la interpretación inicial del documento: con IA, con patrones de texto o de forma manual.",
    "Confirmó las premisas":"La persona que revisó y confirmó los datos que después usaron las reglas.",
    "Modelo de lectura":"El modelo de IA usado para leer el texto, si ese dato se conservó en el análisis.",
    "Lote / documento":"Identifica este grupo de requerimientos y el documento del que provienen.",
    "Entradas":"Los datos de partida que se usan para aplicar una regla o hacer un cálculo.",
    "Matriz":"Tabla que cruza severidad e importancia y devuelve una categoría. Las reglas revisan otras condiciones antes de fijar la prioridad final.",
    "Decisión final":"La prioridad que quedó registrada después de revisar la matriz y las condiciones de tratamiento.",
    "Gravedad del defecto":"Qué tan serio es el defecto. Se mantiene sin determinar en los pendientes.",
    "Urgencia difusa":"Puntaje de 0 a 10 que ayuda a ordenar observaciones dentro de una misma prioridad.",
    "Estado de resolución":"Indica si la observación sigue por consultar o ya pasó por un proceso de resolución.",
    "Resultado":"La conclusión o el grado que quedó registrado tras aplicar las reglas.",
    "Banda":"Nombre del tramo donde cae el grado calculado: bajo, medio o alto según los límites del modelo.",
    "Regla":"Una condición del tipo «si ocurre esto, entonces se concluye aquello».",
    "Antecedente":"Las condiciones que activan una regla difusa. min toma el valor menor y max el mayor.",
    "Salida":"El nivel que aporta una regla difusa al cálculo del resultado.",
    "Activación":"Cuánto se cumple una regla difusa, de 0 a 1. Un valor mayor le permite aportar con más fuerza al resultado.",
    "Variable":"El dato de entrada o de salida que describe el modelo difuso.",
    "Etiqueta":"Un nivel como bajo, medio o alto, definido mediante una curva de pertenencia.",
    "Centro":"El valor donde la curva de una etiqueta alcanza su mayor pertenencia.",
    "Sigma":"La dispersión de la curva: determina qué tan ancho es el intervalo asociado a una etiqueta.",
    "Rango":"Los valores mínimo y máximo admitidos para esa variable.",
    "Comprobación":"Una revisión automática que busca un tipo de inconsistencia en la base.",
    "Problemas detectados":"Cantidad de inconsistencias encontradas por el control. Cero indica que ese control no detectó problemas.",
    "Etapa":"Una parte del procesamiento: aplicar reglas, calcular grados o consolidar el informe.",
    "Sentencias":"Cantidad de instrucciones Cypher ejecutadas en esa etapa.",
    "Segundos":"Tiempo que tardó la etapa durante la ejecución original.",
    "Severidad ↓ / Importancia →":"Buscá la gravedad en la fila y la importancia para el negocio en la columna. El cruce muestra la categoría de la matriz.",
    "Celda aplicada":"Es el cruce de severidad e importancia que se usó para esta observación.",
    "Hechos confirmados":"Los datos revisados por el analista que sirven de base para aplicar las reglas.",
    "Reglas aplicadas":"Las reglas que el motor dejó registradas como fundamento de esta conclusión.",
    "Condiciones registradas para esta decisión":"Los datos adicionales que permiten mantener, diferir o bloquear el tratamiento de una observación.",
    "La matriz aplicada":"Muestra el cruce usado en esta observación. La categoría resultante puede cambiar al aplicar las condiciones de tratamiento.",
    "Por qué quedó así":"Explica qué información y condiciones llevaron a la prioridad final registrada.",
    "Controles de integridad":"Revisiones automáticas que buscan inconsistencias técnicas en la base actual.",
    "Informe consolidado":"El resumen que reúne los resultados del análisis del documento.",
    "Qué reglas se activaron y cuánto":"Muestra qué reglas difusas participaron y con qué nivel de activación se guardaron.",
    "Ver evidencia y procedencia":"Permite consultar el texto o los datos que respaldan el resultado y de dónde provienen.",
    "Reglas del estado general de la evaluación":"Combinan los cuatro criterios: un incumplimiento deja la evaluación observada; si solo falta información, queda pendiente.",
    "Cómo se transforma la activación en el resultado":"Explica cómo se combinan las reglas difusas para obtener el puntaje final.",
    "Obligación · qué se pide":"Describe quién debe hacer qué, sobre qué elemento y con qué resultado esperado.",
    "Escenario · en qué contexto":"Describe quién interviene y en qué situación se aplica la obligación.",
    "Divergencia Lecturas":"Cuánto se diferencian las interpretaciones posibles del texto.",
    "Delimitacion Contexto":"Cuánto ayuda el contexto a aclarar las interpretaciones posibles.",
    "Solapamiento Escenario":"Cuánto coinciden las situaciones donde se aplican los requerimientos comparados.",
    "Incompatibilidad Resultados":"Cuánto se oponen los resultados exigidos por los requerimientos comparados.",
    "Severidad Base":"El puntaje de gravedad que entra al cálculo difuso de urgencia.",
    "Criticidad Negocio":"El puntaje de importancia para el negocio que entra al cálculo difuso de urgencia.",
    resultados_sin_trazabilidad:"Cuenta resultados que no tienen una evidencia o una regla que los respalde.",
    decisiones_candidatas_no_provisionales:"Cuenta decisiones que deberían figurar como provisionales y no están marcadas así.",
    incidencias_priorizadas:"Cuenta problemas de entrada que recibieron una prioridad aunque no deberían tratarse como hallazgos.",
    cardinalidades_incorrectas:"Cuenta evaluaciones que no tienen exactamente los cuatro criterios esperados.",
    cierres_sin_reevaluacion:"Cuenta cierres que no tienen una reevaluación válida que los respalde.",
    sigmas_invalidos:"Cuenta curvas difusas sin una dispersión válida. Sigma tiene que ser mayor que cero.",
    grados_fuera_de_rango:"Cuenta puntajes de urgencia fuera del intervalo permitido de 0 a 10.",
    ciclos_de_reevaluacion:"Cuenta cadenas de reevaluaciones que vuelven a una evaluación anterior formando un ciclo.",
    id:"El identificador que permite encontrar este registro y seguir sus relaciones en la base.",
    hallazgos:"Cantidad de defectos demostrados que reúne el informe.",
    completitud_auditoria:"Resume si se dispone de lo necesario para completar la auditoría según las reglas del informe.",
    calidad_observada:"La conclusión de calidad que el informe consolida a partir de las evaluaciones.",
    confianza:"El grado de confianza de la auditoría que quedó registrado en el informe.",
    "Pertenencia":"Indica cuánto encaja un valor en una etiqueta como baja, media o alta, de 0 a 1.",
    "Agregación":"Combina los aportes de las reglas difusas en una sola curva de salida.",
    "Centroide discreto":"Calcula el centro de la curva de salida usando una cantidad finita de puntos. Ese centro es el grado resultante.",
    "Mamdani":"Método que combina reglas con grados de cumplimiento para obtener un resultado numérico.",
    candidata:"La regla o el modelo pertenece a una formalización propuesta que todavía requiere validación experta.",
    modelo_difuso:"Identifica el modelo y la versión usados para combinar entradas y obtener un grado.",
    "Criticidad Operacion":"El puntaje de importancia de la operación para el negocio que entra al cálculo de urgencia.",
    "Criticidad Requerimiento":"El puntaje de importancia del requerimiento para el negocio que entra al cálculo de urgencia.",
    "Qué información entró":"El texto de origen, la lectura propuesta y los datos confirmados antes de aplicar las reglas.",
    "Cómo se evaluó la calidad":"SM1 revisa cada requerimiento en cuatro criterios y registra el fundamento de sus conclusiones.",
    "Cómo se compararon los requerimientos":"SM2 revisa pares de requerimientos para identificar incompatibilidades en situaciones compartidas.",
    "Cómo se decidió la prioridad":"SM3 combina la gravedad, la importancia y las condiciones acordadas para decidir qué atender primero.",
    "Cómo se calcularon los grados y se verificó el resultado":"Muestra las entradas del cálculo difuso, las reglas que participaron y los controles técnicos ejecutados."
  };
  const normalizarAyuda = s => String(s).normalize("NFD").replace(/[\u0300-\u036f]/g,"").replaceAll("_"," ").toLowerCase().trim().replace(/:$/,"");
  const ayudasPorEtiqueta = Object.fromEntries([...Object.entries(glosario),...Object.entries({...campos,...controles}).filter(([k])=>glosario[k]).map(([k,v])=>[v,glosario[k]])].map(([k,v])=>[normalizarAyuda(k),v]));
  function ayuda(texto, clave=texto, definicion=""){
    const explicacion=definicion||glosario[clave]||ayudasPorEtiqueta[normalizarAyuda(clave)]||ayudasPorEtiqueta[normalizarAyuda(texto)];
    return explicacion?`<span class="tec-termino" data-tec-ayuda="${e(explicacion)}">${e(texto)}<button type="button" class="tec-ayuda" data-tec-ayuda-boton aria-label="Qué significa ${e(texto)}">?</button></span>`:e(texto);
  }
  const ficha = (titulo, texto) => `<div class="tec-dato"><small>${ayuda(titulo)}</small><strong>${e(texto)}</strong></div>`;
  const datos = (obj={}, keys=Object.keys(obj), etiquetas={}) => `<dl class="tec-datos">${keys.filter(k => Object.hasOwn(obj,k)).map(k => `<div><dt>${ayuda(etiquetas[k] || campos[k] || tit(k),etiquetas[k] || k)}</dt><dd>${e(valor(obj[k]))}</dd></div>`).join("")}</dl>`;
  const estado = t => `<span class="tec-estado ${["cumple","sin_hallazgo","incumple","observado","pendiente"].includes(t)?t:""}">${ayuda(tit(t),t)}</span>`;
  const extra = (titulo, cuerpo) => `<details class="tec-extra"><summary>${ayuda(titulo)}</summary>${cuerpo}</details>`;
  const tabla = (cab, filas, clase="") => `<div class="tec-tabla"><table class="${clase}"><thead><tr>${cab.map((c,i)=>`<th scope="col">${ayuda(c,c,clase==="tec-matriz"&&i>0?`Nivel ${c.toLowerCase()} de importancia para el negocio. Buscá la gravedad en las filas para ver la categoría que resulta.`:"")}</th>`).join("")}</tr></thead><tbody>${filas.join("")}</tbody></table></div>`;
  const seccion = (numero, titulo, descripcion, cuerpo, abierta=false) => `<details class="tec-seccion" ${abierta?"open":""}><summary><span class="tec-num">${numero}</span><span><b>${e(titulo)}</b><small>${e(descripcion)}</small></span></summary><div class="tec-cuerpo">${cuerpo}</div></details>`;
  const destino = (tipo,id) => `tec-${tipo}-${id}`;
  const enlace = (tipo,id,texto,atributos="") => `<a class="tec-enlace" href="#${e(destino(tipo,id))}" data-tec-ir="${e(destino(tipo,id))}" ${atributos}>${e(texto)}</a>`;
  const caso = (titulo, subtitulo, cuerpo, badge="",id="") => `<details class="tec-caso" ${id?`id="${e(id)}"`:""}><summary><span><b>${e(titulo)}</b><small>${e(subtitulo)}</small></span>${badge}</summary><div class="tec-caso-cuerpo">${cuerpo}</div></details>`;

  function contexto(res){
    const t=res.tecnico || {}, nodos=Object.fromEntries((t.nodos||[]).map(x=>[x.id,x.datos])), reglas=Object.fromEntries((t.reglas||[]).map(x=>[x.id,x]));
    for(const rq of res.requerimientos||[]) for(const j of rq.evaluacion?.juicios||[]) for(const r of j.reglas||[]) if(typeof r!=="string") reglas[r.id]={...reglas[r.id],...r};
    for(const cp of res.comparaciones||[]) for(const r of cp.reglas||[]) if(typeof r!=="string") reglas[r.id]={...reglas[r.id],...r};
    const node = id => nodos[id] || {};
    const nombre = id => { const rq=(res.requerimientos||[]).find(r=>r.id===id); return rq?.id_documento || rq?.id || id; };
    const reglasHTML = lista => {
      const rs=[...new Map((lista||[]).map(r=>{ const x=typeof r==="string"?reglas[r]||{id:r}:r; return [x.id,{...reglas[x.id],...x}]; })).values()];
      for(const r of rs) reglas[r.id]={...reglas[r.id],...r};
      return rs.length ? `<div class="tec-referencias">${rs.map(r=>enlace("regla",r.id,r.id)).join("")}</div>` : `<p class="tec-nota">No hay una regla aplicada registrada.</p>`;
    };
    const evidencia = id => {
      const evs=(t.relaciones||[]).filter(r=>r.desde===id && r.relacion==="SE_SUSTENTA_EN").map(r=>node(r.hasta));
      return evs.length ? `<p class="tec-nota">Evidencia: ${evs.map(x=>e(x.id)).join(" · ")}. Los textos y las premisas se muestran en su etapa de origen.</p>` : "";
    };
    return {t,node,nombre,reglas,reglasHTML,evidencia};
  }

  function interpretacion(ob,es){
    const filas=[];
    const agregar=(etiqueta,v,def)=>{if(v!=null&&v!=="") filas.push(`<div><dt>${ayuda(etiqueta,etiqueta,def)}</dt><dd>${e(valor(v))}</dd></div>`);};
    if(ob.sujeto&&ob.sujeto===es.actor) agregar("Sujeto y actor",ob.sujeto,"En este caso, quien debe cumplir la obligación también es el actor del escenario.");
    else {agregar("Sujeto",ob.sujeto);agregar("Actor",es.actor);}
    agregar("Acción",ob.accion);
    const grupos=new Map();
    for(const [etiqueta,v] of [["Objeto de la obligación",ob.objeto],["Resultado esperado",ob.resultado],["Objeto del escenario",es.objeto]]){
      if(v==null||v==="") continue;
      const etiquetas=grupos.get(v)||[];etiquetas.push(etiqueta);grupos.set(v,etiquetas);
    }
    for(const [v,etiquetas] of grupos){
      const etiqueta=etiquetas.length===3?"Objeto y resultado":etiquetas.length===2&&etiquetas.includes("Objeto de la obligación")&&etiquetas.includes("Objeto del escenario")?"Objeto compartido":etiquetas.join(" / ");
      agregar(etiqueta,v,etiquetas.length>1?`${etiquetas.join(", ")} coinciden en este caso; se muestran juntos.`:"");
    }
    agregar("Estado o condición",es.estado);agregar("Modalidad",ob.modalidad);
    return `<dl class="tec-datos">${filas.join("")}</dl>`;
  }

  function entrada(res,c){
    const p=c.t.propuesta_confirmada;
    const fuente={llm:"Lectura con IA",heuristica:"Borrador léxico",mixta:"Lectura con IA y respaldo léxico",manual:"Ingreso manual",prueba:"Caso de prueba"}[res.fuente_propuesta] || tit(res.fuente_propuesta);
    let h=`<div class="tec-fichas">${ficha("Lectura",fuente)}${ficha("Confirmó las premisas",res.analista||"Sin registro")}${ficha("Modelo de lectura",p?.llm?.modelo||"No conservado en este análisis")}${ficha("Lote / documento",(res.lote||"Sin lote")+" · "+(res.documento||res.documento_id||"Documento sin identificar"))}</div>
      <p class="tec-nota">La IA propone una lectura. El analista confirma las premisas y Neo4j aplica las reglas para obtener estados, prioridades y grados.</p>
      <p><b>Contexto adicional:</b> ${e(res.contexto||"Sin contexto adicional.")}</p>`;
    if(!p) h+=`<p class="tec-nota">En este análisis anterior no se conservó la lectura inicial. Se recuperan el texto y las premisas confirmadas que quedaron guardadas en el grafo.</p>`;
    if(p?.avisos?.length) h+=extra("Avisos de la lectura",`<ul>${p.avisos.map(a=>`<li>${e(a)}</li>`).join("")}</ul>`);
    for(const rq of res.requerimientos||[]){
      const original=p?.requerimientos?.find(r=>rq.id.endsWith(`-${r.clave}-v1`));
      const r=c.node(rq.id), ob=c.node("O-"+rq.id), es=c.node("ESC-"+rq.id);
      const j=rq.evaluacion?.juicios?.find(j=>j.criterio==="ambiguedad");
      const adicionales={...(original?.extraccion||{})};
      if(!adicionales.lecturas&&j) adicionales.lecturas=c.node(j.id).lecturas;
      const adicionalesKeys=["obligaciones","terminos_vagos","lecturas","criterio_medible","omisiones"].filter(k=>k==="obligaciones"?adicionales[k]?.length>1:Array.isArray(adicionales[k])?adicionales[k].length:!!adicionales[k]);
      const lectura=adicionalesKeys.length?`<h4>Qué más se detectó en el texto</h4>${datos(adicionales,adicionalesKeys)}`:"";
      h+=caso(c.nombre(rq.id),[rq.id,rq.ubicacion].filter(Boolean).join(" · "),`<blockquote>${e(rq.texto)}</blockquote>
        <h4>Obligación y escenario interpretados</h4>${interpretacion(ob,es)}
        <h4>Importancia y condiciones confirmadas</h4>${datos(r,["criticidad_valor","grado_criticidad","fundamento_criticidad",...condiciones])}${lectura}`,"",destino("entrada",rq.id));
    }
    return h;
  }

  function calidad(res,c){
    return `<p class="tec-nota">Cada requerimiento se revisa en cuatro criterios. Un incumplimiento produce un hallazgo; la información insuficiente puede dejar un pendiente. Las reglas de la evaluación combinan esos estados.</p>`+(res.requerimientos||[]).map(rq=>{
      const ev=rq.evaluacion||{};
      let h=`<p>${enlace("entrada",rq.id,"Ver texto, interpretación y datos confirmados")}</p>${extra("Reglas del estado general de la evaluación",c.reglasHTML(ev.reglas))}`;
      for(const j of [...(ev.juicios||[])].sort((a,b)=>Object.keys(nombreCrit).indexOf(a.criterio)-Object.keys(nombreCrit).indexOf(b.criterio))){
        const observaciones=(res.observaciones||[]).filter(o=>o.juicio_id===j.id);
        const base=c.node(j.id);
        const propuesta=c.t.propuesta_confirmada?.requerimientos?.find(r=>rq.id.endsWith(`-${r.clave}-v1`));
        const confirmado=propuesta?.premisas?.criterios?.[j.criterio]||{};
        const adicionales={};
        if(confirmado.metodo&&confirmado.metodo!==propuesta?.extraccion?.criterio_medible) adicionales.metodo=confirmado.metodo;
        const omisiones=(confirmado.omisiones||[]).filter(x=>!(propuesta?.extraccion?.omisiones||[]).includes(x));
        if(omisiones.length) adicionales.omisiones=omisiones;
        h+=`<details class="tec-criterio" id="${e(destino("juicio",j.id))}"><summary><b>${e(nombreCrit[j.criterio]||j.criterio)}</b>${estado(j.estado)}</summary><div class="tec-caso-cuerpo">
          <p>${e(j.justificacion)}</p><h4>Hechos confirmados</h4>${datos(base,critKeys.filter(k=>k!=="lecturas"))}${Object.keys(adicionales).length?datos(adicionales):""}
          <h4>Reglas aplicadas</h4>${c.reglasHTML(j.reglas)}
          ${observaciones.length?`<p class="tec-nota">Observaciones generadas: ${observaciones.map(o=>enlace("prioridad",o.id,`${o.id} · ${o.clase}`)).join(" · ")}</p>`:`<p class="tec-nota">No se generó una observación para este criterio.</p>`}
          ${j.criterio==="ambiguedad"?`<p>${enlace("calculo",j.id,"Ver grado y cálculo de ambigüedad")}</p>`:""}${c.evidencia(j.id)}</div></details>`;
      }
      return caso(c.nombre(rq.id),ev.id||"Evaluación individual",h,estado(ev.estado),destino("calidad",rq.id));
    }).join("");
  }

  function comparaciones(res,c){
    const comparaciones=res.comparaciones || (res.comparacion?[res.comparacion]:[]);
    if(!comparaciones.length) return `<p class="tec-nota">Este análisis no registró pares de requerimientos para comparar.</p>`;
    return `<p class="tec-nota">Antes de concluir que hay una contradicción, se revisan los escenarios, la interpretación y las excepciones que podrían conciliar el par.</p>`+comparaciones.map(x=>{
      const obs=(res.observaciones||[]).filter(o=>o.origen===x.id);
      const reqs=(x.requerimientos||[]).map(id=>(res.requerimientos||[]).find(r=>r.id===id)).filter(Boolean);
      const cuerpo=`<p>Textos comparados: ${reqs.map(r=>enlace("entrada",r.id,c.nombre(r.id))).join(" · ")}</p>
        <p>${e(x.justificacion)}</p><h4>Hechos confirmados</h4>${datos(c.node(x.id),cmpKeys)}
        <h4>Reglas aplicadas</h4>${c.reglasHTML(x.reglas)}${obs.length?`<p class="tec-nota">Observaciones generadas: ${obs.map(o=>enlace("prioridad",o.id,`${o.id} · ${o.clase}`)).join(" · ")}</p>`:`<p class="tec-nota">Sin observación generada.</p>`}<p>${enlace("calculo",x.id,"Ver grado y cálculo de contradicción")}</p>${c.evidencia(x.id)}`;
      return caso((x.requerimientos||[]).map(c.nombre).join(" frente a "),x.id,cuerpo,estado(x.estado),destino("comparacion",x.id));
    }).join("");
  }

  function matriz(c,version){
    const celdas=(c.t.matriz||[]).filter(x=>x.version===version);
    const filas=["baja","media","alta"].map(s=>`<tr><th scope="row">${ayuda(tit(s),s,`Gravedad ${s} del defecto. Cruzala con la importancia para el negocio de las columnas.`)}</th>${["baja","media","alta"].map(cr=>{
      const celda=celdas.find(x=>x.severidad===s&&x.criticidad===cr);
      return `<td data-tec-severidad="${s}" data-tec-criticidad="${cr}">${ayuda(tit(celda?.categoria),celda?.categoria)}</td>`;
    }).join("")}</tr>`);
    return `<details class="tec-extra tec-matriz-compartida" id="${e(destino("matriz",version))}"><summary>Matriz ${e(version)}</summary><p class="tec-nota" data-tec-seleccion aria-live="polite">Usá «Ver en matriz» en una observación para resaltar el cruce que se aplicó.</p>${tabla(["Severidad ↓ / Importancia →","Baja","Media","Alta"],filas,"tec-matriz")}</details>`;
  }

  function fundamento(o,x){
    const d=o.decision||{};
    if(!d.id) return "No hay una decisión de prioridad registrada para esta observación.";
    if(d.motivo==="preventivo"){
      if(!d.criticidad?.valor) return "La importancia para el negocio no está declarada; se aplica un bloqueo preventivo hasta completar ese dato.";
      if(!o.severidad?.valor) return o.clase==="Pendiente" ? "Falta información para completar la evaluación. La severidad del pendiente queda sin determinar y se aplica un bloqueo preventivo." : "La gravedad del defecto no está determinada; se aplica un bloqueo preventivo.";
      if(d.categoria_matriz==="mayor"){
        const faltan=[];
        if(x.hito_acordado!==true) faltan.push("una fecha de resolución acordada");
        if(x.bloqueo_sustantivo_confirmado!==false) faltan.push("la ausencia de un bloqueo sustantivo confirmado");
        return `Falta confirmar ${faltan.join(" y ")||"las condiciones de tratamiento"}.`;
      }
      if(d.categoria_matriz==="menor"){
        const faltan=[];
        if(x.diferimiento_aceptado!==true) faltan.push("la aceptación del cliente para diferirlo");
        if(x.impacto_acotado!==true) faltan.push("que el impacto sea acotado");
        return `Falta confirmar ${faltan.join(" y ")||"las condiciones de diferimiento"}.`;
      }
      return "La decisión registrada es preventiva y requiere completar información o condiciones de tratamiento.";
    }
    if(d.motivo==="en_hito") return "Hay una fecha de resolución acordada y no hay bloqueo sustantivo confirmado.";
    if(d.motivo==="diferimiento") return "El cliente aceptó diferirlo y el impacto es acotado.";
    if((d.reglas||[]).includes("PRC-HC01")) return "El hallazgo deja una obligación esencial sin definir. Esa condición determina el bloqueo sustantivo.";
    return "La combinación de severidad e importancia determina una prioridad bloqueante sustantiva según la regla registrada.";
  }

  function prioridades(res,c){
    const orden={bloqueante:0,mayor:1,menor:2};
    const obs=[...(res.observaciones||[])].sort((a,b)=>(orden[a.decision?.prioridad]??3)-(orden[b.decision?.prioridad]??3)||(b.decision?.grado_urgencia??-1)-(a.decision?.grado_urgencia??-1));
    if(!obs.length) return `<p class="tec-nota">No hay hallazgos ni pendientes que priorizar.</p>`;
    let h=`<p class="tec-nota">La matriz combina gravedad e importancia. Las reglas revisan además las condiciones de tratamiento para determinar la prioridad final. Un bloqueo preventivo pide completar información; uno sustantivo corresponde al problema demostrado.</p>`;
    for(const version of [...new Set((c.t.matriz||[]).map(m=>m.version))]) h+=matriz(c,version);
    for(const o of obs){
      const d=o.decision||{}, dn=c.node(d.id);
      const idContexto=(c.t.relaciones||[]).find(r=>r.desde===d.id&&r.relacion==="USA_CONTEXTO")?.hasta;
      const x=c.node(idContexto);
      const origen=(res.requerimientos||[]).find(r=>r.evaluacion?.id===o.origen);
      const comp=(res.comparaciones||[]).find(r=>r.id===o.origen);
      const titulo=origen?c.nombre(origen.id):comp?(comp.requerimientos||[]).map(c.nombre).join(" / "):o.id;
      const reqs=origen?[origen]:(res.requerimientos||[]).filter(r=>(comp?.requerimientos||[]).includes(r.id));
      const fuenteImportancia=c.node(dn.criticidad_id).ambito;
      const rqImportancia=reqs.find(r=>r.id===fuenteImportancia)||reqs.find(r=>r.criticidad===d.criticidad?.valor&&r.grado_criticidad===d.criticidad?.grado);
      const importancia=rqImportancia?enlace("entrada",rqImportancia.id,`Declarada en ${c.nombre(rqImportancia.id)}`):e(`${d.criticidad?.valor||"Sin declarar"} · ${n(d.criticidad?.grado)} / 10`);
      const version=dn.matriz_id_version||(c.t.matriz||[])[0]?.version;
      const verMatriz=d.categoria_matriz&&version?enlace("matriz",version,"Ver en matriz",`data-tec-celda="${e(JSON.stringify({severidad:o.severidad?.valor,criticidad:d.criticidad?.valor,observacion:o.id}))}"`):"";
      const origenHTML=o.juicio_id?enlace("juicio",o.juicio_id,"Ver evaluación que generó esta observación"):enlace("comparacion",o.origen,"Ver comparación que generó esta observación");
      const distintas=condiciones.filter(k=>Object.hasOwn(x,k)&&(!reqs.length||!reqs.every(r=>c.node(r.id)[k]===x[k])));
      const condicionesHTML=`<p>${reqs.map(r=>enlace("entrada",r.id,`Ver condiciones de ${c.nombre(r.id)}`)).join(" · ")}</p>${distintas.length?`<h4>Condiciones combinadas para esta decisión</h4>${datos(x,distintas)}`:""}`;
      const cuerpo=`<p>${origenHTML}</p>${o.dato_faltante&&o.dato_faltante!==c.node(o.juicio_id).dato_faltante?`<p>Dato faltante: ${e(o.dato_faltante)}</p>`:""}
        <div class="tec-fichas"><div id="${e(destino("severidad",o.id))}">${ficha("Gravedad del defecto",o.severidad?.valor?`${o.severidad.valor}${o.severidad.grado!=null?` · ${n(o.severidad.grado)} / 10`:""}`:"Sin determinar")}</div><div class="tec-dato"><small>${ayuda("Importancia para el negocio")}</small><strong>${importancia}</strong></div><div class="tec-dato"><small>${ayuda("Matriz")}</small><strong>${e(d.categoria_matriz||"Sin celda aplicada")}</strong>${verMatriz}</div>${ficha("Estado de resolución",tit(d.estado_resolucion))}</div>
        <div class="tec-conclusion"><b>Por qué quedó así</b><p>${e(fundamento(o,x))}</p></div>
        ${condicionesHTML}
        <h4>Reglas de la decisión</h4>${c.reglasHTML(d.reglas)}
        ${d.id?`<p>${enlace("calculo",d.id,"Ver urgencia y su cálculo")}</p>`:""}<p class="tec-nota">${dn.provisional===true?"Decisión provisional. ":""}${dn.revisada_humanamente===false?"Revisión humana pendiente. ":""}${dn.emitible===false?"No habilitada para emisión.":""}</p>`;
      h+=caso(titulo,`${o.id} · ${o.clase} · ${tit(o.tipo_defecto||o.motivo_pendiente||"")}`,cuerpo,`<span class="tec-estado">${ayuda(tit(d.prioridad),d.prioridad)} · ${e(d.motivo||"")}</span>`,destino("prioridad",o.id));
    }
    return h;
  }

  function calculo(titulo,id,salida,banda,max,c,entradas,modeloEsperado,motivoSinCalculo="",referencias=[]){
    const registro=c.node(id), modelo=c.t.modelos?.find(m=>m.datos.id===(registro.modelo_difuso_version||modeloEsperado));
    const md=modelo?.datos||{}, variables=modelo?.variables||[];
    const vx=variables.find(v=>v.datos.id===md.id+"-x"), vy=variables.find(v=>v.datos.id===md.id+"-y");
    const x=registro.input_x??entradas[0], y=registro.input_y??entradas[1];
    const haySalida=typeof salida==="number"&&Number.isFinite(salida);
    const entradaHTML=(nombre,v,ref)=>ref?`<div class="tec-dato"><small>${ayuda(tit(nombre))}</small><strong>${ref}</strong></div>`:ficha(tit(nombre),n(v));
    let h=`<div class="tec-fichas">${entradaHTML(vx?.datos.nombre||"Entrada x",x,referencias[0])}${entradaHTML(vy?.datos.nombre||"Entrada y",y,referencias[1])}</div>`;
    if(!haySalida) h+=`<div class="tec-conclusion"><b>Por qué no hay un grado</b><p>${e(motivoSinCalculo || (x==null||y==null?"Falta una entrada numérica necesaria para calcular este grado.":"No se registró un resultado difuso para este caso."))}</p><p>Estado registrado: ${e(tit(registro.estado_calculo_difuso||"no aplicado"))}.</p></div>`;
    if(modelo){
      h+=`<p>${enlace("modelo",md.id,`Ver definición y parámetros de ${md.id}`)}</p>${registro.revision_senior_requerida?`<p class="tec-nota">La banda requiere revisión senior; no implica que ya se haya realizado.</p>`:""}`;
      const filas=(registro.reglas_difusas_ids||[]).map((id,i)=>{
        const alpha=registro.activaciones?.[i];
        return `<tr><td>${enlace("regla-difusa",id,id)}</td><td>${n(alpha,6)}${typeof alpha==="number"?`<meter min="0" max="1" value="${alpha}" aria-label="Activación de ${e(id)}"></meter>`:""}</td></tr>`;
      });
      if(filas.length) h+=`<h4>Activaciones de este caso</h4>${tabla(["Regla","Activación"],filas)}`;
    } else h+=`<p class="tec-nota">Los parámetros del modelo no están disponibles en el catálogo consultado.</p>`;
    return caso(titulo,id,h,`<span class="tec-estado">${haySalida?n(salida)+" / "+max+(banda?" · "+e(banda):""):ayuda("Sin cálculo")}</span>`,destino("calculo",id));
  }

  function catalogoReglas(c){
    return `<details class="tec-extra"><summary>Catálogo de reglas aplicadas</summary>${Object.values(c.reglas).sort((a,b)=>a.id.localeCompare(b.id)).map(r=>`<div class="tec-regla" id="${e(destino("regla",r.id))}"><code>${ayuda(r.id,"Regla")}</code><p>${e(r.descripcion||"No se conservó la descripción de esta regla.")}</p><small>${e([r.descripcion_fuente||r.fuente,r.estado_validacion].filter(Boolean).join(" · "))}</small></div>`).join("")}</details>`;
  }

  function catalogoModelos(c){
    let h=extra("Cómo funciona la lógica difusa",`<ol class="tec-metodo"><li><b>Pertenencia:</b> cada entrada se compara con etiquetas gaussianas.</li><li><b>Activación:</b> AND toma el mínimo y OR el máximo. Cada regla recorta su curva de salida al nivel de su activación.</li><li><b>Agregación:</b> se toma el máximo de las curvas recortadas.</li><li><b>Centroide discreto:</b> el centro de esa distribución produce el grado final.</li></ol><pre>μ(v) = exp(−0,5 × ((v − centro) / sigma)²)
μ_salida(z) = maxᵣ(min(activaciónᵣ, μ_consecuenteᵣ(z)))
grado = Σ(z × μ_salida(z)) / Σμ_salida(z)</pre><p class="tec-nota">xb/xm/xa son las pertenencias de x a baja/media/alta; yb/ym/ya corresponden a y.</p>`);
    for(const modelo of c.t.modelos||[]){
      const md=modelo.datos, variables=modelo.variables||[], max=variables.find(v=>v.datos.rol==="salida")?.datos.max;
      const parametros=variables.flatMap(v=>(v.etiquetas||[]).map(et=>`<tr><td>${e(tit(v.datos.nombre))}</td><td>${e(et.nombre)}</td><td>${n(et.centro)}</td><td>${n(et.sigma)}</td><td>${n(v.datos.min)} a ${n(v.datos.max)}</td></tr>`));
      const reglas=(modelo.reglas||[]).map(r=>`<tr id="${e(destino("regla-difusa",r.id))}"><td><code>${ayuda(r.id,"Regla")}</code></td><td><code>${e(r.antecedente)}</code></td><td>${e(r.salida)}</td></tr>`);
      const cuerpo=`<p>${ayuda(md.tipo)} · ${ayuda(md.estado_validacion)} · ${e(md.puntos)} puntos · paso ${e(md.paso)}.</p><p class="tec-nota">Bandas: baja por debajo de ${max===10?"2,73":"0,273"}; media o intermedia hasta antes de ${max===10?"7,27":"0,727"}; alta desde ese valor.</p><h4>Parámetros de las variables</h4>${tabla(["Variable","Etiqueta","Centro","Sigma","Rango"],parametros)}<h4>Definición de las reglas difusas</h4>${tabla(["Regla","Antecedente","Salida"],reglas)}`;
      h+=caso(md.nombre,md.id,cuerpo,"",destino("modelo",md.id));
    }
    return h;
  }

  function calculosYControles(res,c){
    let h=`<p class="tec-nota">Los estados se obtienen con reglas. La lógica difusa agrega grados de ambigüedad, contradicción y urgencia. A continuación se muestran las entradas y activaciones registradas, junto con los parámetros del catálogo.</p>`;
    for(const rq of res.requerimientos||[]){
      const j=rq.evaluacion?.juicios?.find(j=>j.criterio==="ambiguedad");
      if(j){const p=c.node(j.id); h+=calculo("Ambigüedad · "+c.nombre(rq.id),j.id,j.grado_ambiguedad,j.banda,1,c,[p.divergencia_lecturas,p.delimitacion_contexto],"MD-AMB-1.0");}
    }
    for(const cmp of res.comparaciones||[]){
      const p=c.node(cmp.id);
      const razon=p.excepcion_resuelve?"Una excepción concilia el par; no corresponde calcular contradicción.":p.escenarios==="excluyentes"?"Los escenarios son excluyentes; no corresponde calcular contradicción.":p.dato_necesario_faltante?"Falta información necesaria para comparar el par.":"";
      h+=calculo("Contradicción · "+(cmp.requerimientos||[]).map(c.nombre).join(" / "),cmp.id,cmp.grado_contradiccion,cmp.banda,1,c,[p.solapamiento_escenario,p.incompatibilidad_resultados],"MD-CONTR-1.0",razon);
    }
    for(const o of res.observaciones||[]){
      const d=o.decision;
      if(d){
        const dn=c.node(d.id), fuente=c.node(dn.criticidad_id).ambito;
        const rq=(res.requerimientos||[]).find(r=>r.id===fuente);
        const referencias=[o.severidad?.grado!=null?enlace("severidad",o.id,"Ver gravedad de la observación"):"",d.criticidad?.grado!=null?(rq?enlace("entrada",rq.id,`Ver importancia de ${c.nombre(rq.id)}`):enlace("prioridad",o.id,"Ver importancia usada en la decisión")):""];
        h+=calculo("Urgencia · "+o.id,d.id,d.grado_urgencia,d.banda,10,c,[o.severidad?.grado,d.criticidad?.grado],"MD-URG-1.0",o.clase==="Pendiente"&&!o.severidad?.valor?"La severidad de un pendiente queda sin determinar; falta esa entrada para calcular la urgencia.":"",referencias);
      }
    }
    const ctl=res.controles;
    h+=`<h4>Controles de integridad</h4><p class="tec-nota">Comprobaciones ejecutadas al consultar este detalle sobre toda la base. Cada conteo representa problemas detectados y debe ser cero. Estos controles técnicos no sustituyen la revisión experta del contenido.</p>`;
    h+=ctl?tabla(["Comprobación","Problemas detectados"],Object.entries(ctl.conteos||{}).map(([k,v])=>`<tr><td>${e(controles[k]||tit(k))}</td><td><span class="tec-estado ${v===0?"cumple":"pendiente"}">${e(v)} ${v===0?"· correcto":"· revisar"}</span></td></tr>`)):`<p class="tec-nota">No se recibieron resultados de los controles.</p>`;
    if(res.informe) h+=`<h4>Informe consolidado</h4>${datos(res.informe)}`;
    if(res.tiempos) h+=extra("Tiempos de la ejecución original",`<p>Escritura: ${n(res.tiempos.escritura_s)} s · total: ${n(res.tiempos.total_s)} s.</p>${tabla(["Etapa","Sentencias","Segundos"],(res.tiempos.etapas||[]).map(x=>`<tr><td>${e(x.script)}</td><td>${e(x.sentencias)}</td><td>${n(x.segundos)}</td></tr>`))}`);
    else h+=`<p class="tec-nota">No se conservaron los tiempos de ejecución de este análisis.</p>`;
    h+=catalogoReglas(c)+`<h4>Modelos y método de cálculo</h4>`+catalogoModelos(c);
    h+=`<p><button type="button" class="tec-descargar" data-tec-exportar>Descargar registro completo (JSON)</button></p>`;
    return h;
  }

  function render(res){
    const c=contexto(res), reqs=res.requerimientos||[], cmps=res.comparaciones||[], obs=res.observaciones||[];
    return `<details class="hoja detalle tecnico"><summary>Ver el detalle técnico <small>· datos, reglas, matriz y cálculos</small></summary><div class="detalle-cuerpo">
      <div class="tec-intro"><span class="tec-ceja">EL RECORRIDO DE ESTA AUDITORÍA</span><h3>De lo que escribiste a lo que hay que resolver</h3><p>Abrí cada etapa para seguir las decisiones. Dentro de cada caso encontrás los hechos, las reglas y la evidencia que las sustentan.</p><p class="tec-nota">Pasá el mouse por los términos con <span aria-hidden="true">?</span> para ver una explicación. También podés tocar el signo o enfocarlo con el teclado.</p></div>
      <div class="tec-recorrido" aria-label="Etapas del análisis"><span>Datos</span><i>→</i><span>Calidad</span><i>→</i><span>Comparación</span><i>→</i><span>Prioridad</span><i>→</i><span>Cálculos y controles</span></div>
      ${seccion("01","Qué información entró",`${reqs.length} requerimientos · lectura y premisas confirmadas`,entrada(res,c),true)}
      ${seccion("02","Cómo se evaluó la calidad",`SM1 · atomicidad, ambigüedad, verificabilidad y completitud`,calidad(res,c))}
      ${seccion("03","Cómo se compararon los requerimientos",`SM2 · ${cmps.length} pares registrados`,comparaciones(res,c))}
      ${seccion("04","Cómo se decidió la prioridad",`SM3 · ${obs.length} observaciones · matriz y condiciones de tratamiento`,prioridades(res,c))}
      ${seccion("05","Cómo se calcularon los grados y se verificó el resultado","Lógica difusa · activaciones, fórmulas y controles de integridad",calculosYControles(res,c))}
    </div></details>`;
  }
  function referenciaObservacion(o){
    const evaluacion=o.juicio_id?enlace("juicio",o.juicio_id,"Ver evaluación"):enlace("comparacion",o.origen,"Ver comparación");
    return `<div class="tec-accesos">${evaluacion}${enlace("prioridad",o.id,"Ver prioridad")}</div>`;
  }
  const registros=new WeakMap();
  let tooltip=null, terminoActivo=null, fijado=false, cierrePendiente=null;
  function cerrarAyuda(){
    clearTimeout(cierrePendiente);
    terminoActivo?.querySelector("button")?.removeAttribute("aria-describedby");
    if(tooltip) tooltip.hidden=true;
    terminoActivo=null; fijado=false;
  }
  function ubicarAyuda(){
    const boton=terminoActivo?.querySelector("button");
    if(!boton?.isConnected || !boton.getClientRects().length){cerrarAyuda();return;}
    const r=boton.getBoundingClientRect();
    tooltip.style.width=Math.min(320,Math.max(0,window.innerWidth-24))+"px";
    const rect=tooltip.getBoundingClientRect();
    const izquierda=Math.max(12,Math.min(r.left,window.innerWidth-rect.width-12));
    const arriba=r.bottom+10+rect.height<=window.innerHeight-12?r.bottom+10:r.top-rect.height-10;
    tooltip.style.left=izquierda+"px";
    tooltip.style.top=Math.max(12,Math.min(arriba,window.innerHeight-rect.height-12))+"px";
  }
  function mostrarAyuda(termino,fijar=false){
    clearTimeout(cierrePendiente);
    if(terminoActivo!==termino) terminoActivo?.querySelector("button")?.removeAttribute("aria-describedby");
    terminoActivo=termino; fijado=fijar;
    tooltip.textContent=termino.dataset.tecAyuda;
    tooltip.hidden=false;
    termino.querySelector("button").setAttribute("aria-describedby",tooltip.id);
    ubicarAyuda();
  }
  function activarAyudas(raiz,registro){
    registros.set(raiz,registro);
    cerrarAyuda();
    // Añade ayuda a títulos y estados que no pasan por los constructores de etiquetas.
    raiz.querySelectorAll(".tecnico h4, .tec-criterio > summary > b, .tec-seccion > summary b, .tec-conclusion > b, .tec-estado, .tec-metodo b").forEach(el=>{
      if(!el.querySelector(".tec-termino")) el.innerHTML=ayuda(el.textContent);
    });
    if(raiz.dataset.tecAyudas) return;
    raiz.dataset.tecAyudas="activas";
    tooltip=document.createElement("div");
    tooltip.id="auditia-ayuda-tecnica"; tooltip.className="tec-tooltip"; tooltip.setAttribute("role","tooltip"); tooltip.hidden=true;
    document.body.append(tooltip);
    const aplazarCierre=()=>{if(!fijado) cierrePendiente=setTimeout(cerrarAyuda,180);};
    raiz.addEventListener("pointerover",ev=>{
      if(ev.pointerType==="touch"||fijado) return;
      const termino=ev.target.closest(".tec-termino[data-tec-ayuda]");
      if(termino) mostrarAyuda(termino);
    });
    raiz.addEventListener("pointerout",ev=>{
      const termino=ev.target.closest(".tec-termino[data-tec-ayuda]");
      if(!termino || termino.contains(ev.relatedTarget) || tooltip.contains(ev.relatedTarget)) return;
      if(!termino.contains(document.activeElement)) aplazarCierre();
    });
    raiz.addEventListener("focusin",ev=>{
      const termino=ev.target.closest(".tec-termino[data-tec-ayuda]");
      if(termino) mostrarAyuda(termino);
    });
    raiz.addEventListener("focusout",ev=>{
      if(terminoActivo&&!terminoActivo.contains(ev.relatedTarget)&&!tooltip.contains(ev.relatedTarget)) cierrePendiente=setTimeout(cerrarAyuda,180);
    });
    raiz.addEventListener("click",ev=>{
      const ir=ev.target.closest("[data-tec-ir]");
      if(ir){
        const target=document.getElementById(ir.dataset.tecIr);
        if(!target) return;
        ev.preventDefault();cerrarAyuda();
        for(let padre=target;padre&&padre!==raiz;padre=padre.parentElement) if(padre.tagName==="DETAILS") padre.open=true;
        if(ir.dataset.tecCelda){
          const celda=JSON.parse(ir.dataset.tecCelda);
          target.querySelectorAll("[data-tec-severidad]").forEach(td=>{
            const activa=td.dataset.tecSeveridad===celda.severidad&&td.dataset.tecCriticidad===celda.criticidad;
            td.classList.toggle("tec-celda-activa",activa);
            if(activa) td.setAttribute("aria-label","Celda aplicada");else td.removeAttribute("aria-label");
          });
          target.querySelector("[data-tec-seleccion]").textContent=`${celda.observacion}: severidad ${celda.severidad} e importancia ${celda.criticidad}.`;
        }
        requestAnimationFrame(()=>{target.tabIndex=-1;target.focus({preventScroll:true});target.scrollIntoView({block:"start"});});
        return;
      }
      if(ev.target.closest("[data-tec-exportar]")){
        const registro=registros.get(raiz);
        if(!registro) return;
        const url=URL.createObjectURL(new Blob([JSON.stringify(registro,null,2)],{type:"application/json;charset=utf-8"}));
        const a=document.createElement("a");a.href=url;a.download=`AuditIA-${registro.lote||"analisis"}.json`;a.click();
        setTimeout(()=>URL.revokeObjectURL(url),1000);
        return;
      }
      const boton=ev.target.closest("[data-tec-ayuda-boton]");
      if(!boton) return;
      ev.preventDefault(); ev.stopPropagation();
      const termino=boton.closest(".tec-termino");
      if(terminoActivo===termino&&fijado) cerrarAyuda(); else mostrarAyuda(termino,true);
    });
    raiz.addEventListener("toggle",ev=>{if(!ev.target.open && ev.target.contains(terminoActivo)) cerrarAyuda();},true);
    tooltip.addEventListener("pointerenter",()=>clearTimeout(cierrePendiente));
    tooltip.addEventListener("pointerleave",aplazarCierre);
    document.addEventListener("pointerdown",ev=>{
      if(terminoActivo&&!terminoActivo.contains(ev.target)&&!tooltip.contains(ev.target)) cerrarAyuda();
    });
    document.addEventListener("keydown",ev=>{if(ev.key==="Escape"&&terminoActivo){cerrarAyuda();ev.preventDefault();}});
    document.addEventListener("scroll",()=>{if(terminoActivo) ubicarAyuda();},true);
    window.addEventListener("resize",()=>{if(terminoActivo) ubicarAyuda();});
  }
  return {render,activarAyudas,enlace,referenciaObservacion};
})();
