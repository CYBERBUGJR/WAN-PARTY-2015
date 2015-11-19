#!/bin/bash
#script d'installation et configuration d'un serveur mincraft sous linux.
VERT="\\033[1;32m"
ROUGE="\\033[1;31m"
NORMAL="\\033[0;39m"
CYAN="\\033[1;36m"

read -p "Entrez la version de Minecraft à installer (list pour afficher la liste des versions disponibles) : " ver

while [ $ver = "list" ] ; do

	echo -e "$CYAN" " versions disponibles : 1.8.8 \n 1.8.7 \n 1.8.6\n Entrez la version désirée :" "$NORMAL"
	read ver
	break

done
echo -e "Installation de open-jre :"
apt-get update
apt-get install openjdk-7-jre openjdk-7-jdk
echo -e "$ROUGE" "Téléchargement de la version "$ver" \n" "$VERT"
wget https://s3.amazonaws.com/Minecraft.Download/versions/"$ver"/minecraft_server."$ver".jar 
echo -e "$NORMAL"
mkdir -p /srv/minecraft_server/ 
mv minecraft_server."$ver".jar /srv/minecraft_server ; cd /srv/minecraft_server/
read -p "Visualiser la RAM ? (y/n): " ram
if [ $ram = "y" ] ; then

	echo 3 > /proc/sys/vm/drop_caches ; free -h ; echo -e "\n"
	read -p "Pressez entrée pour continuer.. " 
fi

read -p "Entrez la quantité de mémoire minimale en Mégaoctets(-Xms): " javamin ; echo -e "\n"
read -p "Entrez la quantité de mémoire maximale en Mégaoctets(-Xmx): " javamax ; echo -e "\n"
read -p "Choisissez un nom d'alias pour le démarrage du seveur : " aliass 	
echo "alias "$aliass"='cd /srv/minecraft_serveur/ ; java -jar -Xms"$javamin"M -Xmx"$javamax" minecraft_serveur."$ver".jar'" >> ~/.bashrc ; echo -e "$ROUGE"
read -p "Premier démarrage du serveur, tapez stop dans la console une fois le eula apparu" ; echo -e "$NORMAL"
java -jar minecraft_server."$ver".jar
sed -n -e 's/false/true/g' eula.txt
echo -e "$ROUGE" " Paramétrage du server.properties" "$NORMAL"
read  -p "Press enter"
vim server.properties 
echo -e " le port par défaut est 25565, est-il different ? (Y/n): "
read res
while [ $res = "Y" ]; do 
	read -p "Entrez la valeur du port: " port
	su
	iptables -A INPUT -p tcp -m tcp --dport $port -j ACCEPT
	break
done
while [ $res = "n" ]; do 
	su
	iptables -A INPUT -p tcp -m tcp --dport 25565 -j ACCEPT
	break
done
read -p "Configuration terminée... "



