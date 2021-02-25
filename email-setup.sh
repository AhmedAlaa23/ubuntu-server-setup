#!/bin/bash
echo "__ Setting Up Email Server Bash Script"

# create A record
# hostname: mail, value: your server ip

# create mx record to point to mail.yourdomain.com
# hostname: @, value: mail.yourdomain.com

# create CNAME: name: autodiscover value: mail.yourdomain.com
# create CNAME: name: autoconfig value: mail.yourdomain.com

# create txt records
# Name               Type       Value
# @                  IN TXT     "v=spf1 mx a -all"
# dkim._domainkey    IN TXT     "v=DKIM1; k=rsa; t=s; s=email; p=..."
# _dmarc             IN TXT     "v=DMARC1; p=reject; rua=mailto:mailauth-reports@mail.yourdomain.com"

SCRIPT_DIR=`pwd`
SCRIPT_PATH="$SCRIPT_DIR/$0"

#* ========================================================
#* add mail.yourdomain.com to your nginx with let's encrypt

# add mail.yourdomain.com to be a mail server

read -p "__ Domain Name to create email for (eg: yourdomain.com) ? " DOMAIN_NAME

MAIL_SERVER_NAME="mail.$DOMAIN_NAME"

if [ -f "/etc/nginx/sites-available/$MAIL_SERVER_NAME" ]
then
	echo "__ Domain Already Exist !"
else
	echo "__ Adding site file to sites-available"
	sudo echo "
server {
	listen 80;
	listen [::]:80;

	root /var/www/$MAIL_SERVER_NAME;
	index index.html;

	server_name $MAIL_SERVER_NAME;

	location / {
		proxy_pass	http://127.0.0.1:8080;
	}
}
	" >> /etc/nginx/sites-available/$MAIL_SERVER_NAME

	echo "__ Creating Link in sites-enabled"
	sudo ln -s /etc/nginx/sites-available/$MAIL_SERVER_NAME /etc/nginx/sites-enabled/

	echo "__ Checking Nginx"
	sudo nginx -t

	echo "__ Restarting Nginx"
	sudo systemctl restart nginx
fi

echo "__ Nginx Status"
sudo systemctl status nginx

#* ================================
#* mailcow (with docker)
#================================
# mailcow
echo "__ Installing Mailcow (with docker)"

#* Install docker
echo "__ Installing Docker"
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

sudo systemctl enable docker.service
sudo systemctl start docker.service

# If you would like to use Docker as a non-root user, you should now consider
# adding your user to the "docker" group with something like:
# sudo usermod -aG docker USER_NAME

#* Install Docker Compose
echo "__ Installing Docker Compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "__ Verify Docker Compose Version"
docker-compose --version

#* ============================
#* installing Mailcow
echo "__ Install Mailcow"
cd /opt
sudo git clone https://github.com/mailcow/mailcow-dockerized
cd mailcow-dockerized
sudo ./generate_config.sh

#* ======== config mailcow
#*===========================
echo "__ Configuring Mailcow"

echo "__ Binding http and https Address"

# bind http and https address like below
# sudo nano mailcow.conf
# HTTP_PORT=8080
# HTTP_BIND=127.0.0.1

# HTTPS_PORT=8443
# HTTPS_BIND=127.0.0.1

sudo sed -i '/HTTP_PORT=80/c\HTTP_PORT=8080' mailcow.conf
sudo sed -i '/HTTP_BIND=/c\HTTP_BIND=127.0.0.1' mailcow.conf

sudo sed -i '/HTTPS_PORT=443/c\HTTPS_PORT=8443' mailcow.conf
sudo sed -i '/HTTPS_BIND=/c\HTTPS_BIND=127.0.0.1' mailcow.conf

#* disable ipv6
echo "__ Disabling ipv6"
# -- disable ipv6 (https://mailcow.github.io/mailcow-dockerized-docs/firststeps-disable_ipv6/)

sudo sed -i '/enable_ipv6: true/c\      enable_ipv6: 0' docker-compose.yml

sudo echo "
version: '2.1'
services:

    ipv6nat-mailcow:
      restart: \"no\"
      entrypoint: [\"echo\", \"ipv6nat disabled in compose.override.yml\"]

" >> docker-compose.override.yml


sudo sed -i '/do-ip6: yes/c\  do-ip6: no' data/conf/unbound/unbound.conf

sudo echo "
smtp_address_preference = ipv4
inet_protocols = ipv4
" >> data/conf/postfix/extra.cf


#*======= Pull the images and run the compose file.
echo "Pull the images and run the compose file"
sudo docker-compose pull
sudo docker-compose up -d

# sudo lsof -i :25
# sudo docker-compose stop

#*======== configure ufw firewall
echo "configure ufw firewall"
# allow smtp 25,587,465
# allow IMAP 143/993
# allow POP3 110/995

sudo ufw allow 25
sudo ufw allow 587
sudo ufw allow 143
sudo ufw allow 993
sudo ufw allow 110
sudo ufw allow 995

sudo systemctl restart ufw

echo "__ Deleting get-docker file"
sudo rm -- "$SCRIPT_DIR/get-docker.sh"

echo "__ Deleting The Script File"
sudo rm -- "$SCRIPT_PATH"