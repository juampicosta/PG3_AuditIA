@echo off
cd /d "%~dp0"
docker compose exec app python pruebas/ejecutar_pruebas.py --funcionales
echo.
echo Listo. Avisale a Claude.
pause
