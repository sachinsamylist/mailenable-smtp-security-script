@echo off
:: Like - Share - Subscribe
:: Make Donation - https://paypal.me/SachinSamy?country.x=IN&locale.x=en_GB
:: For any support contact:
:: WhatsApp: https://wa.me/918527117770
:: WebSite: iTCoh.com

:: MailEnable SMTP Security Script - Import IPs to Deny List
:: ---------------------------------------------------------
:: - Imports filtered IPs into MailEnable's deny lists.
:: - Creates SMTP-DENY.SAV and SMTP-DENY.TAB.
:: - Generates an import log with timestamps.
:: ---------------------------------------------------------


setlocal enabledelayedexpansion

:: Define input and output files
set "input_file=failed_ips.txt"
set "output_file_sav=SMTP-DENY.SAV"
set "output_file_tab=SMTP-DENY.TAB"
set "log_file=import_log.txt"

:: Check if the input file exists
if not exist "%input_file%" (
    echo [%date% %time%] ERROR: Input file %input_file% not found! >> %log_file%
    echo Input file %input_file% not found!
    exit /b
)

:: Initialize a flag to track the first line
set "first_line=1"
(for /f "tokens=* delims=" %%A in (%input_file%) do (
    if !first_line! equ 1 (
        echo.>> %output_file_sav%
        echo.>> %output_file_tab%
        set "first_line=0"
    )
    if defined last_line (
        echo !last_line!>> %output_file_sav%
        echo !last_line!>> %output_file_tab%
    )
    set "last_line=%%A	1	CONNECT	SYSTEM"
))

:: Write the last line without a trailing newline
<nul set /p="!last_line!" >> %output_file_sav%
<nul set /p="!last_line!" >> %output_file_tab%

echo [%date% %time%] INFO: Data has been successfully added to %output_file_sav% and %output_file_tab%. >> %log_file%
echo Data has been successfully added to %output_file_sav% and %output_file_tab%.
endlocal
