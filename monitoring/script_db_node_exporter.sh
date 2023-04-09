#!/bin/bash

dnf install wget -y

groupadd --system prometheus
useradd -s /sbin/nologin --system -g prometheus prometheus
curl -s https://api.github.com/repos/prometheus/mysqld_exporter/releases/latest   | grep browser_download_url   | grep linux-amd64 | cut -d '"' -f 4   | wget -qi -
tar xvf mysqld_exporter*.tar.gz
mv  mysqld_exporter-*.linux-amd64/mysqld_exporter /usr/local/bin/
chmod +x /usr/local/bin/mysqld_exporter
mysql -sfu root -ptoto < /tmp/user.sql
rm /tmp/user.sql
echo "[client]
user=mysqld_exporter
password=toto" > /etc/.mysqld_exporter.cnf
chown root:prometheus /etc/.mysqld_exporter.cnf
echo "[Unit]
Description=Prometheus MySQL Exporter
After=network.target
User=prometheus
Group=prometheus

[Service]
Type=simple
Restart=always
ExecStart=/usr/local/bin/mysqld_exporter \
--config.my-cnf /etc/.mysqld_exporter.cnf \
--collect.global_status \
--collect.info_schema.innodb_metrics \
--collect.auto_increment.columns \
--collect.info_schema.processlist \
--collect.binlog_size \
--collect.info_schema.tablestats \
--collect.global_variables \
--collect.info_schema.query_response_time \
--collect.info_schema.userstats \
--collect.info_schema.tables \
--collect.perf_schema.tablelocks \
--collect.perf_schema.file_events \
--collect.perf_schema.eventswaits \
--collect.perf_schema.indexiowaits \
--collect.perf_schema.tableiowaits \
--collect.slave_status \
--web.listen-address=0.0.0.0:9104  #127.0.0.1

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/mysql_exporter.service
systemctl daemon-reload
systemctl enable mysql_exporter
systemctl start mysql_exporter
wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.13.0/mysqld_exporter-0.13.0.linux-amd64.tar.gz
tar xvf mysqld_exporter-0.13.0.linux-amd64.tar.gz
mv mysqld_exporter-0.13.0.linux-amd64/mysqld_exporter /usr/local/bin/
mysql -sfu root -ptoto < /tmp/user2.sql
rm /tmp/user2.sql
echo "ARGS="--collect.global_status --collect.global_variables --collect.engine_innodb_status --collect.info_schema.innodb_metrics --collect.info_schema.processlist --web.listen-address=:9104 --web.telemetry-path=/metrics"" > /etc/sysconfig/mysqld_exporter