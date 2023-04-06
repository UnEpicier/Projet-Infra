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

# DB
scp -P $DB_SSH_PORT ./db/mysql_installation.sql $DB_SSH_USER@$DB_SSH_HOST:/tmp/mysql_installation.sql
ssh -p $DB_SSH_PORT $DB_SSH_USER@$DB_SSH_HOST < ./db/db.sh

ssh -p $API_SSH_PORT $API_SSH_USER@$API_SSH_HOST "cd /home/api/MusicAPI && npm start"