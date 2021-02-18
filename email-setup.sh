#!/bin/bash
echo "__ Setting Up Email Server Bash Script"

echo "__ Installing Postfix"
sudo DEBIAN_PRIORITY=low apt -y install postfix
# the command below to rerun the postfix configuration
# sudo dpkg-reconfigure postfix

echo "__ Configuring Postfix"
sudo postconf -e 'home_mailbox= Maildir/'



#================================
# not a good option (mailcow with docker)
#================================
# mailcow
# curl -sSL https://get.docker.com/ | CHANNEL=stable sh

# sudo usermod -aG docker USER_NAME

# systemctl enable docker.service
# systemctl start docker.service


# sudo curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# sudo chmod +x /usr/local/bin/docker-compose

# cd /opt
# sudo git clone https://github.com/mailcow/mailcow-dockerized
# cd mailcow-dockerized

# sudo ./generate_config.sh

# # config mailcow
# sudo nano mailcow.conf

# HTTP_BIND=127.0.0.1
# HTTP_PORT=8080
# HTTPS_BIND=127.0.0.1
# HTTPS_PORT=8443

# sudo docker-compose up -d

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
