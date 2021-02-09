#!/bin/bash
echo "__ Ubuntu Init Setup Bash Script"

echo "__ Update && Upgrade && Clean"

sudo apt -y update && sudo apt -y upgrade && sudo apt autoremove && sudo apt clean

#=======================================

echo "__ Adding New User"
read -p "Enter The New user Name: " USER_NAME
adduser $USER_NAME

echo "__ Granting The New User Administrative Privileges"
usermod -aG sudo $USER_NAME
echo "__ The New User has Granted Administrative Privileges"

echo "__ $USER_NAME Info"
id $USER_NAME

echo "__ Copying The SSH Key to the New User"
rsync --archive --chown=$USER_NAME:$USER_NAME ~/.ssh /home/$USER_NAME
echo "__ The SSH Key has been Copied to the New User"

#=================================================

echo "__ Setting up Firewall (uwf)"
ufw allow OpenSSH
ufw allow http
ufw allow https
yes y | ufw enable
ufw status
echo "__ Allowed OpenSSH, http, https and enabled uwf"

#=================================================

echo "__ Disabling Root Login (PermitRootLogin no) in /etc/ssh/sshd_config"
sed -i '/^PermitRootLogin[ \t]\+\w\+$/{ s//PermitRootLogin no/g; }' /etc/ssh/sshd_config
echo "__ Root Login Disabled"

echo "__ Reloading sshd"
sudo systemctl reload sshd

echo "__ Deleting The Script File"
rm -- "$0"

echo "__ Switching to $USER_NAME User"
cd ./../home/$USER_NAME
su $USER_NAME