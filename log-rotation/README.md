# Log Rotation

This directory contains a Bash script (`log_rotation.sh`) to automate the rotation and cleanup of application logs (by default targeting `/var/log/myapp`).

## Features
- Checks for the existence of the log directory.
- Compresses `.log` files that are older than 7 days but newer than 30 days using `gzip`.
- Deletes compressed `.gz` logs that are older than 30 days.
- Logs all of its actions and operations to `/var/log/myapp-log-rotation.log`.

## Usage
Run the script manually or set it up as a cron job to automatically rotate logs on a regular schedule:
```bash
./log_rotation.sh
```
