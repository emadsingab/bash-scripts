# Bash System Administration Scripts

This repository contains a collection of Bash scripts for automating and simplifying various Linux system administration tasks. 

## Included Scripts

- **[Bulk User Creation](./bulk-user-creation/)**: A script to automate the creation of multiple Linux users, provisioning their home directories, and setting their passwords from a provided CSV file.
- **[Log Rotation](./log-rotation/)**: A script to manage log retention by automatically compressing old application logs and cleaning up obsolete logs older than a specific threshold.
- **[Service Health Monitor](./service-health-monitor/)**: A script that monitors the status of critical services (like SSH, Nginx, Docker), reports their health, and automatically attempts to restart them if they are down.
- **[User Management](./user-management/)**: A comprehensive, interactive TUI (Terminal User Interface) tool utilizing `whiptail` and `fzf` for managing Linux users and groups seamlessly.

Each directory contains its own `README.md` with more specific details and usage instructions for the respective script.
