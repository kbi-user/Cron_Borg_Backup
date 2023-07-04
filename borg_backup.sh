#!/bin/sh

# Define the Borg Backup repository
export BORG_REPO=/path/to/your/borg/repository

# Import Borg passphrase from an external file
export BORG_PASSPHRASE=$(cat /path/to/repo/key/filename)

# Backup tuning
export BORG_RELOCATED_REPO_ACCESS_IS_OK=yes

# Function to log information
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1"
}

# Check if Borg Backup repository is reachable
borg_info=$(borg info)
if [ $? -eq 0 ]; then
    echo "------------------------------------------------------------------------------"
    echo "Borg Backup repository information:"
    echo "$borg_info"
    echo "------------------------------------------------------------------------------"
else
    echo "------------------------------------------------------------------------------"
    log 1 "Cannot reach backup repository: $BORG_REPO"
    echo "------------------------------------------------------------------------------"
    exit 1
fi

# Check if Borg Backup repository has sufficient space
if ! [ $(df "$BORG_REPO" | awk 'NR==2 {print $4}') -gt 50000 ]; then
    log "Not enough space in backup repository: $BORG_REPO"
    exit 1
fi

# Function to perform the backup
backup_dirs() {
    log "Starting backup for directories"

    borg create \
        --verbose \
        --filter E \
        --list \
        --stats \
        --show-rc \
        --compression lz4 \
        --exclude-caches \
        --exclude '*/.cache/*' \
        --exclude '*/cache/*' \
        --exclude '/home/*/.cache/*' \
        --exclude '/home/*/.local/*' \
        --exclude '/home/*/tmp/*' \
        --exclude '/mnt/*' \
        --exclude '/var/tmp/*' \
        --exclude '/var/cache/*' \
        --exclude '/dev/*' \
        --exclude '/sys/*' \
        --exclude '/proc/*' \
        --exclude '/tmp/*' \
        --exclude '*.swap' \
        ::'{hostname}-{now}' \
        /etc \
        /home \
        /root \
        /var \
        /srv/nvme/share \

    if [ $? -ne 0 ]; then
        log "Backup for directories failed"
        exit 1
    fi

    log "Backup for directories completed successfully"
}

# Function to implement retention policy
post_backup() {
    # Implement retention policy
    # Keep the initial backup, 7 latest backups,
    # 1 backup per month for the last 12 months,
    # and 1 backup per year for all previous years
    log "Implementing retention policy"
    borg prune -v --list --keep-daily=7 --keep-weekly=4 --keep-monthly=12 --keep-yearly=-1

    if [ $? -ne 0 ]; then
        log "Retention policy implementation failed"
        exit 1
    fi

    log "Retention policy implementation successful"
}

# Main function
main() {
    # Perform the backup for the directories
    backup_dirs
    post_backup
}

# Execute the main function
main

