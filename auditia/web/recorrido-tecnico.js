/* Explorador de solo lectura: los nodos y las aristas proceden del lote guardado. */
const RecorridoTecnico=(()=>{
  const e=v=>String(v??"").replace(/[&<>"']/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;","'":"&#39;"}[c]));
  const texto=v=>String(v??"").replaceAll("_"," ");
  const criterios={atomicidad:"Atomicidad",ambiguedad:"Ambigüedad",verificabilidad:"Verificabilidad",completitud:"Completitud"};
  const tipos={Requerimiento:"Requerimiento",EvaluacionIndividual:"Evaluación individual",EvaluacionCruzada:"Comparación",JuicioCriterio:"Juicio del criterio",Hallazgo:"Hallazgo",Pendiente:"Pendiente",DecisionPrioridad:"Decisión de prioridad",Evidencia:"Evidencia",Obligacion:"Obligación",Escenario:"Escenario",Criticidad:"Importancia para el negocio",Severidad:"Gravedad del defecto",ContextoPrioridad:"Condiciones de tratamiento",EstadoResolucion:"Estado de resolución",DocumentoVersion:"Documento",Regla:"Regla",ModeloDifuso:"Modelo difuso"};
  const relaciones={EVALUA:"evalúa",COMPARA:"compara",CONTIENE_JUICIO:"contiene el juicio",GENERA:"genera",DERIVA_DE_JUICIO:"deriva del juicio",PRIORIZA:"prioriza",AFECTA_REQUERIMIENTO:"afecta al requerimiento",APLICA_REGLA:"aplica la regla",SE_SUSTENTA_EN:"se sustenta en",APLICA_MODELO:"aplica el modelo",USA_CONTEXTO:"usa las condiciones",TIENE_CRITICIDAD:"tiene la importancia",TIENE_SEVERIDAD:"tiene la gravedad",TIENE_ESTADO:"tiene el estado",EXPRESA:"expresa",APLICA_EN:"aplica en",SE_INTERPRETA_CON:"se interpreta con",APLICA_CRITERIO:"aplica el criterio",REVISA_DOCUMENTO:"revisa el documento",CONTIENE:"contiene"};
  const etiquetaTipo=n=>[...(n.tipos||[])].reverse().map(t=>tipos[t]).find(Boolean)||"Referencia";
  function tituloRequerimiento(rq={},registro={}){
    const guardado=rq.titulo||rq.nombre||registro.titulo;
    const original=String(guardado||rq.texto||registro.texto_original||"").replace(/\s+/g," ").trim();
    if(!original)return "Requerimiento sin texto conservado";
    const breve=guardado?original:original.replace(/^(?:el sistema|la aplicación|la plataforma|el software|el servicio)\s+(?:deberá|debe|debería|permitirá)\s+/i,"").replace(/[.;]$/,"");
    return breve.charAt(0).toLocaleUpperCase("es")+breve.slice(1);
  }
  function construir(res){
    const t=res.tecnico||{}, nodos=new Map((t.nodos||[]).map(n=>[n.id,n]));
    for(const r of t.reglas||[]) if(!nodos.has(r.id)) nodos.set(r.id,{id:r.id,tipos:["Regla"],datos:r});
    for(const m of t.modelos||[]) if(m.datos?.id&&!nodos.has(m.datos.id)) nodos.set(m.datos.id,{id:m.datos.id,tipos:["ModeloDifuso"],datos:m.datos});
    const aristas=t.relaciones||[], reqs=res.requerimientos||[], observaciones=res.observaciones||[];
    const codigo=id=>reqs.find(r=>r.id===id)?.id_documento||id;
    const nombre=id=>tituloRequerimiento(reqs.find(r=>r.id===id),nodos.get(id)?.datos);
    const grupos=[];
    function ruta(id,titulo,fuentes,ev,j,o){
      const faltantes=[...fuentes,ev?.id,j?.id,o?.id,o?.decision?.id].filter(id=>id&&!nodos.has(id));
      const etapas=[{titulo:"Datos de entrada",ids:fuentes},{titulo:"Evaluación",ids:[ev?.id,j?.id]},{titulo:"Observación",ids:[o?.id]},{titulo:"Prioridad",ids:[o?.decision?.id]}]
        .map(s=>({...s,ids:[...new Set(s.ids.filter(id=>id&&nodos.has(id)))]})).filter(s=>s.ids.length);
      const ids=new Set(etapas.flatMap(s=>s.ids));
      return {id,titulo,fuentes,etapas,aristas:aristas.filter(a=>ids.has(a.desde)&&ids.has(a.hasta)),observacion:o,juicio:j,evaluacion:ev,aviso:faltantes.length?"No se conservaron todos los nodos de este recorrido. Se muestran los registros disponibles.":"",
        cierre:!o?(j?.estado==="pendiente"?"La evaluación quedó pendiente, pero no hay una observación generada registrada para este criterio.":"Este recorrido termina en la evaluación: no hay una observación generada registrada."):!o.decision?.id?"La observación todavía no tiene una decisión de prioridad registrada.":""};
    }
    for(const rq of [...reqs].sort((a,b)=>codigo(a.id).localeCompare(codigo(b.id),"es",{numeric:true}))){
      const ev=rq.evaluacion||{}, rutas=[];
      for(const j of ev.juicios||[]){
        const os=observaciones.filter(o=>o.juicio_id===j.id);
        for(const o of os.length?os:[null]) rutas.push(ruta(o?.id||j.id,`${criterios[j.criterio]||texto(j.criterio)} · ${o?.clase||texto(j.estado)||'Sin estado'}`,[rq.id],ev,j,o));
      }
      for(const o of observaciones.filter(o=>ev.id&&o.origen===ev.id&&!rutas.some(r=>r.observacion?.id===o.id)))rutas.push(ruta(o.id,[o.clase||'Observación',texto(o.tipo_defecto||o.motivo_pendiente)].filter(Boolean).join(' · '),[rq.id],ev,null,o));
      if(!rutas.length) rutas.push(ruta(ev.id||rq.id,"Evaluación general",[rq.id],ev));
      grupos.push({id:rq.id,titulo:nombre(rq.id),codigo:codigo(rq.id),tipo:"requerimiento",texto:rq.texto||"",rutas});
    }
    for(const cp of res.comparaciones||(res.comparacion?[res.comparacion]:[])){
      const os=observaciones.filter(o=>o.origen===cp.id), fuentes=cp.requerimientos||[];
      grupos.push({id:cp.id,titulo:fuentes.map(nombre).join(" ↔ ")||"Comparación sin textos conservados",codigo:fuentes.map(codigo).join(" ↔ ")||cp.id,tipo:"comparacion",texto:fuentes.map(id=>reqs.find(r=>r.id===id)?.texto||"").join(" "),rutas:(os.length?os:[null]).map(o=>ruta(o?.id||cp.id,o?`${o.clase} · ${texto(o.tipo_defecto||o.motivo_pendiente)}`:`Comparación · ${texto(cp.estado)}`,fuentes,cp,null,o))});
    }
    for(const o of observaciones.filter(o=>!grupos.some(g=>g.rutas.some(r=>r.observacion?.id===o.id)))){
      const fuentes=aristas.filter(a=>a.desde===o.id&&a.relacion==="AFECTA_REQUERIMIENTO").map(a=>a.hasta);
      grupos.push({id:o.id,codigo:o.id,tipo:"observacion",titulo:o.descripcion||`${o.clase||'Observación'} sin evaluación de origen conservada`,texto:o.descripcion||"",rutas:[ruta(o.id,o.clase||'Observación',fuentes,{id:o.origen},null,o)]});
    }
    return {nodos,aristas,grupos,nombre,codigo};
  }
  const iconos={flecha:'<path d="M5 12h14m-6-6 6 6-6 6"/>',volver:'<path d="M19 12H5m6-6-6 6 6 6"/>',cerrar:'<path d="m6 6 12 12M18 6 6 18"/>',grafo:'<circle cx="5" cy="6" r="3"/><circle cx="19" cy="6" r="3"/><circle cx="12" cy="19" r="3"/><path d="m7 8 4 8m6-8-4 8M8 6h8"/>',buscar:'<circle cx="10.5" cy="10.5" r="6.5"/><path d="m16 16 5 5"/>',documento:'<path d="M7 3h7l4 4v14H6V3h1Zm7 0v5h5M9 12h6m-6 4h6"/>',regla:'<path d="M8 5H5v14h3m8-14h3v14h-3M10 9l-2 3 2 3m4-6 2 3-2 3"/>',check:'<path d="m5 12 4 4L19 6"/>',reloj:'<circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/>',alerta:'<path d="m12 3 10 18H2L12 3Zm0 6v5m0 3v.1"/>',prioridad:'<path d="M5 21V3m0 1h14l-3 5 3 5H5"/>',play:'<path d="m8 5 11 7-11 7V5Z"/>',pausa:'<path d="M8 5v14m8-14v14"/>',mas:'<path d="M12 5v14M5 12h14"/>',menos:'<path d="M5 12h14"/>',ajustar:'<path d="M8 3H3v5m13-5h5v5M3 16v5h5m13-5v5h-5"/>',capas:'<path d="m12 3 10 6-10 6L2 9l10-6Zm-10 12 10 6 10-6M2 12l10 6 10-6"/>',info:'<circle cx="12" cy="12" r="9"/><path d="M12 11v6m0-10v.1"/>',expandir:'<path d="M14 3h7v7m0-7L10 14M10 3H3v18h18v-7"/>'};
  const ico=nombre=>`<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${iconos[nombre]||iconos.info}</svg>`;
  const numero=v=>typeof v==="number"&&Number.isFinite(v)?v.toLocaleString("es-AR",{maximumFractionDigits:3}):"Sin dato";
  const tono=v=>["cumple","sin_hallazgo","resuelto"].includes(v)?"verde":["pendiente","preventivo"].includes(v)?"ambar":["incumple","observado","bloqueante"].includes(v)?"rojo":"violeta";
  const badge=(v,ui)=>v?`<span class="rec-badge rec-${tono(v)}"><i></i>${ui?ui.ayuda(texto(v),v):e(texto(v))}</span>`:"";
  const normalizar=v=>String(v||"").normalize("NFD").replace(/[\u0300-\u036f]/g,"").toLowerCase();
  const estados=new WeakMap();
  let activo=null;
  function render(res={}){
    const cantidad=(res.requerimientos||[]).length;
    return `<section class="rec-explorador" aria-label="Explorador técnico">
      <div class="rec-invitacion"><div class="rec-invitacion-texto"><span class="rec-eyebrow">EXPLORÁ CÓMO SE LLEGÓ AL RESULTADO</span><h3>Cada decisión tiene un recorrido.</h3><p>Del texto a la prioridad. Seguí la evidencia, las reglas y los cálculos en un mismo lugar.</p><button type="button" class="rec-primario" data-rec-abrir>${ico("grafo")}Explorar el grafo${ico("flecha")}</button><small>${cantidad} requerimiento${cantidad===1?"":"s"} · auditoría ${e(res.lote||"sin identificar")}</small></div><div class="rec-preview" aria-hidden="true"><svg viewBox="0 0 360 160"><path d="M45 80C95 80 90 35 145 35S200 80 235 80S285 125 320 125M145 35C145 75 145 100 145 125S200 80 235 80"/><circle cx="45" cy="80" r="14"/><circle cx="145" cy="35" r="19"/><circle cx="145" cy="125" r="13"/><circle cx="235" cy="80" r="24"/><circle cx="320" cy="125" r="12"/></svg><span class="rec-preview-tag">${ico("check")}Decisiones conectadas</span></div></div>
      <dialog class="rec-pantalla" aria-labelledby="rec-titulo-pantalla">
        <header class="rec-cabecera"><div class="rec-marca">Audit<span>IA</span><i></i><span>Explorador técnico</span></div><span class="rec-auditoria">${ico("documento")}Auditoría ${e(res.lote||"sin identificar")}</span><button type="button" class="rec-salir" data-rec-cerrar>${ico("volver")}<span>Volver a resultados</span></button></header>
        <div class="rec-barra-caso"><div class="rec-contexto"><span class="rec-eyebrow">ESTÁS EXPLORANDO</span><h2 id="rec-titulo-pantalla">El recorrido de una decisión</h2></div><button type="button" class="rec-caso-boton" data-rec-selector aria-expanded="false" aria-controls="rec-selector-casos"><span><small data-rec-codigo></small><strong data-rec-titulo-caso></strong></span>${ico("buscar")}<span class="rec-cambiar">Cambiar caso</span></button></div>
        <div class="rec-rutas" aria-label="Aspecto del caso" data-rec-rutas></div>
        <div class="rec-espacio"><section class="rec-mapa" aria-label="Grafo del caso"><div class="rec-mapa-titulo"><div><span class="rec-punto"></span><b>Mapa de la decisión</b><small data-rec-cuenta></small></div><button type="button" class="rec-herramienta" data-rec-fundamentos aria-pressed="false">${ico("capas")}<span>Fundamentos</span></button></div>
          <div class="rec-lienzo" tabindex="0" aria-label="Grafo interactivo. Usá las flechas del teclado para cambiar de paso; más y menos para acercar o alejar."><div class="rec-mundo"><svg class="rec-aristas" aria-hidden="true"></svg><div class="rec-nodos"></div></div><div class="rec-vacio" hidden></div></div>
          <div class="rec-herramientas"><span>Arrastrá para explorar · tocá un nodo para entenderlo</span><div><button type="button" data-rec-zoom="-1" aria-label="Alejar">${ico("menos")}</button><span data-rec-escala>100%</span><button type="button" data-rec-zoom="1" aria-label="Acercar">${ico("mas")}</button><i></i><button type="button" data-rec-ajustar aria-label="Ver todo el grafo">${ico("ajustar")}</button></div></div>
          <div class="rec-guia"><div class="rec-guia-cabecera"><span class="rec-eyebrow">RECORRIDO GUIADO</span><button type="button" data-rec-reproducir>${ico("play")}Reproducir recorrido</button></div><div class="rec-pasos" aria-label="Pasos del recorrido"></div><div class="rec-navegacion"><button type="button" data-rec-avance="-1">${ico("volver")}Anterior</button><span data-rec-progreso></span><button type="button" data-rec-avance="1">Siguiente${ico("flecha")}</button></div></div>
        </section><aside class="rec-inspector" aria-label="Información del nodo seleccionado"><div class="rec-panel" data-rec-panel tabindex="-1"></div></aside></div>
        <div class="rec-estado-pie"><span>${ico("info")}Estás explorando una auditoría guardada.</span><span>Texto confirmado → reglas → resultado</span></div>
        <div class="rec-selector" id="rec-selector-casos" hidden><div class="rec-selector-cab"><div><span class="rec-eyebrow">ENCONTRÁ UN CASO</span><h3>¿Qué querés explorar?</h3></div><button type="button" data-rec-selector-cerrar aria-label="Cerrar selector">${ico("cerrar")}</button></div><label class="rec-busqueda">${ico("buscar")}<input type="search" data-rec-buscar placeholder="Buscá por título, texto o código…" aria-label="Buscar casos"></label><div class="rec-filtros"><button type="button" data-rec-filtro="todos" aria-pressed="true">Todos</button><button type="button" data-rec-filtro="requerimiento" aria-pressed="false">Requerimientos</button><button type="button" data-rec-filtro="comparacion" aria-pressed="false">Comparaciones</button></div><p class="rec-resultados-busqueda" aria-live="polite"></p><div class="rec-lista-casos"></div></div>
        <span class="rec-anuncio" aria-live="polite" aria-atomic="true"></span>
      </dialog></section>`;
  }
  function detener(s){clearTimeout(s.temporizador);s.reproduciendo=false;botonReproducir(s);}
  function botonReproducir(s){const b=s.cont.querySelector('[data-rec-reproducir]');if(b){b.innerHTML=ico(s.reproduciendo?"pausa":"play")+(s.reproduciendo?"Pausar recorrido":"Reproducir recorrido");b.setAttribute("aria-pressed",String(!!s.reproduciendo));}}
  function notificar(s,abierto){s.cont.dispatchEvent(new CustomEvent("rec-visibilidad",{bubbles:true,detail:{abierto,dialogo:s.dialogo}}));}
  function cerrar(s){detener(s);if(s.dialogo.open)s.dialogo.close();if(activo===s){activo=null;document.body.classList.remove("rec-abierto");}notificar(s,false);s.cont.querySelector('[data-rec-abrir]')?.focus({preventScroll:true});}
  function abrir(s){if(activo&&activo!==s)cerrar(activo);activo=s;document.body.classList.add("rec-abierto");s.dialogo.showModal();notificar(s,true);pintar(s,true);requestAnimationFrame(()=>{if(matchMedia('(max-width:760px)').matches)centrarSeleccion(s);else encuadrar(s);s.cont.querySelector('[data-rec-selector]')?.focus({preventScroll:true});});}
  function activar(raiz,res,ui){
    const anterior=estados.get(raiz);if(anterior){detener(anterior);anterior.observador.disconnect();if(activo===anterior)cerrar(anterior);}
    const cont=raiz.querySelector('.rec-explorador');if(!cont)return;
    const grafo=construir(res),grupo=grafo.grupos.find(g=>g.rutas.some(r=>r.observacion))||grafo.grupos[0];
    const s={raiz,cont,res,ui,grafo,grupo,ruta:grupo?.rutas.find(r=>r.observacion)||grupo?.rutas[0],paso:0,seleccion:null,fundamentos:false,explorados:[],camara:{x:0,y:0,zoom:1},filtro:'todos',ficha:null};
    s.dialogo=cont.querySelector('dialog');s.observador=new ResizeObserver(()=>{if(s.dialogo.open&&s.ruta?.etapas.length){pintarGrafo(s);if(matchMedia('(max-width:760px)').matches)centrarSeleccion(s);else encuadrar(s);}});s.observador.observe(cont.querySelector('.rec-lienzo'));estados.set(raiz,s);pintar(s,true);
    if(cont.dataset.recActivo)return;cont.dataset.recActivo='si';const actual=()=>estados.get(raiz);
    s.dialogo.addEventListener('cancel',ev=>{ev.preventDefault();if(!actual().cont.querySelector('.rec-selector').hidden)selector(actual(),false);else cerrar(actual());});
    s.dialogo.addEventListener('close',ev=>{const a=actual();if(a.dialogo!==ev.currentTarget||a.dialogo.open)return;detener(a);if(activo===a){activo=null;document.body.classList.remove('rec-abierto');}notificar(a,false);});
    cont.addEventListener('input',ev=>{if(ev.target.matches('[data-rec-buscar]'))listarCasos(actual());});
    cont.addEventListener('click',ev=>{
      const a=actual(),b=ev.target.closest('button,a');if(!b)return;
      if(b.matches('[data-rec-abrir]')){abrir(a);return;}if(b.matches('[data-rec-cerrar]')){cerrar(a);return;}
      if(b.matches('[data-rec-selector]')){detener(a);selector(a,true);return;}if(b.matches('[data-rec-selector-cerrar]')){selector(a,false);return;}
      if(b.matches('[data-rec-filtro]')){a.filtro=b.dataset.recFiltro;listarCasos(a);return;}
      if(b.matches('[data-rec-caso]')){detener(a);a.grupo=a.grafo.grupos.find(g=>g.id===b.dataset.recCaso);a.ruta=a.grupo.rutas.find(r=>r.observacion)||a.grupo.rutas[0];a.paso=0;a.seleccion=null;a.explorados=[];a.ficha=null;selector(a,false);pintar(a,true);return;}
      if(b.matches('[data-rec-ruta]')){detener(a);a.ruta=a.grupo.rutas.find(r=>r.id===b.dataset.recRuta);a.paso=0;a.seleccion=null;a.explorados=[];a.ficha=null;pintar(a,true);return;}
      if(b.matches('[data-rec-paso],[data-rec-avance]')){detener(a);irPaso(a,b.hasAttribute('data-rec-paso')?Number(b.dataset.recPaso):a.paso+Number(b.dataset.recAvance));return;}
      if(b.matches('[data-rec-nodo]')){if(a.arrastrado){a.arrastrado=false;return;}detener(a);seleccionar(a,b.dataset.recNodo);return;}
      if(b.matches('[data-rec-fundamentos]')){detener(a);a.fundamentos=!a.fundamentos;a.explorados=[];pintar(a,true);return;}
      if(b.matches('[data-rec-zoom]')){detener(a);ampliar(a,Number(b.dataset.recZoom)*.15);return;}if(b.matches('[data-rec-ajustar]')){detener(a);encuadrar(a);return;}
      if(b.matches('[data-rec-reproducir]')){if(a.reproduciendo){detener(a);return;}if(a.paso===a.ruta.etapas.length-1)irPaso(a,0);a.reproduciendo=true;botonReproducir(a);programar(a);return;}
      if(b.matches('[data-rec-volver-nodo]')){a.ficha=null;pintarPanel(a);return;}
      if(b.matches('[data-tec-ir]')&&a.dialogo.open){ev.preventDefault();ev.stopPropagation();detener(a);a.ficha={id:b.dataset.tecIr,celda:b.dataset.tecCelda,titulo:b.textContent};pintarPanel(a);return;}
    });
    cont.addEventListener('keydown',ev=>{
      const a=actual();if(!a.dialogo.open)return;
      if(ev.key==='Escape'&&!cont.querySelector('.rec-selector').hidden){ev.preventDefault();ev.stopPropagation();selector(a,false);return;}
      if(ev.target.closest('input,select,textarea'))return;
      if(ev.target.closest('.rec-lienzo')){
        if(!a.ruta?.etapas.length)return;
        if(['ArrowRight','ArrowLeft','Home','End','+','-','0'].includes(ev.key))ev.preventDefault();
        if(ev.key==='ArrowRight'||ev.key==='ArrowLeft'){detener(a);irPaso(a,a.paso+(ev.key==='ArrowRight'?1:-1));}
        if(ev.key==='Home'||ev.key==='End'){detener(a);irPaso(a,ev.key==='Home'?0:a.ruta.etapas.length-1);}
        if(ev.key==='+'||ev.key==='-')ampliar(a,ev.key==='+'?.15:-.15);if(ev.key==='0')encuadrar(a);
      }
    });
    const lienzo=cont.querySelector('.rec-lienzo');
    lienzo.addEventListener('pointerdown',ev=>{const a=actual();if(ev.button!==0||ev.target.closest('button'))return;detener(a);a.arrastre={id:ev.pointerId,x:ev.clientX,y:ev.clientY,cx:a.camara.x,cy:a.camara.y};a.arrastrado=false;lienzo.setPointerCapture(ev.pointerId);});
    lienzo.addEventListener('pointermove',ev=>{const a=actual(),d=a.arrastre;if(!d||d.id!==ev.pointerId)return;const dx=ev.clientX-d.x,dy=ev.clientY-d.y;if(Math.abs(dx)+Math.abs(dy)>4)a.arrastrado=true;a.camara.x=d.cx+dx;a.camara.y=d.cy+dy;aplicarCamara(a);});
    const soltar=ev=>{const a=actual();if(a.arrastre?.id===ev.pointerId){a.arrastre=null;a.arrastrado=false;if(lienzo.hasPointerCapture(ev.pointerId))lienzo.releasePointerCapture(ev.pointerId);}};
    lienzo.addEventListener('pointerup',soltar);lienzo.addEventListener('pointercancel',soltar);lienzo.addEventListener('lostpointercapture',()=>{actual().arrastre=null;});
    lienzo.addEventListener('wheel',ev=>{if(ev.ctrlKey||ev.metaKey){ev.preventDefault();ampliar(actual(),ev.deltaY<0?.08:-.08);}}, {passive:false});
    if(!activar.visibilidad){document.addEventListener('visibilitychange',()=>{if(document.hidden&&activo)detener(activo);});activar.visibilidad=true;}
  }
  function selector(s,visible){const p=s.cont.querySelector('.rec-selector');p.hidden=!visible;for(const hijo of s.dialogo.children)if(hijo!==p&&!hijo.classList.contains('tec-tooltip'))hijo.inert=visible;s.cont.querySelector('[data-rec-selector]').setAttribute('aria-expanded',String(visible));if(visible){listarCasos(s);requestAnimationFrame(()=>s.cont.querySelector('[data-rec-buscar]').focus());}else s.cont.querySelector('[data-rec-selector]').focus({preventScroll:true});}
  function listarCasos(s){
    const busqueda=normalizar(s.cont.querySelector('[data-rec-buscar]').value),grupos=s.grafo.grupos.filter(g=>(s.filtro==='todos'||s.filtro===g.tipo)&&normalizar(g.titulo+' '+g.codigo+' '+g.texto).includes(busqueda));
    s.cont.querySelectorAll('[data-rec-filtro]').forEach(b=>b.setAttribute('aria-pressed',String(b.dataset.recFiltro===s.filtro)));
    s.cont.querySelector('.rec-resultados-busqueda').textContent=`${grupos.length} caso${grupos.length===1?'':'s'} encontrado${grupos.length===1?'':'s'}`;
    s.cont.querySelector('.rec-lista-casos').innerHTML=grupos.length?grupos.map(g=>`<button type="button" data-rec-caso="${e(g.id)}" aria-pressed="${g.id===s.grupo?.id}"><span class="rec-caso-icono">${ico(g.tipo==='comparacion'?'grafo':'documento')}</span><span><small>${e(g.codigo)} · ${{comparacion:'Comparación',requerimiento:'Requerimiento',observacion:'Observación'}[g.tipo]}</small><b>${e(g.titulo)}</b><em>${g.rutas.filter(r=>r.observacion).length} ${g.rutas.filter(r=>r.observacion).length===1?"observación":"observaciones"} · ${g.rutas.length} recorrido${g.rutas.length===1?'':'s'}</em></span>${ico('flecha')}</button>`).join(''):`<div class="rec-sin-coincidencias">${ico('buscar')}<h4>No encontramos ese caso</h4><p>Probá con otra palabra del requerimiento o con su código.</p></div>`;
  }
  function programar(s){s.temporizador=setTimeout(()=>{if(!s.reproduciendo||!s.dialogo.open)return;if(s.paso>=s.ruta.etapas.length-1){detener(s);return;}irPaso(s,s.paso+1);if(s.paso>=s.ruta.etapas.length-1)detener(s);else programar(s);},3600);}
  function irPaso(s,paso){if(!s.ruta?.etapas.length)return;s.paso=Math.max(0,Math.min(s.ruta.etapas.length-1,paso));s.seleccion=null;s.ficha=null;s.explorados=[];pintar(s);}
  function seleccionar(s,id){
    let cambio=false;
    if(!s.ruta.etapas.some(p=>p.ids.includes(id))){
      const grupo=s.grafo.grupos.find(g=>g.rutas.some(r=>r.juicio?.id===id||r.observacion?.id===id||r.observacion?.decision?.id===id||r.evaluacion?.id===id)||g.id===id);
      if(grupo){s.grupo=grupo;s.ruta=grupo.rutas.find(r=>r.juicio?.id===id||r.observacion?.id===id||r.observacion?.decision?.id===id)||grupo.rutas.find(r=>r.observacion)||grupo.rutas[0];cambio=true;}
    }
    s.seleccion=id;s.ficha=null;const paso=s.ruta.etapas.findIndex(p=>p.ids.includes(id));if(paso>=0){s.paso=paso;s.explorados=[];}else if(!s.explorados.includes(id))s.explorados.push(id);pintar(s,cambio);
  }
  function nodo(s,id){return s.grafo.nodos.get(id)||{id,tipos:[],datos:{}};}
  function tituloNodo(s,n){
    const t=n.tipos||[],d=n.datos||{};
    if(t.includes('Requerimiento'))return s.grafo.nombre(n.id);
    if(t.includes('JuicioCriterio')){const j=(s.res.requerimientos||[]).flatMap(r=>r.evaluacion?.juicios||[]).find(j=>j.id===n.id);return criterios[j?.criterio]||'Revisión de calidad';}
    if(t.includes('EvaluacionIndividual'))return 'Calidad del requerimiento';
    if(t.includes('EvaluacionCruzada'))return 'Compatibilidad del par';
    if(t.includes('DecisionPrioridad'))return 'Tratamiento de la observación';
    if(t.includes('Hallazgo'))return criterios[d.tipo_defecto]||texto(d.tipo_defecto)||'Incumplimiento confirmado';
    if(t.includes('Pendiente'))return 'Información por completar';
    if(t.includes('Regla'))return n.id;
    if(t.includes('ModeloDifuso'))return d.nombre||'Modelo de cálculo';
    if(t.includes('Evidencia'))return d.naturaleza==='premisas_confirmadas_por_analista'?'Premisas confirmadas':'Evidencia del caso';
    if(t.includes('Obligacion'))return [d.accion,d.objeto].filter(Boolean).join(' ')||'Obligación interpretada';
    return etiquetaTipo(n)==='Referencia'?n.id:etiquetaTipo(n);
  }
  function iconoNodo(n){const t=n.tipos||[];return t.includes('Requerimiento')?'documento':t.includes('Pendiente')?'reloj':t.includes('Hallazgo')?'alerta':t.includes('DecisionPrioridad')?'prioridad':t.includes('Regla')?'regla':t.includes('Evidencia')?'documento':'grafo';}
  function pintar(s,reencuadrar=false){
    const r=s.ruta,hay=!!r?.etapas.length,c=s.cont;
    const foco=document.activeElement,atributo=['data-rec-paso','data-rec-avance','data-rec-ruta','data-rec-nodo'].find(a=>foco?.hasAttribute(a)),valorFoco=atributo?foco.getAttribute(atributo):null;
    c.querySelector('[data-rec-codigo]').textContent=s.grupo?.codigo||'Sin casos';c.querySelector('[data-rec-titulo-caso]').textContent=s.grupo?.titulo||'No hay requerimientos guardados';
    c.querySelector('[data-rec-rutas]').innerHTML=(s.grupo?.rutas||[]).map(r=>`<button type="button" data-rec-ruta="${e(r.id)}" aria-pressed="${r.id===s.ruta?.id}"><i class="rec-dot-${tono(r.juicio?.estado||r.evaluacion?.estado)}"></i>${e(r.juicio?criterios[r.juicio.criterio]||r.titulo:r.titulo)}<small>${e(r.observacion?.clase||texto(r.juicio?.estado||r.evaluacion?.estado))}</small></button>`).join('');
    c.querySelector('.rec-vacio').hidden=hay;
    if(!hay)c.querySelector('.rec-vacio').innerHTML=`${ico('grafo')}<h3>No se conservó el grafo de este análisis</h3><p>No se guardaron las conexiones necesarias para dibujar este recorrido. No se reconstruyen conexiones que no quedaron registradas.</p>`;
    c.querySelector('.rec-mundo').hidden=!hay;c.querySelector('[data-rec-reproducir]').disabled=!hay;
    c.querySelector('[data-rec-fundamentos]').disabled=!hay;c.querySelector('[data-rec-fundamentos]').setAttribute('aria-pressed',String(s.fundamentos));
    c.querySelector('.rec-pasos').innerHTML=hay?r.etapas.map((p,i)=>`<button type="button" data-rec-paso="${i}" class="${i<s.paso?'rec-completado':''}" aria-pressed="${i===s.paso}"><span>${i<s.paso?ico('check'):String(i+1).padStart(2,'0')}</span><b>${e(p.titulo)}</b></button>`).join(''):'';
    c.querySelector('[data-rec-avance="-1"]').disabled=!hay||s.paso===0;c.querySelector('[data-rec-avance="1"]').disabled=!hay||s.paso===r.etapas.length-1;
    c.querySelector('[data-rec-progreso]').textContent=hay?`${s.paso+1} de ${r.etapas.length}`:'Sin recorrido';
    for(const b of c.querySelectorAll('[data-rec-zoom],[data-rec-ajustar]'))b.disabled=!hay;
    if(!hay){s.items=[];s.claveVisual=null;c.querySelector('[data-rec-cuenta]').textContent='Sin nodos conservados';c.querySelector('[data-rec-panel]').innerHTML='<div class="rec-panel-vacio"><h3>Una auditoría, toda su trazabilidad.</h3><p>Elegí otro caso para explorar sus decisiones o volvé al resumen de resultados.</p></div>';return;}
    s.seleccion=s.seleccion||r.etapas[s.paso].ids.at(-1);
    c.querySelector('.rec-anuncio').textContent=`Paso ${s.paso+1} de ${r.etapas.length}: ${r.etapas[s.paso].titulo}. ${tituloNodo(s,nodo(s,s.seleccion))}.`;
    const anteriorDiseno=s.claveVisual;pintarGrafo(s);pintarPanel(s);botonReproducir(s);
    if(atributo&&!foco.isConnected&&s.dialogo.open){const nuevo=[...c.querySelectorAll(`[${atributo}]`)].find(b=>b.getAttribute(atributo)===valorFoco&&!b.disabled);(nuevo||c.querySelector('[data-rec-panel]')).focus({preventScroll:true});}
    if(s.dialogo.open)requestAnimationFrame(()=>{if(matchMedia('(max-width:760px)').matches)centrarSeleccion(s);else if(reencuadrar||!s.encuadrado||anteriorDiseno!==s.claveVisual){encuadrar(s);s.encuadrado=true;}else asegurarSeleccionVisible(s);});
  }
  function visuales(s){
    const items=[],etapas=s.ruta.etapas,ancho=s.cont.querySelector('.rec-lienzo').clientWidth,compacto=ancho>0&&ancho<700;
    etapas.forEach((p,i)=>p.ids.forEach((id,j)=>items.push({id,paso:i,x:70+(compacto?i%2:i)*280,y:compacto?140+Math.floor(i/2)*380+(p.ids.length>1?-85+j*175:0):p.ids.length>1?235+j*175:325,core:true})));
    const principales=new Set(items.map(n=>n.id)),candidatos=[...s.explorados];
    if(!principales.has(s.seleccion))candidatos.push(s.seleccion);
    if(s.fundamentos)for(const a of s.grafo.aristas.filter(a=>a.desde===s.seleccion||a.hasta===s.seleccion)){const id=a.desde===s.seleccion?a.hasta:a.desde;if(!principales.has(id))candidatos.push(id);}
    const extras=[...new Set(candidatos)].filter(id=>!principales.has(id)&&id!==s.seleccion);
    if(!principales.has(s.seleccion))extras.push(s.seleccion);
    extras.slice(-8).forEach((id,i)=>items.push({id,x:70+(i%(compacto?2:4))*280,y:compacto?760+Math.floor(i/2)*175:i<4?45:625,core:false}));
    return items;
  }
  function pintarGrafo(s){
    const items=visuales(s);s.items=items;
    const ids=new Set(items.map(n=>n.id)),aristas=s.grafo.aristas.filter(a=>ids.has(a.desde)&&ids.has(a.hasta));s.aristasVisibles=aristas;
    s.cont.querySelector('[data-rec-cuenta]').textContent=`${items.length} nodos · ${aristas.length} conexiones`;
    const clave=items.map(n=>n.id+':'+n.x+':'+n.y).join('|'),mapa=s.cont.querySelector('.rec-nodos');
    if(s.claveVisual!==clave){mapa.innerHTML=items.map((v,i)=>{const n=nodo(s,v.id),d=n.datos||{},codigo=n.tipos.includes('Requerimiento')?s.grafo.codigo(n.id):etiquetaTipo(n),estado=d.estado||d.prioridad||(n.tipos.includes('Hallazgo')?'observado':n.tipos.includes('Pendiente')?'pendiente':null);return `<button type="button" class="rec-nodo ${v.core?'':'rec-nodo-apoyo'}" data-rec-nodo="${e(n.id)}" style="left:${v.x}px;top:${v.y}px;--rec-demora:${Math.min(i*35,210)}ms"><span class="rec-nodo-superior"><i>${ico(iconoNodo(n))}</i><small>${e(codigo)}</small></span><strong>${e(tituloNodo(s,n))}</strong>${estado?`<span class="rec-nodo-estado rec-${tono(estado)}">${e(texto(estado))}</span>`:`<span class="rec-nodo-estado">${n.tipos.includes('Requerimiento')?'Texto confirmado':'Registro vinculado'}</span>`}</button>`;}).join('');s.claveVisual=clave;}
    mapa.querySelectorAll('[data-rec-nodo]').forEach(b=>{const item=items.find(n=>n.id===b.dataset.recNodo),sel=item.id===s.seleccion;b.classList.toggle('rec-seleccionado',sel);b.classList.toggle('rec-futuro',item.core&&item.paso>s.paso);b.setAttribute('aria-pressed',String(sel));});
    const porId=new Map(items.map(n=>[n.id,n])),svg=s.cont.querySelector('.rec-aristas');svg.setAttribute('viewBox','0 0 1200 1600');
    svg.innerHTML='<defs><marker id="rec-flecha" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="5" markerHeight="5" orient="auto"><path d="M0 0 10 5 0 10Z" fill="context-stroke"/></marker></defs>'+aristas.map(a=>{
      const p=porId.get(a.desde),q=porId.get(a.hasta),dx=q.x-p.x,dy=q.y-p.y,horizontal=Math.abs(dx)>Math.abs(dy);
      const x1=p.x+(horizontal?(dx>0?228:0):114),y1=p.y+(horizontal?67:(dy>0?134:0));
      const x2=q.x+(horizontal?(dx>0?0:228):114),y2=q.y+(horizontal?67:(dy>0?0:134));
      const curva=horizontal?`C ${(x1+x2)/2} ${y1}, ${(x1+x2)/2} ${y2}, ${x2} ${y2}`:`C ${x1} ${(y1+y2)/2}, ${x2} ${(y1+y2)/2}, ${x2} ${y2}`;
      const activa=a.desde===s.seleccion||a.hasta===s.seleccion;
      return `<g data-rec-desde="${e(a.desde)}" data-rec-hasta="${e(a.hasta)}" data-rec-relacion="${e(a.relacion)}" class="${activa?'rec-conexion-activa':''}"><path d="M${x1} ${y1} ${curva}" marker-end="url(#rec-flecha)"/><path class="rec-flujo" d="M${x1} ${y1} ${curva}"/>${activa?`<text x="${(x1+x2)/2}" y="${(y1+y2)/2-9}" text-anchor="middle">${e(relaciones[a.relacion]||texto(a.relacion))}</text>`:''}<title>${e(a.desde)} ${e(relaciones[a.relacion]||a.relacion)} ${e(a.hasta)}</title></g>`;
    }).join('');
  }
  function aplicarCamara(s){const c=s.camara;s.cont.querySelector('.rec-mundo').style.transform=`translate(${c.x}px,${c.y}px) scale(${c.zoom})`;s.cont.querySelector('[data-rec-escala]').textContent=Math.round(c.zoom*100)+'%';}
  function encuadrar(s){const marco=s.cont.querySelector('.rec-lienzo');if(!s.items?.length||!marco.clientWidth)return;const xs=s.items.map(n=>n.x),ys=s.items.map(n=>n.y),minX=Math.min(...xs)-35,minY=Math.min(...ys)-35,w=Math.max(...xs)+263-minX,h=Math.max(...ys)+169-minY;const zoom=Math.min(1.1,Math.max(.22,Math.min((marco.clientWidth-40)/w,(marco.clientHeight-36)/h)));s.camara={zoom,x:(marco.clientWidth-w*zoom)/2-minX*zoom,y:(marco.clientHeight-h*zoom)/2-minY*zoom};aplicarCamara(s);}
  function ampliar(s,delta){const m=s.cont.querySelector('.rec-lienzo'),c=s.camara,z=Math.max(.22,Math.min(1.8,c.zoom+delta)),factor=z/c.zoom;s.camara={zoom:z,x:m.clientWidth/2-(m.clientWidth/2-c.x)*factor,y:m.clientHeight/2-(m.clientHeight/2-c.y)*factor};aplicarCamara(s);}
  function centrarSeleccion(s){const n=s.items.find(n=>n.id===s.seleccion),m=s.cont.querySelector('.rec-lienzo');if(!n)return;const zoom=Math.max(.72,s.camara.zoom);s.camara={zoom,x:m.clientWidth/2-(n.x+114)*zoom,y:m.clientHeight/2-(n.y+67)*zoom};aplicarCamara(s);}
  function asegurarSeleccionVisible(s){const n=s.items.find(n=>n.id===s.seleccion),m=s.cont.querySelector('.rec-lienzo'),c=s.camara;if(!n)return;const x=n.x*c.zoom+c.x,y=n.y*c.zoom+c.y;if(x<20||x+228*c.zoom>m.clientWidth-20||y<55||y+134*c.zoom>m.clientHeight-15)centrarSeleccion(s);}
  function bloque(titulo,cuerpo,clase=''){return `<section class="rec-bloque ${clase}"><h4>${titulo}</h4>${cuerpo}</section>`;}
  function ficha(s,id,celda){
    const original=s.ui.obtenerFicha(id);if(!original)return '<p class="rec-aviso">No se conservó este detalle en la auditoría.</p>';
    const copia=original.cloneNode(true);copia.removeAttribute('id');copia.querySelectorAll('[id]').forEach(el=>el.removeAttribute('id'));copia.querySelectorAll('[data-tec-retorno]').forEach(el=>el.remove());if(copia.tagName==='DETAILS')copia.open=true;
    if(celda){try{const c=JSON.parse(celda);copia.querySelectorAll('[data-tec-severidad]').forEach(td=>td.classList.toggle('tec-celda-activa',td.dataset.tecSeveridad===c.severidad&&td.dataset.tecCriticidad===c.criticidad));const leyenda=copia.querySelector('[data-tec-seleccion]');if(leyenda)leyenda.textContent=`Severidad ${c.severidad||'sin determinar'} e importancia ${c.criticidad||'sin declarar'}.`;}catch{ /* Sigue disponible la matriz completa. */ }}
    if(copia.tagName==='TR'){const tabla=document.createElement('table');tabla.append(copia);return `<div class="tec-tabla">${tabla.outerHTML}</div>`;}return copia.outerHTML;
  }
  function pintarPanel(s){
    s.cont.dispatchEvent(new Event('rec-cambio',{bubbles:true}));
    const panel=s.cont.querySelector('[data-rec-panel]'),n=nodo(s,s.seleccion),d=n.datos||{},t=n.tipos||[],ui=s.ui;
    if(s.ficha){panel.innerHTML=`<button type="button" class="rec-volver-nodo" data-rec-volver-nodo>${ico('volver')}Volver al nodo seleccionado</button><span class="rec-eyebrow">CONSULTA DEL REGISTRO</span><h3>${e(s.ficha.titulo||'Detalle técnico')}</h3><div class="rec-ficha-ampliada">${ficha(s,s.ficha.id,s.ficha.celda)}</div>`;s.cont.querySelector('.rec-inspector').scrollTop=0;return;}
    let cuerpo='',explicacion='',estado=d.estado||d.prioridad,extra='';
    const relacionado=!s.ruta.etapas.some(p=>p.ids.includes(n.id));
    const obs=(s.res.observaciones||[]).find(o=>o.id===n.id||o.decision?.id===n.id);
    const rq=(s.res.requerimientos||[]).find(r=>r.id===n.id||r.evaluacion?.id===n.id||r.evaluacion?.juicios?.some(j=>j.id===n.id));
    if(t.includes('Requerimiento')){
      explicacion='Este es el texto que se confirmó antes de aplicar las reglas de la auditoría.';
      cuerpo=bloque('Texto original',`<blockquote>${e(rq?.texto||d.texto_original||'No se conservó el texto original.')}</blockquote>`,'rec-texto-original');
      const importancia=d.criticidad_valor||rq?.criticidad,grado=d.grado_criticidad??rq?.grado_criticidad;
      cuerpo+=`<div class="rec-dos-metricas"><div><small>${ui.ayuda('Importancia para el negocio')}</small><b>${e(importancia||'Sin declarar')}</b></div><div><small>${ui.ayuda('Puntaje de importancia','grado_criticidad')}</small><b>${grado!=null?numero(grado)+'<em> / 10</em>':'Sin dato'}</b></div></div>`;
      const ob=nodo(s,'O-'+n.id).datos,esc=nodo(s,'ESC-'+n.id).datos;
      if(Object.keys(ob).length||Object.keys(esc).length)cuerpo+=bloque('Lo que se interpretó',ui.interpretacion(ob,esc));
      cuerpo+=bloque('Condiciones confirmadas',ui.datos(d,ui.condiciones));
      const original=s.res.tecnico?.propuesta_confirmada?.requerimientos?.find(r=>n.id.endsWith(`-${r.clave}-v1`));
      const extraccion=original?.extraccion||{},keys=['obligaciones','terminos_vagos','lecturas','criterio_medible','omisiones'].filter(k=>k==='obligaciones'?extraccion[k]?.length>1:Array.isArray(extraccion[k])?extraccion[k].length:!!extraccion[k]);
      if(keys.length)cuerpo+=bloque('Lectura confirmada del texto',ui.datos(extraccion,keys));
      if(s.res.contexto)cuerpo+=bloque('Contexto de la auditoría',`<p>${e(s.res.contexto)}</p>`);
      if(rq?.ubicacion)cuerpo+=`<p class="rec-localizador">${ico('documento')}${e(rq.ubicacion)}</p>`;
    }else if(t.includes('EvaluacionIndividual')){
      explicacion='Se revisaron cuatro criterios. El estado general combina sus resultados; cada criterio conserva su propia conclusión.';
      cuerpo=bloque('Qué se revisó',`<div class="rec-criterios">${(rq?.evaluacion?.juicios||[]).map(j=>`<button type="button" data-rec-nodo="${e(j.id)}"><span>${e(criterios[j.criterio]||j.criterio)}</span>${badge(j.estado)}${ico('flecha')}</button>`).join('')}</div>`);
    }else if(t.includes('JuicioCriterio')||t.includes('EvaluacionCruzada')){
      explicacion=d.justificacion||'Se registró una conclusión a partir de las premisas confirmadas.';
      cuerpo=bloque('Hechos que se tuvieron en cuenta',ui.datos(d,t.includes('JuicioCriterio')?[...ui.critKeys,'metodo','omisiones','fragmentos']:ui.cmpKeys));
      if(d.modelo_difuso_version||t.includes('EvaluacionCruzada'))extra=calculoPanel(s,n);
    }else if(t.includes('Hallazgo')||t.includes('Pendiente')){
      estado=t.includes('Pendiente')?'pendiente':'observado';explicacion=d.descripcion||d.descripcion_defecto||'No se conservó una descripción para esta observación.';
      cuerpo=bloque(t.includes('Pendiente')?'Qué falta para poder decidir':'Qué significa este resultado',`<p>${t.includes('Pendiente')?'Todavía falta información para cerrar la evaluación. Un pendiente no confirma por sí solo un defecto.':'Se confirmó un incumplimiento. La observación conserva la evaluación y la evidencia que lo respaldan.'}</p>${d.dato_faltante?`<div class="rec-aviso">${e(d.dato_faltante)}</div>`:''}`);
      if(obs?.severidad)cuerpo+=bloque('Gravedad registrada',`<div class="rec-metrica-linea"><b>${e(obs.severidad.valor||'Sin determinar')}</b><span>${obs.severidad.grado!=null?numero(obs.severidad.grado)+' / 10':'No hay un grado determinado'}</span></div>`);
    }else if(t.includes('DecisionPrioridad')){
      const contexto=s.grafo.aristas.find(a=>a.desde===n.id&&a.relacion==='USA_CONTEXTO'),x=nodo(s,contexto?.hasta).datos;
      explicacion=obs?ui.fundamento(obs,x):'Esta decisión registra cómo tratar la observación.';
      cuerpo=`<div class="rec-dos-metricas"><div><small>${ui.ayuda('Severidad')}</small><b>${e(obs?.severidad?.valor||'Sin determinar')}</b></div><div><small>${ui.ayuda('Importancia para el negocio')}</small><b>${e(obs?.decision?.criticidad?.valor||'Sin declarar')}</b></div></div>`;
      const version=d.matriz_id_version;
      if(version&&(s.res.tecnico?.matriz||[]).some(m=>m.version===version))cuerpo+=bloque('El cruce en la matriz',`<p>La matriz combina gravedad e importancia. Las condiciones de tratamiento determinan la prioridad final.</p>${ficha(s,'tec-matriz-'+version,JSON.stringify({severidad:obs?.severidad?.valor,criticidad:obs?.decision?.criticidad?.valor}))}`);
      cuerpo+=bloque('Condiciones usadas en esta decisión',ui.datos(x,ui.condiciones));
      if(d.provisional===true||d.revisada_humanamente===false)cuerpo+='<p class="rec-aviso">Decisión provisional. La revisión humana sigue pendiente.</p>';
      extra=calculoPanel(s,n);
    }else if(t.includes('Regla')){explicacion=d.descripcion||'No se conservó la descripción de esta regla.';cuerpo=bloque('Procedencia',ui.datos(d,['descripcion_fuente','fuente','estado_validacion','ejecucion']));}
    else if(t.includes('ModeloDifuso')){explicacion='El modelo transforma las valoraciones confirmadas en un grado numérico.';cuerpo=ficha(s,'tec-modelo-'+n.id);}
    else if(t.includes('Evidencia')){explicacion=d.contenido||'Evidencia vinculada al caso.';cuerpo=bloque('Procedencia de la evidencia',ui.datos(d,['naturaleza','tipo','autor_registro','localizador']));}
    else {explicacion=t.includes('Criticidad')?'Cuánto importa el requerimiento para el negocio.':t.includes('Severidad')?'Gravedad del defecto registrada para priorizarlo.':t.includes('ContextoPrioridad')?'Condiciones confirmadas para determinar el tratamiento de la observación.':'Este registro forma parte de la evidencia y las conexiones del caso.';cuerpo=ui.datos(d,Object.keys(d).filter(k=>d[k]!=null&&!['id','lote','origen','fecha','propuesta_confirmada_json','tiempos_json'].includes(k)));}
    const conexiones=s.grafo.aristas.filter(a=>a.desde===n.id||a.hasta===n.id),reglas=conexiones.filter(a=>a.desde===n.id&&a.relacion==='APLICA_REGLA').map(a=>a.hasta);
    const reglasHTML=reglas.length?bloque('Reglas aplicadas',`<div class="rec-reglas-aplicadas">${reglas.map(id=>{const regla=nodo(s,id).datos;return `<button type="button" data-rec-nodo="${e(id)}"><span>${ico('regla')}<b>${e(id)}</b>${ico('expandir')}</span><p>${e(regla.descripcion||'Abrir la regla registrada')}</p></button>`;}).join('')}</div>`):'';
    const paso=s.ruta.etapas[s.paso];
    panel.innerHTML=`<div class="rec-panel-ruta"><span>${relacionado?'NODO CONECTADO':`PASO ${String(s.paso+1).padStart(2,'0')} / ${String(s.ruta.etapas.length).padStart(2,'0')}`}</span><span>${e(etiquetaTipo(n))}</span></div><div class="rec-panel-icono rec-${tono(estado)}">${ico(iconoNodo(n))}</div><h3>${e(tituloNodo(s,n))}</h3>${badge(estado,ui)}<p class="rec-explicacion">${e(explicacion)}</p>${s.ruta.aviso?`<p class="rec-aviso">${e(s.ruta.aviso)}</p>`:''}${cuerpo}${reglasHTML}${extra}
      ${s.paso===s.ruta.etapas.length-1&&s.ruta.cierre?`<p class="rec-aviso">${e(s.ruta.cierre)}</p>`:''}
      ${relacionado?`<button type="button" class="rec-volver-nodo" data-rec-paso="${s.paso}">${ico('volver')}Volver a ${e(paso.titulo.toLowerCase())}</button>`:''}
      <details class="rec-conexiones"><summary>Conexiones de este nodo <span>${conexiones.length}</span></summary><div class="rec-vecinos">${conexiones.map(a=>{const sale=a.desde===n.id,id=sale?a.hasta:a.desde,otro=nodo(s,id);return `<button type="button" data-rec-nodo="${e(id)}"><small>${sale?'→':'←'} ${e(relaciones[a.relacion]||texto(a.relacion))}</small><b>${e(tituloNodo(s,otro))}</b><code>${e(id)}</code></button>`;}).join('')}</div></details><div class="rec-id-registro">Registro <code>${e(n.id)}</code></div>`;
    s.cont.querySelector('.rec-inspector').scrollTop=0;
  }
  function calculoPanel(s,n){
    const d=n.datos||{},v=d.grado_urgencia??d.grado_ambiguedad??d.grado_contradiccion,max=d.grado_urgencia!=null||n.tipos.includes('DecisionPrioridad')?10:1;
    const etiqueta=n.tipos.includes('DecisionPrioridad')?'Urgencia':n.tipos.includes('EvaluacionCruzada')?'Contradicción':'Ambigüedad';
    if(!d.modelo_difuso_version&&v==null&&!n.tipos.includes('DecisionPrioridad')&&!n.tipos.includes('EvaluacionCruzada'))return '';
    const contenedor=document.createElement('div');contenedor.innerHTML=ficha(s,'tec-calculo-'+n.id);
    const detalle=contenedor.querySelector('.tec-caso-cuerpo')?.innerHTML||contenedor.innerHTML;
    return bloque(`Grado de ${etiqueta.toLowerCase()}`,`<div class="rec-grado"><strong>${v!=null?numero(v):'Sin cálculo'}<small>${v!=null?' / '+max:''}</small></strong><span>${e(texto(d.banda_difusa||d.estado_calculo_difuso||''))}</span></div>${v!=null?`<div class="rec-barra-grado"><i style="width:${Math.max(0,Math.min(100,v/max*100))}%"></i></div>`:''}<details class="rec-calculo" ${v==null?'open':''}><summary>Ver entradas, activaciones y modelo</summary>${detalle}</details>`);
  }
  return {render,activar,construir,tituloRequerimiento};
})();
