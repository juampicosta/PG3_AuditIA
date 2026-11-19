@echo off
cd /d "%~dp0"
echo Reiniciando la app de AuditIA...
docker compose restart app
echo Pruebas funcionales...
docker compose exec app python pruebas/ejecutar_pruebas.py --funcionales
echo Lanzando E2E-04 y CTL-04 en segundo plano (unos 25 minutos)...
docker compose exec -d app sh -c "python pruebas/ejecutar_pruebas.py --e2e E2E-04 CTL-04 >> pruebas/resultados/e2e.log 2>&1"
echo.
echo Listo. Podes cerrar esta ventana: las pruebas siguen solas. Avisale a Claude.
pause
