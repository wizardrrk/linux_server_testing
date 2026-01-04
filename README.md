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

---


