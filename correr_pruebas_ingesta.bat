@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo Actualizando la app (la primera vez instala pypdf, tarda un par de minutos)...
docker compose up -d --build
docker compose restart app
timeout /t 6 >nul
echo Pruebas del analisis de requerimientos nuevos (no usan el LLM, 1 a 2 minutos)...
docker compose exec app python pruebas/probar_ingesta.py > pruebas\resultados\ingesta.log 2>&1
type pruebas\resultados\ingesta.log
echo.
echo Resultado guardado en pruebas\resultados\ingesta.json
pause
