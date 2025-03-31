@echo off
:: Like - Share - Subscribe
:: Make Donation - https://paypal.me/SachinSamy?country.x=IN&locale.x=en_GB
:: For any support contact:
:: WhatsApp: https://wa.me/918527117770
:: WebSite: iTCoh.com

:: MailEnable SMTP Security Script - Extraction and Filtering
:: ---------------------------------------------------------
:: - Extracts failed SMTP logins from SMTP-Activity.log.
:: - Filters and removes duplicate IPs.
:: - Removes VIP IPs from the list.
:: - Generates unique failed IPs for blocking.
:: - Creates a debug log for execution tracking.
:: ---------------------------------------------------------

setlocal enabledelayedexpansion

:: Delete specified files before script execution
for %%F in (
    "failed_ips.txt"
    "debug_log.txt"
    "failed_logins.txt"
    "import_log.txt"
    "SMTP-DENY.SAV"
    "SMTP-DENY.TAB"
) do (
    if exist "%%F" (
        del "%%F"
        echo Deleted %%F
    )
)

:: Define log and output file names
set "LOGFILE=SMTP-Activity.log"
set "FAILED_LOGINS=failed_logins.txt"
set "FAILED_IPS=failed_ips.txt"
set "TEMP_FILE=temp_ips.txt"
set "REMOVE_IPS=01-vip_ips.txt"
set "TEMP_CLEANED=temp_failed_ips.txt"
set "LOCK_FILE=script.lock"
set "DEBUG_LOG=debug_log.txt"

:: Create lock file
echo Script started > "%LOCK_FILE%"
echo [%TIME%] Script execution started. > "%DEBUG_LOG%"

:: Ensure output files do not exist before writing (prevents blank lines)
for %%F in ("%FAILED_LOGINS%" "%FAILED_IPS%" "%TEMP_FILE%" "%TEMP_CLEANED%") do (
    if exist "%%F" (
        del "%%F"
        echo [%TIME%] Deleted existing file: %%F >> "%DEBUG_LOG%"
    )
)

:: Extract lines containing "535 Invalid Username or Password"
findstr /C:"535 Invalid Username or Password" "%LOGFILE%" > "%FAILED_LOGINS%"
echo [%TIME%] Extracted failed login attempts to %FAILED_LOGINS%. >> "%DEBUG_LOG%"

:: Check if extraction worked
if not exist "%FAILED_LOGINS%" (
    echo [%TIME%] ERROR: Failed to extract failed logins. >> "%DEBUG_LOG%"
    goto cleanup
)

:: Extract only IP addresses and store them in a temporary file
(for /f "tokens=5 delims=	" %%A in (%FAILED_LOGINS%) do echo %%A) > "%TEMP_FILE%"
echo [%TIME%] Extracted IPs to %TEMP_FILE%. >> "%DEBUG_LOG%"

:: Log extracted IPs for debugging
echo [%TIME%] Extracted IPs before sorting: >> "%DEBUG_LOG%"
type "%TEMP_FILE%" >> "%DEBUG_LOG%"

:: Remove duplicate IPs and store them in %FAILED_IPS%
set "last_line="
(for /f "delims=" %%A in ('sort /UNIQ "%TEMP_FILE%"') do (
    if defined last_line echo !last_line!
    set "last_line=%%A"
)) > "%FAILED_IPS%"

:: Write the last unique line without adding an extra newline
<nul set /p="!last_line!" >> "%FAILED_IPS%"
echo [%TIME%] Processed unique IPs to %FAILED_IPS%. >> "%DEBUG_LOG%"

:: Log unique IPs
echo [%TIME%] Unique IPs after sorting: >> "%DEBUG_LOG%"
type "%FAILED_IPS%" >> "%DEBUG_LOG%"

:: Remove temp file
del "%TEMP_FILE%"
echo [%TIME%] Removed temp file: %TEMP_FILE%. >> "%DEBUG_LOG%"

:: Remove specific IPs from the list if remove_ips.txt exists
if exist "%REMOVE_IPS%" (
    echo [%TIME%] remove_ips.txt found. Starting cleanup. >> "%DEBUG_LOG%"
    > "%TEMP_CLEANED%" (
        for /f "delims=" %%A in (%FAILED_IPS%) do (
            set "line=%%A"
            set "skip="
            for /f "delims=" %%B in (%REMOVE_IPS%) do (
                if "!line!"=="%%B" set "skip=1"
            )
            if not defined skip echo !line!
        )
    )

    :: Ensure no extra blank line at the end
    set "last_line="
    > "%FAILED_IPS%" (
        for /f "delims=" %%X in (%TEMP_CLEANED%) do (
            if defined last_line echo !last_line!
            set "last_line=%%X"
        )
    )

    :: Write the last IP without extra newline
    <nul set /p="!last_line!" >> "%FAILED_IPS%"
    echo [%TIME%] Removed specified IPs from %FAILED_IPS%. >> "%DEBUG_LOG%"

    :: Log cleaned IPs
    echo [%TIME%] Cleaned IPs after removal: >> "%DEBUG_LOG%"
    type "%FAILED_IPS%" >> "%DEBUG_LOG%"

    :: Clean up
    del "%TEMP_CLEANED%"
    echo [%TIME%] Cleanup complete. >> "%DEBUG_LOG%"
)

:cleanup
:: Remove lock file
del "%LOCK_FILE%"
echo [%TIME%] Script execution completed successfully. >> "%DEBUG_LOG%"

:: Display completion message
echo Extraction and cleanup complete. Check %FAILED_LOGINS%, %FAILED_IPS%, and %DEBUG_LOG%.
pause