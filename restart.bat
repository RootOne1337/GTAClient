@echo off
setlocal EnableExtensions
cd /d "%~dp0"
set "EXE_NAME=VirtBot.exe"
set "NEXT_EXE=VirtBot.next.exe"
set "BACKUP_EXE=VirtBot.exe.bak"

if not exist logs mkdir logs
set "LOG_FILE=logs\restart_%COMPUTERNAME%.log"
echo ==== restart %DATE% %TIME% ====>> "%LOG_FILE%"

taskkill /F /IM "%EXE_NAME%" >> "%LOG_FILE%" 2>&1
timeout /t 2 /nobreak > nul

if exist "%NEXT_EXE%" call :promote_next

if exist "%EXE_NAME%" (
    start "" "%~dp0%EXE_NAME%"
) else (
    echo ERROR: %EXE_NAME% not found>> "%LOG_FILE%"
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
