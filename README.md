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

## Domain (Nginx)
### 1. On the domain provider (etc Namecheap) update the NAMESERVERS (DNS) to point to the server

### 2. On the Server (etc Digitalocean) Add '@' and 'www' A records in the server

### 3. Run the Script (Adds the site to Nginx sites-available)

```bash
curl -o domain-setup.sh -s https://raw.githubusercontent.com/AhmedAlaa23/ubuntu-server-setup/main/domain-setup.sh && sudo bash domain-setup.sh
```

<br/>

## Apps (clone from github and add/configure to server)
1. Clone the App from github to the server (www)
2. Run the App if it's runnable
3. Add it's location to Nginx


```bash
bash <(curl -s https://raw.githubusercontent.com/AhmedAlaa23/ubuntu-server-setup/main/app-setup.sh)
```

<br/>

## Email Server (mailcow-dockerized)

### 1. create A record (hostname: mail, value: your server ip)

### 2. create mx record to point to mail.yourdomain.com (hostname: @, value: mail.yourdomain.com)

### 3. create CNAME:- name: autodiscover value: mail.yourdomain.com
### 4. create CNAME:- name: autoconfig value: mail.yourdomain.com

### 5. create txt records
```bash
1. @                =>	"v=spf1 mx a -all"
2. dkim._domainkey	=>	"v=DKIM1; k=rsa; t=s; s=email; p=..."
3. _dmarc           =>	"v=DMARC1; p=reject; rua=mailto:mailauth-reports@mail.yourdomain.com"
```
### 3. Run the Script
1. Configure Nginx
2. Install Docker & Docker-Compose
3. Install MailCow
4. Configure MailCow
5. Run MailCow
6. Configure ufw to allow (SMTP,IMAP,POP3) ports

```bash
curl -o email-setup.sh -s https://raw.githubusercontent.com/AhmedAlaa23/ubuntu-server-setup/main/email-setup.sh && sudo bash email-setup.sh
```

<br/>

## Let's Encrypt (TLS/HTTPS)
### Run the Script (Adds Let's Encrypt TLS to domains)

```bash
curl -o letsencrypt-setup.sh -s https://raw.githubusercontent.com/AhmedAlaa23/ubuntu-server-setup/main/letsencrypt-setup.sh && sudo bash letsencrypt-setup.sh
```

<br/>