#!/bin/bash
echo "__ Setting Up Email Server Bash Script"

# add mail.yourdomain.com to your nginx with let's encrypt

# create mx record to pint to mail.yourdomain.com
# hostname: @, value: mail.yourdomain.com

# create A record
# hostname: mail, value: your server ip



#================================
# mailcow with docker)
#================================
# mailcow

#* Install docker
echo "Installing Docker"
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# If you would like to use Docker as a non-root user, you should now consider
# adding your user to the "docker" group with something like:
# sudo usermod -aG docker USER_NAME

#* Install Docker Compose
echo "Installing Docker Compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Verify Docker Compose Version"
docker-compose --version

# sudo systemctl enable docker.service
# sudo systemctl start docker.service

#* installing Mailcow
cd /opt
sudo git clone https://github.com/mailcow/mailcow-dockerized
cd mailcow-dockerized
sudo ./generate_config.sh

#* config mailcow
# bind http and https address like below
# sudo nano mailcow.conf
# HTTP_PORT=8080
# HTTP_BIND=127.0.0.1

# HTTPS_PORT=8443
# HTTPS_BIND=127.0.0.1

# -- disable ipv6 (https://mailcow.github.io/mailcow-dockerized-docs/firststeps-disable_ipv6/)

#* Pull the images and run the compose file.
sudo docker-compose pull
sudo docker-compose up -d

# sudo lsof -i :25
# sudo docker-compose stop

# # nginix conf
# echo "__ Adding site file to sites-available"
# sudo echo "
# server {
# 	listen 80;
# 	listen [::]:80;

# 	root /var/www/$DOMAIN_NAME;
# 	index index.html;

# 	server_name mail.$DOMAIN_NAME;

# 	location / {
# 		proxy_pass http://localhost:8080;
# 		proxy_set_header  X-Forwarded-For $remote_addr;
# 		proxy_set_header  Host $http_host;
# 		#proxy_http_version 1.1;
# 		#proxy_set_header Upgrade $http_upgrade
# 	}
# }
# " >> /etc/nginx/sites-available/$DOMAIN_NAME

# sudo ln -s /etc/nginx/sites-available/mail$DOMAIN_NAME /etc/nginx/sites-enabled/

# sudo nginx -t

# sudo systemctl restart nginx













# sudo apt -y install postfix

# # verify that postfix is running
# sudo postfix status

# # Configure Postfix to use Maildir-style mailboxes:
# sudo postconf -e "home_mailbox = Maildir/"
# sudo postconf -e "mailbox_command = "

# # in /etc/postfix/main.cf
# # myhostname = mail.yourdomain.com

# # sudo ufw allow 25/tcp

# # Restart Postfix
# sudo systemctl restart postfix


# sudo dpkg-reconfigure postfix
# sudo nano /etc/postfix/master.cf
# sudo nano /etc/postfix/main.cf