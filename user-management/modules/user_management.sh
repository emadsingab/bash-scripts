#!/bin/bash

add_user() {
    username=$(whiptail --inputbox "Enter the username to add:" 10 50 3>&1 1>&2 2>&3)
    if [[ -z "$username" ]]; then
        whiptail --msgbox "Error: No username entered." 10 50
        return
    fi

    if getent passwd "$username" > /dev/null; then
        whiptail --msgbox "Error: User '$username' already exists." 10 50
        return
    fi

    if whiptail --yesno "Do you want to set a password for '$username' now?" 10 60; then
        while true; do
            pass1=$(whiptail --passwordbox "Enter password for new user '$username':" 10 50 3>&1 1>&2 2>&3)
            if [[ $? -ne 0 ]]; then
                whiptail --msgbox "User addition cancelled." 10 50
                return
            fi

            pass2=$(whiptail --passwordbox "Confirm password for '$username':" 10 50 3>&1 1>&2 2>&3)
            if [[ $? -ne 0 ]]; then
                whiptail --msgbox "User addition cancelled." 10 50
                return
            fi

            if [[ "$pass1" == "$pass2" ]]; then
                if [[ -z "$pass1" ]]; then
                    whiptail --msgbox "Error: Password cannot be empty. Try again." 10 50
                    continue
                fi
                set_password=true
                break
            else
                whiptail --msgbox "Error: Passwords do not match. Please try again." 10 50
            fi
        done
    else
        set_password=false
    fi

    if useradd "$username"; then
        if [[ "$set_password" == true ]]; then
            echo "$username:$pass1" | chpasswd
            whiptail --msgbox "User '$username' added successfully with password set." 10 60
        else
            passwd -l "$username" > /dev/null 2>&1
            whiptail --msgbox "User '$username' added successfully without password." 10 60
        fi
    else
        whiptail --msgbox "Error: Failed to add user." 10 50
    fi
}

delete_user() {
    username=$(pick_user)
    if [[ -z "$username" ]]; then
        return
    fi

    if ! getent passwd "$username" > /dev/null; then
        whiptail --msgbox "Error: User '$username' does not exist." 10 50
        return
    fi

    if userdel -r "$username"; then
        whiptail --msgbox "User '$username' deleted successfully." 10 50
    else
        whiptail --msgbox "Error: Failed to delete user." 10 50
    fi
}

list_users() {
    clear
    getent passwd | awk -F: '{print $1}' | sort | \
    fzf --height 90% \
        --border \
        --prompt="Users > " \
        --header="Browse users - ESC to go back" \
        --preview 'getent passwd {} | awk -F: "{print \"Username : \" \$1 \"\nUID      : \" \$3 \"\nGID      : \" \$4 \"\nHome Dir : \" \$6 \"\nShell    : \" \$7}"'
    clear
}

disable_user() {
    username=$(pick_user)
    if [[ -z "$username" ]]; then
        return
    fi

    if ! getent passwd "$username" > /dev/null; then
        whiptail --msgbox "Error: User '$username' does not exist." 10 50
        return
    fi

    if usermod -L "$username"; then
        whiptail --msgbox "User '$username' has been disabled (locked)." 10 50
    else
        whiptail --msgbox "Error: Failed to disable user." 10 50
    fi
}

enable_user() {
    username=$(pick_user)
    if [[ -z "$username" ]]; then
        return
    fi

    if ! getent passwd "$username" > /dev/null; then
        whiptail --msgbox "Error: User '$username' does not exist." 10 50
        return
    fi

    if usermod -U "$username"; then
        whiptail --msgbox "User '$username' has been enabled (unlocked)." 10 50
    else
        whiptail --msgbox "Error: Failed to enable user." 10 50
    fi
}

change_password() {
    username=$(pick_user)
    if [[ -z "$username" ]]; then
        return
    fi

    if ! getent passwd "$username" > /dev/null; then
        whiptail --msgbox "Error: User '$username' does not exist." 10 50
        return
    fi

    while true; do
        pass1=$(whiptail --passwordbox "Enter new password for '$username':" 10 50 3>&1 1>&2 2>&3)
        if [[ $? -ne 0 ]]; then
            return
        fi

        pass2=$(whiptail --passwordbox "Confirm new password for '$username':" 10 50 3>&1 1>&2 2>&3)
        if [[ $? -ne 0 ]]; then
            return
        fi

        if [[ "$pass1" == "$pass2" ]]; then
            if [[ -z "$pass1" ]]; then
                whiptail --msgbox "Error: Password cannot be empty. Try again." 10 50
                continue
            fi
            break
        else
            whiptail --msgbox "Error: Passwords do not match. Please try again." 10 50
        fi
    done

    echo "$username:$pass1" | chpasswd
    if [[ $? -eq 0 ]]; then
        whiptail --msgbox "Password changed successfully for user '$username'!" 10 50
    else
        whiptail --msgbox "Failed to change password." 10 50
    fi
}
