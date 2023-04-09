#!/bin/bash

dnf update -y
dnf upgrade -y
dnf autoremove -y

dnf install epel-release -y
dnf install nginx certbot python3-certbot-nginx -y
systemctl enable nginx --now

cd /root
openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -subj "/C=FR/ST=France/L=Paris/O=42/CN=api.infra" -keyout api.infra.key  -out api.infra.crt
mv api.infra.crt /etc/pki/tls/certs/
mv api.infra.key /etc/pki/tls/private/

echo "server {
        server_name api.infra;

        listen 443 ssl;

        ssl_certificate /etc/pki/tls/certs/api.infra.crt;
        ssl_certificate_key /etc/pki/tls/private/api.infra.key;

        location / {
                # On définit des headers HTTP pour que le proxying se passe bien
                proxy_set_header  Host $host;
                proxy_set_header  X-Real-IP $remote_addr;
                proxy_set_header  X-Forwarded-Proto http;
                proxy_set_header  X-Forwarded-Host $remote_addr;
                proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;

                # On définit la cible du proxying
                proxy_pass http://$API_SSH_HOST:3000;
        }
}" > /etc/nginx/conf.d/musicapi.conf

systemctl restart nginx

firewall-cmd --permanent --add-service=https
firewall-cmd --reload

#Pour le monitoring
firewall-cmd --add-port=9100/tcp --permanent

exit