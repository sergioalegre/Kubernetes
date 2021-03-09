
[#nodos](#nodos)

[#pods](#pods)

[#deployments](#deployments)

[#escalar/desescalar](#escalar/desescalar)

[#namespaces](#namespaces)

[#MSSQL_Server](#MSSQL_Server)


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
  - eliminar despliegue desde .yml **kubectl delete -f sql-server.yaml**
  - exponer un pod hay que indicar el nombre del pod a exponer y el puerto: **kubectl expose deployment hello-http --type=LoadBalancer --port=80**
  - listar servicios expuestos: **kubectl get services**
  - listar volumenes persistentes **kubectl get pv**

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

### MSSQL_Server
  - https://www.phillipsj.net/posts/sql-server-on-linux-on-kubernetes-part-1/
  - https://www.phillipsj.net/posts/sql-server-on-linux-on-kubernetes-part-2/
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
