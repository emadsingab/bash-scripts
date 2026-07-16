#!/bin/bash
yum --version > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "Using yum..."

    sudo yum install -y epel-release
    sudo yum install -y whiptail fzf

else
    echo "Using apt..."

    sudo apt update
    sudo apt install -y whiptail fzf
fi
echo "Done."