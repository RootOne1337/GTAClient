@echo off
setlocal EnableExtensions
cd /d "%~dp0"

if not exist logs mkdir logs
set "LOG_FILE=logs\install_watchdog_%COMPUTERNAME%.log"
set "TASK_NAME=VirtBotWatchdog"
set "SOURCE_WATCHDOG=%~dp0watchdog.bat"
set "TARGET_DIR=%~dp0"
if defined LOCALAPPDATA (
    set "INSTALL_DIR=%LOCALAPPDATA%\VirtBotWatchdog"
) else (
    set "INSTALL_DIR=%TEMP%\VirtBotWatchdog"
)
set "INSTALLED_WATCHDOG=%INSTALL_DIR%\watchdog.bat"

echo ==== install watchdog %DATE% %TIME% ====>> "%LOG_FILE%"

if not exist "%SOURCE_WATCHDOG%" (
    echo ERROR: watchdog.bat not found>> "%LOG_FILE%"
    exit /b 1
)

if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%" >> "%LOG_FILE%" 2>&1
if not exist "%INSTALLED_WATCHDOG%" (
    copy /y "%SOURCE_WATCHDOG%" "%INSTALLED_WATCHDOG%" >> "%LOG_FILE%" 2>&1
) else (
    echo Keeping existing installed watchdog copy: %INSTALLED_WATCHDOG%>> "%LOG_FILE%"
)

for %%I in ("%INSTALLED_WATCHDOG%") do set "TASK_WATCHDOG=%%~sI"
for %%I in ("%TARGET_DIR%") do set "TASK_TARGET_DIR=%%~sI"

schtasks /Create /TN "%TASK_NAME%" /TR "%TASK_WATCHDOG% %TASK_TARGET_DIR%" /SC MINUTE /MO 5 /RL HIGHEST /F >> "%LOG_FILE%" 2>&1
if errorlevel 1 (
    echo WARN: elevated task install failed, trying current-user task>> "%LOG_FILE%"
    schtasks /Create /TN "%TASK_NAME%" /TR "%TASK_WATCHDOG% %TASK_TARGET_DIR%" /SC MINUTE /MO 5 /F >> "%LOG_FILE%" 2>&1
)

if errorlevel 1 (
    echo ERROR: failed to install watchdog task>> "%LOG_FILE%"
    exit /b 1
)

echo Watchdog task installed>> "%LOG_FILE%"
exit /b 0