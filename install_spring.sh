#!/bin/bash

echo "########## INSTALLING SPRING BOOT ##########"

# Mengecek apakah OpenJDK 21 sudah terinstall
echo "----- CHECKING OPENJDK 21 -----"
if java -version 2>&1 | grep "openjdk version \"21" >/dev/null; then
    echo "OpenJDK 21 is already installed."
else
    # Jika OpenJDK 21 tidak ditemukan, lakukan instalasi
    echo "OpenJDK 21 not found. Installing OpenJDK 21..."
    sudo apt-get update
    sudo apt-get install openjdk-21-jdk -y
fi

# Mengecek apakah Maven versi 3.9.9 sudah terinstall
echo "----- CHECKING MAVEN 3.9.9 -----"
if mvn -version 2>&1 | grep "Apache Maven 3.9.9" >/dev/null; then
    echo "Maven 3.9.9 is already installed."
else
    # Jika Maven versi 3.9.9 tidak ditemukan, download dan install
    echo "Maven 3.9.9 not found. Downloading and installing Maven 3.9.9..."
    wget https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.tar.gz

    # Ekstraksi file tar.gz Maven
    echo "----- EXTRACTING MAVEN 3.9.9 -----"
    tar -xvf apache-maven-3.9.9-bin.tar.gz
    rm apache-maven-3.9.9-bin.tar.gz

    # Memindahkan Maven ke direktori /opt
    echo "----- MOVING MAVEN TO /opt -----"
    sudo mv apache-maven-3.9.9 /opt/

    # Menambahkan variabel lingkungan untuk Maven ke dalam ~/.bashrc
    echo "----- SETTING UP ENV VARS FOR MAVEN -----"
    VARIABLES='
    export M2_HOME="/opt/apache-maven-3.9.9"
    export PATH="$M2_HOME/bin:$PATH"
    '

    echo "$VARIABLES" >> ~/.bashrc

    # Mengupdate environment variable di sesi terminal saat ini
    export M2_HOME="/opt/apache-maven-3.9.9"
    export PATH="$M2_HOME/bin:$PATH"
fi

# Mengecek instalasi Maven dengan menjalankan 'mvn -version'
echo "----- CHECKING MAVEN INSTALLATION -----"
mvn -version

SETUP_DIR="example-apps/spring"

echo "########## SETUP SPRING APP ##########"

# Mengecek apakah direktori untuk Spring App ada
if [ -d "$SETUP_DIR" ]; then
    echo "Directory $SETUP_DIR exists. Changing to that directory..."
    cd "$SETUP_DIR" || { echo "Failed to change directory to $SETUP_DIR. Exiting..."; exit 1; }
else
    # Jika direktori tidak ada, proses dihentikan
    echo "Directory $SETUP_DIR does not exist. Exiting..."
    exit 1
fi

# Membersihkan dan membangun proyek dengan Maven
echo "----- BUILDING PROJECT -----"
mvn clean install

# Menjalankan aplikasi Spring Boot dan mencatat lognya ke file
echo "----- STARTING SPRING BOOT APPLICATION -----"
LOG_FILE="spring-boot.log"
mvn spring-boot:run > "$LOG_FILE" 2>&1 &

# Menyimpan PID dari proses Spring Boot
PID=$!
echo "Spring Boot application is running with PID $PID"

# Tunggu 5 detik untuk memastikan aplikasi berjalan
sleep 5

# Mengecek apakah Spring Boot berjalan di port 10005 menggunakan ss
echo "Checking if Spring Boot is running on port 10005 with ss..."
sudo ss -tuln | grep ':10005'

# Mengecek apakah Spring Boot berjalan di port 10005 menggunakan netstat
echo "Checking if Spring Boot is running on port 10005 with netstat..."
sudo netstat -tuln | grep ':10005'

# Mengecek apakah Spring Boot berjalan di port 10005 menggunakan lsof
echo "Checking if Spring Boot is running on port 10005 with lsof..."
sudo lsof -i :10005

# Mengecek proses Spring Boot menggunakan ps
echo "Checking process with ps..."
ps aux | grep 'mvn spring-boot:run'

# Menunggu 1 menit sebelum menghentikan aplikasi Spring Boot
echo "Waiting 1 minute before stopping the Spring Boot application..."
sleep 60

# Menghentikan proses Spring Boot berdasarkan PID
echo "Stopping the Spring Boot process with PID $PID..."
kill $PID

# Tunggu 5 detik untuk memastikan proses telah berhenti
sleep 5

# Mengecek apakah proses masih berjalan
echo "Checking if the process is still running..."
if ps -p $PID > /dev/null; then
    # Jika masih berjalan, berikan pesan untuk menggunakan 'kill -9'
    echo "Process is still running. Use 'kill -9' if needed."
else
    # Jika sudah berhenti, berikan konfirmasi
    echo "Process has been stopped."
fi
