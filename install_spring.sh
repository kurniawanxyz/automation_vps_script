#!/bin/bash

echo "########## INSTALLING SPRING BOOT ##########"

echo "----- CHECKING OPENJDK 21 -----"
if java -version 2>&1 | grep "openjdk version \"21" >/dev/null; then
    echo "OpenJDK 21 is already installed."
else
    echo "OpenJDK 21 not found. Installing OpenJDK 21..."
    sudo apt-get update
    sudo apt-get install openjdk-21-jdk -y
fi

echo "----- CHECKING MAVEN 3.9.9 -----"
if mvn -version 2>&1 | grep "Apache Maven 3.9.9" >/dev/null; then
    echo "Maven 3.9.9 is already installed."
else
    echo "Maven 3.9.9 not found. Downloading and installing Maven 3.9.9..."
    wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz

    echo "----- EXTRACTING MAVEN 3.9.9 -----"
    tar -xvf apache-maven-3.9.9-bin.tar.gz
    rm apache-maven-3.9.9-bin.tar.gz

    echo "----- MOVING MAVEN TO /opt -----"
    sudo mv apache-maven-3.9.9 /opt/

    echo "----- SETTING UP ENV VARS FOR MAVEN -----"
    VARIABLES='
    export M2_HOME="/opt/apache-maven-3.9.9"
    export PATH="$M2_HOME/bin:$PATH"
    '

    echo "$VARIABLES" >> ~/.bashrc

    export M2_HOME="/opt/apache-maven-3.9.9"
    export PATH="$M2_HOME/bin:$PATH"
fi

echo "----- CHECKING MAVEN INSTALLATION -----"
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
