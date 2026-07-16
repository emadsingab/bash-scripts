#!/bin/bash

# ---------------------------------------------------------
# Root Privilege Check
# ---------------------------------------------------------
if [[ $EUID -ne 0 ]]; then
    whiptail --title "Error" --msgbox "Please run this script as root." 10 50
    clear
    exit 1
fi

# ---------------------------------------------------------
# Load Modules
# ---------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/modules/user_management.sh"
source "$SCRIPT_DIR/modules/group_management.sh"

# ---------------------------------------------------------
# Shared Helper Functions
# ---------------------------------------------------------
pick_user() {
    getent passwd | awk -F: '{print $1}' | sort | \
    fzf --height 80% --border --prompt="Select User > " \
        --header="Use arrows - Enter to select - ESC to cancel"
}

pick_group() {
    getent group | awk -F: '{print $1}' | sort | \
    fzf --height 80% --border --prompt="Select Group > " \
        --header="Use arrows - Enter to select - ESC to cancel"
}

about_info() {
    clear
    printf "%s\n" \
"--------------------------------------------------------------" \
" Manage Linux users and groups with an interactive interface" \
"--------------------------------------------------------------" \
"" \
" Features:" \
"   * Add User" \
"   * Delete User" \
"   * List Users" \
"   * Disable / Enable User" \
"   * Change Password" \
"   * Add / Delete / Modify Groups" \
"   * List Groups" \
"" \
" Note:" \
"   Run this script as root." \
"" \
" Created By: Emad Singab" \
" Thank you for using this script" \
"" \
" Press ESC to return..." \
    | fzf --height=100% \
          --layout=reverse \
          --border \
          --prompt="About > " \
          --header="Welcome" \
          --disabled
    clear
}

# ---------------------------------------------------------
# Main Menu
# ---------------------------------------------------------
while true; do
    CHOICE=$(whiptail --title "Main Menu" \
        --menu "Choose an action:" 22 90 12 \
        "1"  "Add User         - Add a user to the system." \
        "2"  "Delete User      - Delete a user from the system." \
        "3"  "List Users       - List all users on the system." \
        "4"  "Disable User     - Disable a user account." \
        "5"  "Enable User      - Enable a user account." \
        "6"  "Change Password  - Change a user's password." \
        "7"  "Add Group        - Add a user group to the system." \
        "8"  "Delete Group     - Delete a user group from the system." \
        "9"  "Modify Group     - Modify a user group." \
        "10" "List Groups      - List all groups on the system." \
        "11" "About            - Display information about this script." \
        "12" "Exit             - Exit the script." \
        3>&1 1>&2 2>&3)

    STATUS=$?
    clear

    if [[ $STATUS -ne 0 ]]; then
        break
    fi

    case "$CHOICE" in
        1) add_user ;;
        2) delete_user ;;
        3) list_users ;;
        4) disable_user ;;
        5) enable_user ;;
        6) change_password ;;
        7) add_group ;;
        8) delete_group ;;
        9) modify_group ;;
        10) list_groups ;;
        11) about_info ;;
        12)
            whiptail --title "Exit" --msgbox "Exiting. Goodbye!" 10 50
            clear
            break
            ;;
        *)
            whiptail --title "Error" --msgbox "Invalid choice, please try again." 10 50
            ;;
    esac
done

clear