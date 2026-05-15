@echo off
setlocal EnableExtensions
cd /d "%~dp0"

if not exist logs mkdir logs
set "LOG_FILE=logs\manual_update_%COMPUTERNAME%.log"
echo ==== manual update %DATE% %TIME% ====>> "%LOG_FILE%"

echo Fetching latest client files...
git fetch origin >> "%LOG_FILE%" 2>&1
if errorlevel 1 (
    echo Git fetch failed, starting existing client.
    call restart.bat
    exit /b 1
)

echo Applying latest client files...
taskkill /F /IM VirtBot.exe >> "%LOG_FILE%" 2>&1
timeout /t 2 /nobreak > nul

git reset --hard origin/main >> "%LOG_FILE%" 2>&1
if errorlevel 1 (
    echo Git reset failed. Close VirtBot.exe and run update.bat again.
    echo Git reset failed>> "%LOG_FILE%"
    call restart.bat
    exit /b 1
)

call restart.bat
