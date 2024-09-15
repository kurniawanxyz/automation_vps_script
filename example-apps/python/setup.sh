#!/bin/bash

echo "########## SETUP EXAMPLE PYTHON APP ##########"

echo "----- INSTALLING PYTHON VENV"
sudo apt install python3.10-venv

echo "----- MAKE VENV -----"
python3 -m venv .venv

echo "----- ACTIVATE VENV -----"
source .venv/bin/activate

echo "----- INSTALLING DEPENDENCIES -----"
pip install -r requirements.txt

echo "----- STARTING APP -----"
python3 app.py