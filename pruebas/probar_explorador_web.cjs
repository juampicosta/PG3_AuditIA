/* Solo lectura. Requiere app, auditorías guardadas y Playwright.
 * AUDITIA_URL (opcional): http://localhost:8010
 * PLAYWRIGHT_MODULE (opcional): ruta del módulo Playwright ya instalado.
 * node pruebas/probar_explorador_web.cjs
 */
const assert=require('node:assert/strict');
const {chromium}=require(process.env.PLAYWRIGHT_MODULE||'playwright');
const base=process.env.AUDITIA_URL||'http://localhost:8010';

async function verificar(){
  const listado=await(await fetch(base+'/api/analisis/lotes')).json();
  const lotes=Array.isArray(listado)?listado:listado.lotes;
  const registros=await Promise.all(lotes.map(async l=>await(await fetch(base+'/api/analisis/lotes/'+(l.lote||l.id||l))).json()));
  const res=registros.sort((a,b)=>(b.observaciones?.length||0)+(b.comparaciones?.length||0)-(a.observaciones?.length||0)-(a.comparaciones?.length||0))[0];
  assert.ok(res,'Hace falta al menos una auditoría guardada para verificar el explorador.');
  const browser=await chromium.launch();
  try{
    const page=await browser.newPage({viewport:{width:1440,height:1000}}),errores=[];
    page.on('pageerror',e=>errores.push(e.message));await page.goto(base);
    const cargar=async r=>{await page.evaluate(r=>{mostrarLote(r);ALCANZADO.resultados=true;irA('resultados');},r);await page.locator('[data-rec-abrir]').click();};
    await cargar(res);
    const dialogo=page.locator('dialog.rec-pantalla');assert.ok(await dialogo.evaluate(d=>d.open));
    assert.equal(await page.locator('#res-lote > .tecnico, #res-lote .tec-accesos').count(),0);
    assert.equal(await page.getByText('Ver el detalle técnico',{exact:false}).count(),0);
    assert.equal(await page.locator('.rec-nodos .rec-seleccionado').count(),1);
    assert.ok((await page.locator('[data-rec-titulo-caso]').innerText()).length>5);
    // Selector: búsqueda por texto, filtros, vacío y Escape sin cerrar la pantalla.
    await page.locator('[data-rec-selector]').click();await page.locator('[data-rec-buscar]').fill('no-existe-zzzz');
    assert.equal(await page.locator('.rec-lista-casos [data-rec-caso]').count(),0);
    await page.locator('[data-rec-buscar]').fill('');await page.locator('[data-rec-filtro="comparacion"]').click();
    const cantidadComparaciones=await page.locator('.rec-lista-casos [data-rec-caso]').count();
    assert.equal(cantidadComparaciones,(res.comparaciones||[]).length);
    await page.keyboard.press('Escape');assert.ok(await dialogo.evaluate(d=>d.open));assert.ok(await page.locator('.rec-selector').isHidden());
    // Todo el historial: cada ruta y cada nodo, enlaces de los paneles y aristas reales.
    let rutas=0,nodos=0;
    for(const registro of registros){
      await cargar(registro);
      const cobertura=await page.evaluate(r=>{
        const g=RecorridoTecnico.construir(r),cont=document.querySelector('.rec-explorador');let rutas=0,nodos=0;
        for(const grupo of g.grupos){
          cont.querySelector('[data-rec-selector]').click();
          cont.querySelector('[data-rec-filtro="todos"]').click();
          const input=cont.querySelector('[data-rec-buscar]');input.value='';input.dispatchEvent(new Event('input',{bubbles:true}));
          [...cont.querySelectorAll('[data-rec-caso]')].find(b=>b.dataset.recCaso===grupo.id).click();
          for(const ruta of grupo.rutas){
            [...cont.querySelectorAll('[data-rec-ruta]')].find(b=>b.dataset.recRuta===ruta.id).click();rutas++;
            for(const etapa of ruta.etapas)for(const id of etapa.ids){
              const b=[...cont.querySelectorAll('.rec-nodos [data-rec-nodo]')].find(b=>b.dataset.recNodo===id);if(!b)throw Error('Falta nodo '+id);b.click();nodos++;
              if(cont.querySelectorAll('.rec-nodos [aria-pressed="true"]').length!==1)throw Error('Selección inválida '+id);
              for(const a of cont.querySelectorAll('[data-tec-ir]'))if(!DetalleTecnico.tieneFicha(document.querySelector('#res-lote'),a.dataset.tecIr))throw Error('Enlace sin destino '+a.dataset.tecIr);
              const vistos=[...document.querySelectorAll('[id]')].map(e=>e.id);if(new Set(vistos).size!==vistos.length)throw Error('ID duplicado');
              for(const a of cont.querySelectorAll('[data-rec-relacion]'))if(!r.tecnico.relaciones.some(x=>x.desde===a.dataset.recDesde&&x.hasta===a.dataset.recHasta&&x.relacion===a.dataset.recRelacion))throw Error('Arista inventada');
            }
          }
        }
        return {rutas,nodos};
      },registro);
      rutas+=cobertura.rutas;nodos+=cobertura.nodos;
    }
    await cargar(res);
    const priorizada=(res.observaciones||[]).find(o=>o.juicio_id&&o.decision?.id&&o.decision?.categoria_matriz);
    if(priorizada){
      const rq=res.requerimientos.find(r=>r.evaluacion?.juicios?.some(j=>j.id===priorizada.juicio_id));
      await page.locator('[data-rec-selector]').click();
      await page.locator('.rec-lista-casos [data-rec-caso]').filter({hasText:rq.id_documento||rq.texto}).first().click();
      await page.locator('[data-rec-ruta]').evaluateAll((bs,id)=>bs.find(b=>b.dataset.recRuta===id).click(),priorizada.id);
      await page.locator('.rec-pasos [data-rec-paso]').last().click();
      assert.equal(await page.locator('.rec-panel .tec-celda-activa').count(),1);
      await page.locator('.rec-calculo>summary').click();
      const modelo=page.locator('.rec-panel [data-tec-ir^="tec-modelo-"]').first();
      if(await modelo.count()){
        await modelo.click();assert.ok(await dialogo.evaluate(d=>d.open));assert.match(await page.locator('.rec-panel').innerText(),/Parámetros de las variables/);
        await page.locator('[data-rec-volver-nodo]').click();assert.match(await page.locator('.rec-panel h3').innerText(),/Tratamiento/);
      }
      const ayuda=page.locator('.rec-panel .tec-ayuda').first();await ayuda.click();assert.ok(await page.locator('.tec-tooltip').isVisible());
      assert.equal(await page.locator('.tec-tooltip').evaluate(t=>t.closest('dialog')?.open),true);
      await page.keyboard.press('Escape');assert.ok(await dialogo.evaluate(d=>d.open));
      // Desde la evaluación general se puede cambiar de criterio sin arrastrar el hallazgo anterior.
      const evId=rq.evaluacion.id;await page.locator('.rec-nodos [data-rec-nodo]').evaluateAll((bs,id)=>bs.find(b=>b.dataset.recNodo===id).click(),evId);
      const otro=rq.evaluacion.juicios.find(j=>j.estado==='cumple');
      if(otro){await page.locator('.rec-criterios [data-rec-nodo]').evaluateAll((bs,id)=>bs.find(b=>b.dataset.recNodo===id).click(),otro.id);assert.equal(await page.locator('.rec-pasos [data-rec-paso]').count(),2);}
    }
    await cargar(res);
    const pasos=await page.locator('.rec-pasos [data-rec-paso]').count();
    if(pasos>1){
      await page.locator('[data-rec-avance="1"]').focus();await page.keyboard.press('Enter');
      assert.match(await page.locator('[data-rec-progreso]').innerText(),/^2 de/);
      assert.equal(await page.locator('[data-rec-avance="1"]').evaluate(b=>b===document.activeElement||b.disabled),true);
      // Reproducción, pausa y detención al salir.
      await page.locator('[data-rec-reproducir]').click();assert.equal(await page.locator('[data-rec-reproducir]').getAttribute('aria-pressed'),'true');
      await page.waitForTimeout(3800);await page.locator('[data-rec-reproducir]').click();
    }
    // Zoom y desplazamiento.
    const escala=await page.locator('[data-rec-escala]').innerText();await page.locator('[data-rec-zoom="1"]').click();assert.notEqual(await page.locator('[data-rec-escala]').innerText(),escala);
    const m=await page.locator('.rec-lienzo').boundingBox(),antes=await page.locator('.rec-mundo').getAttribute('style');
    await page.mouse.move(m.x+15,m.y+15);await page.mouse.down();await page.mouse.move(m.x+65,m.y+45,{steps:5});await page.mouse.up();
    assert.notEqual(await page.locator('.rec-mundo').getAttribute('style'),antes);await page.locator('[data-rec-ajustar]').click();
    // Fundamentos y un nodo relacionado no deben perder la selección.
    await page.locator('[data-rec-fundamentos]').click();assert.equal(await page.locator('[data-rec-fundamentos]').getAttribute('aria-pressed'),'true');
    const regla=page.locator('.rec-reglas-aplicadas [data-rec-nodo]').first();
    if(await regla.count()){await regla.click();assert.equal(await page.locator('.rec-nodos .rec-seleccionado').count(),1);assert.match(await page.locator('.rec-panel').innerText(),/NODO CONECTADO/);}
    // Cambio de resolución, paneo y controles visibles.
    for(const ancho of [1920,1440,1024,768,390,320]){
      await page.setViewportSize({width:ancho,height:900});await page.waitForTimeout(100);
      assert.equal(await dialogo.evaluate(d=>d.scrollWidth>d.clientWidth),false,'Desborde a '+ancho);
      assert.ok(await page.locator('[data-rec-cerrar]').isVisible());
      assert.equal(await page.evaluate(()=>document.documentElement.scrollWidth>innerWidth),false);
    }
    // Rerender con la pantalla abierta: no deja el cuerpo bloqueado ni listeners viejos.
    await cargar(res);await page.keyboard.press('Escape');assert.equal(await dialogo.evaluate(d=>d.open),false);
    assert.equal(await page.evaluate(()=>document.body.classList.contains('rec-abierto')),false);
    // Sin nodos, sin casos, parcial y texto hostil: siempre un estado navegable.
    const variantes=[{}, {lote:'anterior',requerimientos:[{id:'R1',texto:'El sistema debe conservar los pedidos.'}],observaciones:[]},
      {lote:'hostil',requerimientos:[{id:'R1',id_documento:'RF-01',texto:'<img src=x onerror="window.__xss=1">'}],tecnico:{nodos:[{id:'R1',tipos:['Requerimiento'],datos:{texto_original:'<script>window.__xss=1</script>'}}],relaciones:[]}}];
    for(const variante of variantes){await cargar(variante);await page.locator('.rec-lienzo').focus();await page.keyboard.press('End');assert.ok(await page.locator('[data-rec-cerrar]').isVisible());assert.equal(await page.evaluate(()=>window.__xss),undefined);await page.locator('[data-rec-cerrar]').click();}
    assert.deepEqual(errores,[]);console.log(JSON.stringify({ok:true,lotes:registros.length,rutas,nodos,comparaciones:cantidadComparaciones,errores}));
  }finally{await browser.close();}
}
verificar().catch(e=>{console.error(e);process.exitCode=1;});
