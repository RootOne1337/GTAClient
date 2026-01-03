@echo off
REM VirtBot Restart Script
REM Kills and restarts VirtBot.exe

echo ========================================
echo   VirtBot Restart
echo ========================================
echo.

REM Change to the directory where this bat file is located
cd /d "%~dp0"

echo Stopping VirtBot...
taskkill /F /IM VirtBot.exe >nul 2>&1

timeout /t 2

echo Starting VirtBot from: %CD%
start "" "%~dp0VirtBot.exe"

echo.
echo VirtBot restarted!
timeout /t 2
