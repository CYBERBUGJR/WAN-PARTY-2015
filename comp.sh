#!/bin/bash
echo -e "\nLittle Compressor for Unix: c'est comme Skip, petit mais puissant\n"
echo "Chemin des fichiers à compresser ? (Attention pas d'auto complétion !)"
read pas
echo -e "#!/bin/bash \nrm cd.sh \ncd $pas">cd.sh  #cd étant built-in il faut le sourcer pour qu'il fonctionne !!!
chmod +x cd.sh
source cd.sh



find . -maxdepth 1 -type d | sed -e 's@./@@' | sed -e 's@\.@@' | sed '/^$/d'|  sort -u| while read i
do
	echo -e "Compression de :\n"
	echo -e "$i"
	tar -jcvf "$i".tar.bz2 "$i"
	rm  -rf "$i"
done


