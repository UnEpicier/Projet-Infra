# Mise en place de l'interface Graphique API

Nous avons développé une interface graphique pour que l'utilisation de l'API soit facilité

>  ## Installation de Nodejs

```sh
[toto@web ~]$ sudo dnf module install nodejs
[sudo] password for toto:
Last metadata expiration check: 0:10:57 ago on Fri Mar  3 11:51:00 2023.
Dependencies resolved.
[...]
Installed:
  nodejs-1:18.12.1-1.module+el9.1.0+13234+90e40c60.x86_64
  nodejs-docs-1:18.12.1-1.module+el9.1.0+13234+90e40c60.noarch
  nodejs-full-i18n-1:18.12.1-1.module+el9.1.0+13234+90e40c60.x86_64
  npm-1:8.19.2-1.18.12.1.1.module+el9.1.0+13234+90e40c60.x86_64

Complete!
```

> ## Installation de Git

```sh
[toto@web ~]$ sudo dnf install git
[sudo] password for toto:
Last metadata expiration check: 0:31:47 ago on Fri Mar  3 11:51:00 2023.
Dependencies resolved.
[...]
  perl-overloading-0.02-479.el9.noarch                       perl-parent-1:0.238-460.el9.noarch
  perl-podlators-1:4.14-460.el9.noarch                       perl-subs-1.03-479.el9.noarch
  perl-vars-1.05-479.el9.noarch

Complete!
```

> ## Récupération de l'interface graphique de l'API sur un repos sur Github

```sh
[toto@web ~]$ git clone https://github.com/UnEpicier/MusicAPI-Int.git
Cloning into 'MusicAPI-Int'...
remote: Enumerating objects: 199, done.
remote: Counting objects: 100% (199/199), done.
remote: Compressing objects: 100% (124/124), done.
remote: Total 199 (delta 73), reused 172 (delta 49), pack-reused 0
Receiving objects: 100% (199/199), 82.70 KiB | 830.00 KiB/s, done.
Resolving deltas: 100% (73/73), done.
```

> ## Installation des paquets de NodeJs

```sh
[toto@web ~]$ cd MusicAPI-Int/

# On met à jour NodeJS
[toto@web MusicAPI-Int]$ sudo npm install -g npm@latest

added 1 package, and audited 236 packages in 5s

16 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities

#Installation des paquets de NodeJs
[toto@web MusicAPI-Int]$ npm i

added 353 packages, and audited 354 packages in 41s

52 packages are looking for funding
  run `npm fund` for details

found 0 vulnerabilities
```

> ## Ouverture du port dans le firewall

```sh
[toto@web MusicAPI-Int]$ sudo firewall-cmd --add-port=3000/tcp --permanent
success
[toto@web MusicAPI-Int]$ sudo firewall-cmd --reload
success
```

> ## Création du service

```sh
[toto@web MusicAPI-Int]$ sudo vim /etc/systemd/system/api.service
[toto@web MusicAPI-Int]$ cat /etc/systemd/system/api.service
[Unit]
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
WantedBy=multi-user.target
```

> ## Mise en place du service

```sh
[toto@web MusicAPI-Int]$ sudo systemctl daemon-reload

[toto@web MusicAPI-Int]$ sudo systectctl enable api --now

[toto@web MusicAPI-Int]$ sudo systemctl status api
● api.service - Start API
     Loaded: loaded (/etc/systemd/system/api.service; enabled; vendor preset: disabled)
     Active: active (running) since Fri 2023-03-03 12:52:00 CET; 2min 36s ago
   Main PID: 17602 (npm run dev)
      Tasks: 73 (limit: 11081)
     Memory: 354.8M
        CPU: 13.510s
     CGroup: /system.slice/api.service
             ├─17602 "npm run dev"
             ├─17613 node /home/toto/MusicAPI-Int/node_modules/.bin/concurrently nodemon "n>
             ├─17620 node /home/toto/MusicAPI-Int/node_modules/.bin/nodemon
             ├─17621 "npm run css"
             ├─17639 "npm exec ts-node src/app.ts"
             ├─17651 node /home/toto/MusicAPI-Int/node_modules/.bin/sass --watch ./src/scss>
             └─17692 node /home/toto/MusicAPI-Int/node_modules/.bin/ts-node src/app.ts

Mar 03 12:52:47 web.infra npm[17613]: [0] GET /css/pages/auth.css 304 6.925 ms - -
Mar 03 12:52:47 web.infra npm[17613]: [0] GET /login 304 4.207 ms - -
Mar 03 12:52:47 web.infra npm[17613]: [0] GET /css/global/fonts.css 304 1.752 ms - -
Mar 03 12:52:47 web.infra npm[17613]: [0] GET /css/global/globals.css 304 2.676 ms - -
Mar 03 12:52:47 web.infra npm[17613]: [0] GET /css/pages/auth.css 304 4.498 ms - -
Mar 03 12:52:50 web.infra npm[17613]: [0] GET / 304 191.133 ms - -
Mar 03 12:52:50 web.infra npm[17613]: [0] GET /css/global/fonts.css 304 1.866 ms - -
Mar 03 12:52:50 web.infra npm[17613]: [0] GET /css/global/globals.css 304 2.783 ms - -
Mar 03 12:52:50 web.infra npm[17613]: [0] GET /css/pages/index.css 304 3.464 ms - -
Mar 03 12:52:50 web.infra npm[17613]: [0] GET /js/index.js 304 1.096 ms - -
```

> ## Vérification

```sh
#Executé sur ma machine pas sur la vm
$ curl http://10.107.1.10:3000
<!DOCTYPE html>
<html lang="en">
        <head>
                <meta charset="UTF-8" />
                <meta http-equiv="X-UA-Compatible" content="IE=edge" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title> Music API </title>
```


# Mise en place du reverse proxy à l'aide de de Docker

> ## Installation de Docker

```sh
[toto@reverse ~]$ sudo dnf check-update

[toto@reverse ~]$ sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

[toto@reverse ~]$ sudo dnf install docker-compose-plugin -y

[toto@reverse ~]$ sudo dnf install docker-ce docker-ce-cli containerd.io -y

[toto@reverse ~]$ sudo systemctl start docker

[toto@reverse ~]$ sudo systemctl enable docker

[toto@reverse ~]$ sudo usermod -aG docker $USER

[toto@reverse ~]$ vim nginx.conf

[toto@reverse ~]$ cat nginx.conf

# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;
# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
   # for more information.
    include /etc/nginx/conf.d/*.conf;





   server {
  listen 80 default_server;
  listen [::]:80 default_server;

  listen [::]:443 default_server;
  ssl_reject_handshake on;

  server_name _;
  return 404;
}
}

[toto@reverse ~]$ vim example.com.conf

[toto@reverse ~]$ cat example.com.conf
server {
   listen 443 ssl;
   server_name example.com;

   ssl_certificate /etc/nginx/certs/self-signed.crt;
   ssl_certificate_key /etc/nginx/certs/self-signed.key;

   location / {
        proxy_pass http://10.107.1.10:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header  X-Forwarded-Proto http;
        proxy_set_header  X-Forwarded-Host $remote_addr;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
   }
}
```

> ## Lancement du container

```sh
toto@reverse ~]$ sudo docker run --name reverse-proxy -p 80:80 -p 443:443 -v $PWD/nginx.conf:/etc/nginx/nginx.conf -v $PWD/example.com.conf:/etc/nginx/conf.d/example.com.conf -v ~/certs/:/etc/nginx/certs -d nginx
```
