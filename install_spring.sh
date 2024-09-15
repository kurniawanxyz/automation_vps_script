#!/bin/bash

echo "########## INSTALLING SPRING BOOT ##########"

echo "----- INSTALL OPENJDK 8 -----"
sudo apt-get install openjdk-8-jre

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