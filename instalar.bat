@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================================
echo  AuditIA PG3 - instalacion (una sola vez por computadora)
echo  Requiere Docker Desktop abierto. Tarda entre 10 y 30 minutos
echo  la primera vez (descarga Neo4j, Ollama y el modelo qwen2.5:7b).
echo ============================================================
if not exist .env copy .env.example .env >nul
echo [1/4] Levantando Neo4j, Ollama y la app...
docker compose up -d --build || goto error
echo [2/4] Descargando el modelo qwen2.5:7b (si ya esta, no baja nada)...
docker compose exec ollama ollama pull qwen2.5:7b || goto error
echo [3/4] Cargando la base de conocimiento de PG2 y las reglas...
docker compose exec app python preparar_base.py || goto error
echo [4/4] Probando el analisis de requerimientos nuevos (1 a 2 minutos)...
docker compose exec app python pruebas/probar_ingesta.py
echo.
echo Listo. Abri http://localhost:8010 en el navegador.
start http://localhost:8010
pause
exit /b 0
:error
echo.
echo Algo fallo. Revisa que Docker Desktop este abierto y volve a ejecutar este archivo.
pause
exit /b 1
