#!/bin/bash

dnf module install -y nodejs
dnf install -y git

useradd -m api -s /usr/sbin/nologin
cd /home/api
git clone https://github/com/UnEpicier/MusicAPI.git
cd MusicAPI
npm i

firewall-cmd --zone=public --add-port=3000/tcp --permanent
firewall-cmd --reload

echo "[Unit]
Description=Music API
After=network.target

[Service]
Type=simple
User=api
WorkingDirectory=/home/api/MusicAPI
ExecStart=/home/api/MusicAPI.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target" << EOF > /etc/systemd/system/musicapi.service

systemctl daemon-reload
systemctl enable musicapi --now

exit