#!/bin/bash

source ./config.sh

scp -P $DB_SSH_PORT ./scripts/mysql_installation.sql $DB_SSH_USER@$DB_SSH_HOST:/tmp

ssh $DB_SSH_USER@$DB_SSH_HOST -p $DB_SSH_PORT 'bash -s' < ./scripts/db.sh

ssh $WEB_SSH_USER@$WEB_SSH_HOST -p $WEB_SSH_PORT 'bash -s' < ./web_script/web_script.sh

ssh $REVERSE_WEB_SSH_USER@$REVERSE_WEB_SSH_HOST -p $REVERSE_WEB_SSH_PORT 'bash -s' < ./web_script/reverse_proxy_script.sh