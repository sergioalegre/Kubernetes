###IMPORTANT: run as administrator
#Basado https://blog.sixeyed.com/getting-started-with-docker-on-windows-server-2019/

#Install Docker on W2019
Install-WindowsFeature containers -Restart #reinicia
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force #hace pregunta
Install-Package -Name docker -ProviderName DockerMsftProvider #hace pregunta

#start
Start-Service docker

#verify
docker version

#portainer NO FUNCIONA
#docker pull portainer/portainer
docker volume create portainer_data 
docker run -d -p 9000:9000 --name portainer --restart always -v \\.\pipe\docker_engine:\\.\pipe\docker_engine -v portainer_data:C:\data portainer/portainer
Start "http://127.0.0.1:9000"

# OPCIONAL .NET Core apps
docker image pull mcr.microsoft.com/dotnet/core/aspnet:3.0
docker image pull mcr.microsoft.com/dotnet/core/sdk:3.0.100  

#OPCIONAL Ejemplo de swarm con 5 replicas
docker container run -d -p 8080:80 sixeyed/whoami-dotnet:3.0
docker swarm init --advertise-addr 127.0.0.1
docker service create --publish 8070:80 --replicas 5 sixeyed/whoami-dotnet:nanoserver-1809