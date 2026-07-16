# User Management

This directory contains an interactive, menu-driven Bash project (`main.sh`) for managing Linux users and groups. It leverages `whiptail` and `fzf` to provide a user-friendly graphical interface in the terminal.

## Features
- Add, delete, and list users.
- Disable and enable user accounts.
- Change user passwords.
- Add, delete, modify, and list groups.
- Interactive, searchable prompts for picking users and groups.

## Requirements
You may need to run `Requirements.sh` first to install the necessary dependencies (`whiptail` and `fzf`) for the TUI to function properly.

## Usage
Run the main script as root to launch the interactive menu:
```bash
sudo ./main.sh
```
