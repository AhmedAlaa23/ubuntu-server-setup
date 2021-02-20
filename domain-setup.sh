#!/bin/bash
echo "__ Domain Setup Bash Script"

read -p "__ Domain Name ? " DOMAIN_NAME
read -p "__ Is It a Sub Domain ? (y/n) " IS_SUB_DOMAIN

SERVER_NAME="server_name $DOMAIN_NAME www.$DOMAIN_NAME;"
if [ "$IS_SUB_DOMAIN" == "y" ]
then
	SERVER_NAME="server_name $DOMAIN_NAME;"
fi

echo "__ Removing The Default Server File in sites-enabled"
sudo [ -e /etc/nginx/sites-enabled/default ] && sudo rm /etc/nginx/sites-enabled/default

echo "__ Uncommenting 'server_names_hash_bucket_size 64'"
sudo sed -i '/	# server_names_hash_bucket_size 64;/c\	server_names_hash_bucket_size 64;' /etc/nginx/nginx.conf

if [ -f "/etc/nginx/sites-available/$DOMAIN_NAME" ]
then
	echo "__ Domain Already Exist !"
else
	echo "__ Adding site file to sites-available"
	sudo echo "
server {
	listen 80;
	listen [::]:80;

	root /var/www/$DOMAIN_NAME;
	index index.html;

	$SERVER_NAME

	location / {
		try_files \$uri \$uri/ =404;
	}
}
	" >> /etc/nginx/sites-available/$DOMAIN_NAME

	echo "__ Creating Link in sites-enabled"
	sudo ln -s /etc/nginx/sites-available/$DOMAIN_NAME /etc/nginx/sites-enabled/

	echo "__ Checking Nginx"
	sudo nginx -t

	echo "__ Restarting Nginx"
	sudo systemctl restart nginx

	#======================================
	echo "__ Configuring Let's Encrypt"

	echo "__ Installing Certbot"
	sudo apt -y install certbot python3-certbot-nginx

	echo "__ Obtaining an SSL Certificate"
	if [ "$IS_SUB_DOMAIN" == "y" ]
	then
		sudo certbot --nginx -d $DOMAIN_NAME
	else
		sudo certbot --nginx -d $DOMAIN_NAME -d www.$DOMAIN_NAME
	fi

	echo "__ Verifying Certbot Auto-Renewal"
	sudo systemctl status certbot.timer
	sudo certbot renew --dry-run

	# systemctl list-timers
fi

echo "__ Nginx Status"
sudo systemctl status nginx

echo "__ Deleting The Script File"
rm -- "$0"