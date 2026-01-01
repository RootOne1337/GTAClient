@echo off
REM Force console to stay open and run VirtBot
echo ========================================
echo   VirtBot Direct Launch (Console Open)
echo ========================================
echo.
echo Starting VirtBot.exe...
echo.

REM Keep console open and run exe
cmd /k "VirtBot.exe & echo. & echo. & echo VirtBot exited. Check output above. & pause"
