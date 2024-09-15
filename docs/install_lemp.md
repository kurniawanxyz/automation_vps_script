# Dokumentasi Install Lemp

## Sesuaikan versi php di nginx
```bash
sudo vim /etc/nginx/sites-available/default
```

lalu


```bash
## cari baris dibawah ini lalu sesuaikan versi phpnya
  fastcgi_pass unix:/run/php/php8.2-fpm.sock;
```

lalu 
```bash
sudo systemctl restart nginx
```

