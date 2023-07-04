# Cron-Borg-Backup 📦⏰
![disaster-recovery-plan-your-corporation-cyber-security-concept-2020](https://github.com/kbi-user/Cron_Borg_Backup/assets/15234613/150d77d5-6cfa-4c97-90e3-a9e96511b2cd)
[![GitHub license](https://img.shields.io/github/license/Naereen/StrapDown.js.svg)](https://github.com/naereen/StrapDown.js/blob/master/LICENSE)
[![Made with Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)

Cron-Borg-Backup is a utility script that automates your server backups using [BorgBackup](https://www.borgbackup.org/). The script is implemented in Shell and uses the `cron` daemon to schedule backup operations.

## Prerequisites

- Unix-like operating system
- `BorgBackup` (at least version 1.2.0)
- `mail` command to send emails
- `cron` daemon for scheduling. Make sure your cron can send emails.

## Description

This utility includes two scripts: the backup script (`borg_backup.sh`) that uses BorgBackup to perform and manage backups, and a wrapper script (`borg_backup_wrapper.sh`) that monitors the execution of the backup script, alerting via email when the backup process takes too long.

## Installation & Configuration

1. Clone this repository: 

    ```bash
    git clone https://github.com/username/cron-borg-backup.git
    ```

2. Navigate into the project directory:

    ```bash
    cd cron-borg-backup
    ```

3. Ensure both scripts are executable:

    ```bash
    chmod +x borg_backup.sh borg_backup_wrapper.sh
    ```

4. Open `borg_backup.sh` in your preferred text editor to configure the following:

    - `BORG_REPO`: Path to your BorgBackup repository.
    - `BORG_PASSPHRASE`: Contents of your Borg passphrase file.
    - `borg create`: Modify the directories and exclusion patterns as per your needs.
    - `borg prune`: Adjust the retention policy according to your requirements.

5. Open `borg_backup_wrapper.sh` in your preferred text editor to configure the following:

    - `admin_email`: Email address where notifications will be sent.

6. Schedule the wrapper script to run using `cron`. Use `crontab -e` to open your cron configuration file and add an entry for the wrapper script:

    ```cron
    0 2 * * * /path/to/borg_backup_wrapper.sh
    ```

    This example will run the script every day at 2 AM.

And that's it! Your server backups are now automated with BorgBackup, and you will receive email notifications if a backup operation takes longer than expected.
