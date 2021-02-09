#!/bin/bash
echo "__ Ubuntu Init Setup Bash Script"

echo "__ Choose What to Install"

read -p "__ Install NODE ? (y/n) " I_NODE
read -p "__ Install MYSQL ? (y/n) " I_MYSQL
read -p "__ Install Nginix ? (y/n) " I_NGINIX

if [ "$I_NODE" == "y" ] || [ "$I_NODE" == "yes" ]
then
	echo "__ Installing Nodejs"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
	source ~/.bashrc
	nvm install node

	echo "__ Updating NPM"
	npm install -g npm

	echo "__ Installing Pm2 (-g)"
	npm install -g pm2
fi

if [ "$I_NGINIX" == "y" ] || [ "$I_NGINIX" == "yes" ]
then
	echo "__ Installing Nginx"
	sudo apt install -y nginx
	systemctl status nginx
	echo "__ Nginx Installed"
fi

if [ "$I_MYSQL" == "y" ] || [ "$I_MYSQL" == "yes" ]
then
	echo "__ Installing MYSQL"
	sudo apt install -y mysql-server
	echo "__ Running mysql_secure_installation"
	sudo mysql_secure_installation
	echo "__ MYSQL Installed"

	echo "__ Creating New MYSQL USER"
	read -p "__ New MySQL User Name ? " MYSQL_USER_NAME
	read -p "__ New MySQL User Pass ? " MYSQL_USER_PASS
	read -p "__ User Auth Plugin to be 'mysql_native_password' (y/n or enter) ? " MYSQL_USER_PLUGIN
	
	if [ "$MYSQL_USER_PLUGIN" == "y" ]
	then
		MYSQL_USER_PLUGIN='mysql_native_password'
	else
		MYSQL_USER_PLUGIN='caching_sha2_password'
	fi

	echo "__ Enter the sudo Pass below"
	sudo mysql --user='root' -p --execute='CREATE USER IF NOT EXISTS '$MYSQL_USER_NAME'@'localhost' IDENTIFIED WITH '$MYSQL_USER_PLUGIN' BY "$MYSQL_USER_PASS"; GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER_NAME'@'localhost' WITH GRANT OPTION; USE mysql; SELECT user, host, plugin from user; FLUSH PRIVILEGES;'
	echo "__ Checking That mysql service is running"
	systemctl status mysql.service
fi
