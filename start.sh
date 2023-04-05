#!/bin/bash

source ./config.sh

scp -P $DB_SSH_PORT ./scripts/mysql_installation.sql $DB_SSH_USER@$DB_SSH_HOST:/tmp

ssh $DB_SSH_USER@$DB_SSH_HOST -p $DB_SSH_PORT 'bash -s' < ./scripts/db.sh