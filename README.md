# ubuntu-server-setup
Ubuntu (Linux) Server Setup Bash Script

## Init Setup

1. Update && Upgrade
2. Add New User
3. Granting The New User Administrative Privileges
4. Copying The SSH Key to the New User
5. Setting up Firewall (uwf allow OpenSSH,http,https)
6. Disabling Root Login (PermitRootLogin no) in '/etc/ssh/sshd_config'


```bash
bash <(curl -s https://raw.githubusercontent.com/AhmedAlaa23/ubuntu-server-setup/main/init-setup.sh)
```

<br/>

## Server Stack Setup

### Server for apps (Options)
- Install Nodejs & Install pm2
- Install MYSQL & Configure MySQL
- Install Nginx

```bash
bash <(curl -s https://raw.githubusercontent.com/AhmedAlaa23/ubuntu-server-setup/main/stack-setup.sh)
```

<br/>

## Domain (Nginx & Lets Encrypt)
### 1. On the domain provider (etc Namecheap) update the NAMESERVERS (DNS) to point to the server

### 2. On the Server (etc Digitalocean) Add '@' and 'www' A records in the server

### 3. Run the Script
1. Add the site to Nginx sites-available
2. Add Let's Encrypt to that domain


```bash
sudo bash <(curl -s https://raw.githubusercontent.com/AhmedAlaa23/ubuntu-server-setup/main/domain-setup.sh)
```

<br/>

## Apps (clone from github and add/configure to server)
1. Clone the App from github to the server (www)
2. Run the App if it's runnable
3. Add it's location to Nginx


```bash
sudo bash <(curl -s https://raw.githubusercontent.com/AhmedAlaa23/ubuntu-server-setup/main/app-setup.sh)
```