#!/bin/bash  

#TAMBAHIN SCRIPT GIT CLONE NYA

echo "Installing git.."
sudo apt update 
sudo apt install git
echo "Initiating clone git.." 
git clone https://github.com/vhico07/small-project1.git 

# VARIABLE  
VHOST_AVAILABLE='/etc/nginx/sites-available' 
VHOST_ENABLED='/etc/nginx/sites-enabled' 
VHOST_DEL_AVAIL='/etc/nginx/sites-available/default'
VHOST_DEL_ENAB='/etc/nginx/sites-enabled/default'

# WEB SERVER 
echo "Sedang menginstall Nginx Server" 
sudo apt update 
sudo apt install nginx php-fpm -y  

# DATABASE 
echo "Sedang menginstall Database Mysql-Server" 
sudo apt update 
sudo apt install mysql-server -y

# LIBRARY PHP-MYSQL
sudo apt update 
sudo apt install php-mysql -y

echo "Stop layanan Apache2"
sudo systemctl stop apache2

# DOCUMENT ROOT CONFIG  
cat > $VHOST_AVAILABLE/fesbuk	<<EOF
server {     
	listen 80;

	root /home/ubuntu/small-project1;

	index index.php index.html index.htm index.nginx-debian.html;

	server_name fesbuk.gonnabegood.xyz;
	
	location / {
		try_files \$uri \$uri/ =404;
	}
	
	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
	}
	
	location ~ /\.ht {
		deny all;
	}
}
EOF

# DELETING DOCUMENT DEFAULT 
echo "Menghapus file default pada $VHOST_DEL_AVAIL"
sudo rm -rvf $VHOST_DEL_AVAIL 
echo "Menghapus file default pada $VHOST_DEL_ENAB"
sudo rm -rvf $VHOST_DEL_ENAB

# RESTART AND LINK NGINX SERVER
echo "Debug Error Document Root"
sudo nginx -t
echo "Symlink between sites-enabled and sites-available"
sudo ln -s /etc/nginx/sites-available/fesbuk /etc/nginx/sites-enabled/fesbuk
echo "Restarting Nginx server"
sudo systemctl restart nginx
echo "Selesai restart server"


# TAMBAHIN SCRIPT IMPORT MYSQL
export DBPASS=1234567890

# MEMBUAT USER DI MYSQL
echo "Masukkan Password Root MYSQL"
sudo mysql -u root	<<CREATE_USER_QUERY
create user 'devopscilsy'@'localhost' identified by '1234567890';
grant all privileges on *.* to 'devopscilsy'@'localhost';
CREATE_USER_QUERY
echo "Membuat User devopscilsy di MySQL berhasil" 

# MEMBUAT DATABASE
echo "Masuk sebagai user devopscilsy di MySQL"
sudo mysql -u devopscilsy -p$DBPASS	<<CREATE_DB_QUERY
create database dbsosmed;
show databases;
CREATE_DB_QUERY

# IMPORT DATA
echo "Sedang import data ke dalam database"
sudo mysql -u devopscilsy -p$DBPASS dbsosmed < /home/ubuntu/small-project1/dump.sql
echo "Selesai Import DATABASE"
