#!/bin/bash

# Mengupdate dan menginstal dependensi
sudo apt-get update
sudo apt-get install -y wget tar lsof net-tools python3 python3-pip

# Membuat aplikasi Python sederhana
APP_DIR=~/python_hello_world
mkdir -p $APP_DIR
cd $APP_DIR

cat <<EOF > app.py
from http.server import SimpleHTTPRequestHandler, HTTPServer

PORT = 10003

class RequestHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/plain")
        self.end_headers()
        self.wfile.write(b"Hello, World!")

def run(server_class=HTTPServer, handler_class=RequestHandler):
    server_address = ('', PORT)
    httpd = server_class(server_address, handler_class)
    print(f"Server listening on port {PORT}")
    httpd.serve_forever()

if __name__ == "__main__":
    run()
EOF

# Menjalankan aplikasi dengan nohup
echo "Menjalankan aplikasi Python dengan nohup..."
nohup python3 app.py > output.log 2>&1 &

# Menyimpan PID dari proses yang baru dimulai
PID=$!
echo "Aplikasi Python berjalan dengan PID $PID"

# Tunggu beberapa detik untuk memastikan server telah dimulai
sleep 5

# Periksa status port menggunakan ss
echo "Memeriksa port 10003 dengan ss..."
sudo ss -tuln | grep ':10003'

# Periksa status port menggunakan netstat
echo "Memeriksa port 10003 dengan netstat..."
sudo netstat -tuln | grep ':10003'

# Periksa status port menggunakan lsof
echo "Memeriksa port 10003 dengan lsof..."
sudo lsof -i :10003

# Periksa proses dengan ps
echo "Memeriksa proses dengan ps..."
ps aux | grep 'python3 app.py'

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
