#!/bin/bash

DB=wordpress
USER=userwp
PASS=uX6v8L3Db9
PASSWORDROOT=M3LaP3is46


echo ""
echo "******* Welcome to installing LAMP + Wodpress SSL web-server for Debian 11 *********"
echo ""
echo "Press any key to continue"
read -n 1 -s -r -p ""
echo ""
echo "************************"
echo "Preparring for install"
echo "************************"
echo ""
apt update
apt -y upgrade
echo ""
echo "************************"
echo "Preparring is end"
echo "************************"
echo ""
echo ""


echo "************************"
echo "Preparring for install MariaDB"
echo "************************"
apt -y install software-properties-common gnupg2
apt-key adv --recv-keys --keyserver keyserver.ubuntexu.com 0xF1656F24C74CD1D8
add-apt-repository "deb [arch=amd64] http://mariadb.mirror.liquidtelecom.com/repo/10.5/debian $(lsb_release -cs) main"
echo "************************"
echo "Preparring is end"
echo "************************"
echo ""

echo "************************"
echo "Istalling MariaDB"
echo "************************"
apt update
apt install -y mariadb-server mariadb-client
echo "************************"
echo "Installing is end"
echo "************************"
echo ""

echo "************************"
echo "Secure Installation for MariaDB"
echo "************************"
sudo mariadb -u root -e "CREATE USER 'root'@'$localhost' IDENTIFIED BY '$PASSWORDROOT';"
sudo mariadb -u root -p${PASSWORDROOT} -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mariadb -u root -p${PASSWORDROOT} -e "DELETE FROM mysql.user WHERE User='';"
sudo mariadb -u root -p${PASSWORDROOT} -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';"
sudo mariadb -u root -p${PASSWORDROOT} -e "FLUSH PRIVILEGES;"
echo "************************"
echo "Configuring MariaDB is end"
echo "************************"
echo ""
echo ""

echo "********************************************"
echo "Creating and configuring DB for wordpress"
echo "********************************************"
sudo mariadb -u root -p${PASSWORDROOT} -e "CREATE DATABASE $DB;"
sudo mariadb -u root -p${PASSWORDROOT} -e "GRANT ALL ON $DB.* TO '$USER'@'localhost' IDENTIFIED BY '$PASS';"
sudo mariadb -u root -p${PASSWORDROOT} -e "GRANT ALL PRIVILEGES ON $DB.* TO '$USER'@'localhost';"
sudo mariadb -u root -p${PASSWORDROOT} -e "SHOW DATABASES;"
echo "************************"
echo "Creating and configuring DB is end"
echo "************************"
echo ""
echo ""

echo "********************************************"
echo "Installing PHP mods, libraries"
echo "********************************************"
apt install php7.4 php7.4-mysql libapache2-mod-php7.4 php7.4-cli php7.4-cgi php7.4-gd -y
echo "************************"
echo "Installing is end"
echo "************************"
echo ""

echo "********************************************"
echo "Downloading, installing and configuring Wordpress"
echo "********************************************"
cd /tmp/
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
rsync -av wordpress/* /var/www/html/
chown -R www-data:www-data /var/www/html/
chmod -R 755 /var/www/html/
rm /var/www/html/index.html
echo "***********************************"
echo "Installing and configuring is end"
echo "***********************************"
echo ""


echo "********************************************"
echo "Configuring ssl certificate for Wordpress"
echo "********************************************"
apt-get install openssl -y
openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout /etc/ssl/private/localhost.key -out /etc/ssl/certs/localhost.crt -subj "/C=SI/ST=Ukraine/L=Ukraine/O=Security/OU=Home/CN=www.example.com"
mv /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.old
touch /etc/apache2/sites-available/default-ssl.conf
echo "
<IfModule mod_ssl.c>
	<VirtualHost _default_:443>
		ServerAdmin webmaster@localhost

		DocumentRoot /var/www/html


		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined

		SSLEngine on


		SSLCertificateFile	/etc/ssl/certs/localhost.crt
		SSLCertificateKeyFile /etc/ssl/private/localhost.key

		<FilesMatch !\.(cgi|shtml|phtml|php)#!>
				SSLOptions +StdEnvVars
		</FilesMatch>
		<Directory /usr/lib/cgi-bin>
				SSLOptions +StdEnvVars
		</Directory>


	</VirtualHost>
</IfModule>" > /etc/apache2/sites-available/default-ssl.conf

sed -i 's/!/"/g' /etc/apache2/sites-available/default-ssl.conf
sed -i 's/#/$/g' /etc/apache2/sites-available/default-ssl.conf
a2enmod ssl
a2ensite default-ssl
service apache2 reload

echo "************************"
echo "Configuring SSL is end"
echo "************************"
echo ""

echo "************************"
echo "This script is finish"
echo "************************"
echo ""
