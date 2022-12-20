#!/bin/sh

##################################################################################
# Run this script as Root to Install All Necessary Tools
# You will have to comeplete some prompts so keep watch
# This script will not enable Firewall but only add ports to allow
# This script will install Create User, Apache2, PHP, MySQL (with User), FTP
##################################################################################

read -p "New User Username(lowercare): " USERNAME
read -p "MySQL SQL Root Password: " PASSWORD
read -p "Database For Wordpress(start with wp_): " DATABASE
APACHE_LOG_DIR = '${APACHE_LOG_DIR}'

# Install sudo
apt install sudo

#Install Common Packages Required
sudo apt update && sudo apt upgrade -y
sudo apt install wget curl zip unzip -y
# Create New User with Password
sudo adduser $USERNAME

#Install Apache2 and Open Ports
sudo apt-get install apache2 ufw net-tools -y
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow "Apache Full"

echo "\nApache 2 Has been Installed & Configured in Firewall\n"
systemctl status apache2 --no-pager

#Install PHP
sudo apt-get install php libapache2-mod-php php-cgi php-cli phpunit php-mbstring php-pear php-dev php-xml php-pdo php-common php-zip php-gd php-json php-curl -y 

#Install MySQL and Set Password for Root
sudo apt install mysql-server php-mysql -y
sudo mysql -e "CREATE DATABASE $DATABASE;"
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$PASSWORD';" 
sudo systemctl restart mysql;
echo "\nMySQL has been installed & Configured\n"

#Install phpMyAdmin
sudo apt install phpmyadmin -y
echo "\nPhpMyAdmin has been installed\n"

#Install FTP and OpenPorts
sudo apt install vsftpd
sudo systemctl status vsftpd
sudo systemctl enable --now vsftpd
sudo ufw allow 20/tcp
sudo ufw allow 21/tcp
sudo ufw allow 990/tcp
sudo ufw allow 5000:10000/tcp

#Download & Unzip Wordpress
cd /home/$USERNAME
wget -c https://wordpress.org/latest.zip -O wordpress.zip
unzip wordpress.zip
mv wordpress wordpress.com

# Setup Apache with Directory Access & VHost
cat >> /etc/apache2/apache2.conf <<EOF
<Directory /home/$USERNAME/wordpress.com/>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
</Directory>
EOF

cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/wordpress.com.conf
cat > /etc/apache2/sites-available/wordpress.com.conf <<EOF
<VirtualHost *:80>
    ServerAdmin wordpress@website.com
    ServerName wordpress.com
    ServerAlias www.wordpress.com
    DocumentRoot /home/$USERNAME/wordpress.com
EOF
cat >> /etc/apache2/sites-available/wordpress.com.conf <<- "EOF"
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# CHanging Ownerships & Permissions
chmod 755 /home/$USERNAME
chown -R www-data /home/$USERNAME/wordpress.com
a2dissite 000-default.conf
a2ensite wordpress.com.conf
systemctl restart apache2
echo "Wordpress Completely Setup!"