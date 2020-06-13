#!/bin/bash
#Menu Install Webserver dan Database Server

PS3="Pilih mau pasang yang mana : "
pilihan=("Apache2" "Nginx" "Mysql-Server" "MongoDB" "Keluar")
select opt in "${pilihan[@]}"
do 
	case $opt in
		"Apache2")
                  sudo apt update 
                  sudo apt install apache2 -y
		  break
                  ;;
                 "Nginx")
                  sudo apt update
                  sudo apt install nginx -y
                  break
                  ;;
                 "Mysql-Server")
                  sudo apt update
                  sudo apt install mysql-server -y
                  break
                  ;;
                 "MongoDB")
                  sudo apt update 
                  sudo apt install mongodb -y
                  ;;
		 "Keluar")
                  break
                  ;;
                  *) echo "Pilihan tidak ada"
                  ;;
	esac
done
