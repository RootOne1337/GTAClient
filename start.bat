@echo off
REM VirtBot Launcher
REM Simple launcher for VirtBot.exe

echo ========================================
echo   VirtBot Launcher
echo ========================================
echo.

REM Change to the directory where this bat file is located
cd /d "%~dp0"

REM Check if VirtBot.exe exists
if not exist "VirtBot.exe" (
    echo ERROR: VirtBot.exe not found!
    echo Looking in: %CD%
    pause
    exit /b 1
)

REM Launch VirtBot
echo Starting VirtBot.exe from: %CD%
start "" "%~dp0VirtBot.exe"

echo.
echo VirtBot started!
echo You can close this window.
timeout /t 3
