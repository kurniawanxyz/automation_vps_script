#!/bin/bash

# Mengupdate dan menginstal dependensi
sudo apt-get update
sudo apt-get install -y wget tar lsof net-tools

# Instalasi NVM (Node Version Manager) terbaru
echo "Instalasi NVM..."
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] || (wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.41.3/install.sh | bash)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Instalasi Node.js dan npm
NODE_VERSION=18.17.0
NPM_VERSION=22.19.0
echo "Menginstal Node.js versi $NODE_VERSION dan npm versi $NPM_VERSION..."
nvm install $NODE_VERSION
nvm use $NODE_VERSION
npm install -g npm@$NPM_VERSION

# Verifikasi instalasi Node.js dan npm
echo "Verifikasi instalasi Node.js dan npm..."
node -v
npm -v

# Membuat aplikasi Node.js sederhana
APP_DIR=~/node_hello_world
mkdir -p $APP_DIR
cd $APP_DIR

cat <<EOF > app.js
const http = require('http');

const PORT = 10002;

const requestHandler = (request, response) => {
  response.statusCode = 200;
  response.setHeader('Content-Type', 'text/plain');
  response.end('Hello, World!');
};

const server = http.createServer(requestHandler);

server.listen(PORT, () => {
  console.log(\`Server listening on port \${PORT}\`);
});
EOF

# Menjalankan aplikasi dengan nohup
echo "Menjalankan aplikasi Node.js dengan nohup..."
nohup node app.js > output.log 2>&1 &

# Menyimpan PID dari proses yang baru dimulai
PID=$!
echo "Aplikasi Node.js berjalan dengan PID $PID"

# Tunggu beberapa detik untuk memastikan server telah dimulai
sleep 5

# Periksa status port menggunakan ss
echo "Memeriksa port 10002 dengan ss..."
sudo ss -tuln | grep ':10002'

# Periksa status port menggunakan netstat
echo "Memeriksa port 10002 dengan netstat..."
sudo netstat -tuln | grep ':10002'

# Periksa status port menggunakan lsof
echo "Memeriksa port 10002 dengan lsof..."
sudo lsof -i :10002

# Periksa proses dengan ps
echo "Memeriksa proses dengan ps..."
ps aux | grep 'node app.js'

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
