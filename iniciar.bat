@echo off
cd /d "%~dp0"
echo Iniciando AuditIA (Neo4j, Ollama y la app)...
docker compose up -d
docker compose restart app
timeout /t 8 >nul
start http://localhost:8010
