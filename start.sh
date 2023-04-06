#!/bin/bash

source ./config.sh

# API
## Prepare config files
echo "MYSQL_HOST=\"$DB_SSH_HOST\"
MYSQL_USER=\"api\"
MYSQL_PASS=\"toto\"
MYSQL_DB=\"groupie\"" << EOF > ./api/.env

ssh -p $API_SSH_PORT $API_SSH_USER@$API_SSH_HOST < ./api/api.sh
scp -P $API_SSH_PORT ./api/.env $API_SSH_USER@$API_SSH_HOST:/home/api/MusicAPI/.env

ssh $REVERSE_API_SSH_USER@$REVERSE_API_SSH_HOST -p $REVERSE_API_SSH_PORT 'bash -s' < ./rev_api/rev_api.sh

# DB
scp -P $DB_SSH_PORT ./db/mysql_installation.sql $DB_SSH_USER@$DB_SSH_HOST:/tmp/mysql_installation.sql
ssh -p $DB_SSH_PORT $DB_SSH_USER@$DB_SSH_HOST < ./db/db.sh

ssh -p $API_SSH_PORT $API_SSH_USER@$API_SSH_HOST "cd /home/api/MusicAPI && npm start"
ssh $DB_SSH_USER@$DB_SSH_HOST -p $DB_SSH_PORT 'bash -s' < ./scripts/db.sh

ssh $WEB_SSH_USER@$WEB_SSH_HOST -p $WEB_SSH_PORT 'bash -s' < ./web_script/web_script.sh

ssh $REVERSE_WEB_SSH_USER@$REVERSE_WEB_SSH_HOST -p $REVERSE_WEB_SSH_PORT 'bash -s' < ./web_script/reverse_proxy_script.sh

ssh $MONITORING_SSH_USER@$MONITORING_SSH_HOST -p $MONITORING_SSH_PORT 'bash -s' < ./monitoring/script_monitoring.sh

ssh $DB_SSH_USER@$DB_SSH_HOST -p $DB_SSH_PORT 'bash -s' < ./monitoring/script_db_node_exporter.sh

#Node Exporter

ssh $WEB_SSH_USER@$WEB_SSH_HOST -p $WEB_SSH_PORT 'bash -s' < ./monitoring/script_node_exporter.sh

ssh $REVERSE_WEB_SSH_USER@$REVERSE_WEB_SSH_HOST -p $REVERSE_WEB_SSH_PORT 'bash -s' < ./monitoring/script_node_exporter.sh

ssh $API_SSH_USER@$API_SSH_HOST -p $API_SSH_PORT 'bash -s' < ./monitoring/script_node_exporter.sh

ssh $REVERSE_API_SSH_USER@$REVERSE_API_SSH_HOST -p $REVERSE_API_SSH_PORT 'bash -s' < ./monitoring/script_node_exporter.sh
