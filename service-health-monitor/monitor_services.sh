#!/bin/bash

# Check that the script is running as root

if [[ "$EUID" -ne 0 ]]; then
    echo "ERROR: Run this script as root."
    exit 1
fi

# The SSH service is usually named "sshd" on RHEL-based distributions
# and "ssh" on Debian-based distributions.

# Detect the SSH service name based on the available systemd unit
if systemctl list-unit-files --type=service --no-legend |
    grep -q '^ssh\.service[[:space:]]'; then

    SSH_SERVICE_NAME="ssh"

elif systemctl list-unit-files --type=service --no-legend |
    grep -q '^sshd\.service[[:space:]]'; then

    SSH_SERVICE_NAME="sshd"

else
    SSH_SERVICE_NAME=""
fi

services=("nginx" "docker")

# Add SSH only if an SSH service was found
if [[ -n "$SSH_SERVICE_NAME" ]]; then
    services+=("$SSH_SERVICE_NAME")
else
    echo "WARNING: Neither ssh.service nor sshd.service was found."
fi

echo "========================================"
echo "       Service Health Check Report"
echo "========================================"

for service in "${services[@]}"; do

    # Check whether the service exists
    if ! systemctl list-unit-files --type=service --no-legend |
        grep -q "^${service}\.service[[:space:]]"; then

        echo "$service does not exist on this system."
        echo "========================================"
        continue
    fi

    # Check whether the service is running
    if systemctl is-active --quiet "$service"; then
        echo "$service is RUNNING"

    else
        echo "$service is NOT ACTIVE"
        echo "Attempting to restart $service..."

        if systemctl restart "$service"; then

            # Verify that the service became active
            if systemctl is-active --quiet "$service"; then
                echo "$service has been restarted successfully."
            else
                echo "ERROR: $service restart command succeeded, but the service is not active."
            fi

        else
            echo "ERROR: Failed to restart $service."
            echo "Check logs using:"
            echo "journalctl -u $service --since '10 minutes ago'"
        fi
    fi

    echo "========================================"

done
