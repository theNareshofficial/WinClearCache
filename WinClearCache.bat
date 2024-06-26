@echo off

:: Clear screen
cls

:: Set console text color to green
color a

:: Check if the script is running with administrative privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    :: Display message if not running with administrative privileges
    echo +---------------------------+
    echo *    WinClearCache Tool     +
    echo +---------------------------+
    echo.
    echo                Author  : Naresh
    echo                Github  : https://github.com/theNareshofficial
    echo                Website : http://thenareshofficial.free.nf/
    echo.
    echo Hello %USERNAME%
    echo.
    echo +-------------------------------------------------------------+
    echo + [!] Note!!!                                                 +    
    echo +  This script is not running with administrative privileges. + 
    echo +  Please run this script as an administrator.                +
    echo +                                              - By Naresh    +
    echo +-------------------------------------------------------------+
    echo.
    pause
    exit /b
) else (
    :: Display message if running with administrative privileges
    echo +---------------------------+
    echo *    WinClearCache Tool     +
    echo +---------------------------+
    echo.
    echo                Author  : Naresh
    echo                Github  : https://github.com/theNareshofficial
    echo                Website : http://thenareshofficial.free.nf/
    echo.
    echo Hello %USERNAME%
    echo.
    echo [+] Deleting cache and temporary files...
    echo.

    :: Delete Windows temporary files and directories
    echo [!] Checking if "%TEMP%" exists...
    if exist "%TEMP%" (
        echo [+] Deleting "%TEMP%"...
        del /q /f /s "%TEMP%\*" >nul 2>&1
        rd /s /q "%TEMP%" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%TEMP%"
    )

    echo [!] Checking if "%SystemRoot%\Temp" exists...
    if exist "%SystemRoot%\Temp" (
        echo [+] Deleting "%SystemRoot%\Temp"...
        del /q /f /s "%SystemRoot%\Temp\*" >nul 2>&1
        rd /s /q "%SystemRoot%\Temp" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%SystemRoot%\Temp"
    )

    echo [!] Checking if "%USERPROFILE%\AppData\Local\Temp" exists...
    if exist "%USERPROFILE%\AppData\Local\Temp" (
        echo [+] Deleting "%USERPROFILE%\AppData\Local\Temp"...
        del /q /f /s "%USERPROFILE%\AppData\Local\Temp\*" >nul 2>&1
        rd /s /q "%USERPROFILE%\AppData\Local\Temp" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%USERPROFILE%\AppData\Local\Temp"
    )

    :: Cleaning Windows Update cache
    echo [!] Checking if "%SystemRoot%\SoftwareDistribution\Download" exists...
    if exist "%SystemRoot%\SoftwareDistribution\Download" (
        echo [+] Deleting "%SystemRoot%\SoftwareDistribution\Download"...
        del /q /f /s "%SystemRoot%\SoftwareDistribution\Download\*" >nul 2>&1
        rd /s /q "%SystemRoot%\SoftwareDistribution\Download" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%SystemRoot%\SoftwareDistribution\Download"
    )

    :: Cleaning Windows Prefetch files
    echo [!] Checking if "%SystemRoot%\Prefetch" exists...
    if exist "%SystemRoot%\Prefetch" (
        echo [+] Deleting "%SystemRoot%\Prefetch"...
        del /q /f /s "%SystemRoot%\Prefetch\*" >nul 2>&1
        rd /s /q "%SystemRoot%\Prefetch" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%SystemRoot%\Prefetch"
    )

    :: Clean Recycle Bin using PowerShell
    echo [+] Cleaning Recycle Bin...
    powershell -command "Clear-RecycleBin -Force"

    :: Cleaning Internet Explorer temporary files
    echo [+] Cleaning Internet Explorer temporary files...
    RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255

    :: Cleaning Chrome temporary files
    set "chrome_cache=%LOCALAPPDATA%\Google\Chrome\User Data\Default"
    echo [+] Cleaning Chrome cache in "%chrome_cache%"
    if exist "%chrome_cache%\Cache" (
        echo [+] Deleting Chrome Cache...
        del /q /f /s "%chrome_cache%\Cache\*" >nul 2>&1
        rd /s /q "%chrome_cache%\Cache" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%chrome_cache%\Cache"
    )
    if exist "%chrome_cache%\Code Cache" (
        echo [+] Deleting Chrome Code Cache...
        del /q /f /s "%chrome_cache%\Code Cache\*" >nul 2>&1
        rd /s /q "%chrome_cache%\Code Cache" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%chrome_cache%\Code Cache"
    )
    if exist "%chrome_cache%\GPUCache" (
        echo [+] Deleting Chrome GPU Cache...
        del /q /f /s "%chrome_cache%\GPUCache\*" >nul 2>&1
        rd /s /q "%chrome_cache%\GPUCache" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%chrome_cache%\GPUCache"
    )

    :: Cleaning Firefox temporary files
    set "firefox_cache=%APPDATA%\Mozilla\Firefox\Profiles\*"
    echo [+] Cleaning Firefox cache in "%firefox_cache%"
    if exist "%firefox_cache%\cache2" (
        echo [+] Deleting Firefox cache2...
        del /q /f /s "%firefox_cache%\cache2\*" >nul 2>&1
        rd /s /q "%firefox_cache%\cache2" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%firefox_cache%\cache2"
    )
    if exist "%firefox_cache%\startupCache" (
        echo [+] Deleting Firefox startupCache...
        del /q /f /s "%firefox_cache%\startupCache\*" >nul 2>&1
        rd /s /q "%firefox_cache%\startupCache" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%firefox_cache%\startupCache"
    )

    :: Cleaning Edge temporary files
    set "edge_cache=%LOCALAPPDATA%\Microsoft\Edge\User Data\Default"
    echo [+] Cleaning Edge cache in "%edge_cache%"
    if exist "%edge_cache%\Cache" (
        echo [+] Deleting Edge Cache...
        del /q /f /s "%edge_cache%\Cache\*" >nul 2>&1
        rd /s /q "%edge_cache%\Cache" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%edge_cache%\Cache"
    )
    if exist "%edge_cache%\Code Cache" (
        echo [+] Deleting Edge Code Cache...
        del /q /f /s "%edge_cache%\Code Cache\*" >nul 2>&1
        rd /s /q "%edge_cache%\Code Cache" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%edge_cache%\Code Cache"
    )
    if exist "%edge_cache%\GPUCache" (
        echo [+] Deleting Edge GPU Cache...
        del /q /f /s "%edge_cache%\GPUCache\*" >nul 2>&1
        rd /s /q "%edge_cache%\GPUCache" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%edge_cache%\GPUCache"
    )

    :: Cleaning Opera temporary files
    set "opera_cache=%APPDATA%\Opera Software\Opera Stable"
    echo [+] Cleaning Opera cache in "%opera_cache%"
    if exist "%opera_cache%\Cache" (
        echo [+] Deleting Opera Cache...
        del /q /f /s "%opera_cache%\Cache\*" >nul 2>&1
        rd /s /q "%opera_cache%\Cache" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%opera_cache%\Cache"
    )
    if exist "%opera_cache%\GPUCache" (
        echo [+] Deleting Opera GPU Cache...
        del /q /f /s "%opera_cache%\GPUCache\*" >nul 2>&1
        rd /s /q "%opera_cache%\GPUCache" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%opera_cache%\GPUCache"
    )

    :: Cleaning Safari temporary files
    set "safari_cache=%APPDATA%\Apple Computer\Safari"
    echo [+] Cleaning Safari cache in "%safari_cache%"
    if exist "%safari_cache%\Cache" (
        echo [+] Deleting Safari Cache...
        del /q /f /s "%safari_cache%\Cache\*" >nul 2>&1
        rd /s /q "%safari_cache%\Cache" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%safari_cache%\Cache"
    )

    :: Cleaning Windows Event Logs
    echo [+] Cleaning Windows Event Logs...
    for /f "tokens=*" %%G in ('wevtutil el') do (
        echo [+] Clearing Event Log %%G...
        wevtutil cl "%%G"
    )

    :: Cleaning Windows Thumbnail Cache
    echo [!] Checking if "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" exists...
    if exist "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" (
        echo [+] Deleting Windows Thumbnail Cache...
        del /q /f /s "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
    ) else (
        echo [!] Directory not found: "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db"
    )

    :: Delete all system restore points
    echo [+] Deleting all System Restore Points...
    vssadmin delete shadows /for=%SystemDrive% /all /quiet

    echo.
    echo +---------------------------+
    echo *    CleanUp Completed      +
    echo +---------------------------+
    echo.

    pause
)
