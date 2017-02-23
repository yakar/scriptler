#!/bin/bash

#simple LEMP installer

# need root auth
if [ "$(id -u)" != "0" ]; then echo -e "[!] Must be run with root auth: sudo bash $0"; exit 1; fi

# check if nginx installed?
if [ ! -f /etc/nginx/sites-enabled/default ]; then
	echo "Your nginx is installed, not need this script."
	exit 1
fi

# update
apt update

# nginx, mysql, php7
apt install -y nginx nginx-extras mysql-server php7.0-fpm php7.0-mysql php7.0-mcrypt php7.0-gd php7.0-curl php7.0-xml

# mysql installation
mysql_secure_installation

# php conf
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.0/fpm/php.ini
systemctl restart php7.0-fpm

# nginx
mkdir /var/www/log
read -p "Web Server IP or Domain Name: " ipdomain
echo -e "
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        index index.php index.html;

        server_name $ipdomain;

        access_log  /var/www/log/access.log;
        error_log   /var/www/log/error.log;

        location / {
                try_files \$uri \$uri/ =404;
        }

        location ~ \.php$ {
                include snippets/fastcgi-php.conf;
                fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        }

        location ~ /\.ht {
                deny all;
        }

		client_max_body_size 10M;
		keepalive_timeout 10;
}
" > /etc/nginx/sites-enabled/default

# bonus: hide/change nginx header
sed -i 's/# server_tokens off;/ \
\t # change nginx header \
\t server_tokens off; \
\t more_set_headers "Server: Yakr\/3.5";/g' /etc/nginx/nginx.conf
#sed -i '/http {/a\
#	\t # hide/change nginx header \
#	\t server_tokens off; \
#	\t more_set_headers "Server: Yakr/3.5";' /etc/nginx/nginx.conf
systemctl reload nginx

echo '<?php phpinfo(); ?>' > /var/www/html/info.php

echo "[+] Finish.."