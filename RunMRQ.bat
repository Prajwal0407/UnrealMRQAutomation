@echo off

:: ============================================================
::  CONFIGURATION — edit these variables before first run
:: ============================================================

set UE=C:\Program Files\Epic Games\UE_5.5\Engine\Binaries\Win64\UnrealEditor.exe
set PROJECT=C:\Projects\MyProject\MyProject.uproject
set REPO_DIR=C:\Projects\MyProject
set MAP=/Game/Maps/MyMap
set QUEUE=/Game/Cinematics/MyRenderPreset.MyRenderPreset

:: ============================================================
::  GIT PULL
:: ============================================================
echo ================================================
echo  Pulling latest from git...
echo ================================================

if not exist "%REPO_DIR%\.git" (
    echo [ERROR] Not a git repository: %REPO_DIR%
    pause
    exit /b 1
)

cd /d "%REPO_DIR%"

git diff --quiet --exit-code 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ABORT] Uncommitted changes detected. Commit or stash them first.
    git status
    pause
    exit /b 1
)

git diff --cached --quiet --exit-code 2>nul
if %ERRORLEVEL% neq 0 (
    echo [ABORT] Staged changes detected. Commit or unstage them first.
    pause
    exit /b 1
)

git pull --ff-only
if %ERRORLEVEL% neq 0 (
    echo Git pull failed.
    pause
    exit /b 1
)

:: ============================================================
::  RENDER
:: ============================================================
echo ================================================
echo  Starting MRQ render...
echo ================================================
"%UE%" ^
    "%PROJECT%" ^
    "%MAP%" ^
    -game ^
    -MoviePipelineConfig="%QUEUE%" ^
    -windowed ^
    -StdOut ^
    -allowStdOutLogVerbosity ^
    -Unattended ^
    -log

set UE_EXIT=%ERRORLEVEL%
if %UE_EXIT% neq 0 (
    echo Render failed.
    pause
    exit /b %UE_EXIT%
)

echo Render complete.
