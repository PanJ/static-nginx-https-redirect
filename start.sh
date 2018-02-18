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
  location /healthz {
    access_log off;
    return 200;
  }
  if (\$http_x_forwarded_proto != "https") {
    return 301 https://\$server_name\$request_uri;
  }
  root $ROOT_PATH;
}
EOF

nginx -g "daemon off;"