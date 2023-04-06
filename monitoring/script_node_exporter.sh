#!/bin/bash
curl -LO "https://github.com/prometheus/node_exporter/releases/download/v1.2.2/node_exporter-1.2.2.linux-amd64.tar.gz"
tar xvfz node_exporter-1.2.2.linux-amd64.tar.gz
cp node_exporter-1.2.2.linux-amd64/node_exporter /usr/local/bin/
chmod +x /usr/local/bin/node_exporter
useradd --no-create-home --shell /bin/false node_exporter
echo "[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/node_exporter.service
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter