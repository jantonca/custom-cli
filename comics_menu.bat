@echo off
setlocal enabledelayedexpansion

set "scriptDirectory=C:\Users\subsc\Documents\GitHub\custom-cli\commands"

:menu
cls
echo Comics Commands
echo.
echo [1] ^<^<^< Rename files
echo [2] ^<^<^< Convert to CBR or CBZ
echo [3] ^<^<^< Exit
echo.

set /p "choice=Enter your choice: "

if "%choice%"=="1" (
    call :executeScript "rename_files.ps1"
) else if "%choice%"=="2" (
    call :executeScript "convert_to_cbz.ps1"
) else if "%choice%"=="3" (
    exit
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 >nul
    goto menu
)

:executeScript
set "scriptPath=%scriptDirectory%\%~1"
if exist "%scriptPath%" (
    echo.
    echo Running script: %~1
    echo.
    powershell -ExecutionPolicy Bypass -File "%scriptPath%"
    pause
) else (
    echo.
    echo [ERROR] The '%~1' script file does not exist. Please make sure it is located in the 'commands' directory.
    echo.
    timeout /t 2 >nul
)
goto menu
