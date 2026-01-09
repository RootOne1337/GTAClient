@echo off
REM VirtBot Update Script
REM Updates VirtBot to latest version from GitHub

echo ========================================
echo   VirtBot Updater
echo ========================================
echo.

REM Change to the directory where this bat file is located
cd /d "%~dp0"

REM Check if git is installed
git --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Git is not installed!
    echo Please install Git from https://git-scm.com/
    pause
    exit /b 1
)

REM Force update: fetch and reset to match remote
REM This overwrites local exe files with remote versions
echo Fetching latest updates from GitHub...
echo Working directory: %CD%
git fetch origin

echo Resetting to latest version (force overwrite)...
git reset --hard origin/main

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

REM Start VirtBot from script directory
start "" "%~dp0VirtBot.exe"

echo.
echo VirtBot restarted with new version!
timeout /t 2
