#!/bin/bash

echo "########## INSTALLING PYTHON PROJECT ##########"

# Mengecek apakah Python3 sudah terinstall
echo "----- CHECKING INSTALLED PYTHON -----"
if command -v python3 &>/dev/null; then
    echo "Python3 is installed, version: $(python3 --version)"
else
    # Jika Python3 tidak ditemukan, lakukan instalasi
    echo "Python3 is not installed. Installing Python3..."
    sudo apt-get update -y
    sudo apt-get install python3 -y
fi

# Mengecek apakah pip3 sudah terinstall
echo "----- CHECKING PIP -----"
if command -v pip3 &>/dev/null; then
    echo "Pip3 is installed, version: $(pip3 --version)"
else
    # Jika pip3 tidak ditemukan, lakukan instalasi
    echo "Pip3 is not installed. Installing pip3..."
    sudo apt-get install python3-pip -y
fi

SETUP_DIR="example-apps/python"

# Mengecek apakah direktori proyek Python ada
echo "----- TRY TO EXECUTE EXAMPLE APP -----"
echo "########## SETUP EXAMPLE PYTHON APP ##########"
if [ -d "$SETUP_DIR" ]; then
    echo "Directory $SETUP_DIR exists. Changing to that directory..."
    cd "$SETUP_DIR"
else
    # Jika direktori tidak ada, proses dihentikan
    echo "Directory $SETUP_DIR does not exist. Exiting..."
    exit 1
fi

# Menginstal paket venv untuk lingkungan virtual Python
echo "----- INSTALLING PYTHON VENV -----"
sudo apt install python3.10-venv -y

# Membuat lingkungan virtual Python
echo "----- MAKE VENV -----"
python3 -m venv .venv

# Mengaktifkan lingkungan virtual
echo "----- ACTIVATE VENV -----"
source .venv/bin/activate

# Menginstal dependensi proyek dari file requirements.txt
echo "----- INSTALLING DEPENDENCIES -----"
pip install -r requirements.txt

# Menjalankan aplikasi Python
echo "----- STARTING APP -----"
python3 app.py &

# Menyimpan PID dari proses aplikasi Python
PID=$!
echo "Python app is running with PID $PID"

# Tunggu 5 detik untuk memastikan aplikasi berjalan
sleep 5

# Mengecek apakah aplikasi Python berjalan di port 10004 menggunakan ss
echo "Checking if Python app is running on port 10004 with ss..."
sudo ss -tuln | grep ':10004'

# Mengecek apakah aplikasi Python berjalan di port 10004 menggunakan netstat
echo "Checking if Python app is running on port 10004 with netstat..."
sudo netstat -tuln | grep ':10004'

# Mengecek apakah aplikasi Python berjalan di port 10004 menggunakan lsof
echo "Checking if Python app is running on port 10004 with lsof..."
sudo lsof -i :10004

# Mengecek proses aplikasi Python menggunakan ps
echo "Checking process with ps..."
ps aux | grep 'python3 app.py'

# Menunggu 1 menit sebelum menghentikan aplikasi Python
echo "Waiting 1 minute before stopping the app..."
sleep 60

# Menghentikan proses aplikasi Python berdasarkan PID
echo "Stopping the process with PID $PID..."
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
