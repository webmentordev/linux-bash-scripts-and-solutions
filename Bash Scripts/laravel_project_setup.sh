#!/bin/bash

# ---- Update these values---
DOMAIN="" # Domain or subdomain without http E.g theprimehq.com or blog.theprimehq.com for Nginx config
WWW_DIR="laravel" # Directory in /var/www/ & Database file location | Lowercase
MYSQL_PORT=3306
PASSWORD=$(openssl rand -base64 24 | tr -dc 'A-Za-z0-9!@#%^&*()_+{}|:<>?' | head -c 16)

# ##############################################################
# Check for installed PHP version
if ! command -v php &> /dev/null; then
    echo "PHP is not installed on this system."
    exit 1
fi
PHP_VERSION=$(php -r 'echo PHP_VERSION;')
PHP=$(echo $PHP_VERSION | sed 's/\([0-9]*\.[0-9]*\).*/\1/')

# Verify if project already exists
if [ -d "/var/www/$WWW_DIR" ]; then
    echo "Error: Directory /var/www/$WWW_DIR already exists."
    exit 1
fi

# Verify if MYSQL port is not in use
if netstat -tuln 2>/dev/null | grep -q ":$MYSQL_PORT "; then
    echo "Error: Port $MYSQL_PORT is already in use."
    exit 1
fi
# ##############################################################

# Create Directory for clean setup
mkdir "${WWW_DIR}_db" && cd "${WWW_DIR}_db"

# Setup Nginx Config
cat > /etc/nginx/sites-available/${DOMAIN} << EOF
server {
    listen 80;
    server_name ${DOMAIN};
    root /var/www/${WWW_DIR}/public;
    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Content-Type-Options "nosniff";
    index index.html index.htm index.php;
    client_max_body_size 120M;
    charset utf-8;
    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }
    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }
    error_page 404 /index.php;
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php${PHP}-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
    location ~ /\.(?!well-known).* {
        deny all;
    }
}
EOF

sudo mkdir -p /var/www/${WWW_DIR} && sudo chown -R www-data:www-data /var/www/${WWW_DIR} && sudo chmod -R 755 /var/www/${WWW_DIR}
sudo ln -s /etc/nginx/sites-available/${DOMAIN} /etc/nginx/sites-enabled/
sudo systemctl restart nginx

# Create Docker Composer & run the file
touch compose.yml
cat > compose.yml <<EOF
services:
  ${WWW_DIR}_db:
    image: mysql
    restart: always
    environment:
      MYSQL_DATABASE: laravel_db
      MYSQL_USER: laravel
      MYSQL_PASSWORD: "$PASSWORD"
      MYSQL_ROOT_PASSWORD: "$PASSWORD"
    ports:
      - 127.0.0.1:$MYSQL_PORT:3306
    volumes:
      - ./db_${WWW_DIR}_data:/var/lib/mysql
EOF
docker compose up -d

echo "##################################################################"
echo "##################################################################"
echo "##########################IMPORTANT###############################"
echo "Set domain A record and run this command to setup SSL certificate"
echo "sudo certbot --nginx -d $DOMAIN"
echo "##################################################################"
echo "##################################################################"
echo "MYSQL Host        = 127.0.0.1:$MYSQL_PORT"
echo "MYSQL Password    = $PASSWORD"
echo "DATABSE Name      = laravel_db"
echo "DATABSE Username  = laravel"
echo "##############################################"
echo "##############################################"