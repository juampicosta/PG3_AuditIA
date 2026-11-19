"""Configuración única del asistente integrado (variables de entorno o archivo .env)."""
from __future__ import annotations

import os
from dataclasses import dataclass
from pathlib import Path

RAIZ = Path(__file__).resolve().parent.parent
DIR_TRAZAS = RAIZ / "trazas"


def _cargar_env() -> None:
    """Lee RAIZ/.env sin dependencias externas (no pisa variables ya definidas)."""
    ruta = RAIZ / ".env"
    if not ruta.exists():
        return
    for linea in ruta.read_text(encoding="utf-8").splitlines():
        linea = linea.strip()
        if not linea or linea.startswith("#") or "=" not in linea:
            continue
        clave, valor = linea.split("=", 1)
        os.environ.setdefault(clave.strip(), valor.strip().strip('"').strip("'"))


_cargar_env()


@dataclass
class ConfigGeneral:
    neo4j_uri: str = os.environ.get("NEO4J_URI", "bolt://localhost:7687")
    neo4j_usuario: str = os.environ.get("NEO4J_USER", "neo4j")
    neo4j_password: str | None = os.environ.get("NEO4J_PASSWORD")
    neo4j_database: str = os.environ.get("NEO4J_DATABASE", "neo4j")
    ollama_url: str = os.environ.get("OLLAMA_URL", "http://localhost:11434")
    modelo: str = os.environ.get("OLLAMA_MODEL", "qwen2.5:7b")
    hilos: int | None = int(os.environ["OLLAMA_NUM_THREAD"]) if os.environ.get("OLLAMA_NUM_THREAD") else None
    max_observaciones_encadenadas: int = int(os.environ.get("AUDITIA_MAX_ENLACES", "1"))
    sintesis_llm: bool = os.environ.get("AUDITIA_SINTESIS_LLM", "1") != "0"

    def para_submodulo(self, mod):
        """Construye la Config propia del script PI4 con los mismos valores (temperatura 0, semilla 42)."""
        return mod.Config(neo4j_uri=self.neo4j_uri, neo4j_usuario=self.neo4j_usuario,
                          neo4j_password=self.neo4j_password, neo4j_database=self.neo4j_database,
                          ollama_url=self.ollama_url, modelo=self.modelo, hilos=self.hilos)
