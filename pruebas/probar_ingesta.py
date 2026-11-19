#!/usr/bin/env python3
"""Pruebas del análisis de requerimientos nuevos (PG3 v1.3).

PI-01..PI-02  Réplica: se ingresan como casos nuevos las mismas premisas de EV-CAT-01 y EV-DESC (PG2) y el camino
              genérico (08 + 04 acotado) debe dar los MISMOS estados, reglas, prioridades y grados que la base original.
PI-03..PI-08  Cobertura: cada regla puesta en ejecución en v1.3 (EVI-HC01/HC03/HC05/HC06/HC07, ACC-RD04/RD06/RD18/RD19)
              y la frontera ACC-RD07 se disparan con premisas que las cumplen.
PI-09         Borrador léxico (sin LLM) sobre requerimientos de ejemplo: estados esperados de punta a punta.
PI-10         Controles de integridad de PG2 (07_controles.cypher) en cero después de cada ingreso.
PI-11         Limpieza: los lotes de prueba se borran y la base vuelve a su conteo original.
Opcional --llm: mide una propuesta real del LLM (no cambia el resultado de las pruebas).

Uso (dentro del contenedor):  python pruebas/probar_ingesta.py [--llm] [--conservar]
Resultado: pruebas/resultados/ingesta.json
"""
from __future__ import annotations

import json
import sys
import time
from copy import deepcopy
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(RAIZ))

from auditia import documentos as DOCS  # noqa: E402
from auditia import ingesta as I  # noqa: E402
from auditia.config import ConfigGeneral  # noqa: E402

TOL = 1e-6
resultados: list[dict] = []


def registrar_prueba(pid: str, nombre: str, controles: list[tuple[str, bool, object]]) -> None:
    ok = all(c[1] for c in controles)
    resultados.append({"id": pid, "nombre": nombre, "estado": "pasada" if ok else "fallida",
                       "controles": [{"control": c[0], "ok": c[1], "detalle": c[2]} for c in controles]})
    print(f"  {'OK ' if ok else 'FALLA'} {pid} · {nombre}")
    for c in controles:
        if not c[1]:
            print(f"        ✗ {c[0]} → {c[2]}")


def juicio(res: dict, clave: str, criterio: str) -> dict:
    rq = next(r for r in res["requerimientos"] if r["id"].endswith(f"-{clave}-v1"))
    return next(j for j in rq["evaluacion"]["juicios"] if j["criterio"] == criterio)


def reglas(j: dict) -> list[str]:
    return [r["id"] if isinstance(r, dict) else r for r in j.get("reglas") or []]


def obs(res: dict, sufijo: str) -> dict | None:
    return next((o for o in res["observaciones"] if o["id"].endswith(sufijo)), None)


def base_rq(texto: str, clave: str = "A") -> dict:
    ext = I.extraer_heuristico(texto)
    return {"clave": clave, "texto": texto, "tipo": "funcional", "extraccion": ext,
            "premisas": I.premisas_requerimiento(ext, texto)}


def propuesta(*rqs: dict, comparacion: dict | None = None) -> dict:
    return {"fuente": "prueba", "analista": "Pruebas PG3", "contexto": "", "requerimientos": list(rqs),
            "comparacion": {"extraccion": {}, "premisas": comparacion} if comparacion else None}


def main() -> int:
    usar_llm = "--llm" in sys.argv
    conservar = "--conservar" in sys.argv
    cfg = ConfigGeneral()
    ing = I.Ingesta(cfg)
    t0 = time.perf_counter()
    salida: dict = {"fecha": time.strftime("%Y-%m-%dT%H:%M:%S"), "version": I.VERSION_INGESTA}
    conteo = "MATCH (n:AuditIA_PG2) WHERE n.id <> 'S-ANALISTA' OPTIONAL MATCH (n)-[r]->(:AuditIA_PG2) " \
             "RETURN count(DISTINCT n) AS nodos, count(r) AS relaciones"
    # Se limpian restos de corridas anteriores interrumpidas.
    for fila in ing._q("MATCH (d:AuditIA_PG2:DocumentoVersion {origen:'analista'}) WHERE d.lote STARTS WITH 'T' RETURN d.lote AS l"):
        ing.borrar(fila["l"])
    antes = ing._q(conteo)[0]
    salida["preparacion"] = ing.asegurar_preparacion()
    print("Preparación:", salida["preparacion"])
    lotes: list[str] = []

    def ingresar(prop: dict) -> dict:
        res = ing.registrar(prop, prefijo="T")
        lotes.append(res["lote"])
        return res

    # ---------------------------------------------------------------- PI-01 réplica de EV-CAT-01
    orig = ing._q("""
        MATCH (j:JuicioCriterio {id:'J-EV-CAT-01-ambiguedad'}), (d:DecisionPrioridad {id:'D-H-CAT-B'})
        RETURN j.grado_ambiguedad AS grado, j.banda_difusa AS banda, d.prioridad AS prioridad, d.motivo AS motivo,
               [(d)-[:APLICA_REGLA]->(r:Regla) | r.id] AS reglas_d,
               [(:Evaluacion {id:'EV-CAT-01'})-[:CONTIENE_JUICIO]->(x)-[:APLICA_CRITERIO]->(c) | [c.nombre, x.estado]] AS estados""")[0]
    texto_cat = "El sistema debe cargar rápidamente el catálogo."
    rq = base_rq(texto_cat)
    c = rq["premisas"]["criterios"]
    comun = {"revision_semantica_completa": True, "info_necesaria_identificada": True, "info_disponible": True,
             "contexto_suficiente": True}
    c["atomicidad"].update({**comun, "obligaciones_independientes": 1, "unidad_aceptacion_confirmada": True})
    c["ambiguedad"].update({**comun, "lecturas_residuales": 2, "delimitacion_confirmada": False, "aceptacion_delimita": False,
                            "divergencia_lecturas": 8.5, "delimitacion_contexto": 1, "severidad_propuesta": "media",
                            "puntuacion_severidad_propuesta": 5.0})
    c["verificabilidad"].update({**comun, "aceptacion_necesaria": True, "aceptacion_disponible": False,
                                 "comprobacion_definida": False})
    c["completitud"].update({**comun, "info_disponible": False, "informacion_aplicable_identificada": False,
                             "omisiones_demostradas": None})
    res = ingresar(propuesta(rq))
    j_amb = juicio(res, "A", "ambiguedad")
    h = obs(res, "-A-AMB")
    estados_orig = dict(orig["estados"])
    estados_new = {j["criterio"]: j["estado"] for j in next(r for r in res["requerimientos"])["evaluacion"]["juicios"]}
    registrar_prueba("PI-01", "Réplica de EV-CAT-01 por el camino genérico", [
        ("estados por criterio iguales a EV-CAT-01", estados_new == estados_orig, {"nuevo": estados_new, "pg2": estados_orig}),
        ("regla de ambigüedad EVI-HC02", "EVI-HC02" in reglas(j_amb), reglas(j_amb)),
        ("evaluación observada (EVI-RD04)", next(r for r in res["requerimientos"])["evaluacion"]["estado"] == "observado", None),
        ("grado de ambigüedad idéntico", j_amb["grado_ambiguedad"] is not None and abs(j_amb["grado_ambiguedad"] - orig["grado"]) < TOL,
         {"nuevo": j_amb["grado_ambiguedad"], "pg2": orig["grado"]}),
        ("misma banda difusa", j_amb["banda"] == orig["banda"], {"nuevo": j_amb["banda"], "pg2": orig["banda"]}),
        ("hallazgo H-…-AMB con severidad media", h is not None and h["clase"] == "Hallazgo" and h["severidad"]["valor"] == "media", h),
        ("misma prioridad y motivo que D-H-CAT-B", h and h["decision"] and (h["decision"]["prioridad"], h["decision"]["motivo"])
         == (orig["prioridad"], orig["motivo"]), {"nuevo": h and h["decision"], "pg2": [orig["prioridad"], orig["motivo"]]}),
        ("misma regla de prioridad", h and h["decision"] and sorted(h["decision"]["reglas"]) == sorted(orig["reglas_d"]),
         {"nuevo": h and h["decision"] and h["decision"]["reglas"], "pg2": orig["reglas_d"]}),
        ("dos pendientes (verificabilidad y completitud)", obs(res, "-A-VER") is not None and obs(res, "-A-COM") is not None,
         [o["id"] for o in res["observaciones"]]),
        ("controles PG2 en cero", res["controles"]["todos_en_cero"], res["controles"]["conteos"]),
    ])

    # ---------------------------------------------------------------- PI-02 réplica de EV-DESC
    orig = ing._q("""
        MATCH (ev:EvaluacionCruzada {id:'EV-DESC'}), (d:DecisionPrioridad {id:'D-H-DESC'})
        RETURN ev.grado_contradiccion AS grado, ev.banda_difusa AS banda, d.prioridad AS prioridad, d.motivo AS motivo,
               d.grado_urgencia AS urgencia, d.banda_difusa AS banda_u, [(d)-[:APLICA_REGLA]->(r:Regla) | r.id] AS reglas_d""")[0]
    a = base_rq("En una venta de categoría A se debe aplicar el descuento del 10 %.", "A")
    b = base_rq("En una venta de categoría A no se debe aplicar ningún descuento.", "B")
    for r in (a, b):
        r["premisas"]["prioridad"].update({"criticidad_valor": "alta", "grado_criticidad": 9.0,
                                           "obligacion_esencial_indefinida": True, "bloqueo_sustantivo_confirmado": True})
    cmp = {"escenarios": "coincidentes", "resultados_incompatibles": True, "excepcion_resuelve": False,
           "region_comun_definida": True, "interpretacion_cerrada": True, "datos_controlados": True,
           "solapamiento_escenario": 9.5, "incompatibilidad_resultados": 9.5, "severidad_propuesta": "alta",
           "puntuacion_severidad_propuesta": 9.0, "ambito_comun": "misma venta A",
           "justificacion": "Los precios finales son incompatibles y no se declaró una excepción conciliadora."}
    res = ingresar(propuesta(a, b, comparacion=cmp))
    comp = res["comparacion"]
    h = obs(res, "-AB")
    contradice = ing._q("MATCH (:Requerimiento {lote:$l})-[c:CONTRADICE]->(:Requerimiento {lote:$l}) RETURN count(c) AS n",
                        l=res["lote"])[0]["n"]
    registrar_prueba("PI-02", "Réplica de EV-DESC por el camino genérico", [
        ("comparación observada con ACC-RD05", comp and comp["estado"] == "observado" and "ACC-RD05" in reglas(comp), comp),
        ("grado de contradicción idéntico", comp and comp["grado_contradiccion"] is not None
         and abs(comp["grado_contradiccion"] - orig["grado"]) < TOL, {"nuevo": comp and comp["grado_contradiccion"], "pg2": orig["grado"]}),
        ("hallazgo de contradicción con severidad alta", h is not None and h["tipo_defecto"] == "contradiccion"
         and h["severidad"]["valor"] == "alta", h),
        ("CONTRADICE derivada", contradice == 1, contradice),
        ("misma prioridad, motivo y regla que D-H-DESC", h and h["decision"] and
         (h["decision"]["prioridad"], h["decision"]["motivo"], sorted(h["decision"]["reglas"])) ==
         (orig["prioridad"], orig["motivo"], sorted(orig["reglas_d"])), {"nuevo": h and h["decision"], "pg2": orig}),
        ("grado de urgencia idéntico", h and h["decision"]["grado_urgencia"] is not None and
         abs(h["decision"]["grado_urgencia"] - orig["urgencia"]) < TOL, {"nuevo": h and h["decision"]["grado_urgencia"], "pg2": orig["urgencia"]}),
        ("controles PG2 en cero", res["controles"]["todos_en_cero"], res["controles"]["conteos"]),
    ])

    # ---------------------------------------------------------------- PI-03..PI-05 reglas nuevas de SM1
    rq = base_rq("El sistema debe registrar el pedido y notificar al cliente por correo.")
    res = ingresar(propuesta(rq))
    j = juicio(res, "A", "atomicidad")
    registrar_prueba("PI-03", "EVI-HC01: dos obligaciones sin unidad de aceptación → atomicidad incumple", [
        ("borrador detecta 2 obligaciones", rq["premisas"]["criterios"]["atomicidad"]["obligaciones_independientes"] == 2,
         rq["premisas"]["criterios"]["atomicidad"]),
        ("juicio incumple por EVI-HC01", j["estado"] == "incumple" and "EVI-HC01" in reglas(j), j),
        ("hallazgo H-…-ATO", obs(res, "-A-ATO") is not None, [o["id"] for o in res["observaciones"]]),
    ])
    rq2 = deepcopy(rq)
    rq2["premisas"]["criterios"]["atomicidad"]["unidad_aceptacion_confirmada"] = True
    res = ingresar(propuesta(rq2))
    j = juicio(res, "A", "atomicidad")
    registrar_prueba("PI-04", "EVI-HC06: acciones que forman una única unidad de aceptación → excepción (cumple)", [
        ("juicio cumple por EVI-HC06", j["estado"] == "cumple" and "EVI-HC06" in reglas(j), j),
    ])
    rq = base_rq("El sistema debe admitir los medios de pago tarjeta, transferencia, etc.")
    rq["premisas"]["criterios"]["verificabilidad"].update({"comprobacion_definida": True, "metodo_discrimina": False,
                                                           "aceptacion_necesaria": False, "aceptacion_disponible": True})
    res = ingresar(propuesta(rq))
    jc, jv = juicio(res, "A", "completitud"), juicio(res, "A", "verificabilidad")
    registrar_prueba("PI-05", "EVI-HC05 (omisión demostrada) y EVI-HC07 (método que no discrimina)", [
        ("borrador detecta la enumeración abierta", rq["premisas"]["criterios"]["completitud"]["omisiones_demostradas"] >= 1,
         rq["premisas"]["criterios"]["completitud"]),
        ("completitud incumple por EVI-HC05", jc["estado"] == "incumple" and "EVI-HC05" in reglas(jc), jc),
        ("verificabilidad incumple por EVI-HC07", jv["estado"] == "incumple" and "EVI-HC07" in reglas(jv), jv),
    ])
    rq = base_rq("El sistema debe cargar rápidamente el catálogo.")
    ctx = "Criterio de aceptación: el catálogo carga en 2 segundos como máximo."
    rq = {"clave": "A", "texto": rq["texto"], "tipo": "funcional", "extraccion": I.extraer_heuristico(rq["texto"], ctx),
          "premisas": I.premisas_requerimiento(I.extraer_heuristico(rq["texto"], ctx), rq["texto"], ctx)}
    prop = propuesta(rq)
    prop["contexto"] = ctx
    res = ingresar(prop)
    ja, jv = juicio(res, "A", "ambiguedad"), juicio(res, "A", "verificabilidad")
    registrar_prueba("PI-06", "EVI-HC03: el criterio de aceptación delimita el término vago → ambigüedad resuelta", [
        ("ambigüedad cumple por EVI-HC03", ja["estado"] == "cumple" and "EVI-HC03" in reglas(ja), ja),
        ("verificabilidad cumple por EVI-HC04", jv["estado"] == "cumple" and "EVI-HC04" in reglas(jv), jv),
        ("grado difuso en banda baja", ja["banda"] == "baja", ja.get("banda")),
    ])

    # ---------------------------------------------------------------- PI-07..PI-08 reglas nuevas de SM2
    casos_cmp = [
        ("ACC-RD04", "sin_hallazgo", {"escenarios": "coincidentes", "resultados_incompatibles": True, "excepcion_resuelve": True}),
        ("ACC-RD18", "sin_hallazgo", {"escenarios": "coincidentes", "resultados_incompatibles": False, "excepcion_resuelve": False}),
        ("ACC-RD06", "observado", {"escenarios": "parciales", "region_comun_definida": True, "resultados_incompatibles": True,
                                   "excepcion_resuelve": False}),
        ("ACC-RD19", "sin_hallazgo", {"escenarios": "parciales", "region_comun_definida": True, "resultados_incompatibles": False,
                                      "excepcion_resuelve": False}),
        ("ACC-RD07", "pendiente", {"escenarios": "parciales", "region_comun_definida": False, "resultados_incompatibles": True,
                                   "excepcion_resuelve": False}),
        ("ACC-RD03", "sin_hallazgo", {"escenarios": "excluyentes", "resultados_incompatibles": True, "excepcion_resuelve": False}),
    ]
    controles = []
    for regla, estado, premisas in casos_cmp:
        a = base_rq("El pedido en preparación puede ser cancelado por el cliente.", "A")
        b = base_rq("El pedido antes del despacho no puede ser cancelado.", "B")
        cmp = {"interpretacion_cerrada": True, "datos_controlados": True, "region_comun_definida": premisas["escenarios"] == "coincidentes",
               "solapamiento_escenario": 6.0, "incompatibilidad_resultados": 8.0, "severidad_propuesta": "alta",
               "puntuacion_severidad_propuesta": 9.0, "ambito_comun": "pedido en preparación", "justificacion": f"Caso de {regla}."}
        cmp.update(premisas)
        res = ingresar(propuesta(a, b, comparacion=cmp))
        comp = res["comparacion"]
        o = obs(res, "-AB")
        esperado_obs = {"observado": "Hallazgo", "pendiente": "Pendiente", "sin_hallazgo": None}[estado]
        controles.append((f"{regla} → {estado}", comp["estado"] == estado and regla in reglas(comp)
                          and ((o or {}).get("clase") == esperado_obs), {"estado": comp["estado"], "reglas": reglas(comp),
                                                                         "observacion": o and o["id"]}))
        if regla == "ACC-RD06":
            controles.append(("ACC-RD06 deriva contradiccion_en_region", o is not None and o["tipo_defecto"] == "contradiccion_en_region", o))
        if regla == "ACC-RD07":
            controles.append(("ACC-RD07 deriva Pendiente(frontera_semantica) sin severidad",
                              o is not None and o["motivo_pendiente"] == "frontera_semantica" and o["severidad"]["valor"] is None, o))
    registrar_prueba("PI-07", "SM2: excepción, compatibles, región común, frontera y excluyentes", controles)

    # ---------------------------------------------------------------- PI-08 SM3 con criticidad declarada
    a = base_rq("El sistema debe registrar el pedido y notificar al cliente por correo.")
    a["premisas"]["prioridad"].update({"criticidad_valor": "media", "grado_criticidad": 5.0, "hito_acordado": True})
    a["premisas"]["criterios"]["atomicidad"]["severidad_propuesta"] = "baja"
    res = ingresar(propuesta(a))
    h = obs(res, "-A-ATO")
    registrar_prueba("PI-08", "SM3: severidad baja × criticidad media = celda mayor; hito acordado → PRC-HC04", [
        ("categoría de matriz mayor", h and h["decision"]["categoria_matriz"] == "mayor", h and h["decision"]),
        ("prioridad mayor en hito (PRC-HC04)", h and h["decision"]["prioridad"] == "mayor" and "PRC-HC04" in h["decision"]["reglas"],
         h and h["decision"]),
        ("urgencia difusa calculada", h and h["decision"]["grado_urgencia"] is not None, h and h["decision"]),
    ])

    # ---------------------------------------------------------------- PI-09 borrador léxico de punta a punta
    ejemplos = [
        ("El sistema debe exportar el reporte mensual en formato PDF.", "sin_hallazgo"),
        ("La búsqueda de productos debe responder en menos de 2 segundos.", "sin_hallazgo"),
        ("La aplicación debe ser fácil de usar.", "observado"),
    ]
    controles = []
    for texto, esperado in ejemplos:
        res = ingresar(propuesta(base_rq(texto)))
        ev = res["requerimientos"][0]["evaluacion"]
        controles.append((f"«{texto}» → {esperado}", ev["estado"] == esperado,
                          {"estado": ev["estado"], "juicios": {j["criterio"]: j["estado"] for j in ev["juicios"]}}))
    registrar_prueba("PI-09", "Borrador léxico sin LLM: estados de punta a punta", controles)

    # ---------------------------------------------------------------- PI-10 controles
    ctl = ing.controles()
    registrar_prueba("PI-10", "Controles de integridad de PG2 sobre toda la base", [
        ("07_controles.cypher en cero", ctl["todos_en_cero"], ctl["conteos"])])

    # ---------------------------------------------------------------- PI-12 documento completo
    esperado = {"RF-01": "sin_hallazgo", "RF-02": "observado", "RF-03": "observado", "RF-04": "observado",
                "RF-05": "sin_hallazgo", "RF-06": "sin_hallazgo", "RF-07": "sin_hallazgo", "RNF-01": "sin_hallazgo",
                "RNF-02": "observado"}
    controles = []
    for nombre in ("Especificacion_Tienda_Online.docx", "Especificacion_Tienda_Online.pdf", "Especificacion_Tienda_Online.txt"):
        ruta = RAIZ / "ejemplos" / nombre
        leido = DOCS.leer_documento(nombre, ruta.read_bytes())
        ids = [q["id_documento"] for q in leido["requerimientos"]]
        controles.append((f"{nombre}: 9 requerimientos detectados con su ID", ids == list(esperado), ids))
        if nombre.endswith(".docx"):
            prop = I.proponer(leido["requerimientos"], usar_llm=False, documento=nombre)
            prop["analista"] = "Pruebas PG3"
            res = ingresar(prop)
            estados = {r["id_documento"]: r["evaluacion"]["estado"] for r in res["requerimientos"]}
            controles.append(("estados por requerimiento del documento", estados == esperado, estados))
            comps = res.get("comparaciones") or []
            controles.append(("SM2 propone solo el par RF-05/RF-06 y lo observa (ACC-RD05)",
                              len(comps) == 1 and comps[0]["estado"] == "observado" and "ACC-RD05" in reglas(comps[0]),
                              [(c["id"], c["estado"], reglas(c)) for c in comps]))
            controles.append(("el documento queda registrado con su nombre", res.get("documento") == nombre, res.get("documento")))
            controles.append(("controles PG2 en cero", res["controles"]["todos_en_cero"], res["controles"]["conteos"]))
    registrar_prueba("PI-12", "Documento completo (.docx, .pdf, .txt): detección, análisis por lote y comparación propuesta", controles)

    # ---------------------------------------------------------------- LLM opcional
    if usar_llm:
        print("  Midiendo una propuesta del LLM (puede tardar varios minutos)…")
        prop = I.proponer(["El sistema debe cargar rápidamente el catálogo.",
                           "El catálogo debe mostrarse completo en menos de 3 segundos."], usar_llm=True, cfg=cfg)
        salida["llm"] = {"fuente": prop["fuente"], "segundos": prop["segundos"], "avisos": prop["avisos"],
                         "extraccion": [r["extraccion"] for r in prop["requerimientos"]],
                         "comparacion": prop["comparacion"]}
        print(f"  LLM: fuente={prop['fuente']} · {prop['segundos']} s")

    # ---------------------------------------------------------------- PI-11 limpieza
    if not conservar:
        for lote in lotes:
            ing.borrar(lote)
        despues = ing._q(conteo)[0]
        registrar_prueba("PI-11", "Limpieza: la base vuelve al conteo original", [
            ("nodos y relaciones iguales a antes", despues == antes, {"antes": antes, "despues": despues})])
    salida["lotes"] = lotes
    salida["pruebas"] = resultados
    salida["resumen"] = {"pasadas": sum(r["estado"] == "pasada" for r in resultados), "total": len(resultados),
                         "segundos": round(time.perf_counter() - t0, 1)}
    destino = RAIZ / "pruebas/resultados/ingesta.json"
    destino.parent.mkdir(parents=True, exist_ok=True)
    destino.write_text(json.dumps(salida, ensure_ascii=False, indent=2, default=str), encoding="utf-8")
    print(f"\n{salida['resumen']['pasadas']}/{salida['resumen']['total']} pruebas pasadas · {destino}")
    ing.cerrar()
    return 0 if salida["resumen"]["pasadas"] == salida["resumen"]["total"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
