#!/bin/bash

# Update package list
sudo apt update

# Install monitoring tools
sudo apt install -y htop nmon

# Create log directory
mkdir -p /var/log/sys_monitor
chmod 775 -R /var/log/sys_monitor

# Add cron jobs for logging (with timestamps)
(crontab -l 2>/dev/null; echo "*/1 * * * * /bin/bash -c \"echo \\\"==== \$(date) ====\\\" >> /var/log/sys_monitor/disk_usage.log; /bin/df -h >> /var/log/sys_monitor/disk_usage.log 2>&1\"") | crontab - # SYS_DISK_USAGE

(crontab -l 2>/dev/null; echo "*/1 * * * * /bin/bash -c \"echo \\\"==== \$(date) ====\\\" >> /var/log/sys_monitor/top_cpu.log; /bin/ps aux --sort=-\\%cpu | head -n 10 >> /var/log/sys_monitor/top_cpu.log 2>&1\"") | crontab - # SYS_CPU_STAT

(crontab -l 2>/dev/null; echo "*/1 * * * * /bin/bash -c \"echo \\\"==== \$(date) ====\\\" >> /var/log/sys_monitor/top_mem.log; /bin/ps aux --sort=-\\%mem | head -n 10 >> /var/log/sys_monitor/top_mem.log 2>&1\"") | crontab - # SYS_MEM_STAT

# Inform user
echo "Monitoring setup complete. Logs will be saved in /var/log/sys_monitor/"
