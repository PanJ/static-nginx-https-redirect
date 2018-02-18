#!/bin/sh

# From https://github.com/MorbZ/docker-web-redirect

if [ -z "$REDIRECT_TARGET" ]; then
	echo "Redirect target variable not set (REDIRECT_TARGET)"
	exit 1
fi

if [ -z "$ROOT_PATH" ]; then
	echo "Root path not set (ROOT_PATH)"
	exit 1
fi

# Add https if not set
if ! [[ $REDIRECT_TARGET =~ ^https?:// ]]; then
  REDIRECT_TARGET="https://$REDIRECT_TARGET"
fi

# Add trailing slash
if [[ ${REDIRECT_TARGET:length-1:1} != "/" ]]; then
  REDIRECT_TARGET="$REDIRECT_TARGET/"
fi

echo "Redirecting HTTP requests to ${REDIRECT_TARGET}..."

cat <<EOF > /etc/nginx/conf.d/default.conf
server {
	listen 80;
  gzip on;
  gzip_disable "msie6";
  root $ROOT_PATH
  location / {
    if ($http_x_forwarded_proto != "https") {
      rewrite ^(.*)$ $REDIRECT_TARGET\$1 permanent;
    }
  }
}
EOF

nginx -g "daemon off;"