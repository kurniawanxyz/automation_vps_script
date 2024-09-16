#!/bin/bash

# Mengupdate dan menginstal dependensi
sudo apt-get update
sudo apt-get install -y wget tar lsof net-tools

# Versi Go yang akan diinstal
GO_VERSION=1.23.0

# URL unduhan Go
GO_TAR_URL=https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz

# Direktori instalasi Go
GO_INSTALL_DIR=/usr/local/go

# Mengunduh dan menginstal Go
wget $GO_TAR_URL -O /tmp/go${GO_VERSION}.linux-amd64.tar.gz
sudo rm -rf $GO_INSTALL_DIR
sudo tar -C /usr/local -xzf /tmp/go${GO_VERSION}.linux-amd64.tar.gz

# Menambahkan Go ke PATH
if ! grep -q "export PATH=\$PATH:/usr/local/go/bin" ~/.profile; then
    echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
fi
source ~/.profile

# Verifikasi instalasi Go
echo "Verifikasi instalasi Go..."
go version

# Membuat aplikasi Go sederhana
APP_DIR=~/go_hello_world
mkdir -p $APP_DIR
cd $APP_DIR

cat <<EOF > main.go
package main

import (
    "fmt"
    "net/http"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, World!")
}

func main() {
    http.HandleFunc("/", helloHandler)
    fmt.Println("Server listening on port 10004")
    if err := http.ListenAndServe(":10004", nil); err != nil {
        fmt.Println("Error starting server:", err)
    }
}
EOF

# Menjalankan aplikasi dengan nohup
echo "Menjalankan aplikasi Go dengan nohup..."
nohup go run main.go > output.log 2>&1 &

# Menyimpan PID dari proses yang baru dimulai
PID=$!
echo "Aplikasi Go berjalan dengan PID $PID"

# Tunggu beberapa detik untuk memastikan server telah dimulai
sleep 5

# Periksa status port menggunakan ss
echo "Memeriksa port 10004 dengan ss..."
sudo ss -tuln | grep ':10004'

# Periksa status port menggunakan netstat
echo "Memeriksa port 10004 dengan netstat..."
sudo netstat -tuln | grep ':10004'

# Periksa status port menggunakan lsof
echo "Memeriksa port 10004 dengan lsof..."
sudo lsof -i :10004

# Periksa proses dengan ps
echo "Memeriksa proses dengan ps..."
ps aux | grep 'go run main.go'

# Tunggu 1 menit
echo "Menunggu 1 menit sebelum menghentikan aplikasi..."
sleep 60

# Hentikan proses
echo "Menghentikan proses dengan PID $PID..."
kill $PID

# Tunggu beberapa detik untuk memastikan proses berhenti
sleep 5

# Periksa apakah proses masih berjalan
echo "Memeriksa apakah proses masih berjalan setelah penghentian..."
if ps -p $PID > /dev/null; then
    echo "Proses masih berjalan. Gunakan 'kill -9' jika perlu."
else
    echo "Proses telah dihentikan."
fi

# Hapus file log jika diinginkan
# rm output.log
