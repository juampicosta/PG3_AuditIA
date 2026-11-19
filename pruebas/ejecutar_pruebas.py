#!/usr/bin/env python3
"""AuditIA · PG3 · Pruebas funcionales y de extremo a extremo.

  python pruebas/ejecutar_pruebas.py --funcionales      # sin LLM: recuperación, consultas, reglas, difusa, controles (~1 min)
  python pruebas/ejecutar_pruebas.py --e2e              # casos integrados con el LLM (pruebas/casos_e2e.json; lento en CPU)
  python pruebas/ejecutar_pruebas.py --e2e E2E-02 CTL-01

Los resultados (esperado vs. obtenido) quedan en pruebas/resultados/.
"""
from __future__ import annotations

import argparse
import datetime as dt
import json
import sys
import time
import traceback
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(RAIZ))

from auditia.config import ConfigGeneral  # noqa: E402
from auditia.orquestador import Orquestador, observaciones_del_paquete  # noqa: E402
from auditia.submodulos import modulo  # noqa: E402

DIR_RES = RAIZ / "pruebas" / "resultados"


def _valores(obj):
    if isinstance(obj, dict):
        for v in obj.values():
            yield from _valores(v)
    elif isinstance(obj, list):
        for v in obj:
            yield from _valores(v)
    else:
        yield obj


def contiene(obj, esperado) -> bool:
    for v in _valores(obj):
        if isinstance(esperado, float) and isinstance(v, (int, float)) and not isinstance(v, bool):
            if abs(float(v) - esperado) < 5e-6:
                return True
        elif v == esperado:
            return True
    return False


def recuperar(clave: str, kb, ext: dict, texto: str):
    mod = modulo(clave)
    ext, _ = mod.normalizar_extraccion(ext, texto)
    rec, _ = mod.recuperar(kb, ext, texto)
    return rec


# --------------------------------------------------------------------------------------------
# Pruebas funcionales (determinísticas, sin LLM; la extracción se reemplaza por un JSON fijo)
# --------------------------------------------------------------------------------------------
def pruebas_funcionales(orq: Orquestador) -> list[dict]:
    kb = {k: orq.asistente(k).kb for k in ("SM1", "SM2", "SM3")}
    E1 = lambda intencion, **e: {"intencion": intencion,
                                 "entidades": {"requerimiento_id": None, "requerimiento_texto": None, "observacion_id": None,
                                               "evaluacion_id": None, **e},
                                 "conceptos": {"criterio": None}, "filtros": {"estado_juicio": None, "banda_ambiguedad": None},
                                 "condiciones": {"version": None, "alcance": "vigente"}, "faltantes": []}
    E2 = lambda intencion, **e: {"intencion": intencion,
                                 "entidades": {"requerimiento_ids": [], "requerimiento_texto": None, "documento_id": None,
                                               "evaluacion_id": None, "observacion_id": None, **e},
                                 "conceptos": {"categoria": None}, "filtros": {"tipo_analisis": None, "estado": None},
                                 "condiciones": {"alcance": "vigente"}, "faltantes": []}
    E3 = lambda intencion, **e: {"intencion": intencion,
                                 "entidades": {"observacion_id": None, "observacion_texto": None, "documento_id": None, **e},
                                 "filtros": {"prioridad": None, "motivo": None, "estado_seguimiento": "abiertas"},
                                 "matriz": {"severidad": None, "criticidad": None}, "faltantes": []}

    def p_sm1_diagnostico():
        rec = recuperar("SM1", kb["SM1"], E1("diagnostico_requerimiento", requerimiento_id="RQ-CAT-v1"),
                        "¿Qué problemas de calidad tiene RQ-CAT-v1?")
        p = rec.paquete
        return {"ambiguedad_incumple": contiene(p, "incumple"), "hallazgo": contiene(p, "H-CAT-B"),
                "grado_0781016": contiene(p, 0.7810157758841172), "banda_alta": contiene(p, "alta"),
                "consultas": [c["consulta"] for c in rec.consultas]}

    def p_sm1_desconocido():
        rec = recuperar("SM1", kb["SM1"], E1("grado_ambiguedad", requerimiento_id="RQ-AMB-SIN-DATO-v1"),
                        "¿Qué grado de ambigüedad tiene RQ-AMB-SIN-DATO-v1?")
        grados = [d.get("grado_ambiguedad") for d in _dicts(rec.paquete) if "grado_ambiguedad" in d]
        return {"sin_grado_inventado": bool(grados) and all(g is None for g in grados), "grados": grados}

    def p_sm2_contradiccion():
        rec = recuperar("SM2", kb["SM2"], E2("grado_contradiccion", evaluacion_id="EV-DESC"),
                        "¿Qué grado de contradicción tiene EV-DESC?")
        p = rec.paquete
        return {"grado_0843975": contiene(p, 0.843975) or any(isinstance(v, float) and abs(v - 0.843975) < 5e-6
                                                             for v in _valores(p)),
                "observado": contiene(p, "observado"), "hallazgo": contiene(p, "H-DESC"),
                "consultas": [c["consulta"] for c in rec.consultas]}

    def p_sm2_cobertura():
        rec = recuperar("SM2", kb["SM2"], E2("cobertura_categoria", documento_id="DOC-SEG-DESCONOCIDO-v1"),
                        "¿Seguridad es exigible en DOC-SEG-DESCONOCIDO-v1?")
        p = rec.paquete
        return {"pendiente": contiene(p, "pendiente"), "P-SEG": contiene(p, "P-SEG"),
                "regla_ACC_RD12": contiene(p, "ACC-RD12"), "perfil_insuficiente": contiene(p, "perfil_insuficiente")}

    def p_sm3_regla_bloqueo_sustantivo():
        rec = recuperar("SM3", kb["SM3"], E3("fundamento_prioridad", observacion_id="H-DESC"), "¿Por qué H-DESC es bloqueante?")
        p = rec.paquete
        return {"bloqueante": contiene(p, "bloqueante"), "sustantivo": contiene(p, "sustantivo"),
                "regla_PRC_HC01": contiene(p, "PRC-HC01"), "provisional": contiene(p, True),
                "celda_MPR_alta_alta": contiene(p, "MPR-alta-alta")}

    def p_sm3_regla_bloqueo_preventivo():
        rec = recuperar("SM3", kb["SM3"], E3("fundamento_prioridad", observacion_id="P-TASA"), "¿Por qué P-TASA es bloqueante?")
        p = rec.paquete
        return {"bloqueante": contiene(p, "bloqueante"), "preventivo": contiene(p, "preventivo")}

    def p_sm3_urgencia_difusa():
        rec = recuperar("SM3", kb["SM3"], E3("urgencia_difusa", observacion_id="H-PRIO-EXCEPCION"),
                        "¿Qué urgencia tiene H-PRIO-EXCEPCION?")
        urg = [v for d in _dicts(rec.paquete) for k, v in d.items() if "urgencia" in k and isinstance(v, (int, float))
               and not isinstance(v, bool)]
        return {"urgencia_calculada": bool(urg), "en_universo_0_10": bool(urg) and all(0 <= u <= 10 for u in urg),
                "valores": urg[:4]}

    def p_validador_plan():
        plan = {"tipo": "consulta", "pasos": [{"submodulo": "SM3", "subconsulta": "¿Por qué H-INVENTADA es bloqueante?",
                                               "depende_de": None}], "motivo": "x"}
        errores = orq.validar_plan(plan, "¿Por qué la contradicción de descuentos es bloqueante?")
        return {"rechaza_id_inventado": any("IDs" in e for e in errores), "errores": errores}

    def p_respaldo():
        plan = orq.ruteo_respaldo("¿Qué prioridad y urgencia tiene la contradicción de los descuentos?")
        accion = orq.ruteo_respaldo("Marcá H-DESC como resuelto")
        return {"enruta_SM2_SM3": [p["submodulo"] for p in plan["pasos"]] == ["SM2", "SM3"],
                "detecta_accion": accion["tipo"] == "accion_no_permitida"}

    def p_solo_lectura():
        m = modulo("SM1")
        return {"rechaza_escritura": not m.es_solo_lectura("MATCH (n) DETACH DELETE n"),
                "acepta_lectura": m.es_solo_lectura("MATCH (n:Regla) RETURN n.id")}

    def p_enlace():
        rec = recuperar("SM1", kb["SM1"], E1("diagnostico_requerimiento", requerimiento_id="RQ-CAT-v1"),
                        "¿Qué problemas de calidad tiene RQ-CAT-v1?")
        sub, enlace = orq._enlazar({"subconsulta": "¿Qué prioridad tiene su hallazgo?", "depende_de": 1},
                                   {"paquete_evidencia": rec.paquete})
        return {"elige_H_CAT_B": (enlace or {}).get("elegidas") == ["H-CAT-B"], "subconsulta": sub,
                "candidatas": (enlace or {}).get("candidatas")}

    def p_verificador_gl05():
        rec = recuperar("SM3", kb["SM3"], E3("fundamento_prioridad", observacion_id="H-DESC"), "¿Por qué H-DESC es bloqueante?")
        mala = "H-DESC tiene prioridad menor por la regla PRC-HC99 y una urgencia de 3.14. Es provisional."
        violaciones = modulo("SM3").verificar_respuesta(mala, rec.paquete)
        return {"rechaza_respuesta_infiel": len(violaciones) > 0, "violaciones": violaciones[:4]}

    def p_verificador_sintesis():
        pasos = [{"submodulo": "SM2", "traza": {"respuesta_final": "EV-DESC observado con grado 0.844 [H-DESC].",
                                                 "paquete_evidencia": {}}},
                 {"submodulo": "SM3", "traza": {"respuesta_final": "H-DESC es bloqueante (PRC-HC01). Es provisional.",
                                                 "paquete_evidencia": {}}}]
        mala = "La contradicción H-DESC tiene grado 0.95 y quedó resuelta [SM2]. Es bloqueante [SM3]. Es provisional."
        buena = "EV-DESC quedó observado con grado 0.844 por H-DESC [SM2]. H-DESC es bloqueante por PRC-HC01 [SM3]. Es provisional."
        v_mala, v_buena = orq.verificar_sintesis(mala, pasos, "x"), orq.verificar_sintesis(buena, pasos, "x")
        return {"rechaza_mala": bool(v_mala), "acepta_buena": not v_buena, "violaciones_mala": v_mala}

    def p_normalizar_plan():
        plan = {"tipo": "consulta", "pasos": [
            {"submodulo": "SM1", "subconsulta": "¿Qué tan ambiguo es el requerimiento de notificar?", "depende_de": None},
            {"submodulo": "SM1", "subconsulta": "¿Cómo se calculó la ambigüedad?", "depende_de": 1}], "motivo": "x"}
        normal, notas = orq.normalizar_plan(plan)
        respaldo = orq.ruteo_respaldo("¿Qué tan ambiguo es el requerimiento de notificar a los clientes habituales?")
        return {"fusiona_pasos_repetidos": len(normal["pasos"]) == 1 and not orq.validar_plan(normal, "x"),
                "respaldo_no_confunde_cliente_con_SM3": [p["submodulo"] for p in respaldo["pasos"]] == ["SM1"],
                "notas": notas}

    def p_verificador_semantico():
        from auditia.orquestador import verificar_semantica
        fuente = ["La regla URG-RB3 activa con 0.539. El grado de urgencia de H-PRIO-EXCEPCION es 7.38, en la banda alta. "
                  "La decisión D-H-PRIO-EXCEPCION tiene prioridad bloqueante, motivo sustantivo."]
        cruzada = "H-PRIO-EXCEPCION tiene una urgencia de 0.539 y URG-RB3 activa con 7.38. Es provisional."
        atributo = "La decisión D-H-PRIO-EXCEPCION tiene prioridad mayor, motivo preventivo. Es provisional."
        fiel = "H-PRIO-EXCEPCION tiene urgencia 7.38, en la banda alta, y URG-RB3 activa con 0.539. Es provisional."
        return {"rechaza_numeros_cruzados": bool(verificar_semantica(cruzada, fuente)),
                "rechaza_atributo_cambiado": bool(verificar_semantica(atributo, fuente)),
                "acepta_sintesis_fiel": not verificar_semantica(fiel, fuente),
                "violaciones_cruzada": verificar_semantica(cruzada, fuente)}

    pruebas = [
        ("PF-01", "Recuperación de conocimiento", "SM1 recupera el diagnóstico de RQ-CAT-v1",
         "ambigüedad incumple, H-CAT-B, grado 0,781016 banda alta", p_sm1_diagnostico),
        ("PF-02", "Ejecución de consultas", "SM2 recupera la comparación EV-DESC",
         "observado, H-DESC, grado de contradicción 0,843975", p_sm2_contradiccion),
        ("PF-03", "Ejecución de consultas", "SM2 recupera la cobertura de Seguridad en DOC-SEG-DESCONOCIDO-v1",
         "pendiente P-SEG por perfil_insuficiente (ACC-RD12)", p_sm2_cobertura),
        ("PF-04", "Activación de reglas", "SM3 fundamenta la prioridad de H-DESC",
         "bloqueante, sustantivo, PRC-HC01, celda MPR-alta-alta, provisional", p_sm3_regla_bloqueo_sustantivo),
        ("PF-05", "Activación de reglas", "SM3 fundamenta la prioridad de P-TASA",
         "bloqueante con motivo preventivo (falta el dato, no hay defecto)", p_sm3_regla_bloqueo_preventivo),
        ("PF-06", "Lógica difusa", "Urgencia difusa de H-PRIO-EXCEPCION",
         "urgencia calculada dentro del universo [0, 10]", p_sm3_urgencia_difusa),
        ("PF-07", "Lógica difusa", "Ambigüedad sin dato de entrada (RQ-AMB-SIN-DATO-v1)",
         "no se imputa un grado (null), no se rellena con 0,5", p_sm1_desconocido),
        ("PF-08", "Orquestación", "El validador del plan rechaza un ID inventado por el LLM",
         "error 'usa IDs que no están en la consulta'", p_validador_plan),
        ("PF-09", "Orquestación", "Enrutador de respaldo por palabras clave",
         "contradicción + prioridad -> SM2, SM3; verbo de modificación -> acción no permitida", p_respaldo),
        ("PF-10", "Orquestación", "Encadenamiento SM1 -> SM3 toma el ID del grafo",
         "elige H-CAT-B (primer Hallazgo del paquete)", p_enlace),
        ("PF-11", "Generación de respuestas", "El verificador GL05 rechaza una explicación infiel",
         "detecta prioridad alterada, regla y número inexistentes", p_verificador_gl05),
        ("PF-12", "Generación de respuestas", "El verificador de síntesis rechaza números y cierres inventados",
         "rechaza la síntesis infiel y acepta la fiel", p_verificador_sintesis),
        ("PF-13", "Seguridad", "Control de solo lectura sobre Cypher", "rechaza DETACH DELETE, acepta MATCH", p_solo_lectura),
        ("PF-14", "Orquestación", "Normalización del plan y respaldo (corrección tras CTL-04)",
         "fusiona pasos repetidos del mismo submódulo; 'clientes habituales' no enruta a SM3", p_normalizar_plan),
        ("PF-15", "Generación de respuestas", "Verificador semántico de la síntesis (corrección tras la devolución)",
         "rechaza números asociados a otra variable y prioridades o motivos cambiados; acepta la síntesis fiel", p_verificador_semantico),
    ]
    resultados = []
    for pid, componente, nombre, esperado, fn in pruebas:
        t0 = time.perf_counter()
        try:
            obtenido = fn()
            booleanos = {k: v for k, v in obtenido.items() if isinstance(v, bool)}
            estado = "pasó" if booleanos and all(booleanos.values()) else "falló"
        except Exception as e:  # noqa: BLE001
            obtenido, estado = {"error": f"{type(e).__name__}: {e}", "detalle": traceback.format_exc()[-800:]}, "error"
        resultados.append({"id": pid, "componente": componente, "prueba": nombre, "esperado": esperado,
                           "obtenido": obtenido, "estado": estado, "segundos": round(time.perf_counter() - t0, 2)})
        print(f"{pid} [{estado}] {nombre}")
    return resultados


def _dicts(obj):
    if isinstance(obj, dict):
        yield obj
        for v in obj.values():
            yield from _dicts(v)
    elif isinstance(obj, list):
        for v in obj:
            yield from _dicts(v)


# --------------------------------------------------------------------------------------------
# Pruebas de extremo a extremo (con el LLM)
# --------------------------------------------------------------------------------------------
def evaluar_e2e(caso: dict, traza: dict) -> dict:
    controles: dict[str, bool] = {}
    controles["tipo_salida"] = traza.get("tipo_salida") == caso["tipo_esperado"]
    if caso.get("motivo_esperado"):
        controles["motivo"] = traza.get("motivo_cierre") == caso["motivo_esperado"]
    obtenidos = [p["submodulo"] for p in traza.get("pasos", [])]
    controles["submodulos"] = sorted(obtenidos) == sorted(caso["submodulos_esperados"])
    if len(obtenidos) > 1 and "SM3" in obtenidos:
        controles["orden_diagnostico_antes_de_tratamiento"] = obtenidos[-1] == "SM3"
    respuesta = traza.get("respuesta_final", "")
    for i in caso.get("ids_en_respuesta", []):
        controles[f"respuesta_cita_{i}"] = i in respuesta
    for sm, ids in (caso.get("ids_en_trazabilidad") or {}).items():
        paso = next((p for p in traza.get("pasos", []) if p["submodulo"] == sm), None)
        texto = json.dumps(paso["traza"], ensure_ascii=False) if paso else ""
        for i in ids:
            controles[f"{sm}_recupera_{i}"] = i in texto
    if caso.get("enlace_esperado"):
        enlaces = [p.get("enlace") for p in traza.get("pasos", []) if p.get("enlace")]
        controles["encadenamiento"] = any(caso["enlace_esperado"] in (e.get("elegidas") or []) for e in enlaces)
    redaccion_llm = {}
    for p in traza.get("pasos", []):
        tipo = p["traza"].get("tipo_salida")
        # Control: la respuesta del paso es fiel al grafo (explicación aprobada por GL05 o respaldo construido con datos).
        controles[f"{p['submodulo']}_respuesta_fiel"] = tipo in ("explicacion", "respaldo")
        exp = p["traza"].get("explicacion") or {}
        redaccion_llm[p["submodulo"]] = {"verificacion": exp.get("resultado_verificacion"), "tipo_salida": tipo,
                                         "intentos": len(exp.get("intentos", []))}
    return {"controles": controles, "aprobado": all(controles.values()), "redaccion_llm": redaccion_llm}


def correr_e2e(orq: Orquestador, filtro: list[str] | None, continuar: bool = False) -> list[dict]:
    casos = json.loads((RAIZ / "pruebas" / "casos_e2e.json").read_text(encoding="utf-8"))
    if filtro:
        casos = [c for c in casos if c["id"] in filtro]
    resultados = []
    parcial = DIR_RES / "e2e_parcial.json"
    if continuar and parcial.exists():
        resultados = json.loads(parcial.read_text(encoding="utf-8"))
        hechos = {r["id"] for r in resultados}
        print(f"Retomando: ya terminados {sorted(hechos)}", flush=True)
        casos = [c for c in casos if c["id"] not in hechos]
    for c in casos:
        print(f"\n=== {c['id']} · {c['titulo']}\n    {c['consulta']}", flush=True)
        traza = orq.responder(c["consulta"], etiqueta=c["id"],
                              progreso=lambda e, d: print(f"    [{dt.datetime.now():%H:%M:%S}] {e}: {d}", flush=True))
        ev = evaluar_e2e(c, traza)
        r = {"id": c["id"], "titulo": c["titulo"], "consulta": c["consulta"], "situacion": c.get("situacion"),
             "esperado": {k: c.get(k) for k in ("tipo_esperado", "motivo_esperado", "submodulos_esperados",
                                                "ids_en_respuesta", "ids_en_trazabilidad", "enlace_esperado")},
             "obtenido": {"tipo_salida": traza.get("tipo_salida"), "motivo_cierre": traza.get("motivo_cierre"),
                          "submodulos": [p["submodulo"] for p in traza.get("pasos", [])],
                          "fuente_enrutamiento": (traza.get("enrutamiento") or {}).get("fuente"),
                          "modo_sintesis": (traza.get("sintesis") or {}).get("modo"),
                          "respuesta": traza.get("respuesta_final")},
             **ev, "segundos": traza.get("segundos_totales"), "traza": traza.get("archivo_traza")}
        resultados.append(r)
        parcial.write_text(json.dumps(resultados, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"    -> {'APROBADO' if ev['aprobado'] else 'NO APROBADO'} · {traza.get('segundos_totales')} s · "
              f"{ {k: v for k, v in ev['controles'].items() if not v} or 'todos los controles ok'}", flush=True)
    return resultados


def reevaluar() -> int:
    """Recalcula esperado vs. obtenido desde las trazas guardadas (sin volver a llamar al LLM)."""
    definiciones = {c["id"]: c for c in json.loads((RAIZ / "pruebas" / "casos_e2e.json").read_text(encoding="utf-8"))}
    for nombre in ("e2e_parcial.json", "e2e.json"):
        ruta = DIR_RES / nombre
        if not ruta.exists():
            continue
        datos = json.loads(ruta.read_text(encoding="utf-8"))
        lista = datos["casos"] if isinstance(datos, dict) else datos
        for r in lista:
            traza = json.loads((RAIZ / r["traza"]).read_text(encoding="utf-8"))
            r.update(evaluar_e2e(definiciones[r["id"]], traza))
        if isinstance(datos, dict):
            datos["aprobados"] = sum(r["aprobado"] for r in lista)
        ruta.write_text(json.dumps(datos, ensure_ascii=False, indent=2), encoding="utf-8")
        print(f"{nombre}: {sum(r['aprobado'] for r in lista)}/{len(lista)} aprobados")
    return 0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--funcionales", action="store_true")
    ap.add_argument("--e2e", nargs="*")
    ap.add_argument("--continuar", action="store_true", help="retoma la batería E2E desde e2e_parcial.json")
    ap.add_argument("--reevaluar", action="store_true", help="recalcula los controles E2E desde las trazas guardadas")
    a = ap.parse_args()
    if a.reevaluar:
        return reevaluar()
    DIR_RES.mkdir(parents=True, exist_ok=True)
    orq = Orquestador(ConfigGeneral())
    marca = dt.datetime.now().strftime("%Y%m%d_%H%M%S")
    try:
        if a.funcionales:
            res = pruebas_funcionales(orq)
            salida = {"fecha": marca, "total": len(res), "pasaron": sum(r["estado"] == "pasó" for r in res), "pruebas": res}
            (DIR_RES / "funcionales.json").write_text(json.dumps(salida, ensure_ascii=False, indent=2), encoding="utf-8")
            print(f"\nFuncionales: {salida['pasaron']}/{salida['total']} pasaron")
        if a.e2e is not None:
            res = correr_e2e(orq, a.e2e or None, a.continuar)
            salida = {"fecha": marca, "modelo": orq.cfg.modelo, "huella_prompts": orq.huella, "total": len(res),
                      "aprobados": sum(r["aprobado"] for r in res), "casos": res}
            nombre = "e2e.json" if (not a.e2e or a.continuar) else f"e2e_{'_'.join(a.e2e)}.json"
            (DIR_RES / nombre).write_text(json.dumps(salida, ensure_ascii=False, indent=2), encoding="utf-8")
            print(f"\nE2E: {salida['aprobados']}/{salida['total']} aprobados")
    finally:
        orq.cerrar()
    return 0


if __name__ == "__main__":
    sys.exit(main())
