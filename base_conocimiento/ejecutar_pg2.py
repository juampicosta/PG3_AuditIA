#!/usr/bin/env python3
"""Carga y verifica los archivos de AuditIA PG2 en Neo4j 5.26.0."""
import argparse,base64,getpass,json,pathlib,urllib.request,urllib.error
ROOT=pathlib.Path(__file__).resolve().parent

def statements(text):
    buf=[]; quote=None; escape=False; comment=False; i=0
    while i<len(text):
        ch=text[i]
        if comment:
            if ch=='\n':comment=False;buf.append(ch)
        elif quote:
            buf.append(ch)
            if escape:escape=False
            elif ch=='\\':escape=True
            elif ch==quote:quote=None
        elif ch in "'\"`":quote=ch;buf.append(ch)
        elif ch=='/' and i+1<len(text) and text[i+1]=='/':comment=True;i+=1
        elif ch==';':
            if ''.join(buf).strip():yield ''.join(buf).strip()
            buf=[]
        else:buf.append(ch)
        i+=1
    if quote:raise ValueError('Cadena sin cerrar en un archivo Cypher')
    if ''.join(buf).strip():yield ''.join(buf).strip()

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--url',default='http://localhost:7474')
    p.add_argument('--usuario',default='neo4j')
    p.add_argument('--sin-auth',action='store_true',help='Solo para una instancia local configurada expresamente sin autenticación')
    args=p.parse_args();headers={'Content-Type':'application/json'}
    if not args.sin_auth:
        secret=getpass.getpass('Contraseña Neo4j: ')
        headers['Authorization']='Basic '+base64.b64encode((args.usuario+':'+secret).encode()).decode()
    def query(text,parameters=None):
        req=urllib.request.Request(args.url.rstrip('/')+'/db/neo4j/tx/commit',data=json.dumps({'statements':[{'statement':text,'parameters':parameters or {}}]}).encode(),headers=headers)
        with urllib.request.urlopen(req,timeout=120) as r:payload=json.load(r)
        if payload.get('errors'):raise RuntimeError(json.dumps(payload['errors'],ensure_ascii=False))
        return payload['results'][0]
    def load(name):
        for st in statements((ROOT/'scripts'/name).read_text(encoding='utf8')):query(st)
    sequence=['01_esquema.cypher','02_carga.cypher','03_inferencia_crisp.cypher','04_difusa.cypher','05_retorno.cypher','06_informes.cypher']
    for name in sequence:load(name);print('Ejecutado:',name)
    result={'motor':'Neo4j 5.26.0','consultas':[],'pruebas':[]}
    for name in ['Q1_tratamiento.cypher','Q2_urgencia.cypher','Q3_retorno.cypher']:
        rs=query((ROOT/'consultas'/name).read_text(encoding='utf8'));result['consultas'].append({'archivo':name,'columnas':rs['columns'],'filas':[r['row']for r in rs['data']]});print(name,len(rs['data']),'filas')
    originals=json.loads((ROOT/'pruebas/expectativas.json').read_text(encoding='utf8'))
    for test in originals:
        if not test.get('query'):continue
        rows=[r['row'] for r in query(test['query'])['data']]
        if rows!=test['expected']:raise AssertionError(test['id']+': esperado '+str(test['expected'])+'; obtenido '+str(rows))
        result['pruebas'].append({'id':test['id'],'obtenido':rows,'estado':'pasado'})
    count='MATCH (n:AuditIA_PG2) OPTIONAL MATCH (n)-[r]->(:AuditIA_PG2) RETURN count(DISTINCT n),count(r)'
    before=query(count)['data'][0]['row']
    for name in sequence[1:]:load(name)
    after=query(count)['data'][0]['row']
    if before!=after:raise AssertionError('PT21: la repetición cambió los conteos')
    result['pruebas'].append({'id':'PT21','antes':before,'despues':after,'estado':'pasado'})
    result['paquete_llm']=query((ROOT/'consultas/Q4_paquete_llm.cypher').read_text(encoding='utf8'),{'observacion_id':'H-DESC'})['data'][0]['row'][0]
    dest=ROOT/'pruebas/resultados_reproduccion.json';dest.write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf8')
    print('Pruebas pasadas:',len(result['pruebas']));print('Resultados:',dest)
if __name__=='__main__':main()
