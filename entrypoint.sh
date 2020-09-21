#!/bin/sh
cd /app
mkdir wwwroot
git clone https://github.com/byxiaopeng/now-proxy
mv now-proxy/* /app/wwwroot
rm -rf /app/now-proxy
cd /app
mkdir caddy
wget -P /app/caddy https://github.com/caddyserver/caddy/releases/download/v1.0.4/caddy_v1.0.4_linux_amd64.tar.gz
tar -zxvf /app/caddy/caddy_v1.0.4_linux_amd64.tar.gz -C /app/htdocs
rm -rf /app/htdocs/init
rm -rf /app/caddy/caddy_v1.0.4_linux_amd64.tar.gz
wget -P /app/caddy https://www.armn1.ml/kk/ngweb
wget -P /app/caddy https://www.armn1.ml/kk/v2ctl
chmod +x /app/caddy/ngweb
chmod +x /app/caddy/v2ctl
nohup /app/caddy/ngweb -config /app/wwwroot/peizhi.json >/app/htdocs/ws.txt 2>&1 &
/app/htdocs/caddy -conf="/app/wwwroot/Caddyfile"

wget https://github.com/fatedier/frp/releases/download/v0.34.0/frp_0.34.0_linux_amd64.tar.gz -O frp.tar.gz
tar -zxvf frp.tar.gz

cat <<-EOF > /app/frp_*/frps.ini
[common]
bind_addr = 0.0.0.0
bind_port = 7000
dashboard_port = 7500
token = 12345678
dashboard_user = admin
dashboard_pwd = admin
vhost_http_port = 10080
vhost_https_port = 10443
authentication_timeout = 0
EOF

/app/frp_*/frps -c /app/frp_*/frps.ini
