[#Instalacion](#Instalacion)

[#Deployments](#Deployments)

------------

### Instalacion

  - basado https://www.youtube.com/watch?v=tbbZ5HURHhU
  - descargar la ultima version de https://github.com/k3s-io/k3s/releases con wget en Master y Workers
    - **wget https://github.com/k3s-io/k3s/releases/download/v1.20.4%2Bk3s1/k3s**
  - En todos: **chmod 777 k3s**
  - Como root de aqui en adelante
  - Solo en Master **./k3s server --node-ip=10.0.0.4 &** esperamos a que se instale (en B2 tardo 10 minutos)
    - Damos un par de 'intros' para recuperar la consola y nos copiamos el token **cat /var/lib/rancher/k3s/server/node-token**
  - En los workers **./k3s agent --server https://<ipMaster>:6443 --token <token copiado>** esperamos 5 minutos
  - En Master vemos el estado del cluster debieran salir los Workers **./k3s kubectl get nodes**


### Deployments

  - Creamos un pod: **./k3s kubectl create deployment nginx --image=nginx**
  - escalar **./k3s kubectl scale --replicas=4 deployment/nginx**
  - revisar: **./k3s kubectl get pods**
  - en que worker esta un pod determinado **/k3s kubectl describe pod <nombre_pod>**
