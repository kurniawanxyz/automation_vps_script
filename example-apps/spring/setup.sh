#!/bin/bash

echo "########## SETUP SPRING APP ##########"
mvn clean install

echo "----- STARTING SPRING BOOT -----"
mvn spring-boot:run