#!/bin/bash
# notasecret
echo "just a simple example on how to install wordpress in a aws vm"

sudo apt-get update

# apache
sudo apt update && sudo apt install -y apache2
sudo systemctl stop apache2.service
sudo systemctl start apache2.service
sudo systemctl enable apache2.service

#maria db
sudo apt-get install mariadb-server mariadb-client -y
sudo systemctl stop mysql.service
sudo systemctl start mysql.service
sudo systemctl enable mysql.service

export DEBIAN_FRONTEND="noninteractive"
export PASSWORD=Sup3rS3cure777

sudo debconf-set-selections <<< 'mariadb-server mysql-server/root_password password Sup3rS3cure777'
sudo debconf-set-selections <<< 'mariadb-server mysql-server/root_password_again password Sup3rS3cure777'
sudo apt-get install -y mariadb-server
sudo mysql --user=root --password='Sup3rS3cure777' --execute='CREATE DATABASE wordpress;GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER ON wordpress.* TO wordpress@localhost IDENTIFIED BY "Sup3rS3cure777"; FLUSH PRIVILEGES;'

# instal PHP
sudo apt install php libapache2-mod-php php-mysql -y

# download and unzip wordpress
cd /tmp && wget https://wordpress.org/wordpress-6.4.3.tar.gz
tar -xzvf wordpress-6.4.3.tar.gz
sudo cp -R wordpress/* /var/www/html/
sudo rm /var/www/html/index.html
sudo chown www-data:www-data  -R /var/www/html/

sudo systemctl restart apache2.service