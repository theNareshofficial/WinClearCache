@echo off

:: Check if the script is running with administrative privileges
net session >nul 2>&1
if %errorLevel% == 0 (
            echo .
            echo [+] Admin Access is Avaliable
) else (
            echo 
            echo [+] Admin Access is not Avaliable
)