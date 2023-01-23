[#Conceptos](#Conceptos)

[#Comandos](#Comandos)

[#Monitorizacion](#Monitorizacion)

[#Backup-Restore](#Backup-Restore)

[#Reinstalar](#Reinstalar)

[#Registry](#Registry)


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
    - Añadir un tag para subir al registry:
      - **docker image tag imagen_actual sergioalegre/repositorio/imagen_nueva:v1**
      - **docker push sergioalegre/repositorio/imagen_nueva:v1**


  - **Contenedores:**
    - Listar:
      - Listar los que estan en ejecución **docker ps**
      - Listar todos **docker ps -a**    
      - Si un docker se ejecuto pero termino (Status = EXITED) podemos ver su status y último comando con **docker ps -a**

    - Iniciar:
      - Iniciar un docker: **docker start imagen**
      - Ejecutar un docker **docker run imagen** si no tenia la imagen, la descarga. Con *--name* le ponemos nombre, ejemplo: *docker run --name PRUEBA1 ubuntu*    
      - Ejecutar un único comando dentro de un contenedor **docker run imagen comando** ejemplo: *docker run ubuntu ls-al* Pero despues de hacer el comando el docker se detendra
      - Montar un volumen de Windows **docker run -v C:\temp:/media python:miDocker**

    - Sesión interactiva:
        - **docker attach id**  ejemplo: *docker attach 1jh*
        - **docker run -it imagen comando** Entartá en pseudoterminal, ejemplo: *docker run -it ubuntu bash*
        - Para salir de la consola interactiva sin detener el contenedor: *"Ctrl + P + Q"*

    - Detener:
      - Detener un contenedor: **docker stop id**, ejemplo *docker stop 3fb*
      - Detener un contenedor desde sesión interactiva con **exit**

    - Espacio:
      - Espacio usado por imágenes y dockers: **docker system df -v** [Documentación](https://docs.docker.com/engine/reference/commandline/system_df/)

    - Saber la IP:
      - **docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' <container_name_or_id>**



  - **dockerfile:**
    - El dockerfile se ha de llamar dockerfile
    - docker build -t nombre_nuevo /ruta_completa_al_dockerfile/
    - ![Componentes Dockerfile](https://github.com/sergioalegre/Dockers/blob/main/pics/dockerfile_elementos.JPG?raw=true)
    - ![Componentes Dockerfile](https://github.com/sergioalegre/Dockers/blob/main/pics/dockerfile_ejemplo.JPG?raw=true)    


### Monitorizacion

  - Glance: https://www.danielmartingonzalez.com/es/monitorizacion-del-sistema-con-glances/


### Backup-Restore

  1: Backup/restore de DOCKER
  - NOTA: esto solo hace backup del contenedor no de los volumenes, para saber si el contenedor tiene volumenes usar **docker inspect <nombre contenedor>** y buscar la sección llamada **Mounts**.

  - Backup docker:
    - Buscar el id del docker id del que hacer backup **sudo docker ps −a**
    - **sudo docker commit −p <CONTAINER_ID> backup_grafana01**
    - **sudo docker save −o /media/DISCO_USB_EXT/backup_grafana01.tar backup_grafana01**
    - ![Componentes Dockerfile](https://github.com/sergioalegre/Dockers/blob/main/pics/backup-dockers.jpg?raw=true)

  - Restore docker:
    - Para restaurar **sudo docker load -i /media/DISCO_USB_EXT/backup_grafana01.tar**
    - Nos cargará la imagen y ahora con **docker run** lo instanciaremos

  2: Backup/restore de VOLUMENES
  - When you run postgres inside a docker container, it stores its data in something called a volume. The path in your screenshot is that of a volume. Volumes are meant be accessed only from containers. In your case, you can only access it from the container pgsql-0. You need to be logged in as root if your want to access it from the Linux VM directly.

  3: Backup/restore de BBDD
  - Ejemplo1: Here’s an alternative method for backing up your database. Use the following command: **docker exec pgsql-0 pg_dump -U postgres <database_name> > backup.sql**
  This will run the pg_dump command “inside” the container called pgsql-0, and store the results in a file called backup.sql. You can restore the backup using the command: **docker exec -i <postgres_container_name> psql -U postgres -d <database_name> < backup.sql**

  - Ejemplo2 (Polyspace) https://es.mathworks.com/help/releases/R2021a/polyspace_bug_finder_access/gs/database-backup.html
    - Backup: To ensure that your backup does not contain partial or corrupted data, stop docker(s) before starting the backup operation **docker stop app1DB app1Frontend**

    Generate the database backup and save it to backup_db.sql: **docker exec app1DB pg_dumpall -U postgres > backup_db.sql**
    The docker exec command runs the pg_dumpall utility inside the dockerDB container. The -U specifies superuser postgres. The output of pg_dumpall is then saved as backup_db.sql. Be aware that using pg_dumpall on large databases might generate files that exceed the maximum file size limit on some operating systems and can be time consuming.

    Once you complete your backup, restart the APP: **docker start app1DB app1Frontend**
    - Restore: stop docker(s) before starting the restore operation **docker stop app1DB app1Frontend**

      Restore DB Backup **docker exec -i app1DB psql -U postgres postgres <backup_db.sql**

      If you stored your backup in a compressed file, decompress the file, and then pipe its content to the docker exec command **gzip -cd backup_db.gz | docker exec -i app1DB -U postgres postgres**


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

### Registry

  - Docker Hub
    - logarse **docker login**
    - tag: **docker tag <nombre_imagen> sergioalegre/<nombre_imagen>:<version>**
    - push: **docker push sergioalegre/<nombre_imagen>:<version>**
    - ![Ejemplo Registry](https://github.com/sergioalegre/Kubernetes/blob/main/pics/dockerhub.PNG?raw=true)

  - Azure Container Registry (sergioregistry es el Login Server)
    - logarse **az login**
    - contexto: **az account set -s SUBSCRIPTION_ID** y **az acr login --name sergioregistry**
    - tag: **docker tag <nombre_imagen> sergioregistry.azurecr.io/<nombre_imagen>:<version>**
    - push: **docker push sergioregistry.azurecr.io/<nombre_imagen>:<version>**
    - listar imagenes en el registry: **az acr repository list -n sergioregistry -o table**
