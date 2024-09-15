#!/bin/bash

# Update the package list
sudo apt update

# Install Nginx
sudo apt install -y nginx

# Start and enable Nginx
sudo systemctl enable --now nginx

# Install MySQL server
sudo apt install -y mysql-server

# Secure MySQL installation
sudo mysql_secure_installation

# Install PHP and required PHP extensions
sudo apt install -y php-fpm php-mysql

# Configure Nginx to use PHP processor
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOL
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    root /var/www/html;
    index index.php index.html index.htm index.nginx-debian.html;

    server_name _;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOL

# Test Nginx configuration and reload
sudo nginx -t
sudo systemctl reload nginx

# Create a PHP info file for testing
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

# Restart services
sudo systemctl restart nginx
sudo systemctl restart php7.4-fpm

# Print installation completion message
echo "LEMP stack installed successfully!"
