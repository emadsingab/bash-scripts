#!/bin/bash

add_group() {
    groupname=$(whiptail --inputbox "Enter the group name to add:" 10 50 3>&1 1>&2 2>&3)
    if [[ -z "$groupname" ]]; then
        whiptail --msgbox "Error: No group name entered." 10 50
        return
    fi

    if getent group "$groupname" > /dev/null; then
        whiptail --msgbox "Error: Group '$groupname' already exists." 10 50
        return
    fi

    if groupadd "$groupname"; then
        whiptail --msgbox "Group '$groupname' added successfully." 10 50
    else
        whiptail --msgbox "Error: Failed to add group." 10 50
    fi
}

delete_group() {
    groupname=$(pick_group)
    if [[ -z "$groupname" ]]; then
        return
    fi

    if ! getent group "$groupname" > /dev/null; then
        whiptail --msgbox "Error: Group '$groupname' does not exist." 10 50
        return
    fi

    if groupdel "$groupname"; then
        whiptail --msgbox "Group '$groupname' deleted successfully." 10 50
    else
        whiptail --msgbox "Error: Failed to delete group." 10 50
    fi
}

modify_group() {
    oldgroup=$(pick_group)
    if [[ -z "$oldgroup" ]]; then
        return
    fi

    newgroup=$(whiptail --inputbox "Enter the new group name:" 10 50 3>&1 1>&2 2>&3)
    if [[ -z "$newgroup" ]]; then
        whiptail --msgbox "Error: New group name must be provided." 10 50
        return
    fi

    if ! getent group "$oldgroup" > /dev/null; then
        whiptail --msgbox "Error: Group '$oldgroup' does not exist." 10 50
        return
    fi

    if groupmod -n "$newgroup" "$oldgroup"; then
        whiptail --msgbox "Group '$oldgroup' renamed to '$newgroup' successfully." 10 50
    else
        whiptail --msgbox "Error: Failed to rename group." 10 50
    fi
}

list_groups() {
    clear
    getent group | awk -F: '{print $1}' | sort | \
    fzf --height 90% \
        --border \
        --prompt="Groups > " \
        --header="Browse groups - ESC to go back" \
        --preview 'getent group {}'
    clear
}
