[#Conceptos](#Conceptos)

[#Comandos básicos](#Comandos-basicos)


------------
### Conceptos
  - **TAG** es como las versiones de una imagen. Una imagen puede tener varios tags
  - Una **imagen** puede estar hecha de varias imagenes a la su vez por ello cuando hacemos un pull de una imagen hay varias descargas que hacer.
  - No todos los dockers son interactivos, no todos tienen un CLI que lo permita personalizar


### Comandos-basicos

  - **Docker Hub(DH):**
    - Buscar en DH: **docker search**
    - Descargar desde el DH **docker pull**
    - Descargar un TAG concreto. La lista de tags de una imagen se pueden ver en DH **docker pull ubuntu:14:04** Si no indicamos el TAG descargaremos por defecto el *latest*


  - **Imagenes:**
    - Listar ya descargadas y su TAG **docker images**



  - **Contenedores:**
    - Listar los que estan en ejecución **docker ps**
    - Listar todos **docker ps -a**    
    - Si un docker se ejecuto pero termino (Status = EXITED) podemos ver su status y último comando con **docker ps -a**
    - Ejecutar un docker **docker run <imagen>** si no tenia la imagen, la descarga    
    - Ejecutar un único comando dentro de un contenedor **docker run <imagen> <comando>** ejemplo: *docker run ubuntu ls-al* Pero despues de hacer el comando el docker se detendra
    - Iniciar sesion interactiva (pseudoterminal) en un contenedor **docker run -i -t <imagen> <comando>**  ejemplo: *docker run -i -t ubuntu bash*
