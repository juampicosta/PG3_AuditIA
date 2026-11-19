/* Ejecutar con: node --test pruebas/probar_recorrido_tecnico.cjs */
const {test}=require('node:test');
const assert=require('node:assert/strict');
const fs=require('node:fs');
const path=require('node:path');
const vm=require('node:vm');
const ctx=vm.createContext({});
vm.runInContext(fs.readFileSync(path.join(__dirname,'../auditia/web/recorrido-tecnico.js'),'utf8')+';globalThis.explorador=RecorridoTecnico;',ctx);
const construir=res=>ctx.explorador.construir(res);

function fixture(){
  const nodos=[['R1','Requerimiento'],['R2','Requerimiento'],['EV1','EvaluacionIndividual'],['J1','JuicioCriterio'],['J2','JuicioCriterio'],['H1','Hallazgo'],['P1','Pendiente'],['D1','DecisionPrioridad'],['CP1','EvaluacionCruzada']]
    .map(([id,tipo])=>({id,tipos:[tipo],datos:{id}}));
  const relaciones=[['EV1','EVALUA','R1'],['EV1','CONTIENE_JUICIO','J1'],['EV1','CONTIENE_JUICIO','J2'],['EV1','GENERA','H1'],['H1','DERIVA_DE_JUICIO','J1'],['D1','PRIORIZA','H1'],['J1','APLICA_REGLA','REGLA1'],['CP1','COMPARA','R1'],['CP1','COMPARA','R2']]
    .map(([desde,relacion,hasta])=>({desde,relacion,hasta}));
  return {requerimientos:[{id:'R1',id_documento:'RF-01',evaluacion:{id:'EV1',juicios:[{id:'J1',criterio:'ambiguedad',estado:'incumple'},{id:'J2',criterio:'atomicidad',estado:'cumple'}]}},{id:'R2',id_documento:'RF-02'}],
    observaciones:[{id:'H1',clase:'Hallazgo',origen:'EV1',juicio_id:'J1',decision:{id:'D1'}}],
    comparaciones:[{id:'CP1',estado:'sin_hallazgo',requerimientos:['R1','R2']}],
    tecnico:{nodos,relaciones,reglas:[{id:'REGLA1',descripcion:'Regla guardada'}]}};
}

test('el recorrido de un hallazgo conserva nodos, relaciones y dirección reales',()=>{
  const res=fixture(), grafo=construir(res), ruta=grafo.grupos[0].rutas[0];
  assert.deepEqual(Array.from(ruta.etapas,s=>Array.from(s.ids)),[['R1'],['EV1','J1'],['H1'],['D1']]);
  assert.ok(ruta.aristas.some(a=>a.desde==='D1'&&a.hasta==='H1'&&a.relacion==='PRIORIZA'));
  assert.ok(!ruta.aristas.some(a=>a.desde==='H1'&&a.hasta==='D1'));
  for(const a of ruta.aristas)assert.ok(res.tecnico.relaciones.includes(a));
  assert.equal(grafo.nodos.get('REGLA1').datos.descripcion,'Regla guardada');
});

test('un criterio que cumple termina en la evaluación y no hereda otro hallazgo',()=>{
  const ruta=construir(fixture()).grupos[0].rutas.find(r=>r.id==='J2');
  assert.equal(ruta.etapas.length,2);
  assert.equal(ruta.observacion,null);
  assert.match(ruta.cierre,/no hay una observación/);
  assert.ok(!ruta.aristas.some(a=>a.hasta==='H1'));
});

test('un pendiente sin decisión no inventa una prioridad',()=>{
  const res=fixture();res.observaciones=[{id:'P1',clase:'Pendiente',origen:'EV1',juicio_id:'J1'}];
  res.tecnico.relaciones.push({desde:'P1',relacion:'DERIVA_DE_JUICIO',hasta:'J1'});
  const ruta=construir(res).grupos[0].rutas[0];
  assert.equal(ruta.etapas.length,3);
  assert.equal(ruta.etapas.at(-1).ids[0],'P1');
  assert.match(ruta.cierre,/no tiene una decisión/);
});

test('la comparación conserva los dos orígenes sin generar observaciones inexistentes',()=>{
  const ruta=construir(fixture()).grupos.find(g=>g.id==='CP1').rutas[0];
  assert.deepEqual(Array.from(ruta.etapas[0].ids),['R1','R2']);
  assert.equal(ruta.etapas.length,2);
  assert.equal(ruta.aristas.length,2);
  assert.ok(ruta.aristas.every(a=>a.desde==='CP1'&&a.relacion==='COMPARA'));
});

test('una comparación con hallazgo y prioridad recorre ambos módulos',()=>{
  const res=fixture();res.observaciones=[{id:'H1',clase:'Hallazgo',origen:'CP1',decision:{id:'D1'}}];
  res.tecnico.relaciones.push({desde:'CP1',relacion:'GENERA',hasta:'H1'});
  const ruta=construir(res).grupos.find(g=>g.id==='CP1').rutas[0];
  assert.equal(ruta.etapas.length,4);
  assert.ok(ruta.aristas.some(a=>a.relacion==='GENERA'&&a.desde==='CP1'));
  assert.ok(!ruta.etapas.flatMap(s=>s.ids).includes('J1'));
});

test('un lote antiguo sin detalle no reconstruye nodos ni aristas supuestas',()=>{
  const res=fixture();delete res.tecnico;
  const grafo=construir(res);
  assert.equal(grafo.nodos.size,0);
  assert.ok(grafo.grupos.every(g=>g.rutas.every(r=>!r.etapas.length&&!r.aristas.length)));
  assert.equal(construir({}).grupos.length,0);
});

test('varios resultados de un criterio tienen rutas independientes',()=>{
  const res=fixture();res.observaciones.push({id:'P1',clase:'Pendiente',origen:'EV1',juicio_id:'J1'});
  const rutas=construir(res).grupos[0].rutas.filter(r=>r.juicio?.id==='J1');
  assert.equal(rutas.length,2);
  assert.equal(new Set(rutas.map(r=>r.id)).size,2);
  assert.ok(!rutas[1].etapas.flatMap(s=>s.ids).includes('H1'));
});

test('los títulos permiten reconocer el texto y conservan títulos explícitos',()=>{
  assert.equal(ctx.explorador.tituloRequerimiento({texto:'El sistema debe cargar rápidamente el catálogo de productos.'}),'Cargar rápidamente el catálogo de productos');
  assert.equal(ctx.explorador.tituloRequerimiento({titulo:'Catálogo',texto:'Otro texto'}),'Catálogo');
  assert.equal(ctx.explorador.tituloRequerimiento({}, {texto_original:'La aplicación deberá exportar los pedidos.'}),'Exportar los pedidos');
  assert.equal(ctx.explorador.tituloRequerimiento({}),'Requerimiento sin texto conservado');
});

test('el selector diferencia código, nombre y texto completo sin perder comparaciones',()=>{
  const res=fixture();res.requerimientos[0].texto='El sistema debe procesar los pagos.';res.requerimientos[1].texto='La aplicación debe cancelar los pagos.';
  const grafo=construir(res), rq=grafo.grupos[0],par=grafo.grupos.find(g=>g.id==='CP1');
  assert.equal(rq.codigo,'RF-01');assert.equal(rq.titulo,'Procesar los pagos');assert.match(rq.texto,/El sistema debe/);
  assert.match(par.titulo,/Procesar los pagos.*Cancelar los pagos/);assert.equal(par.tipo,'comparacion');
});

test('una evaluación sin juicios y el formato anterior de comparación siguen disponibles',()=>{
  const res=fixture();delete res.requerimientos[0].evaluacion.juicios;res.observaciones=[];res.comparacion=res.comparaciones[0];delete res.comparaciones;
  const grafo=construir(res);assert.equal(grafo.grupos[0].rutas[0].titulo,'Evaluación general');assert.ok(grafo.grupos.some(g=>g.id==='CP1'));
});

test('los resultados sin juicio o sin evaluación de origen también se pueden encontrar',()=>{
  const res=fixture();delete res.observaciones[0].juicio_id;
  res.observaciones.push({id:'P1',clase:'Pendiente',origen:'evaluacion-no-conservada',descripcion:'Falta el criterio de aceptación'});
  const grafo=construir(res),rutas=grafo.grupos.flatMap(g=>g.rutas);
  assert.ok(rutas.some(r=>r.observacion?.id==='H1'));
  assert.ok(rutas.some(r=>r.observacion?.id==='P1'));
  assert.match(rutas.find(r=>r.observacion?.id==='P1').aviso,/No se conservaron todos/);
});

test('los registros parciales se avisan sin dibujar nodos que faltan',()=>{
  const res=fixture();res.tecnico.nodos=res.tecnico.nodos.filter(n=>n.id!=='D1');
  const ruta=construir(res).grupos[0].rutas[0];
  assert.match(ruta.aviso,/registros disponibles/);assert.ok(!ruta.etapas.flatMap(p=>p.ids).includes('D1'));
});
