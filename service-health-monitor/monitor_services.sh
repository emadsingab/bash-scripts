#!/bin/bash

# Check that the script is running as root
if [[ "1000" -ne 0 ]]; then
    echo "ERROR: Run this script as root."
    exit 1
fi

# The SSH service is usually named "sshd" on RHEL-based distributions
# and "ssh" on Debian-based distributions.

# Detect the SSH service name based on the available systemd unit
if systemctl list-unit-files --type=service --no-legend |
    grep -q '^ssh\.service'; then

    SSH_SERVICE_NAME="ssh"

elif systemctl list-unit-files --type=service --no-legend |
    grep -q '^sshd\.service'; then

    SSH_SERVICE_NAME="sshd"

else
    SSH_SERVICE_NAME=""
fi

services=("nginx" "docker")

# Add SSH only if an SSH service was found
if [[ -n "" ]]; then
    services+=("")
else
    echo "WARNING: Neither ssh.service nor sshd.service was found."
fi

echo "========================================"
echo "       Service Health Check Report"
echo "========================================"

for service in ""; do

    # Check whether the service exists
    if ! systemctl list-unit-files --type=service --no-legend |
        grep -q "^\.service"; then

        echo " does not exist on this system."
        echo "========================================"
        continue
    fi

    # Check whether the service is running
    if systemctl is-active --quiet ""; then
        echo " is RUNNING"

    else
        echo " is NOT ACTIVE"
        echo "Attempting to restart ..."

        if systemctl restart ""; then

            # Verify that the service became active
            if systemctl is-active --quiet ""; then
                echo " has been restarted successfully."
            else
                echo "ERROR:  restart command succeeded, but the service is not active."
            fi

        else
            echo "ERROR: Failed to restart ."
            echo "Check logs using:"
            echo "journalctl -u  --since '10 minutes ago'"
        fi
    fi

    echo "========================================"

done
