#!/bin/bash

# Variables
LOG_DIR="/var/log/myapp"
SCRIPT_LOG="/var/log/myapp-log-rotation.log"

# Ensure the application log directory exists
if [[ ! -d "$LOG_DIR" ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Log directory $LOG_DIR does not exist." \
        >> "$SCRIPT_LOG"
    exit 1
fi

# Compress logs older than 7 days but newer than 30 days
find "$LOG_DIR" -type f -name "*.log" -mtime +7 -mtime -30 -exec gzip -- {} \; -exec echo "[$(date '+%Y-%m-%d %H:%M:%S')] Compressed: {}" \; >> "$SCRIPT_LOG" 2>&1

# Delete compressed logs older than 30 days
find "$LOG_DIR" -type f  -name "*.gz -mtime +30 -exec rm -f -- {} \; -exec echo "[$(date '+%Y-%m-%d %H:%M:%S')] Deleted: {}" \; >> "$SCRIPT_LOG" 2>&1

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Log rotation completed successfully." >> "$SCRIPT_LOG"
