@echo off
REM VirtBot Autostart Setup
REM Sets up Windows Task Scheduler to auto-start VirtBot on user login

echo ========================================
echo   VirtBot Autostart Setup
echo ========================================
echo.

REM Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: This script requires Administrator privileges!
    echo Please right-click and select "Run as Administrator"
    pause
    exit /b 1
)

REM Get current directory
set "SCRIPT_DIR=%~dp0"
set "START_BAT=%SCRIPT_DIR%start.bat"

REM Check if start.bat exists
if not exist "%START_BAT%" (
    echo ERROR: start.bat not found in current directory!
    echo Please make sure you're running this from GTAClient folder.
    pause
    exit /b 1
)

echo Setting up Task Scheduler...
echo.
echo Task Name: Start_GTAClient
echo Action: Run %START_BAT%
echo Trigger: At user logon
echo.

REM Delete existing task if present
schtasks /Query /TN "Start_GTAClient" >nul 2>&1
if %errorLevel% equ 0 (
    echo Removing existing task...
    schtasks /Delete /TN "Start_GTAClient" /F >nul 2>&1
)

REM Create new task
schtasks /Create /TN "Start_GTAClient" /TR "\"%START_BAT%\"" /SC ONLOGON /RL HIGHEST /F

if %errorLevel% equ 0 (
    echo.
    echo ========================================
    echo   Success! Autostart configured!
    echo ========================================
    echo.
    echo VirtBot will now start automatically when you log in.
    echo.
    echo To disable autostart, run: schtasks /Delete /TN "Start_GTAClient" /F
    echo To test now, run: start.bat
) else (
    echo.
    echo ERROR: Failed to create scheduled task!
    echo Please check permissions and try again.
)

echo.
pause
