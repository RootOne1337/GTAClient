@echo off
REM VirtBot Launcher
REM Simple launcher for VirtBot.exe

echo ========================================
echo   VirtBot Launcher
echo ========================================
echo.

REM Check if VirtBot.exe exists
if not exist "VirtBot.exe" (
    echo ERROR: VirtBot.exe not found!
    echo Please make sure you're in the correct directory.
    pause
    exit /b 1
)

REM Launch VirtBot
echo Starting VirtBot.exe...
start "" VirtBot.exe

echo.
echo VirtBot started!
echo You can close this window.
timeout /t 3
