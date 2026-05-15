@echo off
setlocal EnableExtensions
cd /d "%~dp0"
set "EXE_NAME=VirtBot.exe"
set "NEXT_EXE=VirtBot.next.exe"
set "BACKUP_EXE=VirtBot.exe.bak"

if not exist logs mkdir logs
set "LOG_FILE=logs\start_%COMPUTERNAME%.log"
echo ==== start %DATE% %TIME% ====>> "%LOG_FILE%"

if exist "watchdog.bat" (
    call "watchdog.bat"
    exit /b %ERRORLEVEL%
)

if exist "%NEXT_EXE%" call :promote_next

if exist "%EXE_NAME%" (
    start "" "%~dp0%EXE_NAME%"
) else (
    echo ERROR: %EXE_NAME% not found>> "%LOG_FILE%"
    echo VirtBot.exe not found
    timeout /t 10 /nobreak > nul
)
exit /b 0

:promote_next
del /f /q "%BACKUP_EXE%" > nul 2>&1
if exist "%EXE_NAME%" ren "%EXE_NAME%" "%BACKUP_EXE%" >> "%LOG_FILE%" 2>&1
if not exist "%EXE_NAME%" (
    move /y "%NEXT_EXE%" "%EXE_NAME%" >> "%LOG_FILE%" 2>&1
    if exist "%EXE_NAME%" del /f /q "%BACKUP_EXE%" > nul 2>&1
)
if exist "%BACKUP_EXE%" if not exist "%EXE_NAME%" ren "%BACKUP_EXE%" "%EXE_NAME%" > nul 2>&1
exit /b 0
