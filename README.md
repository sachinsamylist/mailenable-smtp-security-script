
This repository contains batch scripts designed to enhance SMTP security for MailEnable Standard Edition. It automates the extraction of failed SMTP logins, filters IP addresses, and creates deny lists to block unauthorized access.

# MailEnable SMTP Security Script

## 🚀 Overview
This repository contains batch scripts designed to enhance SMTP security for **MailEnable Standard Edition** by:
- Extracting failed SMTP login attempts from `SMTP-Activity.log`.
- Filtering and sorting IP addresses.
- Removing duplicate IPs.
- Generating deny lists (`.SAV` and `.TAB`) to block malicious IPs.
- Excluding VIP IPs from the deny list.

## 🛠️ Requirements
- **MailEnable Standard Edition**
- Windows OS
- SMTP logs (`SMTP-Activity.log`)

## 📄 File Descriptions

### 🛠️ **Batch Scripts**
- **00combined_script.bat**
    - Main script that:
        - Extracts failed logins from `SMTP-Activity.log`
        - Filters unique IPs
        - Removes duplicate IPs
        - Excludes VIP IPs from the deny list
        - Generates the final list of failed IPs
        - Creates debug logs for execution tracking

- **01import_ips_FINAL.bat**
    - Imports the filtered IPs into MailEnable's deny lists:
        - Adds IPs to `SMTP-DENY.SAV` and `SMTP-DENY.TAB`
        - Creates an import log with timestamps

- **01-vip_ips.txt**
    - List of trusted IPs (VIP IPs) that are excluded from blocking.
    - Add IPs you want to whitelist here.

---

### 📄 **Log Files**
- **SMTP-Activity.log**
    - Raw SMTP log file containing connection attempts and failures.
    - Used as the source for extracting failed logins.

- **failed_logins.txt**
    - Extracted failed SMTP login attempts.
    - Contains timestamp, IP addresses, and error details.

- **failed_ips.txt**
    - Unique, filtered list of failed IP addresses.
    - Used to generate MailEnable deny lists.

- **debug_log.txt**
    - Detailed execution log for debugging and troubleshooting.

- **import_log.txt**
    - Log of import operations with timestamps.
    - Confirms successful import of IPs into MailEnable deny lists.

---

### 🔥 **Deny Lists**
- **SMTP-DENY.SAV**
    - Contains denied IPs with the following format:
    ```
    101.254.99.82    1    CONNECT    SYSTEM
    ```

- **SMTP-DENY.TAB**
    - Contains denied IPs in TAB-separated format:
    ```
    101.254.99.82    1    CONNECT    SYSTEM
    ```

---

