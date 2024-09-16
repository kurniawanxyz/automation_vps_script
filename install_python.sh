#!/bin/bash

echo "########## INSTALLING PYTHON PROJECT ##########"

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

SETUP_DIR="example-apps/python"

echo "----- TRY TO EXECUTE EXAMPLE APP -----"
echo "########## SETUP EXAMPLE PYTHON APP ##########"

if [ -d "$SETUP_DIR" ]; then
    echo "Directory $SETUP_DIR exists. Changing to that directory..."
    cd "$SETUP_DIR"
else
    echo "Directory $SETUP_DIR does not exist. Exiting..."
    exit 1
fi

echo "----- INSTALLING PYTHON VENV -----"
sudo apt install python3.10-venv -y

echo "----- MAKE VENV -----"
python3 -m venv .venv

echo "----- ACTIVATE VENV -----"
source .venv/bin/activate

echo "----- INSTALLING DEPENDENCIES -----"
pip install -r requirements.txt

echo "----- STARTING APP -----"
python3 app.py &

PID=$!
echo "Python app is running with PID $PID"

sleep 5

echo "Checking if Python app is running on port 10004 with ss..."
sudo ss -tuln | grep ':10004'

echo "Checking if Python app is running on port 10004 with netstat..."
sudo netstat -tuln | grep ':10004'

echo "Checking if Python app is running on port 10004 with lsof..."
sudo lsof -i :10004

echo "Checking process with ps..."
ps aux | grep 'python3 app.py'

echo "Waiting 1 minute before stopping the app..."
sleep 60

echo "Stopping the process with PID $PID..."
kill $PID

sleep 5

echo "Checking if the process is still running..."
if ps -p $PID > /dev/null; then
    echo "Process is still running. Use 'kill -9' if needed."
else
    echo "Process has been stopped."
fi
