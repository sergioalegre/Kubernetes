# Dockerfile: instrucciones para crear una imagen
# Image: plantilla para ejecutar contenedores
# Container: proceso donde tenemos nuestro APP empaquetada

# que imagen usaremos de base
FROM python:3.9

# ruta de trabajo
WORKDIR /my-app

#Añadir archivos
    # Añadir 1 archivo al contenedor (origen y destino)
    ADD main.py .
    # Añadir carpeta entera (origen y destino)
    ADD ./dir1 ./dir1

# dependencias:
    #para generar el archivo de dependencias hacemos un 'pip freeze > requirements.txt'
    # opcion1: definimos librerias, paquetes o exensiones en un txt
    COPY requirements.txt .
    RUN pip install --no-cache-dir -r requirements.txt
    # opcion2, es un ejemplo, para un hola mundo no lo necesitamos
    RUN pip install requests beautefulsoup4

# entry point del container
CMD ["python", "./main.py"]

# crear la imagen, le damos el nombre y la ruta
    # docker build -t hola-mundo-sergio .

# ejecutar docker
    # docker run hola-mundo-sergio
    # si el docker fuera interactivo (requiere user input o porque queremos entrar en el)
        # docker run -it hola-mundo-sergio bash
    # si hace falta esponer un puerto
        # docker run -p 8000:8000 hola-mundo-sergio
    # para ponerle nombre y no de uno aleatorio
        # docker run --name ElNombreDelDocker hola-mundo-sergio
    # mapear volumen y que el output del docker sea una ruta concreta
        # docker run -v C:\test:/media hola-mundo-sergio
    # imaginemos que index.html esta en C:\Web
        # docker run -v C:\Web:/usr/share/nginx/html nginx:latest
    # ejecutar sin parar
        # docker run hola-mundo-sergio sleep infinity

# Problema conocido#1:
    # "error de acceso"
    # Solucion:
    # Install-Module -Name dockeraccesshelper
    # Import-Module dockeraccesshelper
    # Add-AccountToDockerAccess "GRUPOANTOLIN\hq_admin15"

# Problema conocido#2:
    # "no supported platform found in manifest list"
    # Solucion:
    # La imagen base a la que se llama no existe, quizas haya una version superior