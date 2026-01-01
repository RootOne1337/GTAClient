@echo off
REM Debug launcher - shows errors before closing
echo ========================================
echo   VirtBot Debug Launcher
echo ========================================
echo.

REM Run VirtBot and keep console open on error
VirtBot.exe

REM If exe crashed or closed, pause to see error
if errorlevel 1 (
    echo.
    echo ========================================
    echo   ERROR: VirtBot exited with code %errorlevel%
    echo ========================================
    echo.
    echo Check logs folder for more details
    pause
) else (
    echo.
    echo VirtBot closed normally
    timeout /t 3
)
