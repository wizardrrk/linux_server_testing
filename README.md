# 🛠️ System Monitoring Setup Guide

A lightweight and effective system monitoring setup for development environments. This guide and accompanying script help us monitor CPU, memory, disk usage, and processes, while logging key metrics for capacity planning and developer visibility.
# Task 1
---

## 📚 Scenario Overview

- The development server is experiencing intermittent performance issues.
- New developers need visibility into system resource usage.
- System metrics must be consistently tracked for effective capacity planning.

---

## ✅ Features

- Real-time monitoring with `htop` 
- Disk usage tracking with `df` and `du`
- Process monitoring for top CPU and memory consumers
- Automated logging via cron jobs
- Weekly log review and export support for capacity planning

---

## 🖥️ Step 1: Install Monitoring Tools

Install `htop` 

```bash
sudo apt update
sudo apt install -y htop
```

Launch tools:

```bash
htop
```

---

## 📊 Step 2: Disk Usage Monitoring

Overall disk usage:

```bash
df -h
```

Directory-level usage:

```bash
du -sh /home/*
```

---

## ⚙️ Step 3: Process Monitoring

Top CPU consumers:

```bash
ps aux --sort=-%cpu | head -n 10
```

Top memory consumers:

```bash
ps aux --sort=-%mem | head -n 10
```

---

## 📝 Step 4: Reporting Structure

Create a log directory:

```bash
mkdir -p /var/log/sys_monitor
```

Set up cron jobs:

```bash
crontab -e
```

Add the following lines:

```cron
*/5 * * * * df -h >> /var/log/sys_monitor/disk_usage.log
*/5 * * * * ps aux --sort=-%cpu | head -n 10 >> /var/log/sys_monitor/top_cpu.log
*/5 * * * * ps aux --sort=-%mem | head -n 10 >> /var/log/sys_monitor/top_mem.log
```

---

## 📈 Step 5: Capacity Planning

Review logs weekly:

```bash
less /var/log/sys_monitor/disk_usage.log
```

---

## 🧭 Workflow Diagram

```
MONITORING TOOLS
 ├── htop (CPU)
      ↓
DISK & PROCESS MONITORING
 ├── df, du (Disk)
 └── ps (Processes)
      ↓
LOGS
 └── /var/log/sys_monitor/*.log
      
```

---

## 🧑‍💻 Developer Onboarding Tips

- Run `htop` for real-time insights.
- Check `/var/log/sys_monitor/` for historical data.
- Use `ps` commands to identify bottlenecks.

---

## 💾 Quick Setup Script

Save the following as `setup_monitoring.sh`:

```bash
#!/bin/bash

# Update package list
sudo apt update

# Install monitoring tools
sudo apt install -y htop 

# Create log directory
mkdir -p /var/log/sys_monitor

# Add cron jobs for logging
(crontab -l 2>/dev/null; echo "*/5 * * * * df -h >> /var/log/sys_monitor/disk_usage.log") | crontab -
(crontab -l 2>/dev/null; echo "*/5 * * * * ps aux --sort=-%cpu | head -n 10 >> /var/log/sys_monitor/top_cpu.log") | crontab -
(crontab -l 2>/dev/null; echo "*/5 * * * * ps aux --sort=-%mem | head -n 10 >> /var/log/sys_monitor/top_mem.log") | crontab -

# Inform user
echo "Monitoring setup complete. Logs will be saved in /var/log/sys_monitor/"
```

Run it with:

```bash
bash setup_monitoring.sh
```



# TASK 2

---

# 🛡️ User Management and Access Control

This repository documents the setup of **user accounts and secure access controls** for new developers on a Linux system.  
The goal is to ensure isolated workspaces, proper password management, and compliance with security policies.

---

## 📋 Scenario

Two new developers require system access:

- **Sarah** → `/home/Sarah/workspace`
- **Mike** → `/home/mike/workspace`

Each developer must have:
- A dedicated working directory
- Restricted access (only the owner can read/write/execute)
- Secure password policies (expiration + complexity)

---

## ⚙️ Steps Implemented

### 1. Create User Accounts
```bash
sudo adduser Sarah
sudo adduser mike
```

- Secure passwords set during account creation.

---

### 2. Create Dedicated Workspaces
```bash
sudo mkdir -p /home/Sarah/workspace
sudo mkdir -p /home/mike/workspace
```

---

### 3. Set Ownership and Permissions
```bash
sudo chown Sarah:Sarah /home/Sarah/workspace
sudo chmod 700 /home/Sarah/workspace

sudo chown mike:mike /home/mike/workspace
sudo chmod 700 /home/mike/workspace
```
- `chmod 700` → Only the owner has full access.

---

### 4. Enforce Password Policy

#### Expiration (30 days)
```bash
sudo chage -M 30 Sarah
sudo chage -M 30 mike
```

#### Complexity Rules
Edit `/etc/pam.d/common-password`:
```
password requisite pam_pwquality.so retry=3 minlen=12 ucredit=-1 lcredit=-1 dcredit=-1 ocredit=-1
```

- Minimum length: 12 characters  
- At least one uppercase, lowercase, digit, and special character  

---

### 5. Verification

Check directory permissions:
```bash
ls -ld /home/*/workspace
```

Check password policy:
```bash
sudo chage -l Sarah
sudo chage -l mike
```

---

## ✅ Summary

- **Users created:** Sarah & Mike  
- **Directories:** `/home/Sarah/workspace`, `/home/mike/workspace`  
- **Access control:** Owner-only permissions (`chmod 700`)  
- **Password policy:** Expiration every 30 days + complexity enforced  

---

## 📖 Notes

- This setup follows **principle of least privilege**.  
- Future developers can be onboarded by repeating the same steps.  
- For auditing, consider enabling **system logging** and **monitoring tools**.


---

---

# 📦 Task 3: Backup Configuration for Web Servers (Ubuntu on WSL2)

## 🎯 Objective
Set up **automated backups** for Apache and Nginx web servers with:
- Weekly cron jobs (Tuesday, 12:00 AM)  
- Correct naming convention for backup files  
- Integrity verification  
- Documentation and logging  

---

## 🛠️ Implementation Steps

### 1. Identify Critical Directories
- **Apache (Ubuntu):**
  - `/etc/apache2/` → configuration files  
  - `/var/www/html/` → website content  

- **Nginx:**
  - `/etc/nginx/` → configuration files  
  - `/usr/share/nginx/html/` → website content  

---

### 2. Create Backup Script and give execute permission
File: `/usr/local/bin/web_backup.sh`

```bash
#!/bin/bash

# Timestamp format: YYYYMMDD_HHMM
TIMESTAMP=$(date +"%Y%m%d_%H%M")

# Backup destination
BACKUP_DIR="/var/backups/webservers"
mkdir -p $BACKUP_DIR

# Apache backup (Ubuntu path)
tar -czf $BACKUP_DIR/apache_${TIMESTAMP}.tar.gz /etc/apache2/ /var/www/html/

# Nginx backup
tar -czf $BACKUP_DIR/nginx_${TIMESTAMP}.tar.gz /etc/nginx/ /usr/share/nginx/html/

# Verify integrity
tar -tzf $BACKUP_DIR/apache_${TIMESTAMP}.tar.gz > /var/log/web_backup.log 2>&1
tar -tzf $BACKUP_DIR/nginx_${TIMESTAMP}.tar.gz >> /var/log/web_backup.log 2>&1

echo "Backup completed at $(date)" >> /var/log/web_backup.log
```
### give execute permission
```bash
sudo chmod +x /usr/local/bin/web_backup.sh
```

- **Naming convention:**  
  - `apache_YYYYMMDD_HHMM.tar.gz`  
  - `nginx_YYYYMMDD_HHMM.tar.gz`  

- **Integrity check:** `tar -tzf` ensures archives are readable.  

---

### 3. Schedule Cron Job
Edit crontab with `crontab -e`:

```bash
0 0 * * 2 /usr/local/bin/web_backup.sh
```

- Runs **every Tuesday at 12:00 AM**.  

---

### 4. Logging & Documentation
- **Log file:** `/var/log/web_backup.log`  
- Contains timestamps, archive verification results, and completion messages.  

Example log entry:
```
Backup completed at Tue Jan 6 00:00:01 IST 2026
Verified apache_20260106_0000.tar.gz
Verified nginx_20260106_0000.tar.gz
```

---

## 📊 Challenges & Solutions

| Challenge | Solution |
|-----------|----------|
| Apache path differs (`/etc/httpd/` vs `/etc/apache2/`) | Adjusted script for Ubuntu |
| Permissions for backup directories | Script runs with `sudo` or root cron job |
| Large backup sizes | Used `tar.gz` compression |
| Ensuring reliability | Added integrity check with `tar -tzf` |
| Documentation for onboarding | README + logs + screenshots |

---

## 🖥️ Screenshots / Terminal Outputs

### Cron Job Confirmation
```bash
wizardrrk@DESKTOP-BQ9P59M:/var/log$ sudo crontab -l
# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command
#*/1 * * * * /bin/bash -c "/bin/df -h >> /var/log/sys_monitor/disk_usage_3.log 2>&1"
#*/1 * * * * /bin/bash -c "/bin/ps aux --sort=-\%cpu | /usr/bin/head -n 10 >> /var/log/sys_monitor/top_cpu_3.log 2>&1"
#*/1 * * * * /bin/bash -c "/bin/ps aux --sort=-\%mem | /usr/bin/head -n 10 >> /var/log/sys_monitor/top_mem_3.log 2>&1"
#*/1 * * * * echo "cron ran at $(date)" >> /var/log/sys_monitor/debug_3.log 2>&1"
0 0 * * 2 /usr/local/bin/web_backup.sh
```

### Backup Directory Listing
```bash
lwizardrrk@DESKTOP-BQ9P59M:/var/backups/webservers$ ll
total 44
drwxr-xr-x 2 root root 4096 Jan  4 18:05 ./
drwxr-xr-x 3 root root 4096 Jan  4 18:03 ../
-rw-r--r-- 1 root root  713 Jan  4 18:03 apache_20260104_1803.tar.gz
-rw-r--r-- 1 root root  713 Jan  4 18:04 apache_20260104_1804.tar.gz
-rw-r--r-- 1 root root  713 Jan  4 18:05 apache_20260104_1805.tar.gz
-rw-r--r-- 1 root root 7022 Jan  4 18:03 nginx_20260104_1803.tar.gz
-rw-r--r-- 1 root root 7022 Jan  4 18:04 nginx_20260104_1804.tar.gz
-rw-r--r-- 1 root root 7022 Jan  4 18:05 nginx_20260104_1805.tar.gz
```

### Log File Output
```bash
wizardrrk@DESKTOP-BQ9P59M:/var/backups$ cd ..
wizardrrk@DESKTOP-BQ9P59M:/var$ cd log
wizardrrk@DESKTOP-BQ9P59M:/var/log$ cat web_backup.log
etc/apache2/
etc/apache2/conf-available/
etc/apache2/conf-available/javascript-common.conf
var/www/html/
var/www/html/index.nginx-debian.html
etc/nginx/
etc/nginx/nginx.conf
etc/nginx/fastcgi_params
etc/nginx/modules-available/
etc/nginx/conf.d/
etc/nginx/conf.d/revproxy.conf
etc/nginx/scgi_params
etc/nginx/sites-available/
etc/nginx/sites-available/default
etc/nginx/koi-win
etc/nginx/sites-enabled/
etc/nginx/sites-enabled/default
etc/nginx/mime.types
etc/nginx/modules-enabled/
etc/nginx/uwsgi_params
etc/nginx/koi-utf
etc/nginx/win-utf
etc/nginx/snippets/
etc/nginx/snippets/fastcgi-php.conf
etc/nginx/snippets/snakeoil.conf
etc/nginx/fastcgi.conf
etc/nginx/proxy_params
usr/share/nginx/html/
usr/share/nginx/html/index.html
Backup completed at Sun Jan  4 18:06:01 UTC 2026
```

---

## ✅ Summary
- Automated backups configured for **Apache (`/etc/apache2/`)** and **Nginx (`/etc/nginx/`)**.  
- Cron jobs scheduled weekly at **Tuesday 12:00 AM**.  
- Proper naming convention ensures traceability.  
- Integrity verification and logging implemented.  
- Challenges addressed with distro-specific paths, permissions, and compression.  

---
