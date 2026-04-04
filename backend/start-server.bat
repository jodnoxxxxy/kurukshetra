@echo off
cd /d "%~dp0"
:loop
node mock-server.js
if errorlevel 1 (
    echo Server crashed, restarting in 3 seconds...
    timeout /t 3 /nobreak
    goto loop
)
