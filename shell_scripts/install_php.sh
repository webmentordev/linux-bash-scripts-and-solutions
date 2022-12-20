#!/bin/sh

#install php 7.x.x with supporting libraries for apache2
sudo apt-get install php libapache2-mod-php php-cgi wget php-cli php-zip unzip phpunit curl php-pear php-dev php-xml php-pdo php-common -y 

echo "PHP has been successfully Installed"
php -v