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

cat <<EOF > /etc/nginx/conf.d/default.conf
server {
  listen $PORT;
  gzip on;
  gzip_disable "msie6";
  index index.html;
  root $ROOT_PATH;
  location /healthz {
    access_log off;
    return 200;
    break;
  }
  location / {
    if (\$http_x_forwarded_proto != "https") {
      return 301 https://\$host\$request_uri;
    }
  }
}
EOF
cat /etc/nginx/conf.d/default.conf
nginx -g "daemon off;"