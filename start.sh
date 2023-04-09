#!/bin/bash

source ./config.sh

# API
## Prepare config files
echo "MYSQL_HOST=\"$DB_SSH_HOST\"
MYSQL_USER=\"api\"
MYSQL_PASS=\"toto\"
MYSQL_DB=\"groupie\"" > ./api/.env


ssh -p $API_SSH_PORT $API_SSH_USER@$API_SSH_HOST < ./api/api.sh
scp -P $API_SSH_PORT ./api/MusicAPI.sh $API_SSH_USER@$API_SSH_HOST:/home/api/MusicAPI.sh
scp -P $API_SSH_PORT ./api/.env $API_SSH_USER@$API_SSH_HOST:/home/api/MusicAPI/.env

# Reverse API
echo "server {
        server_name api.infra;

        listen 443 ssl;

        ssl_certificate /etc/pki/tls/certs/api.infra.crt;
        ssl_certificate_key /etc/pki/tls/private/api.infra.key;

        location / {
                # On définit des headers HTTP pour que le proxying se passe bien
                proxy_set_header  Host \$host;
                proxy_set_header  X-Real-IP \$remote_addr;
                proxy_set_header  X-Forwarded-Proto http;
                proxy_set_header  X-Forwarded-Host \$remote_addr;
                proxy_set_header  X-Forwarded-For \$proxy_add_x_forwarded_for;

                # On définit la cible du proxying
                proxy_pass http://$API_SSH_HOST:3000;
        }
}" > ./rev_api/musicapi.conf
ssh $REVERSE_API_SSH_USER@$REVERSE_API_SSH_HOST -p $REVERSE_API_SSH_PORT 'bash -s' < ./rev_api/rev_api.sh
scp -P $REVERSE_API_SSH_PORT ./rev_api/musicapi.conf $REVERSE_API_SSH_USER@$REVERSE_API_SSH_HOST:/etc/nginx/conf.d/musicapi.conf
ssh $REVERSE_API_SSH_USER@$REVERSE_API_SSH_HOST -p $REVERSE_API_SSH_PORT -e "systemctl start nginx"

# DB
scp -P $DB_SSH_PORT ./db/mysql_installation.sql $DB_SSH_USER@$DB_SSH_HOST:/tmp/mysql_installation.sql
ssh -p $DB_SSH_PORT $DB_SSH_USER@$DB_SSH_HOST < ./db/db.sh

ssh -p $API_SSH_PORT $API_SSH_USER@$API_SSH_HOST -e "systemctl start api"

ssh $WEB_SSH_USER@$WEB_SSH_HOST -p $WEB_SSH_PORT 'bash -s' < ./web_script/web_script.sh

ssh $REVERSE_WEB_SSH_USER@$REVERSE_WEB_SSH_HOST -p $REVERSE_WEB_SSH_PORT 'bash -s' < ./web_script/reverse_proxy_script.sh

ssh $MONITORING_SSH_USER@$MONITORING_SSH_HOST -p $MONITORING_SSH_PORT 'bash -s' < ./monitoring/script_monitoring.sh

#Node Exporter
scp -P $DB_SSH_PORT ./monitoring/user.sql $DB_SSH_USER@$DB_SSH_HOST:/tmp/user.sql
scp -P $DB_SSH_PORT ./monitoring/user2.sql $DB_SSH_USER@$DB_SSH_HOST:/tmp/user2.sql
ssh $DB_SSH_USER@$DB_SSH_HOST -p $DB_SSH_PORT 'bash -s' < ./monitoring/script_db_node_exporter.sh

ssh $WEB_SSH_USER@$WEB_SSH_HOST -p $WEB_SSH_PORT 'bash -s' < ./monitoring/script_node_exporter.sh

ssh $REVERSE_WEB_SSH_USER@$REVERSE_WEB_SSH_HOST -p $REVERSE_WEB_SSH_PORT 'bash -s' < ./monitoring/script_node_exporter.sh

ssh $API_SSH_USER@$API_SSH_HOST -p $API_SSH_PORT 'bash -s' < ./monitoring/script_node_exporter.sh

ssh $REVERSE_API_SSH_USER@$REVERSE_API_SSH_HOST -p $REVERSE_API_SSH_PORT 'bash -s' < ./monitoring/script_node_exporter.sh
