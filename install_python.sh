#!/bin/bash

echo "########## INSTALING PYTHON PROJECT ##########"

echo "----- CHECKING INSTALLED PYTHON -----"

if command -v python3 &>/dev/null; then
    echo "Python3 is installed, version: $(python3 --version)"
else
    echo "Python3 is not installed. Installing Python3..."
    sudo apt-get update -y
    sudo apt-get install python3 -y
fi

echo "----- CHECKING PIP -----"

if command -v pip3 &>/dev/null; then
    echo "Pip3 is installed, version: $(pip3 --version)"
else
    echo "Pip3 is not installed. Installing pip3..."
    sudo apt-get install python3-pip -y
fi

echo "----- TRY TO EXECUTE EXAMPLE APP -----"

SETUP_SCRIPT="example-apps/python/setup.sh"
SETUP_DIR=$(dirname "$SETUP_SCRIPT")

if [ -f "$SETUP_SCRIPT" ]; then
    echo "Changing directory to: $SETUP_DIR"
    cd "$SETUP_DIR" || { echo "Failed to change directory to $SETUP_DIR"; exit 1; }

    echo "Running setup script: $SETUP_SCRIPT"
    chmod +x "$(basename "$SETUP_SCRIPT")"
    bash "$(basename "$SETUP_SCRIPT")"
else
    echo "Setup script not found: $SETUP_SCRIPT"
    exit 1
fi