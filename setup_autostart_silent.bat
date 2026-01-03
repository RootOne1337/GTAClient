@echo off
REM VirtBot Autostart Setup (Silent Mode for Tactical RMM)
REM Sets up Windows Task Scheduler to auto-start VirtBot on user login
REM This version runs silently without user interaction

REM Change to script directory
cd /d "%~dp0"

REM Get paths
set "START_BAT=%~dp0start.bat"

REM Check if start.bat exists
if not exist "%START_BAT%" (
    echo ERROR: start.bat not found in %~dp0
    exit /b 1
)

REM Delete existing task if present (suppress errors)
schtasks /Query /TN "Start_GTAClient" >nul 2>&1
if %errorLevel% equ 0 (
    schtasks /Delete /TN "Start_GTAClient" /F >nul 2>&1
)

REM Create new task for current user
REM /RU %USERNAME% specifies task runs as current user
schtasks /Create /TN "Start_GTAClient" /TR "%START_BAT%" /SC ONLOGON /RU "%USERNAME%" /RL HIGHEST /F

if %errorLevel% equ 0 (
    echo SUCCESS: Autostart configured for Start_GTAClient (user: %USERNAME%)
    exit /b 0
) else (
    echo ERROR: Failed to create task with HIGHEST privilege (error: %errorLevel%)
    REM Try without HIGHEST as fallback
    schtasks /Create /TN "Start_GTAClient" /TR "%START_BAT%" /SC ONLOGON /RU "%USERNAME%" /F
    if %errorLevel% equ 0 (
        echo SUCCESS: Autostart configured for Start_GTAClient (user: %USERNAME%, limited privileges)
        exit /b 0
    ) else (
        echo ERROR: Failed to create task (error: %errorLevel%)
        exit /b 1
    )
)
