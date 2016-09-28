#!/bin/bash

psw=$( gksudo --print-pass --message 'Ingresa contraseña' -- _ 2>/dev/null )

# si se dio click a cancelar
if [[ ${?} != 0 || -z ${psw} ]]; then
	#zenity --error --text="Permiso Denegado!"
	zenity --notification --window-icon="error" --text="Permiso Denegado!"
	exit
fi

# si la contraseña es incorrecta
if ! sudo -kSp '' [ 1 ] <<< "${psw}" 2>/dev/null ; then
	#zenity --error --text="Permiso Denegado!"
	zenity --notification --window-icon="error" --text="Permiso Denegado!"
	exit
fi

# ejemplo de ejecutar comando...
#sudo -kSp '' ls "/root" <<< "${psw}" 2>/dev/null

v_ap=$(service apache2 status | grep running)
v_my=$(service mysql status | grep running)

if [ "$v_ap" != "" ] || [ "$v_my" != "" ]; then
	echo "deteniendo servidor apache..."
	sudo -kSp '' service apache2 stop <<< "${psw}" 2>/dev/null
	echo "deteniendo servidor mysql..."
	sudo -kSp '' service mysql stop <<< "${psw}" 2>/dev/null
	zenity --notification --window-icon="info" --text="el servidor se ha detenido correctamente"
else
	echo "iniciando servidor apache..."
	sudo -kSp '' service apache2 start <<< "${psw}" 2>/dev/null
	echo "iniciando servidor mysql..."
	sudo -kSp '' service mysql start <<< "${psw}" 2>/dev/null
	zenity --notification --window-icon="info" --text="el servidor se ha iniciado correctamente"
fi

