@echo off
REM --- Image Bed One-Click Publish Script ---
REM Final fix: Use CALL to launch Git Bash and inherit the correct directory.

REM 1. Temporarily change CMD encoding to UTF-8 to fix garbled characters.
chcp 65001 > nul

REM 2. Find Git Bash installation path.
set "GIT_BASH_PATH=C:\Program Files\Git\bin\bash.exe"

if not exist "%GIT_BASH_PATH%" (
    set "GIT_BASH_PATH=C:\Program Files (x86)\Git\bin\bash.exe"
)

if not exist "%GIT_BASH_PATH%" (
    echo.
    echo ERROR: Git Bash not found.
    echo Please check your Git installation path.
    pause
    exit /b 1
)

REM 3. Switch to the batch file's directory (H:\github\r2-album\).
REM This sets the working directory for the subsequent CALL command.
cd /d "%~dp0"

echo.
echo Launching Git Bash window...
echo Current Directory: %cd%
echo ----------------------------------------------------
echo.

REM 4. CALL Git Bash, execute the script, and wait for user input.
REM CALL is used to execute the external program and ensure CMD waits for it to finish.
REM This launches Git Bash inside the current CMD window.
CALL "%GIT_BASH_PATH%" -c "./safe_publish.sh; echo; read -p 'Script finished, press Enter to exit...' _;"

REM 5. Restore CMD encoding
chcp 936 > nul
exit /b 0