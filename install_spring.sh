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

echo "########## SETUP SPRING APP ##########"

if [ -d "$SETUP_DIR" ]; then
    echo "Directory $SETUP_DIR exists. Changing to that directory..."
    cd "$SETUP_DIR" || { echo "Failed to change directory to $SETUP_DIR. Exiting..."; exit 1; }
else
    echo "Directory $SETUP_DIR does not exist. Exiting..."
    exit 1
fi

echo "----- BUILDING PROJECT -----"
mvn clean install

echo "----- STARTING SPRING BOOT APPLICATION -----"
mvn spring-boot:run

PID=$!
echo "Spring Boot application is running with PID $PID"

sleep 5

echo "Checking if Spring Boot is running on port 10005 with ss..."
sudo ss -tuln | grep ':10005'

echo "Checking if Spring Boot is running on port 10005 with netstat..."
sudo netstat -tuln | grep ':10005'

echo "Checking if Spring Boot is running on port 10005 with lsof..."
sudo lsof -i :10005

echo "Checking process with ps..."
ps aux | grep 'mvn spring-boot:run'

echo "Waiting 1 minute before stopping the Spring Boot application..."
sleep 60

echo "Stopping the Spring Boot process with PID $PID..."
kill $PID

sleep 5

echo "Checking if the process is still running..."
if ps -p $PID > /dev/null; then
    echo "Process is still running. Use 'kill -9' if needed."
else
    echo "Process has been stopped."
fi
