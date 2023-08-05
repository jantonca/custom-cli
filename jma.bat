@echo off
setlocal enabledelayedexpansion

set "scriptDirectory=C:\Users\subsc\Documents\GitHub\custom-cli"

if "%~1"=="comics" (
    call :executeScript "comics_menu.bat"
) else if /i "%~1"=="help" (
    call :displayHelp
) else if "%~1"=="" (
    echo Welcome to jma: A CLI for custom Commands
    echo Use "jma help" for available commands and options.
    echo.
) else (
    echo Invalid option. Use "jma help" for available commands and options.
    echo.
)

exit /b

:executeScript
set "scriptPath=%scriptDirectory%\%~1"
if exist "%scriptPath%" (
    echo.
    echo Running script: %~1
    echo.
    call "%scriptPath%"
    pause
) else (
    echo.
    echo [ERROR] The '%~1' script file does not exist. Please make sure it is located in the 'custom-cli' directory.
    echo.
    timeout /t 2 >nul
)
exit /b

:displayHelp
echo jma: A CLI for Comics Commands
echo Usage:
echo    jma comics  - Execute the Comics Commands menu.
echo    jma help    - Show available commands and options (this help message).
echo.
exit /b
