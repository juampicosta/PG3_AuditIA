# AuditIA · PG3 · Asistente integrado (Grupo 10) · v1.3

## Windows, la forma fácil (Docker Desktop abierto)

1. Doble clic en **`instalar.bat`** (solo la primera vez: levanta Neo4j, Ollama y la app, baja `qwen2.5:7b`, carga la base y corre las pruebas).
2. Las veces siguientes: **`iniciar.bat`**.
3. Abrir http://localhost:8010.

## Manual (PowerShell, en esta carpeta)

```powershell
copy .env.example .env
docker compose up -d --build
docker compose exec ollama ollama pull qwen2.5:7b
docker compose exec app python preparar_base.py        # una sola vez: carga PG2 + reglas de los tres submódulos
docker compose exec app python -m auditia --verificar
```

Miniapp: http://localhost:8010 · API: http://localhost:8010/docs · Neo4j Browser: http://localhost:7476 (bolt://localhost:7689, usuario neo4j, contraseña en .env)

## Usar Gemini en lugar de Ollama (opcional, gratis y sin tarjeta)

1. Sacar una clave en https://aistudio.google.com/apikey.
2. En `.env`: `LLM_PROVEEDOR=gemini` y `GEMINI_API_KEY=<tu clave>` (opcional: `GEMINI_MODEL`, por defecto `gemini-flash-latest`).
3. `docker compose up -d app` para que la app tome la configuración. No hace falta bajar `qwen2.5:7b`.

Solo cambia quién redacta y extrae: los diagnósticos, reglas y grados los sigue calculando Neo4j. Para volver a Ollama: `LLM_PROVEEDOR=ollama`.
El texto de las consultas y documentos se envía a Google (en el plan gratuito puede usarse para mejorar sus modelos): no cargar documentos confidenciales.
Las trazas y evidencias del informe se generaron con `qwen2.5:7b` local; con Gemini las respuestas no son idénticas.

Si ya tenés el modelo en otro volumen de Docker, poné su nombre en `OLLAMA_VOLUME` dentro de `.env`.

## Dos modos en la miniapp

- **Consultar a AuditIA**: preguntas en lenguaje natural; el prompt maestro elige SM1, SM2 y/o SM3.
- **Analizar requerimientos nuevos** (v1.3): se carga un documento (`.txt`, `.md`, `.docx`, `.pdf`; ejemplo en `ejemplos/`) o se escriben a mano; el LLM propone premisas a partir del texto (o el borrador léxico, sin LLM),
  el analista las confirma y Neo4j aplica las reglas (`base_conocimiento/scripts/08_inferencia_casos_nuevos.cypher`,
  `04_difusa.cypher` acotado al lote y `06_informes.cypher`). El caso queda consultable como cualquier otro.

## Pruebas

En los resultados, **Explorar el grafo** es el acceso a la explicación técnica.
El historial recupera los datos, reglas y evidencia de Neo4j; las nuevas auditorías
conservan además la lectura propuesta y los tiempos originales.

**Explorar el grafo** abre una pantalla completa con el mapa a la izquierda y la
explicación a la derecha. El buscador identifica los casos por código, título y
texto; si no hay un título guardado, el nombre se toma del texto original. Se
puede recorrer con Anterior/Siguiente, reproducir el recorrido guardado, acercar
y mover el mapa, o sumar sus fundamentos. El panel muestra premisas, reglas,
matriz y cálculos sin salir del explorador. En celular se apilan mapa y panel.
La navegación consulta el resultado guardado: no ejecuta reglas ni modifica la
auditoría. Respeta la preferencia de reducir movimiento y permite usar teclado.

```powershell
node --test pruebas/probar_recorrido_tecnico.cjs                    # rutas del grafo, Node 18+, sin servicios
node pruebas/probar_explorador_web.cjs                              # app + historial + Playwright instalado; solo lectura
docker compose exec app python pruebas/probar_detalle_tecnico.py    # trazabilidad e historial, sin LLM
docker compose exec app python pruebas/probar_ingesta.py            # análisis de requerimientos nuevos (sin LLM, ~1 min)
docker compose exec app python pruebas/ejecutar_pruebas.py --funcionales
docker compose exec app python pruebas/ejecutar_pruebas.py --e2e
```
