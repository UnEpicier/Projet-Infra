#!/bin/bash

sudo dnf update -y
sudo dnf upgrade -y
sudo dnf autoremove -y

# Install mariadb
sudo dnf install mariadb-server -y
sudo systemctl enable mariadb --now

mysql -sfu root -ptoto < /tmp/mysql_installation.sql

sudo rm /tmp/mysql_installation.sql

exit