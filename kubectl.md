
[#nodos](#nodos)

[#pods](#pods)

[#deployments](#deployments)

[#escalar/desescalar](#escalar/desescalar)

[#namespaces](#namespaces)


------------


### nodos
  - listar nodos **kubectl get nodes**
  - detalle nodos **kubectl describe nodes**

### pods  
  - listar pods **kubectl get pods**

### deployments
  - desplegar una pod desde docker hub: **kubectl create deployment hello-http --image=httpd:latest**
  - detalle del pod que acabamos de desplegar **kubectl describe pod hello-http** . Nos dira IP, dockers que contiene, estado, eventos.
  - desplegar pod desde un .yml **kubectl apply -f fichero.yml**
  - exponer un pod hay que indicar el nombre del pod a exponer y el puerto: **kubectl expose deployment hello-http --type=LoadBalancer --port=80**
  - listar servicios expuestos: **kubectl get services**

### escalar/desescalar  
  - escalar/desescalar pod, hay que indicar el numero de replicas que queremos (hacia arriba o abajo) y el pod a escalar/desescalar: **kubectl scale deployment --replicas=3 hello-http**
  - comprobamos el resultado del escalado con **kubectl get pods**
  - ![kubectl](https://github.com/sergioalegre/Dockers/blob/main/pics/kubectl1.jpg?raw=true)
  - eliminar pod:
    - si viene desde imagen: **kubectl delete deployment hello-http**
    - si viene desde yaml: **kubectl delete -f app.yml**
  - eliminar servicio expuesto: **kubectl delete service hello-http**

### namespaces  
  - listar namespaces **kubectl get namespaces**
