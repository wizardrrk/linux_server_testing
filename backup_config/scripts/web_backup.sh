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
