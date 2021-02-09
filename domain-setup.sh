#!/bin/bash
echo "__ Domain Setup Bash Script"

read -p "__ Domain Name ? " DOMAIN_NAME

echo "__ Removing The Defualt Server File in sites-enabled"
sudo [ -e /etc/nginx/sites-enabled/default ] && rm /etc/nginx/sites-enabled/default

echo "__ Uncommenting 'server_names_hash_bucket_size 64'"
sudo sed -i '/	# server_names_hash_bucket_size 64;/c\	server_names_hash_bucket_size 64;' /etc/nginx/nginx.conf

echo "__ Adding site file to sites-available"
sudo echo "
server {
	listen 80;
	listen [::]:80;

	root /var/www/$DOMAIN_NAME;
	index index.html;

	server_name $DOMAIN_NAME www.$DOMAIN_NAME;

	location / {
		try_files $uri $uri/ =404;
	}
}
" >> /etc/nginx/sites-available/'$DOMAIN_NAME'

echo "__ Creating Link in sites-enabled"
sudo ln -s /etc/nginx/sites-available/'$DOMAIN_NAME' /etc/nginx/sites-enabled/

echo "__ Checking Nginx"
sudo nginx -t

echo "__ Restarting Nginx"
sudo systemctl restart nginx