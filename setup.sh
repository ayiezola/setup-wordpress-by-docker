#!/bin/bash
#Created by github.com/ayiezola
#Simple script install wordpress using docker image

#Password
echo "Hye boss,"
echo "This password will be use while setting up MariaDB and Wordpress."
echo "Please input your password:"
read password

#Update
apt-get update

#install docker
apt-get install docker.io -y

#Download MariaDB docker image from repo
docker pull mariadb

#Download Wordpress docker image from repo
docker pull wordpress

#Create docker volume to store the MariaDB persistence data
#You can verify the persistent data directory
#docker volume inspect mariadb-data
#CreateaAt,Driver,Labels,MountPoint,Name,Options,Scope
docker volume create mariadb-data

#Create Folder
mkdir mariadb
mkdir wordpress

#Create a symbolic link to an easier access location
ls -s /var/lib/docker/volumes/mariadb-data/_data /mariadb

#Start a MariaDB container with persistent data storage
#This command will crete as follow:
#Database root password
#Database named wordpress
#Database account named wordpress and password
docker run -d --name wordpressdb -v mariadb-data:/var/lib/mysql -e "MYSQL_ROOT_PASSWORD=$password" -e MYSQL_USER=wordpress -e "MYSQL_PASSWORD=$password" -e "MYSQL_DATABASE=wordpress" mariadb

#Create docker volume to store Wordpress persistent data
docker volume create wordpress-data

#To verify your persistent data directory, use this command:
#docker volume inspect wordpress-data

#Create a symbolic link to an easier access location
ls -s /var/lib/docker/volumes/wordpress-data/_data /wordpress

#Start a wordpress container with persistent data storage
docker run -d --name wordpress -p 80:80 -v wordpress-data:/var/www/html --link wordpressdb:mysql -e WORDPRESS_DB_USER=wordpress -e "WORDPRESS_DB_PASSWORD=$password" -e WORDPRESS_DB_NAME=wordpress wordpress


#Finish
#You installation interface will be available by using your IP/DOmain:
echo "Your Public IP is :"
curl ifconfig.me
echo " "

echo "Your local IP is:"
ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
echo " "




