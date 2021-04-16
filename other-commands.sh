#* compress folder with permissions
sudo tar cvpzf put_your_name_here.tar.gz /etc/

#* extract folder with permission
sudo tar xpvzf put_your_name_here.tar.gz -C /etc/

#* download file from server to local
scp -r user@yourserver.com:~/file.tar.gz /c/Users/ahmed/Desktop/file.tar.gz

#* download file from server to local
scp -r /c/Users/ahmed/Desktop/file.tar.gz user@yourserver.com:~/file.tar.gz

#* =========== Database Commands
#* show users
USE mysql; SELECT user, host, plugin from user;

#* show databases
SHOW DATABASES;
