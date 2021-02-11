[#Conceptos](#Conceptos)

[#Comandos](#Comandos)

[#Monitorizacion](#Monitorizacion)

[#Backup-Restore](#Backup-Restore)

[#Reinstalar](#Reinstalar)


------------

### Conceptos

  - **TAG** es como las versiones de una imagen. Una imagen puede tener varios tags.
  - Una **imagen** puede estar hecha de varias imagenes a la su vez por ello cuando hacemos un pull de una imagen hay varias descargas que hacer.
  - No todos los dockers son interactivos, no todos tienen un CLI que lo permita personalizar.
  - **dockerfile** archivo de texto con los comandos de personalización de una imagen.


### Comandos

  - **Docker Hub(DH):**
    - Buscar en DH: **docker search**
    - Descargar desde el DH **docker pull nombre_imagen**
    - Descargar un TAG concreto. La lista de tags de una imagen se pueden ver en DH **docker pull ubuntu:14:04** Si no indicamos el TAG descargaremos por defecto el *latest*


  - **Imagenes:**
    - Listar ya descargadas y su TAG **docker images**
    - Tras personalizar una imagen com *commit* podemos crear una nueva imagen. Ejemplo: **docker commit id_imagen_que_hemos_personalizado nombre_nueva_imagen**


  - **Contenedores:**
    - Listar:
      - Listar los que estan en ejecución **docker ps**
      - Listar todos **docker ps -a**    
      - Si un docker se ejecuto pero termino (Status = EXITED) podemos ver su status y último comando con **docker ps -a**

    - Iniciar:
      - Iniciar un docker: **docker start imagen**
      - Ejecutar un docker **docker run imagen** si no tenia la imagen, la descarga. Con *--name* le ponemos nombre, ejemplo: *docker run --name PRUEBA1 ubuntu*    
      - Ejecutar un único comando dentro de un contenedor **docker run imagen comando** ejemplo: *docker run ubuntu ls-al* Pero despues de hacer el comando el docker se detendra

    - Sesión interactiva:
        - **docker attach id**  ejemplo: *docker attach 1jh*
        - **docker run -it imagen comando** Entartá en pseudoterminal, ejemplo: *docker run -it ubuntu bash*
        - Para salir de la consola interactiva sin detener el contenedor: *"Ctrl + P + Q"*

    - Detener:
      - Detener un contenedor: **docker stop id**, ejemplo *docker stop 3fb*
      - Detener un contenedor desde sesión interactiva con **exit**

    - Espacio:
      - Espacio usado por imágenes y dockers: **docker system df -v** [Documentación](https://docs.docker.com/engine/reference/commandline/system_df/)


  - **dockerfile:**
    - El dockerfile se ha de llamar dockerfile
    - docker build -t nombre_nuevo /ruta_completa_al_dockerfile/
    - ![Componentes Dockerfile](https://github.com/sergioalegre/Dockers/blob/main/pics/dockerfile_elementos.JPG?raw=true)
    - ![Componentes Dockerfile](https://github.com/sergioalegre/Dockers/blob/main/pics/dockerfile_ejemplo.JPG?raw=true)    


### Monitorizacion

  - Glance: https://www.danielmartingonzalez.com/es/monitorizacion-del-sistema-con-glances/


### Backup-Restore

  - NOTA: esto solo hace backup del contenedor no de los volumenes, para saber si el contenedor tiene volumenes usar **docker inspect <nombre contenedor>** y buscar la sección llamada **Mounts**.

  - Backup:
    - Buscar el id del docker id del que hacer backup **sudo docker ps −a**
    - **sudo docker commit −p <CONTAINER_ID> backup_grafana01**
    - **sudo docker save −o /media/DISCO_USB_EXT/backup_grafana01.tar backup_grafana01**
    - ![Componentes Dockerfile](https://github.com/sergioalegre/Dockers/blob/main/pics/backup-dockers.jpg?raw=true)

  - Restore:
    -Para restaurar **sudo docker load -i /media/DISCO_USB_EXT/backup_grafana01.tar**
    - Nos cargará la imagen y ahora con **docker run** lo instanciaremos


### Reinstalar (no se si pierde datos no volatiles, probado en un docker con datos volatiles)

  - Ejemplo Portainer:
  - step1. stop and delete container.
    - **$sudo docker ps -a (to check container list)**
    - **$sudo docker stop [container ID]**
    - **$docker rm -v [container ID]**

  - step2. delete image
    - **$docker images (to check image ID)**
    - **$docker rmi [image ID]**

  - step3. delete volume
    - **$docker volume rm portainer_data**

  - step4. re-install portainer
    - **$docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v/data/portainer/data:/data portainer/portainer**
