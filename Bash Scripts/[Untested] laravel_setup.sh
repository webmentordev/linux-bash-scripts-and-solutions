#!/bin/bash

MYSQL_PORT=3306
NODE_VERSION="22.14.0"
PASSWORD=$(openssl rand -base64 24 | tr -dc 'A-Za-z0-9!@#%^&*()_+{}|:<>?' | head -c 16)

# Create Directory for clean setup
mkdir setup && cd setup

# Install / Update Packages, Docker, Nginx & Certbot
sudo apt update && sudo apt upgrade -y && sudo apt install curl zip unzip wget nginx htop -y
curl -fsSL https://get.docker.com -o install-docker.sh && sudo sh install-docker.sh
sudo apt-get install certbot python3-certbot-nginx -y

# Install Composer
sudo apt install curl gpg gnupg2 software-properties-common ca-certificates apt-transport-https lsb-release -y && add-apt-repository ppa:ondrej/php && sudo apt update -y
sudo apt install php8.3 -y
sudo apt install php8.3-{cli,pdo,mysql,zip,gd,mbstring,curl,xml,bcmath,common,dev,pear,fpm} phpunit -y
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Install NodeJS
sudo apt-get install nodejs xz-utils tar -y
wget "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.xz"
sudo tar -xf node-v${NODE_VERSION}-linux-x64.tar.xz
sleep 3
cd node-v${NODE_VERSION}-linux-x64
sudo cp -r bin /usr/
sudo cp -r lib /usr/
sudo cp -r include /usr/
sudo cp -r share /usr/
echo "Node JS Downloaded, Installed and Updated to v${NODE_VERSION}"
node -v
cd ..
sudo rm -r node-v${NODE_VERSION}-linux-x64
rm node-v${NODE_VERSION}-linux-x64.tar.xz

# Create Docker Composer & run the file
touch compose.yml
cat > compose.yml <<EOF
services:
  db:
    image: mysql
    restart: always
    environment:
      MYSQL_DATABASE: laravel_db
      MYSQL_USER: laravel
      MYSQL_PASSWORD: "$PASSWORD"
      MYSQL_ROOT_PASSWORD: "$PASSWORD"
    ports:
      - $MYSQL_PORT:3306
    volumes:
      - ./db_data:/var/lib/mysql
volumes:
  db_data:
EOF
docker composer up -d


# Create Swap space
if swapon --show | grep -q '/swapfile'; then
  echo "Swap already exists at /swapfile"
else
  echo "Creating swap file..."
  sudo fallocate -l 2G /swapfile
  sudo chmod 600 /swapfile
  sudo mkswap /swapfile
  sudo swapon /swapfile
  if [ ! -f /etc/fstab.bak ]; then
    sudo cp /etc/fstab /etc/fstab.bak
  fi
  if ! grep -q '/swapfile' /etc/fstab; then
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab > /dev/null
  fi
  echo "Swap file created and activated."
fi

echo "##############################################"
echo "##############################################"
echo "MYSQL Host     = 127.0.0.1:$MYSQL_PORT"
echo "MYSQL Password = $PASSWORD"
echo "##############################################"
echo "##############################################"