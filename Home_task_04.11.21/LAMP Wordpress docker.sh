#!/bin/bash

# mysql root password
MRP=RooT321

# mysql user
MU=userwp

# mysql user password
MUP=uX6v8L3Db9

# mysql data base name
MDBN=wordpress_db

# container name
CN1=mariadb

# container name
CN2=wordpress_web


echo ""
echo "******* Welcome to installing Wodpress + MariaDB web-server on Docker for Debian 11 *********"
echo ""
echo "Press any key to continue"
read -n 1 -s -r -p ""
echo ""


echo "###############################################"
echo "   Updating packages and installing Docker     "
echo "###############################################"
apt update -y
apt install curl -y
curl -fsSL https://get.docker.com/ | sh
echo ""


echo ""
echo "###############################################"
echo "              Installing MariaDB               "
echo "###############################################"
docker pull mariadb
docker run -e MYSQL_ROOT_PASSWORD=$MRP -e MYSQL_USER=$MU -e MYSQL_PASSWORD=$MUP -e MYSQL_DATABASE=$MDBN -v /root/wordpress/database:/var/lib/mysql --name $CN1 -d mariadb
docker start mariadb
docker ps
echo ""

echo ""
echo "###############################################"
echo "             Installing WORDPRESS              "
echo "###############################################"
docker pull wordpress
docker run -e WORDPRESS_DB_USER=$MU -e WORDPRESS_DB_PASSWORD=$MUP -e WORDPRESS_DB_NAME=$MDBN -p 80:80 -v /root/wordpress/html:/var/www/html --link $CN1:mysql --name $CN2 -d wordpress
docker ps
echo ""
echo "###############################################"
echo "             Finish installing script          "
echo "###############################################"
