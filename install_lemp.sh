#!/bin/bash

# Update the package list
echo "apt update"
sudo apt update

# Install Nginx
echo "INSTALL NGINX"
sudo apt install -y nginx

# Start and enable Nginx
echo "AUTO START NGINX"
sudo systemctl enable --now nginx

# Install MySQL server
echo "INSTALL MARIADB-SERVER"
sudo apt install -y mariadb-server

# Secure MySQL installation
echo "SECURE MARIADB"
sudo mysql_secure_installation

# Install PHP and required PHP extensions
echo "INSTALL PHP & REQUIRED PHP EXTENSION"
sudo apt install -y php-fpm php-mysql

# Configure Nginx to use PHP processor
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOL
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	# SSL configuration
	#
	# listen 443 ssl default_server;
	# listen [::]:443 ssl default_server;
	#
	# Note: You should disable gzip for SSL traffic.
	# See: https://bugs.debian.org/773332
	#
	# Read up on ssl_ciphers to ensure a secure configuration.
	# See: https://bugs.debian.org/765782
	#
	# Self signed certs generated by the ssl-cert package
	# Don't use them in a production server!
	#
	# include snippets/snakeoil.conf;

	root /var/www/html;

	# Add index.php to the list if you are using PHP
	index index.html index.php  index.htm index.nginx-debian.html;

	server_name _;

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		autoindex on;
		try_files $uri $uri/ =404;
	}

	# pass PHP scripts to FastCGI server
	#
	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
	#
	#	# With php-fpm (or other unix sockets):
		fastcgi_pass unix:/run/php/php8.2-fpm.sock;
	#	# With php-cgi (or other tcp sockets):
	#	fastcgi_pass 127.0.0.1:9000;
	}

	# deny access to .htaccess files, if Apache's document root
	# concurs with nginx's one
	#
	location ~ /\.ht {
	#	deny all;
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
sudo systemctl restart php8.2-fpm

# Print installation completion message
echo "LEMP stack installed successfully!"
