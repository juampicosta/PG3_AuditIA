"""AuditIA · PG3 v1.3 · Lectura de documentos de requerimientos (.txt, .md, .docx, .pdf).

Extrae el texto en forma literal y detecta los párrafos que expresan requerimientos. Cada candidato conserva su
ubicación (página / párrafo) y, si lo tiene, su identificador en el documento (RF-01, 3.2.1, …), para que el analista
verifique la extracción antes de analizar (GL01: una extracción no fiel no se evalúa).
"""
from __future__ import annotations

import io
import re
import zipfile
from xml.etree import ElementTree as ET

MAX_BYTES = 8 * 1024 * 1024
MAX_REQUERIMIENTOS = 26

_W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"
_MODAL = re.compile(r"\b(debe(?:r[aá])?|deber[aá]n|deben|tiene que|tendr[aá] que|permitir[aá]|ha de|puede|pueden|"
                    r"se requiere|es obligatori[oa]|no podr[aá]|no debe(?:r[aá])?|podr[aá]n?|garantizar[aá])\b", re.IGNORECASE)
_ID_INICIAL = re.compile(r"^\s*(?:(?P<id>(?:[A-Z]{1,5}[-_ ]?\d{1,4}(?:\.\d+)*)|(?:\d+(?:\.\d+)+\.?))\s*[:.)\-–—]?\s+|[-•*·▪●◦]\s+)")


_TITULO = re.compile(r"^\d+(?:\.\d+)*\.?\s+[A-ZÁÉÍÓÚÑ][^.]{0,80}$")


class ErrorDocumento(Exception):
    pass


def _decodificar(datos: bytes) -> str:
    for cod in ("utf-8-sig", "utf-16", "cp1252", "latin-1"):
        try:
            texto = datos.decode(cod)
            if cod == "utf-16" and "\x00" in texto:
                continue
            return texto
        except UnicodeDecodeError:
            continue
    raise ErrorDocumento("No se pudo leer la codificación del archivo de texto.")


def _parrafos_texto(texto: str) -> list[dict]:
    """Párrafos de un .txt/.md: se separan por línea en blanco o por líneas que empiezan con viñeta o ID."""
    salida, actual, n = [], [], 0
    for linea in texto.replace("\r\n", "\n").split("\n"):
        limpia = linea.strip().lstrip("#").strip()
        if not limpia:
            if actual:
                n += 1
                salida.append({"texto": " ".join(actual), "ubicacion": f"párrafo {n}"})
                actual = []
            continue
        if actual and (_ID_INICIAL.match(limpia) or _TITULO.match(limpia)):
            n += 1
            salida.append({"texto": " ".join(actual), "ubicacion": f"párrafo {n}"})
            actual = []
        actual.append(limpia)
    if actual:
        n += 1
        salida.append({"texto": " ".join(actual), "ubicacion": f"párrafo {n}"})
    return salida


def _parrafos_docx(datos: bytes) -> list[dict]:
    try:
        with zipfile.ZipFile(io.BytesIO(datos)) as z:
            xml = z.read("word/document.xml")
    except (zipfile.BadZipFile, KeyError) as e:
        raise ErrorDocumento("El .docx no es válido o está dañado.") from e
    raiz = ET.fromstring(xml)
    salida, n = [], 0
    for p in raiz.iter(_W + "p"):
        partes = []
        for nodo in p.iter():
            if nodo.tag == _W + "t" and nodo.text:
                partes.append(nodo.text)
            elif nodo.tag == _W + "tab":
                partes.append(" ")
            elif nodo.tag in (_W + "br", _W + "cr"):
                partes.append(" ")
        texto = re.sub(r"\s+", " ", "".join(partes)).strip()
        if texto:
            n += 1
            salida.append({"texto": texto, "ubicacion": f"párrafo {n}"})
    return salida


def _parrafos_pdf(datos: bytes) -> list[dict]:
    try:
        from pypdf import PdfReader
    except ImportError as e:
        raise ErrorDocumento("Falta la librería pypdf: ejecutá 'docker compose up -d --build' una vez para instalarla.") from e
    try:
        lector = PdfReader(io.BytesIO(datos))
    except Exception as e:  # noqa: BLE001
        raise ErrorDocumento("El PDF no es válido o está protegido.") from e
    salida = []
    for i, pagina in enumerate(lector.pages, start=1):
        texto = pagina.extract_text() or ""
        for j, par in enumerate(_parrafos_texto(texto), start=1):
            salida.append({"texto": par["texto"], "ubicacion": f"página {i}, párrafo {j}"})
    if not salida:
        raise ErrorDocumento("El PDF no tiene texto seleccionable (¿es una imagen escaneada?).")
    return salida


def extraer_parrafos(nombre: str, datos: bytes) -> list[dict]:
    if len(datos) > MAX_BYTES:
        raise ErrorDocumento("El archivo supera los 8 MB.")
    ext = nombre.lower().rsplit(".", 1)[-1] if "." in nombre else ""
    if ext in ("txt", "md", "csv"):
        return _parrafos_texto(_decodificar(datos))
    if ext == "docx":
        return _parrafos_docx(datos)
    if ext == "pdf":
        return _parrafos_pdf(datos)
    raise ErrorDocumento("Formato no admitido. Usá .txt, .md, .docx o .pdf (un .doc viejo se puede guardar como .docx).")


def _oraciones(texto: str) -> list[str]:
    return [o.strip() for o in re.split(r"(?<=[.;])\s+(?=[A-ZÁÉÍÓÚÑ¿])", texto) if o.strip()]


def detectar_requerimientos(parrafos: list[dict]) -> list[dict]:
    """Candidatos: oraciones con verbo modal de obligación. Se conserva el texto literal (sin el ID inicial)."""
    candidatos = []
    for par in parrafos:
        texto = par["texto"]
        m = _ID_INICIAL.match(texto)
        id_doc = (m.group("id") or "").strip() if m else ""
        cuerpo = texto[m.end():].strip() if m else texto
        oraciones = _oraciones(cuerpo)
        con_modal = [o for o in oraciones if _MODAL.search(o)]
        if not con_modal:
            continue
        # Un párrafo con un ID propio se toma completo (es un requerimiento con su redacción); sin ID, oración por oración.
        piezas = [cuerpo] if id_doc and len(cuerpo) <= 600 else con_modal
        for k, pieza in enumerate(piezas, start=1):
            if not 12 <= len(pieza) <= 1000:
                continue
            ubic = par["ubicacion"] + (f", oración {k}" if len(piezas) > 1 else "")
            candidatos.append({"texto": pieza, "ubicacion": ubic, "id_documento": id_doc if len(piezas) == 1 else
                               (f"{id_doc}.{k}" if id_doc else "")})
    return candidatos[:MAX_REQUERIMIENTOS]


def leer_documento(nombre: str, datos: bytes) -> dict:
    parrafos = extraer_parrafos(nombre, datos)
    reqs = detectar_requerimientos(parrafos)
    return {"nombre": nombre, "parrafos": len(parrafos), "requerimientos": reqs,
            "truncado": len(reqs) >= MAX_REQUERIMIENTOS,
            "aviso": None if reqs else "No se detectaron oraciones con 'debe', 'deberá', 'permitirá'… Podés copiar el texto a mano."}
