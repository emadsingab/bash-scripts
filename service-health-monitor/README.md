# Service Health Monitor

This directory contains a Bash script (`monitor_services.sh`) designed to monitor the health and status of critical system services such as SSH, Nginx, and Docker.

## Features
- Validates root privileges required for service management.
- Automatically detects the correct SSH daemon service name based on the OS (e.g., `ssh` for Debian-based systems or `sshd` for RHEL-based).
- Checks whether monitored services are installed and currently running.
- Automatically attempts to restart inactive services and verifies the restart success.
- Prints a health check report to the terminal.

## Usage
Run the script as root to perform a health check on the predefined services:
```bash
sudo ./monitor_services.sh
```
