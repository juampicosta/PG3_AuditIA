#!/usr/bin/env python3
"""Contrasta Cypher con una implementación independiente del cálculo de los PI3."""
import ast,json,math,pathlib
ROOT=pathlib.Path(__file__).resolve().parent

def expression(expr,env):
    def calc(n):
        if isinstance(n,ast.Name):return env[n.id]
        values=[calc(a) for a in n.args]
        return min(values) if n.func.id=='min' else max(values)
    return calc(ast.parse(expr,mode='eval').body)

def infer(m,x,y):
    def mus(v,sigmas,maxv):return [math.exp(-.5*((v-c)/s)**2) for c,s in zip([0,maxv/2,maxv],sigmas)]
    env=dict(zip(['xb','xm','xa','yb','ym','ya'],mus(x,m['xs'],m['xmax'])+mus(y,m['ys'],m['ymax'])))
    activations=[expression(r[0],env) for r in m['rules']]
    num=den=0.
    for i in range(1001):
        z=m['zmax']*i/1000;out=mus(z,m['zs'],m['zmax'])
        mu=max(min(a,out[['baja','media','alta'].index(r[1])]) for a,r in zip(activations,m['rules']))
        num+=z*mu;den+=mu
    return num/den,activations

def main():
    models=json.loads((ROOT/'datos/modelos_pi3.json').read_text(encoding='utf8'))
    actual=json.loads((ROOT/'evidencias/calculos_difusos.json').read_text(encoding='utf8'))
    checks=[]
    for row in actual:
        key=row['modelo'].split('-')[1];degree,activations=infer(models[key],row['x'],row['y'])
        error=abs(degree-row['grado']);alpha_error=max(abs(a-b) for a,b in zip(activations,row['activaciones']))
        if error>1e-9 or alpha_error>1e-9:raise AssertionError(row['id'])
        checks.append({'id':row['id'],'modelo':row['modelo'],'cypher':row['grado'],'python':degree,'error_absoluto':error,'error_maximo_activaciones':alpha_error,'estado':'pasado'})
    isolated=infer(models['CONTR'],1,6)[0]
    result={'metodo':'Mamdani MIN/MAX; suma sobre 1001 puntos','tolerancia_absoluta':1e-9,'comparaciones':checks,'control_matematico_aislado_CONTR_1_6':isolated,'nota_control':'No se publica en el flujo con escenarios excluyentes; PT36 prueba la inhibición crisp.'}
    (ROOT/'evidencias/verificacion_independiente.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf8')
    print('Cálculos contrastados:',len(checks),'Error máximo:',max(c['error_absoluto']for c in checks))
if __name__=='__main__':main()
