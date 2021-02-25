#!/bin/bash
echo "__ Let's Encrypt (TLS/https) Setup Bash Script"

read -p "__ Domain Name ? " DOMAIN_NAME
read -p "__ Add for the www version too ? (y/n) " IS_WWW_DOMAIN

echo "__ Configuring Let's Encrypt"

echo "__ Installing Certbot"
sudo apt -y install certbot python3-certbot-nginx

echo "__ Obtaining an SSL Certificate"
if [ "$IS_WWW_DOMAIN" == "n" ]
then
	sudo certbot --nginx -d $DOMAIN_NAME
else
	sudo certbot --nginx -d $DOMAIN_NAME -d www.$DOMAIN_NAME
fi

echo "__ Verifying Certbot Auto-Renewal"
sudo systemctl status certbot.timer
sudo certbot renew --dry-run

# systemctl list-timers