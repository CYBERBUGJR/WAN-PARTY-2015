#!/bin/bash
# Authors :
# Maxime POUVREAU <pouvreau.maxime@gmail.com>
# Benjamin CALVET <cyberbugjr@gmail.com>
#

apt-get install at

while true ; do
	echo "################################################"
	echo "Quelle IP bannir ? :"
	read IP
	echo "Combien de minutes ? [1-60] (defaut 1min) :"
	read T
	
	if test -z $T ; then
		T=1
		echo "Temps défini à $T minute(s)"
	elif test $T -lt 0 || test $T -gt 60 ; then
		T=1
		echo "Temps défini à $T minute(s)"
	fi

	if [[ "$IP" =~ ^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$ ]] ; then
		echo "Bannir l'IP $IP ? [O/n]"
		read confirm
		if test "$confirm" = "O" || test "$confirm" = "" ; then	
			iptables -A PREROUTING -t mangle -s $IP -j DROP
			#iptables -D PREROUTING -t mangle -s $IP -j DROP | at now + $T minute
		else
			echo "L'IP $1 ne sera pas bannie"
		fi
	else
		echo "Ce n'est pas une IP..."
	fi
done
