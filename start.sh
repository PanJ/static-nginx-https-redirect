#!/bin/sh

# From https://github.com/MorbZ/docker-web-redirect

if [ -z "$PORT" ]; then
	echo "Defaulting port to 80"
	PORT=80
fi

if [ -z "$ROOT_PATH" ]; then
	echo "Root path not set (ROOT_PATH)"
	exit 1
fi

SPA_CONFIG=""
if [ "$SPA" = "true" ]; then
	SPA_CONFIG="try_files $uri $uri/ /index.html;"
fi

cat <<EOF > /etc/nginx/conf.d/default.conf
server {
  listen $PORT;
  port_in_redirect off;
  gzip on;
  gzip_disable "msie6";
  gzip_vary on;
  gzip_proxied any;
  gzip_comp_level 6;
  gzip_buffers 16 8k;
  gzip_http_version 1.1;
  gzip_min_length 256;
  gzip_types text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript application/vnd.ms-fontobject application/x-font-ttf font/opentype image/svg+xml image/x-icon;
  
  index index.html;
  location /healthz {
    access_log off;
    return 200;
    break;
  }
  location / {
    if (\$http_x_forwarded_proto != "https") {
      return 301 https://\$host\$request_uri;
    }
    root $ROOT_PATH;
    $SPA_CONFIG
  }
}
EOF
nginx -g "daemon off;"