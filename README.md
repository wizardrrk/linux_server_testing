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
```markdown
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

```

---

