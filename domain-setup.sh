#!/bin/bash

#1. add A record in the DNS

echo "__ Domain Setup Bash Script"

read -p "__ Domain Name ? " DOMAIN_NAME
read -p "__ Add The WWW version too ? (y/N) " ADD_WWW_VERSION
read -p "__ The App Port ? " APP_PORT

SERVER_NAME="$DOMAIN_NAME"
if [ "$ADD_WWW_VERSION" == "y" ]
then
	SERVER_NAME="$DOMAIN_NAME www.$DOMAIN_NAME"
fi

echo "__ Removing The Default Server File in sites-enabled"
sudo [ -e /etc/nginx/sites-enabled/default ] && sudo rm /etc/nginx/sites-enabled/default

if [ -f "/etc/nginx/sites-available/$DOMAIN_NAME" ]
then
	echo "__ Domain Already Exist !"
else
	echo "__ Adding site file to sites-available"
	sudo echo "
upstream $DOMAIN_NAME{
	server 127.0.0.1:$APP_PORT;
	keepalive 64;
}

server {
	listen 80;
	listen [::]:80;

	server_name $SERVER_NAME;

	location / {
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_set_header X-Real-IP \$remote_addr;
		proxy_set_header Host \$http_host;

		proxy_http_version 1.1;
		proxy_set_header Upgrade \$http_upgrade;
		proxy_set_header Connection \"up grade\";

		proxy_pass http://$DOMAIN_NAME/;
		proxy_redirect off;
		proxy_read_timeout 240s;
	}
}
	" >> /etc/nginx/sites-available/$DOMAIN_NAME

	echo "__ Creating Link in sites-enabled"
	sudo ln -s /etc/nginx/sites-available/$DOMAIN_NAME /etc/nginx/sites-enabled/

	echo "__ Checking Nginx"
	sudo nginx -t

	echo "__ Restarting Nginx"
	sudo systemctl restart nginx
fi

echo "__ Nginx Status"
sudo systemctl status nginx

echo "__ Deleting The Script File"
rm -- "$0"