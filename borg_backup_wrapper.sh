#!/bin/sh

# Admin email to send notifications
admin_email="ms@durchd8.de"

# Get the hostname
hostname=$(hostname)

# Get the current time
start_time=$(date '+%Y-%m-%d %H:%M:%S')

# Run the backup script in the background
/root/bin/server_backup &

# Get the PID of the backup script
backup_pid=$!

# Hour counter
hours=0

# Check if the backup script is running every hour
while true; do
    if ps -p $backup_pid > /dev/null; then
        hours=`expr $hours + 1`

        if [ $hours -gt 1 ]; then
            # Send an email every hour the script is running
            echo "Backup script is still running after $(expr $hours - 1) hour(s). Start time was $start_time on $hostname." | mail -s "Backup Script Running" $admin_email
        fi

        # If the script is running more than 10 hours, send a warning
        if [ $hours -gt 10 ]; then
            echo "Warning: Backup script is still running after $(expr $hours - 1) hours. Start time was $start_time on $hostname. Administrator intervention may be required." | mail -s "Backup Script Running Long" $admin_email
        fi

        # Sleep for an hour
        sleep 3600
    else
        # If the backup script has stopped running, break the loop
        break
    fi
done
