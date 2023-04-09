#!/bin/bash

dnf install wget -y

wget https://github.com/prometheus/prometheus/releases/download/v2.13.1/prometheus-2.13.1.linux-amd64.tar.gz
tar xzf prometheus-2.13.1.linux-amd64.tar.gz
mv prometheus-2.13.1.linux-amd64/ /usr/share/prometheus
useradd -u 3434 -d /usr/share/prometheus -s /bin/false prometheus
mkdir -p /var/lib/prometheus/data
chown prometheus:prometheus /var/lib/prometheus/data
chown -R prometheus:prometheus /usr/share/prometheus
/usr/share/prometheus/prometheus --config.file=/usr/share/prometheus/prometheus.yml
echo "[Unit]
Description=Prometheus Server
Documentation=https://prometheus.io/docs/introduction/overview/
After=network-online.target

[Service]
User=prometheus
Restart=on-failure
WorkingDirectory=/usr/share/prometheus
ExecStart=/usr/share/prometheus/prometheus --config.file=/usr/share/prometheus/prometheus.yml

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/prometheus.service
firewall-cmd --add-port=9090/tcp --permanent
firewall-cmd --reload

echo "# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label \`job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['localhost:9090', '10.107.1.10:9100', '10.107.1.11:9100', '10.107.1.11:9104', '10.107.1.13:9100', '10.107.1.14:9100', '10.107.1.15:9100']" > /usr/share/prometheus/prometheus.yml
systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus
groupadd --system prometheus
useradd -s /sbin/nologin --system -g prometheus prometheus

echo "[grafana]\
name=grafana\
baseurl=https://packages.grafana.com/oss/rpm\
repo_gpgcheck=1\
enabled=1\
gpgcheck=1\
gpgkey=https://packages.grafana.com/gpg.key\
sslverify=1\
sslcacert=/etc/pki/tls/certs/ca-bundle.crt" > /etc/yum.repos.d/grafana.repo

dnf install grafana
systemctl start grafana-server

echo "[grafana]\
name=grafana\
baseurl=https://packages.grafana.com/oss/rpm\
repo_gpgcheck=1\
enabled=1\
gpgcheck=1\
gpgkey=https://packages.grafana.com/gpg.key\
sslverify=1\
sslcacert=/etc/pki/tls/certs/ca-bundle.crt" > /etc/yum.repos.d/grafana.repo

dnf install grafana
systemctl start grafana-server