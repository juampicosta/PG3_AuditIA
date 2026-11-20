@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================================
echo  AuditIA v1.3 - pruebas para el informe de reentrega
echo ============================================================
if not exist .env (
  if exist "..\..\PG3_AuditIA\.env" ( copy "..\..\PG3_AuditIA\.env" .env >nul ) else ( copy .env.example .env >nul )
)
echo [1/4] Levantando la version del repo (reconstruye la app)...
docker compose up -d --build
docker compose restart app
timeout /t 10 >nul
echo [2/4] Pruebas de analisis de documentos (sin LLM)...
docker compose exec -T app python pruebas/probar_ingesta.py > pruebas\resultados\ingesta.log 2>&1
type pruebas\resultados\ingesta.log | findstr /V "Received notification"
echo [3/4] Pruebas de trazabilidad tecnica (sin LLM)...
docker compose exec -T app python pruebas/probar_detalle_tecnico.py > pruebas\resultados\detalle_tecnico.log 2>&1
type pruebas\resultados\detalle_tecnico.log | findstr /V "Received notification"
echo [4/4] Pruebas funcionales del asistente (sin LLM, ~1 min)...
docker compose exec -T app python pruebas/ejecutar_pruebas.py --funcionales > pruebas\resultados\funcionales_v1.3.log 2>&1
copy /Y pruebas\resultados\funcionales.json pruebas\resultados\funcionales_v1.3.json >nul
type pruebas\resultados\funcionales_v1.3.log | findstr /V "Received notification" | more +0
echo.
echo Listo. Deja la app abierta (http://localhost:8010) y avisale a Claude.
pause
