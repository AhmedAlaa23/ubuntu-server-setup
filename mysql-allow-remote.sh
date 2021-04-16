sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf

bind-address            = 0.0.0.0

================================

sudo systemctl restart mysql

CREATE USER IF NOT EXISTS '$MYSQL_USER_NAME'@'%' IDENTIFIED WITH '$MYSQL_USER_PLUGIN' BY "$MYSQL_USER_PASS";
# CREATE USER IF NOT EXISTS 'outlet'@'%' IDENTIFIED WITH mysql_native_password BY "outletdb!let";

USE DB_NAME
GRANT ALL PRIVILEGES ON DB_NAME.* TO '$MYSQL_USER_NAME'@'localhost' WITH GRANT OPTION;
# GRANT ALL PRIVILEGES ON DB_NAME.* TO 'outlet'@'%' WITH GRANT OPTION;


FLUSH PRIVILEGES;