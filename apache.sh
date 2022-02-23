#!/bin/bash

bucle="true"

if [ $2 ];then
	echo "ERROR. Ha introducido mas parametros de los necesarios. Consulte la ayuda"
elif [[ $1 && $1 != "--help" ]]; then
	echo "Parametro incorrecto, si necesita ayuda para usar el comando introduzca el parametro --help"
elif [[ $1 == "--help" ]];then
	echo "Bienvenido a la ayuda"
else
	while (($bucle=="true"))
	do
		estado=`systemctl status apache2.service 2> null`
		echo -e "\n"
		echo "MENU de GESTION APACHE"
		echo "---------------------------"
		echo "¿Que desea realizar?"
		if [[ -z $estado ]]; then
			echo "1.- Instalar Apache"
		else
			echo "2.- Comprobar Estado"
			echo "3.- Iniciar Servicio"
			echo "4.- Parar Servicio"
			echo "5.- Cambiar Puerto de Escucha"
			echo "6.- Desinstalar Apache"
		fi
		echo "99.- Salir del programa"
		echo "---------------------------"
		read -p "Introduzca el numero de opcion que desea: " opcion
		echo -e "\n"


		if [ $opcion -eq 1 ];then
			estado=`systemctl status apache2.service 2> null`
			if [[ -z $estado ]]; then
				echo "Se va a realizar la instalacion del servicio Apache"
				sudo apt -y install apache2
			else
				echo "El servicio Apache ya se encuentra instalado"
			fi
		elif [ $opcion -eq 2 ];then
			estado=`systemctl status apache2.service 2> null`
                        if [[ -z $estado ]]; then
                                echo "El servicio no se encuentra instalado. Seleccione opcion 1 en el menu de opciones"
                       else
                                 systemctl status apache2.service | head -n3 | tail -n1
                        fi
		elif [ $opcion -eq 3 ];then
			estado=`systemctl status apache2.service 2> null`
                        if [[0 -z $estado ]]; then
                                echo "El servicio no se encuentra instalado. Seleccione opcion 1 en el menu de opciones"
                       else
                                systemctl start apache2.service
				if [ $? -eq 0 ]; then
					echo "Apache se ha iniciado con exito."
				else
					echo "ERROR. No se ha podido iniciar el servicio."
				fi
                        fi
		elif [ $opcion -eq 4 ];then
                        estado=`systemctl status apache2.service 2> null`
                        if [[ -z $estado ]]; then
                                echo "El servicio no se encuentra instalado. Seleccione opcion 1 en el menu de opciones"
                       else
                                systemctl stop apache2.service
                                if [ $? -eq 0 ]; then
                                        echo "Apache se ha parado con exito."
                                else
                                        echo "ERROR. No se ha podido parar el servicio."
                                fi
                        fi
		elif [ $opcion -eq 5 ];then
			echo "1.- Ver Puerto Actual"
			echo "2.- Cambiar Puerto Actual"
			read -p "Seleccione una opcion: " eleccion
			if [ $eleccion -eq 1 ]; then
				cat /etc/apache2/ports.conf | head -n5 | tail -n1
			elif [ $eleccion -eq 2 ]; then
	                        estado=`systemctl status apache2.service 2> null`
	                        if [[ -z $estado ]]; then
	                                echo "El servicio no se encuentra instalado. Seleccione opcion 1 en el menu de opciones"
	                       	else
					pregunta="true"
					while (( $pregunta == "true" ))
					do
	 	                               puerto1=`cat /etc/apache2/ports.conf | head -n5 | tail -n1`
						read -p "Dime el numero de puerto que quieres configurar como activo: " argumento
						es_numero='^-?[0-9]+([.][0-9]+)?$'
							if ! [[ $argumento =~ $es_numero ]];then
	       							 echo "ERROR: No ha introducido un numero"
							else
	        						if [[ $argumento -gt 0 && $argumento -le 9000 ]];then
	        							sudo sed -i "s/$puerto1/Listen $argumento/" /etc/apache2/ports.conf
									if [ $? -eq 0 ]; then
	                                       					echo "Se ha cambiado el puerto con extio al numero $argumento."
	                                				else
	                                        				echo "ERROR. No se ha podido cambiar el puerto."
	                                				fi
								break
								else
	        							echo "Introduzca un numero de puerto valido de 1 al 9000"
								fi
	        					fi
					done
				fi
			else
				echo "Opcion no contemplada"
			fi
		elif [ $opcion -eq 6 ];then
                        estado=`systemctl status apache2.service 2> null`
                        if [ -z $estado ]; then
                                echo "El servicio no se encuentra instalado."
                       else
                                sudo apt purge -y apache2
                                if [ $? -eq 0 ]; then
                                        echo "Apache se ha desinstalado con exito."
                                else
                                        echo "ERROR. No se ha podido desinstalar el servicio."
                                fi
                        fi

		elif [ $opcion -eq 99 ];then
			echo "Hasta luego"
			break
		else
			echo "opcion no contemplada"
		fi
done
fi
