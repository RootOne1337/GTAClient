@echo off
REM VirtBot Update Script
REM Updates VirtBot to latest version from GitHub

echo ========================================
echo   VirtBot Updater
echo ========================================
echo.

REM Check if git is installed
git --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git is not installed!
    echo Please install Git from https://git-scm.com/
    pause
    exit /b 1
)

REM Pull latest changes
echo Pulling latest updates from GitHub...
git pull

if errorlevel 1 (
    echo.
    echo WARNING: Update failed!
    echo Please check your internet connection or git status.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   Update Complete!
echo ========================================
echo.
echo Restarting VirtBot in 3 seconds...
timeout /t 3

REM Kill existing VirtBot process
taskkill /F /IM VirtBot.exe >nul 2>&1

REM Start VirtBot
start "" VirtBot.exe

echo.
echo VirtBot restarted with new version!
timeout /t 2
