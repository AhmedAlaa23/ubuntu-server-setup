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
curl https://raw.githubusercontent.com/AhmedAlaa23/ubuntu-server-setup/main/init-setup.sh | bash
```

<br>

## Server Stack Setup

### Server for apps (Options)
- Install Nodejs & Install pm2
- Install MYSQL & Configure MySQL
- Install Nginx

```bash
curl https://raw.githubusercontent.com/AhmedAlaa23/ubuntu-server-setup/main/stack-setup.sh | bash
```

## Domain (Nginx & Lets Encrypt)
1. Add the site to Nginx sites-available
2. Add Let's Encrypt to that domain

```bash
curl https://raw.githubusercontent.com/AhmedAlaa23/ubuntu-server-setup/main/domain-setup.sh | bash
```