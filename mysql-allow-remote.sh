sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf

bind-address            = 0.0.0.0

================================

sudo systemctl restart mysql

CREATE USER IF NOT EXISTS '$MYSQL_USER_NAME'@'%' IDENTIFIED WITH '$MYSQL_USER_PLUGIN' BY "$MYSQL_USER_PASS";

USE DB_NAME
GRANT ALL PRIVILEGES ON DB_NAME.* TO '$MYSQL_USER_NAME'@'localhost' WITH GRANT OPTION;


FLUSH PRIVILEGES;

# open the port
sudo ufw allow 3306