@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "TARGET_DIR=%~1"
if not defined TARGET_DIR set "TARGET_DIR=%~dp0"
cd /d "%TARGET_DIR%" || exit /b 1
set "APP_DIR=%CD%"

set "EXE_NAME=VirtBot.exe"
set "NEXT_EXE=VirtBot.next.exe"
set "BACKUP_EXE=VirtBot.exe.bak"

if not exist logs mkdir logs
set "LOG_FILE=logs\watchdog_%COMPUTERNAME%.log"
echo ==== watchdog %DATE% %TIME% ====>> "%LOG_FILE%"

git fetch origin main >> "%LOG_FILE%" 2>&1
if not errorlevel 1 (
    for %%F in (VirtBot.next.exe restart.bat start.bat update.bat install_watchdog.bat) do (
        git checkout origin/main -- "%%F" >> "%LOG_FILE%" 2>&1
    )
) else (
    echo WARN: git fetch failed, using local files>> "%LOG_FILE%"
)

call :ensure_latest_running
exit /b 0

:ensure_latest_running
set "PROMOTE=0"
if exist "%NEXT_EXE%" (
    if not exist "%EXE_NAME%" (
        set "PROMOTE=1"
    ) else (
        set "CURRENT_HASH="
        set "NEXT_HASH="
        for /f "delims=" %%H in ('git hash-object "%EXE_NAME%" 2^>nul') do set "CURRENT_HASH=%%H"
        for /f "delims=" %%H in ('git hash-object "%NEXT_EXE%" 2^>nul') do set "NEXT_HASH=%%H"
        if defined NEXT_HASH if not "!CURRENT_HASH!"=="!NEXT_HASH!" set "PROMOTE=1"
    )
)

if "%PROMOTE%"=="1" (
    taskkill /F /IM "%EXE_NAME%" >> "%LOG_FILE%" 2>&1
    timeout /t 2 /nobreak > nul
    call :promote_next
)

tasklist /FI "IMAGENAME eq %EXE_NAME%" 2>nul | find /I "%EXE_NAME%" >nul
if errorlevel 1 (
    if exist "%EXE_NAME%" (
        start "" "%APP_DIR%\%EXE_NAME%"
        echo Started %EXE_NAME%>> "%LOG_FILE%"
    ) else (
        echo ERROR: %EXE_NAME% not found>> "%LOG_FILE%"
    )
) else (
    echo %EXE_NAME% already running>> "%LOG_FILE%"
)
exit /b 0

:promote_next
for /l %%I in (1,1,30) do (
    del /f /q "%BACKUP_EXE%" > nul 2>&1
    if exist "%EXE_NAME%" ren "%EXE_NAME%" "%BACKUP_EXE%" >> "%LOG_FILE%" 2>&1
    if not exist "%EXE_NAME%" (
        move /y "%NEXT_EXE%" "%EXE_NAME%" >> "%LOG_FILE%" 2>&1
        if exist "%EXE_NAME%" (
            del /f /q "%BACKUP_EXE%" > nul 2>&1
            echo Promoted %NEXT_EXE% to %EXE_NAME%>> "%LOG_FILE%"
            exit /b 0
        )
    )
    if exist "%BACKUP_EXE%" if not exist "%EXE_NAME%" ren "%BACKUP_EXE%" "%EXE_NAME%" > nul 2>&1
    timeout /t 2 /nobreak > nul
)

echo ERROR: failed to promote %NEXT_EXE%>> "%LOG_FILE%"
exit /b 1