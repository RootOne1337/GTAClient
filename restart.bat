@echo off
REM VirtBot Restart Script
REM Kills and restarts VirtBot.exe

echo ========================================
echo   VirtBot Restart
echo ========================================
echo.

echo Stopping VirtBot...
taskkill /F /IM VirtBot.exe >nul 2>&1

timeout /t 2

echo Starting VirtBot...
start "" VirtBot.exe

echo.
echo VirtBot restarted!
timeout /t 2
