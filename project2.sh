#!/bin/bash
# https://github.com/many-ip/Project2


usage(){
	echo "Usage: ${0} USER_NAME [COMMENT]..." >&2
	echo "Crea una cuenta en el sistema local con el nombre de USER_NAME y un campo de comentarios de COMMENT." >&2
	exit 1
}


if [ $EUID -ne 0 ]
then
	echo "Necesita ejecutar como sudo o root"
else
	if [ -z $1 ]
	then
		usage
	else
		USER=$1
		shift 
		COMMENT="${@}"
		
		PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
		
		useradd -c "$COMMENT" -m "$USER" &> /dev/null
		
		if [ $? -ne 0 ]
		then		
			echo "No se ha podido crear el usuario" &>2
			exit 1
		fi
		echo $PASSWORD | passwd --stdin $USER &> /dev/null
		
		if [ $? -ne 0 ]
		then
			echo "La contraseña no se ha podido establecer"
			exit 1
		fi
		
		passwd -e $USER &> /dev/null
		
		echo "Usuario: $USER"
		echo 
		echo "Constraseña: $PASSWORD"
		echo
		echo "HOST: ${HOSTNAME}"
		
	fi
fi

