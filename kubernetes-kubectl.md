
Apuntes curso Linux Foundation: https://docs.google.com/document/d/1NghuuHdenqE6dwJPv1xK1kWL0Nb4mCFvqXbcip2QlEY/edit#

cheatsheet: https://kubernetes.io/docs/reference/kubectl/cheatsheet/

[#cluster](#cluster)

[#nodos](#nodos)

[#pods](#pods)

[#deployments](#deployments)

[#ReplicaSet](#ReplicaSet)

[#namespaces](#namespaces)

[#ServiceTypes](#ServiceTypes)

[#minikube](#minikube)

[#MSSQL_Server](#MSSQL_Server)
#### [1 Pod](https://github.com/sergioalegre/Dockers/blob/main/kubernetes-kubectl.md#1-pod-1 "1 Pod")
#### [Deployment](https://github.com/sergioalegre/Dockers/blob/main/kubernetes-kubectl.md#deployement-escalable "Deployment")

------------
### cluster
  - listar todo lo que haya en el cluster **kubectl get all**

### nodos
  - listar nodos **kubectl get nodes**
  - detalle nodos **kubectl describe nodes**
  - **configmap** son los pares clave-valor que permiten personalizar una imagen

### pods  
  - listar pods **kubectl get pods**
  - listar pods con label concreta **kubectl get pods -L <label1>**
  - detalle pod **kubectl describe pod <nombre_pod>**

### deployments
  - desplegar una pod desde docker hub: **kubectl create deployment hello-http --image=httpd:latest**
  - detalle del pod que acabamos de desplegar **kubectl describe pod hello-http** . Nos dira IP, dockers que contiene, estado, eventos.
  - log de un pod: **kubectl logs <pod_name> -f**
  - desplegar pod desde un .yml **kubectl apply -f fichero.yml**
  - eliminar despliegue desde .yml **kubectl delete -f sql-server.yaml**
  - exponer un pod hay que indicar el nombre del pod a exponer y el puerto: **kubectl expose deployment hello-http --type=LoadBalancer --port=80**
  - listar servicios expuestos: **kubectl get services**
  - listar volumenes persistentes **kubectl get pv**

### ReplicaSet
  - listar replicasets existentes **kubectl get replicasets**
  - escalar/desescalar pod, hay que indicar el numero de replicas que queremos (hacia arriba o abajo) y el pod a escalar/desescalar: **kubectl scale deployment --replicas=3 hello-http**
  - comprobamos el resultado del escalado con **kubectl get pods**
  - ![kubectl](https://github.com/sergioalegre/Dockers/blob/main/pics/kubectl1.jpg?raw=true)
  - eliminar pod:
    - si viene desde imagen: **kubectl delete deployment hello-http**
    - si viene desde yaml: **kubectl delete -f app.yml**
  - eliminar servicio expuesto: **kubectl delete service hello-http**

### namespaces  
  - listar namespaces **kubectl get namespaces**
  - detalles del servicio **kubectl describe service <nombre_servicio>**

### ServiceTypes
  - listar servicios activos **kubectl get services**

### minikube
  - invocar un servicio **minikube service <nombre_servicio>**
  - listar addons **minikube addons list**
  - habilitar addon (en este ejemplo el addon ingress) **minikube addons enable ingress**

### MSSQL_Server
  - https://www.phillipsj.net/posts/sql-server-on-linux-on-kubernetes-part-1/
  - https://www.phillipsj.net/posts/sql-server-on-linux-on-kubernetes-part-2/

  #### 1 POD:
  - **storage.yaml** (contiene el Persistent Volume y el Persistent Volume Claim)
      ```
      apiVersion: v1
    kind: PersistentVolume
    metadata:
      name: sqldata
    spec:
      capacity:
        storage: 500Mi
      storageClassName: sqlserver
      accessModes:
        - ReadWriteMany
      hostPath:
        path: "/tmp/sqldata"
    ---
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: dbclaim
    spec:
      accessModes:
        - ReadWriteMany
      storageClassName: sqlserver
      resources:
        requests:
          storage: 400Mi
      ```
  - **sql-server.yaml**
      ```
      apiVersion: v1
      kind: Pod
      metadata:
        labels:
          run: mydb
        name: mydb
      spec:
        volumes:
          - name: sqldata-storage
            persistentVolumeClaim:
              claimName: dbclaim
        initContainers:
        - name: volume-permissions
          image: busybox
          command: ["sh", "-c", "chown -R 10001:0 /var/opt/mssql"]
          volumeMounts:
          - mountPath: "/var/opt/mssql"
            name: sqldata-storage
        containers:
        - image: mcr.microsoft.com/mssql/server
          name: mydb
          env:
          - name: ACCEPT_EULA
            value: "Y"
          - name: SA_PASSWORD
            value: TestingPassword1
          - name: MSSQL_PID
            value: Developer
          ports:
          - containerPort: 1433
            name: mydb
          volumeMounts:
          - mountPath: "/var/opt/mssql"
            name: sqldata-storage
      ---
      apiVersion: v1
      kind: Service
      metadata:
         name: mydb
      spec:
        type: NodePort
        ports:
        - port: 1433
          nodePort: 31433
        selector:
          run: mydb
      ```
    - **kubectl apply -f storage.yaml**          
    - **kubectl apply -f sql-server.yaml**
    - los datos persistentes estarán en **/tmp/sqldata**

    #### DEPLOYEMENT ESCALABLE
    (basado https://docs.microsoft.com/es-es/sql/linux/tutorial-sql-server-containers-kubernetes?view=sql-server-ver15):
  - **storage.yaml** (contiene el Persistent Volume y el Persistent Volume Claim)
      ```
      apiVersion: v1
      kind: PersistentVolume
      metadata:
        name: sqldatax3
      spec:
        capacity:
          storage: 500Mi
        storageClassName: sqlserver
        accessModes:
          - ReadWriteMany
        hostPath:
          path: "/tmp/sqldatax3"
      ---
      apiVersion: v1
      kind: PersistentVolumeClaim
      metadata:
        name: dbclaimx3
      spec:
        accessModes:
          - ReadWriteMany
        storageClassName: sqlserver
        resources:
          requests:
            storage: 400Mi      
      ```  
  - **sql-server.yaml**
      ```
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: mssql-deployment
      spec:
        replicas: 1
        selector:
           matchLabels:
             app: mssql
        template:
          metadata:
            labels:
              app: mssql
          spec:
            terminationGracePeriodSeconds: 30
            hostname: mssqlinst
            securityContext:
              fsGroup: 10001
            containers:
            - name: mssql
              image: mcr.microsoft.com/mssql/server:2019-latest
              ports:
              - containerPort: 1433
              env:
              - name: MSSQL_PID
                value: "Developer"
              - name: ACCEPT_EULA
                value: "Y"
              - name: SA_PASSWORD
                valueFrom:
                  secretKeyRef:
                    name: mssql
                    key: SA_PASSWORD
              volumeMounts:
              - name: mssqldb
                mountPath: /tmp/sqldatax3
            volumes:
            - name: mssqldb
              persistentVolumeClaim:
                claimName: dbclaimx3
      ---
      apiVersion: v1
      kind: Service
      metadata:
        name: mssql-deployment
      spec:
        selector:
          app: mssql
        ports:
          - protocol: TCP
            port: 1433
            targetPort: 32000
        type: LoadBalancer
      ```
  - **kubectl apply -f storage.yaml**          
  - **kubectl apply -f sql-server.yaml**
  - los datos persistentes estarán en **/tmp/sqldata**
