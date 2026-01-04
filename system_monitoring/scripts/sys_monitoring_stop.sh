#!/bin/bash

# Stop monitoring cron jobs

# Backup current crontab
crontab -l > /tmp/cron_backup_$(date +%F_%T).bak

# Remove the monitoring jobs from crontab
crontab -l | grep -v "# SYS_DISK_USAGE" | crontab - \
          | grep -v "# SYS_CPU_STAT" | crontab - \
          | grep -v "# SYS_MEM_USAGE" | crontab - \
          > /tmp/cron_new

# Install the cleaned crontab
crontab /tmp/cron_new

# Inform user
echo "Monitoring cron jobs removed. Backup saved in /tmp/cron_backup_<timestamp>"
