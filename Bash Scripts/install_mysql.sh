#!/bin/bash

read -p "Enter Username: " USERNAME
read -p "Enter Password: " PASSWORD

sudo apt install mysql-server php-mysql -y
sudo mysql -e "CREATE USER '$USERNAME'@'localhost' IDENTIFIED BY '$PASSWORD'" 
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$USERNAME'@'localhost' WITH GRANT OPTION"
sudo systemctl restart mysql;