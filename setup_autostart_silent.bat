@echo off
REM VirtBot Autostart Setup (Silent Mode for Tactical RMM)
REM Sets up Windows Task Scheduler to auto-start VirtBot on user login
REM This version runs silently without user interaction

REM Change to script directory
cd /d "%~dp0"

REM Get paths
set "SCRIPT_DIR=%~dp0"
set "START_BAT=%SCRIPT_DIR%start.bat"

REM Check if start.bat exists
if not exist "%START_BAT%" (
    echo ERROR: start.bat not found in %SCRIPT_DIR%
    exit /b 1
)

REM Delete existing task if present (suppress errors)
schtasks /Query /TN "Start_GTAClient" >nul 2>&1
if %errorLevel% equ 0 (
    schtasks /Delete /TN "Start_GTAClient" /F >nul 2>&1
)

REM Create new task
REM Note: /RL HIGHEST requires admin rights, but works from RMM running as SYSTEM
schtasks /Create /TN "Start_GTAClient" /TR "\"%START_BAT%\"" /SC ONLOGON /RL HIGHEST /F >nul 2>&1

if %errorLevel% equ 0 (
    echo SUCCESS: Autostart configured for Start_GTAClient
    exit /b 0
) else (
    echo ERROR: Failed to create scheduled task (error code: %errorLevel%)
    REM Try without HIGHEST privilege as fallback
    schtasks /Create /TN "Start_GTAClient" /TR "\"%START_BAT%\"" /SC ONLOGON /F >nul 2>&1
    if %errorLevel% equ 0 (
        echo SUCCESS: Autostart configured for Start_GTAClient (limited privileges)
        exit /b 0
    ) else (
        echo ERROR: Failed to create scheduled task with fallback
        exit /b 1
    )
)
