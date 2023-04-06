#!/bin/bash

dnf update -y
dnf upgrade -y
dnf autoremove -y

dnf module install nodejs -y

dnf install git

git clone https://github.com/UnEpicier/MusicAPI-Int.git

cd MusicAPI-Int/

npm install -g npm@latest

npm i

firewall-cmd --add-port=3000/tcp --permanent

firewall-cmd --reload



echo "[Unit]
Description=Start API
Wants=network.target
After=syslog.target network-online.target

[Service]
ExecStart=npm run dev
WorkingDirectory=/home/toto/MusicAPI-Int/
User=toto
Type=Oneshot
Restart=on-failure

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/api.service

systemctl daemon-reload

systemtctl enable api --now