#!/bin/bash

dnf update -y
dnf upgrade -y
dnf autoremove -y

# Install mariadb
dnf install mariadb-server -y
systemctl enable mariadb --now

mysql -sfu root -proot < /tmp/mysql_installation.sql

rm /tmp/mysql_installation.sql

systemctl restart mariadb

firewall-cmd --permanent --add-port=3306/tcp
firewall-cmd --reload

exit