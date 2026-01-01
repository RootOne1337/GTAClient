@echo off
REM Test by running Python directly (no compilation)
REM This requires Python to be installed on the client machine

echo ========================================
echo   VirtBot Source Test (No EXE)
echo ========================================
echo.
echo This will run VirtBot from Python source
echo Useful for debugging without recompiling
echo.

REM Check Python
python --version 2>nul
if errorlevel 1 (
    echo ERROR: Python not found!
    echo.
    echo This test requires Python 3.11+
    echo Download from: https://www.python.org/downloads/
    pause
    exit /b 1
)

echo Installing dependencies...
pip install -r requirements.txt -q 2>nul

echo.
echo Starting VirtBot from source...
echo ========================================
echo.

python main.py

echo.
echo ========================================
echo VirtBot stopped
echo.
pause
