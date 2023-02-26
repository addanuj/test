#!/bin/bash

# Check if script is running as root, if not, ask for sudo password
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root."
    sudo "$0" "$@"
    exit 0
fi

# Check for Linux flavor and install required packages
if command -v apt-get >/dev/null 2>&1; then
    apt-get install -y git docker.io
elif command -v yum >/dev/null 2>&1; then
    yum install -y git docker
else
    echo "Unsupported Linux flavor."
    exit 1
fi

# Create directory and move into it
mkdir cp4s-auto-install
cd cp4s-auto-install

# Clone repository
git clone https://github.com/IBM/automation-cp4s.git

# Run apply.sh in each directory under automation-cp4s
for d in automation-cp4s/*/ ; do
    if [ -f "$d/apply.sh" ]; then
        (cd "$d" && sh apply.sh)
    fi
done

# Show message that installation is complete
echo "Installation complete."
