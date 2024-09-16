#!/bin/bash

echo "########## INSTALLING SPRING BOOT ##########"

echo "----- INSTALL OPENJDK 21 -----"
sudo apt-get install openjdk-21-jdk

echo "----- MEASURE OPENJDK ALREADY INSTALLED -----"
java -version

echo "----- DOWNLOAD MAVEN 3.9.9 -----"
wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz

echo "----- EXTRACTING MAVEN 3.9.9 -----"
tar -xvf apache-maven-3.9.9-bin.tar.gz
rm apache-maven-3.9.9-bin.tar.gz

echo "----- MOVE TO OPT -----"
sudo mv apache-maven-3.9.9 /opt/

echo "----- SETUP ENV VAR -----"
VARIABLES='
export M2_HOME="/opt/apache-maven-3.9.9"
export PATH="$M2_HOME/bin:$PATH"
'

echo "$VARIABLES" >> ~/.bashrc

export M2_HOME="/opt/apache-maven-3.9.9"
export PATH="$M2_HOME/bin:$PATH"

echo "----- MEASURE MAVEN -----"
mvn -version


SETUP_DIR="example-apps/spring"
SETUP_SCRIPT="setup.sh"

if [ -d "$SETUP_DIR" ]; then
    echo "Changing directory to: $SETUP_DIR"
    cd "$SETUP_DIR" || { echo "Failed to change directory to $SETUP_DIR"; exit 1; }
else
    echo "Directory not found: $SETUP_DIR"
    exit 1
fi

if [ -f "$SETUP_SCRIPT" ]; then
    echo "Running setup script: $SETUP_SCRIPT"
    chmod +x "$SETUP_SCRIPT"
    bash "$SETUP_SCRIPT" || { echo "Failed to execute $SETUP_SCRIPT"; exit 1; }
else
    echo "Setup script not found: $SETUP_SCRIPT"
    exit 1
fi