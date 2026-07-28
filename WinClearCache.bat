@echo off
setlocal enabledelayedexpansion

:: ====================================================================
:: WinClearCache Tool v2.0 - Advanced Edition
:: Author: Naresh R (@theNareshofficial)
:: GitHub: https://github.com/theNareshofficial
:: ====================================================================

mode con: cols=90 lines=42
color 0a
cls

:: Configuration variables
set "SCRIPT_VERSION=2.0 Advanced"
set "LOG_DIR=%LOCALAPPDATA%\WinClearCache\Logs"
set "DRY_RUN=0"
set "SAVE_LOG=1"
set "ITEMS_DELETED=0"

:: Create log directory safely
if not exist "!LOG_DIR!" mkdir "!LOG_DIR!" >nul 2>&1

:: Universal ISO Timestamp Generator (WMIC with PowerShell Fallback)
set "dt="
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value 2^>nul') do set "dt=%%I"
if not defined dt (
    for /f "delims=" %%P in ('powershell -NoProfile -Command "Get-Date -Format 'yyyyMMdd_HHmmss'" 2^>nul') do set "ts=%%P"
    set "LOG_FILE=!LOG_DIR!\WinClearCache_!ts!.log"
) else (
    set "LOG_FILE=!LOG_DIR!\WinClearCache_!dt:~0,8!_!dt:~8,6!.log"
)

:: ====================================================================
:: PRIVILEGE CHECK
:: ====================================================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    cls
    color 0c
    echo +==================================================================+
    echo ^| WinClearCache Tool v!SCRIPT_VERSION! - ADMINISTRATOR REQUIRED    ^|
    echo +==================================================================+
    echo.
    echo [ERROR] This script requires administrative privileges!
    echo.
    echo How to fix:
    echo    1. Right-click this script
    echo    2. Select "Run as administrator"
    echo    3. Click "Yes" when prompted
    echo.
    echo Script Details:
    echo    Author  : Naresh R
    echo    GitHub  : https://github.com/theNareshofficial
    echo    Website : http://thenareshofficial.free.nf/
    echo.
    pause
    exit /b 1
)

:: ====================================================================
:: MAIN MENU
:: ====================================================================
:main_menu
cls
color 0a
echo +==================================================================+
echo ^|  WinClearCache Tool v!SCRIPT_VERSION!                            ^|
echo +==================================================================+
echo.
echo Hello %USERNAME%! Welcome to WinClearCache
echo System: %COMPUTERNAME%
echo.
echo +==================================================================+
echo ^| MAIN MENU                                                        ^|
echo +==================================================================+
echo.
echo [1] Run Full Cleanup (Safe System ^& Browsers)
echo [2] Quick Cleanup (Fast - System Temp ^& Recycle Bin)
echo [3] Browser Cache Only
echo [4] System Analysis ^& Health Check
echo [5] Settings (Dry-run, Logging, Options)
echo [6] View Cleanup Log
echo [7] About / Help
echo [8] Exit
echo.
set "choice="
set /p choice="Enter your choice (1-8): "

if "!choice!"=="1" goto full_cleanup_confirm
if "!choice!"=="2" goto quick_cleanup_confirm
if "!choice!"=="3" goto browser_only_confirm
if "!choice!"=="4" goto system_analysis
if "!choice!"=="5" goto settings_menu
if "!choice!"=="6" goto view_log
if "!choice!"=="7" goto about
if "!choice!"=="8" goto exit_script
goto main_menu

:: ====================================================================
:: FULL CLEANUP CONFIRMATION
:: ====================================================================
:full_cleanup_confirm
cls
color 0a
echo +==================================================================+
echo ^| FULL CLEANUP - Comprehensive System Cleanup                      ^|
echo +==================================================================+
echo.
if !DRY_RUN! equ 1 (
    color 0e
    echo [INFO] DRY-RUN MODE ENABLED - No files will actually be deleted
    color 0a
    echo.
)

echo Preparing to clean:
echo    [+] Temporary files (System ^& User)
echo    [+] Windows Update download cache
echo    [+] Prefetch files
echo    [+] Recycle Bin
echo    [+] Browser caches (Chrome, Firefox, Edge, Opera)
echo    [+] Primary Windows Event Logs
echo    [+] Thumbnail cache
echo.
set "confirm="
set /p confirm="Are you sure you want to proceed? (Y/N): "
if /i "!confirm!"=="Y" (
    call :perform_full_cleanup
    goto cleanup_complete
) else (
    echo.
    echo Cleanup cancelled.
    pause
    goto main_menu
)

:: ====================================================================
:: QUICK CLEANUP CONFIRMATION
:: ====================================================================
:quick_cleanup_confirm
cls
color 0a
echo +==================================================================+
echo ^| QUICK CLEANUP - Fast System Optimization                        ^|
echo +==================================================================+
echo.
if !DRY_RUN! equ 1 (
    color 0e
    echo [INFO] DRY-RUN MODE ENABLED
    color 0a
    echo.
)
echo Quick cleanup will remove:
echo    [+] Temporary files (System ^& User)
echo    [+] Recycle Bin
echo    [+] Thumbnail cache
echo.
set "confirm="
set /p confirm="Proceed with quick cleanup? (Y/N): "
if /i "!confirm!"=="Y" (
    call :perform_quick_cleanup
    goto cleanup_complete
) else (
    echo.
    echo Cleanup cancelled.
    pause
    goto main_menu
)

:: ====================================================================
:: BROWSER ONLY CLEANUP
:: ====================================================================
:browser_only_confirm
cls
color 0a
echo +==================================================================+
echo ^| BROWSER CACHE CLEANUP                                           ^|
echo +==================================================================+
echo.
if !DRY_RUN! equ 1 (
    color 0e
    echo [INFO] DRY-RUN MODE ENABLED
    color 0a
    echo.
)
echo This will clean cache from:
echo    [+] Google Chrome, Mozilla Firefox, Microsoft Edge, Opera
echo.
echo [NOTE] Please close all web browsers before continuing!
echo.
set "confirm="
set /p confirm="Proceed with browser cleanup? (Y/N): "
if /i "!confirm!"=="Y" (
    call :perform_browser_cleanup
    goto cleanup_complete
) else (
    echo.
    echo Cleanup cancelled.
    pause
    goto main_menu
)

:: ====================================================================
:: SYSTEM ANALYSIS
:: ====================================================================
:system_analysis
cls
color 0a
echo +==================================================================+
echo ^| SYSTEM ANALYSIS ^& HEALTH CHECK                                  ^|
echo +==================================================================+
echo.

echo [+] Disk Space Summary:
powershell -Command "Get-Volume -DriveLetter %SystemDrive:~0,1% | Select-Object DriveLetter, FileSystemLabel, @{Name='SizeRemaining(GB)';Expression={[math]::round($_.SizeRemaining/1GB,2)}}, @{Name='TotalSize(GB)';Expression={[math]::round($_.Size/1GB,2)}} | Format-Table -AutoSize" 2>nul
echo.

echo [+] System Temp Folder Path:
echo     %TEMP%
echo.

echo [+] Log Directory Path:
echo     !LOG_DIR!
echo.

pause
goto main_menu

:: ====================================================================
:: SETTINGS MENU
:: ====================================================================
:settings_menu
cls
color 0a
echo +==================================================================+
echo ^| SETTINGS ^& OPTIONS                                              ^|
echo +==================================================================+
echo.
echo Current Settings:
if !DRY_RUN! equ 1 (echo    Dry-Run Mode: [ENABLED - Safe testing mode]) else (echo    Dry-Run Mode: [DISABLED - Files will be deleted])
if !SAVE_LOG! equ 1 (echo    Save Logs   : [ENABLED]) else (echo    Save Logs   : [DISABLED])
echo.
echo [1] Toggle Dry-Run Mode
echo [2] Toggle Save Logs
echo [3] Open Log Folder
echo [4] Clear Logs Older Than 7 Days
echo [5] Back to Main Menu
echo.
set "setting_choice="
set /p setting_choice="Enter choice: "

if "!setting_choice!"=="1" (
    if !DRY_RUN! equ 1 (set "DRY_RUN=0" & echo [+] Dry-run mode DISABLED) else (set "DRY_RUN=1" & echo [+] Dry-run mode ENABLED)
    pause
    goto settings_menu
)
if "!setting_choice!"=="2" (
    if !SAVE_LOG! equ 1 (set "SAVE_LOG=0" & echo [+] Logging DISABLED) else (set "SAVE_LOG=1" & echo [+] Logging ENABLED)
    pause
    goto settings_menu
)
if "!setting_choice!"=="3" (
    start "" explorer "!LOG_DIR!"
    goto settings_menu
)
if "!setting_choice!"=="4" (
    echo [+] Clearing logs older than 7 days...
    forfiles /P "!LOG_DIR!" /M *.log /D -7 /C "cmd /c del /f /q @path" 2>nul
    echo [+] Operation complete.
    pause
    goto settings_menu
)
if "!setting_choice!"=="5" goto main_menu
goto settings_menu

:: ====================================================================
:: VIEW LOG
:: ====================================================================
:view_log
cls
color 0a
echo +==================================================================+
echo ^| CLEANUP LOGS                                                    ^|
echo +==================================================================+
echo.

if not exist "!LOG_DIR!" (
    echo [!] No log directory found.
    pause
    goto main_menu
)

echo Recent cleanup logs:
echo.
dir /O:-D /B "!LOG_DIR!\*.log" 2>nul || echo (No log files found)
echo.
pause
goto main_menu

:: ====================================================================
:: ABOUT / HELP
:: ====================================================================
:about
cls
color 0b
echo +==================================================================+
echo ^| WinClearCache Tool v!SCRIPT_VERSION! - About                    ^|
echo +==================================================================+
echo.
echo Version : !SCRIPT_VERSION!
echo Author  : Naresh R (@theNareshofficial)
echo GitHub  : https://github.com/theNareshofficial
echo Website : http://thenareshofficial.free.nf/
echo.
echo +==================================================================+
echo ^| FEATURES                                                         ^|
echo +==================================================================+
echo.
echo - Multiple cleanup profiles (Full, Quick, Browsers)
echo - Dry-run execution mode for safety validation
echo - Automated operational logging with full path output
echo - Optimized for Windows 10 ^& 11 architectures
echo - Safe multi-profile browser cleaning
echo - Windows Update ^& BITS service management
echo.
pause
goto main_menu

:: ====================================================================
:: CLEANUP EXECUTORS
:: ====================================================================

:perform_full_cleanup
cls
color 0a
call :log_message "========== FULL CLEANUP STARTED =========="
echo.

call :clean_temp_files
call :clean_windows_update
call :clean_prefetch
call :clean_recycle_bin
call :clean_chrome
call :clean_firefox
call :clean_edge
call :clean_opera
call :clean_event_logs
call :clean_thumbnail_cache

call :log_message "========== FULL CLEANUP COMPLETED =========="
echo.
goto :eof

:perform_quick_cleanup
cls
color 0a
call :log_message "========== QUICK CLEANUP STARTED =========="
echo.

call :clean_temp_files
call :clean_recycle_bin
call :clean_thumbnail_cache

call :log_message "========== QUICK CLEANUP COMPLETED =========="
echo.
goto :eof

:perform_browser_cleanup
cls
color 0a
call :log_message "========== BROWSER CLEANUP STARTED =========="
echo.

call :clean_chrome
call :clean_firefox
call :clean_edge
call :clean_opera

call :log_message "========== BROWSER CLEANUP COMPLETED =========="
echo.
goto :eof

:: ====================================================================
:: INDIVIDUAL CLEANUP MODULES
:: ====================================================================

:clean_temp_files
call :log_message "[+] Cleaning temporary files..."

for %%D in ("%TEMP%" "%SystemRoot%\Temp" "%USERPROFILE%\AppData\Local\Temp") do (
    if exist "%%~D" (
        if !DRY_RUN! equ 1 (
            call :log_message "     [DRY-RUN] Would clean contents of: %%~D"
        ) else (
            echo     Cleaning: %%~D
            del /q /f /s "%%~D\*" >nul 2>&1
            for /d %%p in ("%%~D\*") do rmdir /s /q "%%~p" >nul 2>&1
            call :log_message "  [OK] Cleaned: %%~D"
            set /a ITEMS_DELETED+=1
        )
    )
)
echo.
goto :eof

:clean_windows_update
call :log_message "[+] Cleaning Windows Update cache..."

if exist "%SystemRoot%\SoftwareDistribution\Download" (
    if !DRY_RUN! equ 1 (
        call :log_message "     [DRY-RUN] Would delete Windows Update cache"
    ) else (
        echo     Stopping wuauserv and bits services...
        net stop wuauserv >nul 2>&1
        net stop bits >nul 2>&1
        echo     Deleting update download directory...
        del /q /f /s "%SystemRoot%\SoftwareDistribution\Download\*" >nul 2>&1
        net start bits >nul 2>&1
        net start wuauserv >nul 2>&1
        call :log_message "  [OK] Cleaned Windows Update cache"
        set /a ITEMS_DELETED+=1
    )
)
echo.
goto :eof

:clean_prefetch
call :log_message "[+] Cleaning Prefetch files..."

if exist "%SystemRoot%\Prefetch" (
    if !DRY_RUN! equ 1 (
        call :log_message "     [DRY-RUN] Would delete Prefetch files"
    ) else (
        echo     Deleting .pf files in Prefetch...
        del /q /f "%SystemRoot%\Prefetch\*.pf" >nul 2>&1
        call :log_message "  [OK] Cleaned Prefetch files"
        set /a ITEMS_DELETED+=1
    )
)
echo.
goto :eof

:clean_recycle_bin
call :log_message "[+] Cleaning Recycle Bin..."

if !DRY_RUN! equ 1 (
    call :log_message "     [DRY-RUN] Would empty Recycle Bin"
) else (
    echo     Emptying Recycle Bin via PowerShell...
    powershell -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
    call :log_message "  [OK] Recycle Bin emptied"
    set /a ITEMS_DELETED+=1
)
echo.
goto :eof

:clean_chrome
call :log_message "[+] Cleaning Chrome cache..."

set "chrome_path=%LOCALAPPDATA%\Google\Chrome\User Data"
if exist "!chrome_path!" (
    if !DRY_RUN! equ 1 (
        call :log_message "     [DRY-RUN] Would delete Chrome cache"
    ) else (
        for /d %%C in ("!chrome_path!\Default" "!chrome_path!\Profile*") do (
            if exist "%%~C\Cache" rmdir /s /q "%%~C\Cache" >nul 2>&1
            if exist "%%~C\Code Cache" rmdir /s /q "%%~C\Code Cache" >nul 2>&1
            if exist "%%~C\GPUCache" rmdir /s /q "%%~C\GPUCache" >nul 2>&1
        )
        call :log_message "  [OK] Chrome cache cleaned"
        set /a ITEMS_DELETED+=1
    )
)
echo.
goto :eof

:clean_firefox
call :log_message "[+] Cleaning Firefox cache..."

set "firefox_path=%LOCALAPPDATA%\Mozilla\Firefox\Profiles"
if exist "!firefox_path!" (
    if !DRY_RUN! equ 1 (
        call :log_message "     [DRY-RUN] Would delete Firefox cache"
    ) else (
        for /d %%A in ("!firefox_path!\*") do (
            if exist "%%~A\cache2" rmdir /s /q "%%~A\cache2" >nul 2>&1
            if exist "%%~A\startupCache" rmdir /s /q "%%~A\startupCache" >nul 2>&1
        )
        call :log_message "  [OK] Firefox cache cleaned"
        set /a ITEMS_DELETED+=1
    )
)
echo.
goto :eof

:clean_edge
call :log_message "[+] Cleaning Edge cache..."

set "edge_path=%LOCALAPPDATA%\Microsoft\Edge\User Data"
if exist "!edge_path!" (
    if !DRY_RUN! equ 1 (
        call :log_message "     [DRY-RUN] Would delete Edge cache"
    ) else (
        for /d %%E in ("!edge_path!\Default" "!edge_path!\Profile*") do (
            if exist "%%~E\Cache" rmdir /s /q "%%~E\Cache" >nul 2>&1
            if exist "%%~E\Code Cache" rmdir /s /q "%%~E\Code Cache" >nul 2>&1
            if exist "%%~E\GPUCache" rmdir /s /q "%%~E\GPUCache" >nul 2>&1
        )
        call :log_message "  [OK] Edge cache cleaned"
        set /a ITEMS_DELETED+=1
    )
)
echo.
goto :eof

:clean_opera
call :log_message "[+] Cleaning Opera cache..."

set "opera_path=%LOCALAPPDATA%\Opera Software\Opera Stable"
if exist "!opera_path!" (
    if !DRY_RUN! equ 1 (
        call :log_message "     [DRY-RUN] Would delete Opera cache"
    ) else (
        if exist "!opera_path!\Cache" rmdir /s /q "!opera_path!\Cache" >nul 2>&1
        if exist "!opera_path!\System Cache" rmdir /s /q "!opera_path!\System Cache" >nul 2>&1
        call :log_message "  [OK] Opera cache cleaned"
        set /a ITEMS_DELETED+=1
    )
)
echo.
goto :eof

:clean_event_logs
call :log_message "[+] Cleaning Primary Windows Event Logs..."

if !DRY_RUN! equ 1 (
    call :log_message "     [DRY-RUN] Would clear Event Logs"
) else (
    for %%L in (Application System Security Setup) do (
        echo     Clearing event log: %%L
        wevtutil cl "%%L" >nul 2>&1
    )
    call :log_message "  [OK] Primary Event Logs cleared"
    set /a ITEMS_DELETED+=1
)
echo.
goto :eof

:clean_thumbnail_cache
call :log_message "[+] Cleaning Thumbnail Cache..."

set "thumb_path=%LOCALAPPDATA%\Microsoft\Windows\Explorer"
if exist "!thumb_path!" (
    if !DRY_RUN! equ 1 (
        call :log_message "     [DRY-RUN] Would delete Thumbnail cache"
    ) else (
        echo     Clearing thumbnail databases...
        ie4uinit.exe -show >nul 2>&1
        del /q /f /a "!thumb_path!\thumbcache_*.db" >nul 2>&1
        call :log_message "  [OK] Thumbnail cache cleared"
        set /a ITEMS_DELETED+=1
    )
)
echo.
goto :eof

:: ====================================================================
:: CLEANUP COMPLETE
:: ====================================================================
:cleanup_complete
color 0a
echo +==================================================================+
echo ^| CLEANUP COMPLETE                                                ^|
echo +==================================================================+
echo.
if !DRY_RUN! equ 1 (
    color 0e
    echo [INFO] This was a DRY-RUN. No files were actually deleted.
    echo To perform actual cleanup, disable Dry-Run in Settings.
    color 0a
) else (
    color 0a
    echo [SUCCESS] All tasks completed successfully!
)
echo.
echo Operations completed: !ITEMS_DELETED!
if !SAVE_LOG! equ 1 (
    echo.
    echo [LOG LOCATION] Absolute log file path:
    echo "!LOG_FILE!"
)
echo.
echo [1] Return to Main Menu
echo [2] Exit
echo.
set "complete_choice="
set /p complete_choice="Enter choice: "

if "!complete_choice!"=="1" goto main_menu
if "!complete_choice!"=="2" goto exit_script
goto main_menu

:: ====================================================================
:: LOGGING FUNCTION
:: ====================================================================
:log_message
echo %~1
if !SAVE_LOG! equ 1 (
    echo [!TIME!] %~1 >> "!LOG_FILE!"
)
goto :eof

:: ====================================================================
:: EXIT
:: ====================================================================
:exit_script
cls
color 0a
echo +==================================================================+
echo ^| Thank you for using WinClearCache Tool v!SCRIPT_VERSION!        ^|
echo +==================================================================+
echo.
echo Author: Naresh R (@theNareshofficial)
echo.
echo Happy cleaning!
echo.
pause
exit /b 0