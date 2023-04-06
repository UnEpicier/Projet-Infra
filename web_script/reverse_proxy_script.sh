dnf check-update

dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install docker-compose-plugin -y

dnf install docker-ce docker-ce-cli containerd.io -y

systemctl start docker

systemctl enable docker

sudo usermod -aG docker $USER

echo "# For more information on configuration, see:
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
}" > nginx.conf

echo "server {
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
}" > example.com.conf

docker run --name reverse-proxy -p 80:80 -p 443:443 -v $PWD/nginx.conf:/etc/nginx/nginx.conf -v $PWD/example.com.conf:/etc/nginx/conf.d/example.com.conf -v ~/certs/:/etc/nginx/certs -d nginx