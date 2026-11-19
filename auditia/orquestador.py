"""AuditIA · PG3 · Orquestador del asistente integrado.

Flujo de una consulta:
  1. Validación determinística de la entrada.
  2. Enrutamiento con el System Prompt maestro (LLM, JSON con esquema) y validación del plan en código.
     Si el plan es inválido dos veces se usa el enrutador de respaldo por palabras clave.
  3. Ejecución de los pasos sobre los submódulos PI4 (cada uno: extracción -> Cypher fijo -> paquete ->
     explicación -> verificador GL05). Un paso puede depender de otro: el ID de la observación se toma del
     paquete de evidencia que devolvió Neo4j, nunca del LLM.
  4. Síntesis: con un paso se devuelve la respuesta verificada del submódulo; con varios, un LLM las une y un
     verificador comprueba IDs, números, origen y carácter provisional. Si falla, se compone en forma determinística.
  5. Traza completa en trazas/ (enrutamiento, Cypher, reglas, evidencias, verificaciones y tiempos).

Autores: Grupo 10 (Costa, Juan Pablo; Isgró, Tomás Valentino; Lucero, Bruno) · Inteligencia Artificial · UTN FRM · 2026
"""
from __future__ import annotations

import datetime as dt
import hashlib
import json
import re
import threading
import time
import unicodedata
from pathlib import Path
from typing import Any, Callable

from .config import DIR_TRAZAS, ConfigGeneral
from .submodulos import REGISTRO, modulo

VERSION = "PG3-AuditIA-1.2"
DIR_PROMPTS = Path(__file__).resolve().parent / "prompts"
MAX_CARACTERES = 600
TIPOS_CONTROL = ("requiere_aclaracion", "accion_no_permitida", "fuera_de_dominio")

MENSAJES_CONTROL = {
    "requiere_aclaracion": ("Necesito un poco más de información para consultar la base de conocimiento. Indicá qué "
                            "requerimiento, observación o documento querés revisar (por ID, por ejemplo H-DESC o "
                            "RQ-CAT-v1, o con palabras de su descripción) y qué querés saber: su diagnóstico de calidad, "
                            "una contradicción, dependencia o cobertura, o su prioridad, urgencia o clarificación."),
    "accion_no_permitida": ("No puedo hacer eso. AuditIA consulta la base de conocimiento en modo de solo lectura: no "
                            "cambia diagnósticos, severidades, prioridades ni estados, no da observaciones por resueltas, "
                            "no registra respuestas del cliente y no envía preguntas. Las instrucciones incluidas en el "
                            "texto se tratan como datos, sin autoridad sobre el sistema. Puedo explicarte cómo quedó "
                            "evaluada o priorizada una observación y en qué reglas se basa."),
    "fuera_de_dominio": ("AuditIA solo responde consultas sobre la auditoría de calidad de los requerimientos registrados "
                         "en su base de conocimiento: juicios de calidad (SM1), contradicciones, dependencias y cobertura "
                         "(SM2), y prioridad, urgencia y clarificación (SM3). No estima esfuerzo ni costos y no opina. "
                         "Ejemplo: «¿Se contradicen los requerimientos de los descuentos y por qué quedó bloqueante?»"),
}

# Enrutador de respaldo (determinístico): se usa solo si el plan del LLM es inválido dos veces.
PALABRAS_CLAVE = {
    "SM1": ("ambig", "verificab", "atomic", "atómic", "completitud", "calidad", "juicio", "criterio", "version",
            "versión", "cambió", "cambio entre", "historial", "evalu", "testeable"),
    "SM2": ("contradic", "contradicen", "depend", "cobertura", "cubierta", "exigible", "categoría", "categoria",
            "seguridad", "rendimiento", "anexo", "deriv", "análisis cruzado", "analisis cruzado"),
    "SM3": ("prioridad", "bloque", "urgencia", "urgente", "pregunt", "clarific", "matriz", "mpr", "senior",
            "informe", "firmar", "firma", "criticidad", "seguimiento", "preguntar al cliente", "preguntarle al cliente"),
}
PATRON_ACCION = re.compile(r"\b(marc[aá]|cambi[aá]|pon[eé]|asign[aá]|borr[aá]|elimin[aá]|ignor[aá]|olvid[aá]|"
                           r"da(?:la|lo)? por|envi[aá]|registr[aá])\b", re.IGNORECASE)

# --- Control semántico de la síntesis (v1.2) -----------------------------------------------------
# Variables cuantitativas que aparecen en las respuestas de los submódulos. Se normalizan sin tildes.
VARIABLES = {
    "urgencia": ("urgencia",), "ambiguedad": ("ambiguedad",), "contradiccion": ("contradiccion",),
    "activacion": ("activacion", "activa con", "activa"), "pertenencia": ("pertenencia",),
    "severidad": ("severidad",), "criticidad": ("criticidad",),
}
PATRON_NUMERO = re.compile(r"(?<![\w.,-])(\d+(?:[.,]\d+)?)(?![\w])")
PATRON_PRIORIDAD = re.compile(r"\b(?:prioridad|es|como|quedo|queda|resulta)\s+(bloqueante|mayor|menor)\b")
PATRON_MOTIVO = re.compile(r"\b(preventivo|sustantivo|en_hito|en hito|diferimiento)\b")
PATRON_BANDA = re.compile(r"\bbanda\s+(baja|media|intermedia|alta)\b")
PATRON_ESTADO = re.compile(r"\b(observad[oa]|pendiente|resuelt[oa]|sin_hallazgo|sin hallazgo|cumple|incumple)\b")


def _oraciones(texto: str) -> list[str]:
    return [o.strip() for o in re.split(r"(?<=[.;:])\s+|\n+", texto or "") if o.strip()]


def _variable_cercana(norm: str, pos: int, ventana: int = 70) -> str | None:
    """Variable cuantitativa mencionada más cerca ANTES de la posición del número (dentro de la ventana)."""
    tramo = norm[max(0, pos - ventana):pos]
    mejor, mejor_pos = None, -1
    for var, claves in VARIABLES.items():
        for c in claves:
            i = tramo.rfind(c)
            if i > mejor_pos:
                mejor, mejor_pos = var, i
    return mejor


def pares_variable_numero(texto: str) -> set[tuple[str, str]]:
    norm = _normalizar(texto or "")
    pares = set()
    for m in PATRON_NUMERO.finditer(norm):
        var = _variable_cercana(norm, m.start())
        if var:
            pares.add((var, m.group(1).replace(",", ".")))
    return pares


def atributos_por_id(texto: str) -> dict[str, dict[str, set[str]]]:
    """Para cada ID de observación o decisión: prioridades, motivos, bandas y estados afirmados en su misma oración."""
    salida: dict[str, dict[str, set[str]]] = {}
    for o in _oraciones(texto):
        ids = set(re.findall(r"(?<![\w-])(?:H|P|R-J|D)-[A-Z0-9](?:[A-Z0-9]|-(?=[A-Z0-9]))*", o))
        if not ids:
            continue
        n = _normalizar(o)
        attrs = {"prioridad": set(PATRON_PRIORIDAD.findall(n)),
                 "motivo": {m.replace(" ", "_") for m in PATRON_MOTIVO.findall(n)},
                 "banda": set(PATRON_BANDA.findall(n)),
                 "estado": {e.replace(" ", "_").rstrip("ao") for e in PATRON_ESTADO.findall(n)}}
        for i in ids:
            d = salida.setdefault(i.rstrip("."), {k: set() for k in attrs})
            for k, v in attrs.items():
                d[k] |= v
    return salida


def verificar_semantica(texto: str, respuestas: list[str]) -> list[str]:
    """Comprueba el significado, no solo la presencia: cada número con su variable y cada atributo con su ID."""
    violaciones: list[str] = []
    fuente = " ".join(respuestas)
    pares_fuente = pares_variable_numero(fuente)
    numeros_fuente = {n for _, n in pares_fuente}
    for var, num in sorted(pares_variable_numero(texto)):
        if (var, num) not in pares_fuente and num in numeros_fuente:
            correctas = sorted(v for v, n in pares_fuente if n == num)
            violaciones.append(f"asocia {num} a «{var}», pero en los submódulos corresponde a «{', '.join(correctas)}»")
    attrs_fuente: dict[str, dict[str, set[str]]] = {}
    for r in respuestas:
        for i, d in atributos_por_id(r).items():
            dst = attrs_fuente.setdefault(i, {k: set() for k in d})
            for k, v in d.items():
                dst[k] |= v
    for i, d in atributos_por_id(texto).items():
        ref = attrs_fuente.get(i)
        if not ref:
            continue
        for k, valores in d.items():
            extra = valores - ref.get(k, set())
            if extra and ref.get(k):
                violaciones.append(f"atribuye a {i} {k} «{', '.join(sorted(extra))}» y los submódulos dicen «{', '.join(sorted(ref[k]))}»")
    return violaciones


PATRON_OBS = re.compile(r"\b(?:H|P|R-J)-[A-Z0-9](?:[A-Z0-9]|-(?=[A-Z0-9]))*\b")
PATRON_DECIMAL = re.compile(r"(?<![\w.,])(\d+[.,]\d+)(?![\w])")


# ------------------------------------------------------------------------------------------------
# Utilidades
# ------------------------------------------------------------------------------------------------
def _normalizar(texto: str) -> str:
    t = unicodedata.normalize("NFKD", texto.lower())
    return "".join(c for c in t if not unicodedata.combining(c))


def _ids(texto: str) -> set[str]:
    patron = modulo("SM3").PATRON_ID
    return {m.group(0).rstrip(".") for m in patron.finditer(texto or "")}


def _decimales(texto: str) -> set[str]:
    return {m.group(1).replace(",", ".") for m in PATRON_DECIMAL.finditer(texto or "")}


def _ahora() -> str:
    return dt.datetime.now().isoformat(timespec="seconds")


def _caminar(obj: Any):
    if isinstance(obj, dict):
        yield obj
        for v in obj.values():
            yield from _caminar(v)
    elif isinstance(obj, list):
        for v in obj:
            yield from _caminar(v)


def observaciones_del_paquete(paquete: dict | None) -> list[dict]:
    """Observaciones (Hallazgo/Pendiente) presentes en un paquete de evidencia, en orden de aparición."""
    vistas: dict[str, dict] = {}
    for d in _caminar(paquete or {}):
        oid, clase = d.get("id"), d.get("clase")
        if isinstance(oid, str) and clase in ("Hallazgo", "Pendiente") and oid not in vistas:
            vistas[oid] = {"id": oid, "clase": clase}
        oid2 = d.get("observacion_id")
        if isinstance(oid2, str) and oid2 not in vistas and PATRON_OBS.fullmatch(oid2):
            vistas[oid2] = {"id": oid2, "clase": d.get("tipo") or "observacion"}
    return list(vistas.values())


def resumen_trazabilidad(clave: str, traza_sm: dict) -> dict:
    """Reconstruye fuente -> regla -> evidencia -> consulta -> explicación para un paso."""
    paquete = traza_sm.get("paquete_evidencia") or {}
    reglas: dict[str, dict] = {}
    evidencias: dict[str, dict] = {}
    fuentes: set[str] = set()
    for d in _caminar(paquete):
        for r in d.get("reglas", []) if isinstance(d.get("reglas"), list) else []:
            if isinstance(r, str):
                reglas.setdefault(r, {"id": r})
            elif isinstance(r, dict) and r.get("id"):
                reglas[r["id"]] = {k: r.get(k) for k in ("id", "descripcion", "fuente", "estado_validacion", "ejecucion")}
        if isinstance(d.get("regla"), str):
            reglas.setdefault(d["regla"], {"id": d["regla"]})
        eid = d.get("id")
        if isinstance(eid, str) and eid.startswith("E-") and "contenido" in d:
            evidencias[eid] = {k: d.get(k) for k in ("id", "contenido", "tipo", "localizador", "fuente")}
            if d.get("fuente"):
                fuentes.add(str(d["fuente"]))
    if paquete.get("fuente"):
        fuentes.add(str(paquete["fuente"]))
    mod = modulo(clave)
    consultas = []
    for c in traza_sm.get("consultas_cypher", []) or []:
        try:
            texto = mod.cargar_consulta(c["consulta"])
        except Exception:  # noqa: BLE001 - la traza no debe fallar por un archivo faltante
            texto = None
        consultas.append({**c, "cypher": texto})
    exp = traza_sm.get("explicacion") or {}
    return {
        "submodulo": clave,
        "intencion": traza_sm.get("intencion"),
        "fuentes": sorted(fuentes),
        "consultas": consultas,
        "reglas": list(reglas.values()),
        "evidencias": list(evidencias.values())[:12],
        "observaciones": observaciones_del_paquete(paquete),
        "verificacion": exp.get("resultado_verificacion"),
        "intentos_explicacion": len(exp.get("intentos", [])),
        "tipo_salida": traza_sm.get("tipo_salida"),
    }


# ------------------------------------------------------------------------------------------------
# Orquestador
# ------------------------------------------------------------------------------------------------
class Orquestador:
    def __init__(self, cfg: ConfigGeneral | None = None):
        self.cfg = cfg or ConfigGeneral()
        self.prompt_maestro = (DIR_PROMPTS / "system_prompt_maestro.txt").read_text(encoding="utf-8")
        self.prompt_sintesis = (DIR_PROMPTS / "system_prompt_sintesis.txt").read_text(encoding="utf-8")
        self.esquema_ruteo = json.loads((DIR_PROMPTS / "esquema_ruteo.json").read_text(encoding="utf-8"))
        self.huella = hashlib.sha256((self.prompt_maestro + self.prompt_sintesis).encode()).hexdigest()[:12]
        sm3 = modulo("SM3")
        self.llm = sm3.crear_cliente_llm(self.cfg.para_submodulo(sm3))   # Ollama o Gemini según LLM_PROVEEDOR
        self._asistentes: dict[str, Any] = {}
        self._candado = threading.Lock()   # una consulta por vez (LLM local o cupo gratuito de Gemini)
        (DIR_TRAZAS / "submodulos").mkdir(parents=True, exist_ok=True)

    # -- submódulos -----------------------------------------------------------------------------
    def asistente(self, clave: str):
        if clave not in self._asistentes:
            mod = modulo(clave)
            mod.DIR_EJECUCIONES = DIR_TRAZAS / "submodulos"   # todas las trazas en un solo lugar
            self._asistentes[clave] = mod.Asistente(self.cfg.para_submodulo(mod))
        return self._asistentes[clave]

    def cerrar(self) -> None:
        for a in self._asistentes.values():
            a.cerrar()

    def verificar(self) -> dict:
        estado: dict[str, Any] = {"version": VERSION, "modelo": self.cfg.modelo, "neo4j_uri": self.cfg.neo4j_uri,
                                  "proveedor": self.cfg.proveedor}
        if self.cfg.proveedor != "gemini":
            estado["ollama_url"] = self.cfg.ollama_url
        # La clave "ollama" se mantiene como estado del LLM (cualquiera sea el proveedor) por compatibilidad con la miniapp.
        try:
            modelos = self.llm.modelos_disponibles()
            estado["ollama"] = "ok"
            estado["modelo_disponible"] = any(m == self.cfg.modelo or m.startswith(self.cfg.modelo + ":")
                                              for m in modelos)
            estado["modelos"] = modelos
        except Exception as e:  # noqa: BLE001
            estado["ollama"] = f"error: {e}"
        try:
            kb = self.asistente("SM1").kb
            fila = kb.driver.execute_query(
                "MATCH (n:AuditIA_PG2) OPTIONAL MATCH (n)-[r]->(:AuditIA_PG2) RETURN count(DISTINCT n) AS nodos, "
                "count(r) AS relaciones", database_=self.cfg.neo4j_database).records[0]
            reglas = kb.driver.execute_query(
                "MATCH (r:Regla:AuditIA_PG2) RETURN count(r) AS total, count(r.descripcion) AS con_texto",
                database_=self.cfg.neo4j_database).records[0]
            estado.update({"neo4j": "ok", "nodos": fila["nodos"], "relaciones": fila["relaciones"],
                           "reglas": reglas["total"], "reglas_con_texto": reglas["con_texto"]})
        except Exception as e:  # noqa: BLE001
            estado["neo4j"] = f"error: {e}"
        estado["listo"] = estado.get("neo4j") == "ok" and estado.get("ollama") == "ok" \
            and estado.get("modelo_disponible", False) and estado.get("nodos", 0) > 0
        return estado

    # -- etapa 2: enrutamiento --------------------------------------------------------------------
    def validar_plan(self, plan: Any, consulta: str) -> list[str]:
        errores: list[str] = []
        if not isinstance(plan, dict):
            return ["La salida no es un objeto JSON."]
        tipo = plan.get("tipo")
        pasos = plan.get("pasos")
        if tipo not in ("consulta",) + TIPOS_CONTROL:
            errores.append(f"tipo inválido: {tipo!r}")
        if not isinstance(pasos, list):
            return errores + ["'pasos' debe ser una lista."]
        if tipo in TIPOS_CONTROL and pasos:
            errores.append(f"con tipo {tipo} la lista de pasos debe estar vacía")
        if tipo == "consulta" and not 1 <= len(pasos) <= 3:
            errores.append("una consulta necesita entre 1 y 3 pasos")
        literales = _ids(consulta)
        vistos = set()
        for i, p in enumerate(pasos, start=1):
            if not isinstance(p, dict):
                errores.append(f"paso {i}: no es un objeto")
                continue
            sm, sub, dep = p.get("submodulo"), p.get("subconsulta"), p.get("depende_de")
            if sm not in REGISTRO:
                errores.append(f"paso {i}: submódulo inválido {sm!r}")
            elif sm in vistos:
                errores.append(f"paso {i}: el submódulo {sm} se repite")
            vistos.add(sm)
            if not isinstance(sub, str) or len(sub.strip()) < 8:
                errores.append(f"paso {i}: subconsulta vacía")
            elif len(sub) > 400:
                errores.append(f"paso {i}: subconsulta de más de 400 caracteres")
            else:
                inventados = _ids(sub) - literales
                if inventados:
                    errores.append(f"paso {i}: usa IDs que no están en la consulta del usuario: {sorted(inventados)}")
            if dep is not None and (not isinstance(dep, int) or not 1 <= dep < i):
                errores.append(f"paso {i}: depende_de debe referirse a un paso anterior")
        return errores

    @staticmethod
    def normalizar_plan(plan: Any) -> tuple[Any, list[str]]:
        """Fusiona pasos repetidos del mismo submódulo (el LLM a veces divide una pregunta en dos)."""
        if not isinstance(plan, dict) or not isinstance(plan.get("pasos"), list):
            return plan, []
        pasos, notas, mapa = [], [], {}
        for i, p in enumerate(plan["pasos"], start=1):
            if not isinstance(p, dict):
                return plan, []
            previo = next((j for j, q in enumerate(pasos) if q["submodulo"] == p.get("submodulo")), None)
            if previo is not None and isinstance(p.get("subconsulta"), str):
                pasos[previo]["subconsulta"] = (pasos[previo]["subconsulta"].rstrip() + " " + p["subconsulta"].strip())[:400]
                mapa[i] = previo + 1
                notas.append(f"paso {i} fusionado con el paso {previo + 1} ({p.get('submodulo')})")
                continue
            q = dict(p)
            dep = q.get("depende_de")
            q["depende_de"] = mapa.get(dep, dep) if isinstance(dep, int) else dep
            if q["depende_de"] == len(pasos) + 1:
                q["depende_de"] = None
            pasos.append(q)
            mapa[i] = len(pasos)
        return ({**plan, "pasos": pasos} if notas else plan), notas

    def ruteo_respaldo(self, consulta: str) -> dict:
        norm = _normalizar(consulta)
        if PATRON_ACCION.search(consulta):
            return {"tipo": "accion_no_permitida", "pasos": [], "motivo": "Respaldo: verbo de modificación detectado."}
        puntajes = {sm: sum(1 for p in pal if _normalizar(p) in norm) for sm, pal in PALABRAS_CLAVE.items()}
        elegidos = [sm for sm in ("SM1", "SM2", "SM3") if puntajes[sm] > 0]
        if not elegidos:
            return {"tipo": "fuera_de_dominio", "pasos": [], "motivo": "Respaldo: sin términos del dominio."}
        diagnostico = [sm for sm in elegidos if sm != "SM3"][:1]
        pasos = [{"submodulo": sm, "subconsulta": consulta[:400], "depende_de": None} for sm in diagnostico]
        if "SM3" in elegidos:
            pasos.append({"submodulo": "SM3", "subconsulta": consulta[:400], "depende_de": 1 if pasos else None})
        return {"tipo": "consulta", "pasos": pasos, "motivo": f"Respaldo por palabras clave: {puntajes}."}

    def rutear(self, consulta: str) -> tuple[dict, dict]:
        traza: dict[str, Any] = {"intentos": [], "huella_prompt": self.huella}
        mensaje = f"Consulta del usuario:\n{consulta}"
        for intento in range(2):
            try:
                texto, meta = self.llm.chat(self.prompt_maestro, mensaje, temperatura=0.0,
                                            formato=self.esquema_ruteo, max_tokens=500)
            except Exception as e:  # noqa: BLE001
                traza["intentos"].append({"error": str(e)})
                break
            try:
                plan = json.loads(texto)
            except json.JSONDecodeError:
                plan = None
            plan, notas = self.normalizar_plan(plan)
            errores = self.validar_plan(plan, consulta) if plan is not None else ["JSON inválido"]
            traza["intentos"].append({"salida": texto, "errores": errores, "normalizacion": notas, **meta})
            if not errores:
                traza["fuente"] = "llm"
                traza["plan"] = plan
                return plan, traza
            mensaje = (f"Consulta del usuario:\n{consulta}\n\nTu salida anterior fue rechazada por el validador: "
                       f"{'; '.join(errores)}. Corregila respetando todas las reglas.")
        plan = self.ruteo_respaldo(consulta)
        traza["fuente"] = "respaldo_palabras_clave"
        traza["plan"] = plan
        return plan, traza

    # -- etapa 3: ejecución de pasos ------------------------------------------------------------
    def _enlazar(self, paso: dict, previo: dict | None) -> tuple[str, dict | None]:
        """Completa la subconsulta con la observación que devolvió Neo4j en el paso anterior."""
        sub = paso["subconsulta"]
        if previo is None or PATRON_OBS.search(sub):
            return sub, None
        obs = observaciones_del_paquete(previo.get("paquete_evidencia"))
        if not obs:
            return sub, {"estado": "sin_observaciones", "candidatas": []}
        hallazgos = [o for o in obs if o["clase"] == "Hallazgo"]
        elegidas = (hallazgos or obs)[: self.cfg.max_observaciones_encadenadas]
        ids = ", ".join(o["id"] for o in elegidas)
        nueva = f"{sub.rstrip()} (observación {ids})"
        return nueva[:400], {"estado": "enlazado", "elegidas": [o["id"] for o in elegidas],
                             "candidatas": [o["id"] for o in obs],
                             "criterio": "primer Hallazgo del paquete de evidencia; si no hay, primer Pendiente"}

    def _reenrutar(self, sub: str, actual: str, usados: set[str]) -> str | None:
        norm = _normalizar(sub)
        puntajes = {sm: sum(1 for p in pal if _normalizar(p) in norm) for sm, pal in PALABRAS_CLAVE.items()
                    if sm != actual and sm not in usados}
        if not puntajes:
            return None
        mejor = max(puntajes, key=lambda s: puntajes[s])
        return mejor if puntajes[mejor] > 0 else None

    # -- etapa 4: síntesis --------------------------------------------------------------------------
    def verificar_sintesis(self, texto: str, pasos: list[dict], consulta: str) -> list[str]:
        sm3 = modulo("SM3")
        violaciones: list[str] = []
        respuestas = " ".join(p["traza"].get("respuesta_final", "") for p in pasos)
        permitidos = _ids(respuestas) | _ids(consulta)
        for p in pasos:
            permitidos |= sm3.ids_del_paquete(p["traza"].get("paquete_evidencia") or {})
        inventados = sorted(_ids(texto) - permitidos)
        if inventados:
            violaciones.append(f"cita IDs que no figuran en las respuestas de los submódulos: {inventados}")
        numeros = sorted(_decimales(texto) - _decimales(respuestas))
        if numeros:
            violaciones.append(f"incluye números que no figuran en las respuestas de los submódulos: {numeros}")
        for p in pasos:
            if f"[{p['submodulo']}]" not in texto:
                violaciones.append(f"no indica el origen [{p['submodulo']}]")
            obs_paso = set(PATRON_OBS.findall(p["traza"].get("respuesta_final", "")))
            if obs_paso and not obs_paso & set(PATRON_OBS.findall(texto)):
                violaciones.append(f"omite las observaciones de {p['submodulo']}: {sorted(obs_paso)}")
        if "provisional" not in _normalizar(texto):
            violaciones.append("no aclara que las conclusiones son provisionales")
        violaciones += verificar_semantica(texto, [p["traza"].get("respuesta_final", "") for p in pasos])
        for patron, nombre in ((sm3._AFIRMA_CIERRE, "un cierre"), (sm3._AFIRMA_ENVIO, "un envío"),
                               (sm3._AFIRMA_EMITIBLE, "que algo es emitible"), (sm3._AFIRMA_SENIOR, "una revisión senior")):
            if sm3._menciones_afirmativas(patron, texto) and not sm3._menciones_afirmativas(patron, respuestas):
                violaciones.append(f"afirma {nombre} que ninguna respuesta de submódulo afirma")
        return violaciones

    @staticmethod
    def composicion_determinista(pasos: list[dict]) -> str:
        partes = []
        for p in pasos:
            ficha = REGISTRO[p["submodulo"]]
            partes.append(f"{ficha.nombre} [{p['submodulo']}]: {p['traza'].get('respuesta_final', '').strip()}")
        partes.append("Las conclusiones son provisionales: provienen de reglas y parámetros candidatos de un prototipo "
                      "académico, sin validación experta.")
        return "\n\n".join(partes)

    def sintetizar(self, consulta: str, pasos: list[dict]) -> tuple[str, dict]:
        traza: dict[str, Any] = {"intentos": []}
        utiles = [p for p in pasos if p["traza"].get("tipo_salida") in ("explicacion", "respaldo")]
        if len(pasos) == 1:
            traza["modo"] = "respuesta_del_submodulo"
            return pasos[0]["traza"].get("respuesta_final", ""), traza
        if not self.cfg.sintesis_llm or len(utiles) < 2:
            traza["modo"] = "composicion_determinista"
            return self.composicion_determinista(pasos), traza
        bloques = "\n\n".join(f"Paso {i} · {p['submodulo']} ({REGISTRO[p['submodulo']].nombre})\n"
                              f"Subconsulta: {p['subconsulta']}\nRespuesta verificada: {p['traza'].get('respuesta_final', '')}"
                              for i, p in enumerate(pasos, start=1))
        mensaje = f"Consulta original del usuario:\n{consulta}\n\nRespuestas de los submódulos:\n{bloques}"
        for _ in range(2):
            try:
                texto, meta = self.llm.chat(self.prompt_sintesis, mensaje, temperatura=0.0, max_tokens=650)
            except Exception as e:  # noqa: BLE001
                traza["intentos"].append({"error": str(e)})
                break
            texto = texto.strip()
            violaciones = self.verificar_sintesis(texto, pasos, consulta)
            traza["intentos"].append({"texto": texto, "violaciones": violaciones, **meta})
            if not violaciones:
                traza["modo"] = "sintesis_llm_verificada"
                return texto, traza
            mensaje += ("\n\nTu redacción anterior fue rechazada por el verificador: " + "; ".join(violaciones)
                        + ". Reescribila corrigiendo esos puntos.")
        traza["modo"] = "composicion_determinista"
        return self.composicion_determinista(pasos), traza

    # -- consulta completa --------------------------------------------------------------------------
    def responder(self, consulta: str, etiqueta: str | None = None,
                  progreso: Callable[[str, str], None] | None = None) -> dict:
        avisar = progreso or (lambda etapa, detalle: None)
        with self._candado:
            return self._responder(consulta.strip(), etiqueta, avisar)

    def _responder(self, consulta: str, etiqueta: str | None, avisar: Callable[[str, str], None]) -> dict:
        inicio = time.perf_counter()
        traza: dict[str, Any] = {"version": VERSION, "fecha": _ahora(), "modelo": self.cfg.modelo,
                                 "huella_prompts": self.huella, "caso": etiqueta, "consulta_usuario": consulta,
                                 "pasos": []}
        motivo = modulo("SM1").validar_entrada(consulta[:400]) if len(consulta) <= MAX_CARACTERES else \
            f"La consulta supera los {MAX_CARACTERES} caracteres."
        if motivo:
            traza.update({"tipo_salida": "aclaracion", "motivo_cierre": "entrada_invalida",
                          "respuesta_final": motivo + " " + MENSAJES_CONTROL["requiere_aclaracion"]})
            return self._guardar(traza, inicio)

        avisar("enrutamiento", "El prompt maestro decide qué submódulos consultar")
        plan, traza_ruteo = self.rutear(consulta)
        traza["enrutamiento"] = traza_ruteo
        if plan["tipo"] in TIPOS_CONTROL:
            traza.update({"tipo_salida": "aclaracion", "motivo_cierre": plan["tipo"],
                          "respuesta_final": MENSAJES_CONTROL[plan["tipo"]]})
            return self._guardar(traza, inicio)

        usados: set[str] = set()
        por_paso: dict[int, dict] = {}
        for i, paso in enumerate(plan["pasos"], start=1):
            clave = paso["submodulo"]
            previo = por_paso.get(paso.get("depende_de") or 0)
            sub, enlace = self._enlazar(paso, previo)
            avisar(f"paso_{i}", f"{clave} · {REGISTRO[clave].nombre}: {sub}")
            t_sm = self.asistente(clave).responder(sub, mostrar=False, etiqueta=f"{etiqueta or 'consulta'}_p{i}_{clave}")
            registro = {"paso": i, "submodulo": clave, "subconsulta": sub, "enlace": enlace, "traza": t_sm}
            if t_sm.get("motivo_cierre") == "otro_submodulo":
                alternativo = self._reenrutar(sub, clave, usados | {clave})
                if alternativo:
                    avisar(f"paso_{i}", f"{clave} indicó otro submódulo; reenrutando a {alternativo}")
                    registro["reenrutado_desde"] = clave
                    clave = alternativo
                    t_sm = self.asistente(clave).responder(sub, mostrar=False,
                                                           etiqueta=f"{etiqueta or 'consulta'}_p{i}_{clave}")
                    registro.update({"submodulo": clave, "traza": t_sm})
            por_paso[i] = t_sm
            if t_sm.get("motivo_cierre") == "otro_submodulo" and traza["pasos"]:
                registro["descartado"] = "el submódulo indicó otro submódulo ya consultado; el paso no aporta datos"
                traza.setdefault("pasos_descartados", []).append({k: v for k, v in registro.items() if k != "traza"})
                avisar(f"paso_{i}", f"{clave} no corresponde; se descarta el paso")
                continue
            usados.add(clave)
            registro["trazabilidad"] = resumen_trazabilidad(clave, t_sm)
            traza["pasos"].append(registro)

        avisar("sintesis", "Integrando las respuestas verificadas de los submódulos")
        respuesta, traza_sint = self.sintetizar(consulta, traza["pasos"])
        traza["sintesis"] = traza_sint
        traza["respuesta_final"] = respuesta
        tipos = {p["traza"].get("tipo_salida") for p in traza["pasos"]}
        traza["tipo_salida"] = "integrada" if len(traza["pasos"]) > 1 else (traza["pasos"][0]["traza"].get("tipo_salida"))
        traza["submodulos_consultados"] = [p["submodulo"] for p in traza["pasos"]]
        traza["tipos_salida_pasos"] = sorted(t for t in tipos if t)
        return self._guardar(traza, inicio)

    def _guardar(self, traza: dict, inicio: float) -> dict:
        traza["segundos_totales"] = round(time.perf_counter() - inicio, 2)
        marca = dt.datetime.now().strftime("%Y%m%d_%H%M%S_%f")[:-3]
        nombre = f"{marca}_{traza.get('caso') or 'consulta'}.json"
        DIR_TRAZAS.mkdir(exist_ok=True)
        (DIR_TRAZAS / nombre).write_text(json.dumps(traza, ensure_ascii=False, indent=2, default=str), encoding="utf-8")
        traza["archivo_traza"] = f"trazas/{nombre}"
        return traza
