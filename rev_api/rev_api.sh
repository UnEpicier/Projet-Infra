#!/bin/bash

dnf update -y
dnf upgrade -y
dnf autoremove -y

dnf install epel-release -y
dnf install nginx certbot python3-certbot-nginx -y
systemctl enable nginx

cd /root
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -subj "/C=FR/ST=France/L=Paris/O=42/CN=api.infra" -keyout api.infra.key  -out api.infra.crt
mv api.infra.crt /etc/pki/tls/certs/
mv api.infra.key /etc/pki/tls/private/

firewall-cmd --permanent --add-service=https
firewall-cmd --reload

#Pour le monitoring
firewall-cmd --add-port=9100/tcp --permanent

exit