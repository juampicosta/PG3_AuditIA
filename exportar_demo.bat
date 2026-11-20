@echo off
cd /d "%~dp0"
docker compose exec -T app python exportar_demo.py %1
pause
