# Kubernetes Phonebook Project Guide

# Outline

# Setting up Kubernetes Cluster
# Setup Docker files
# Pushed to Docker hub repository
# Secret and Config Volumes
# Services
 # SQL Deployment file
# Web Deployments
# Create Kubernetes Cluster

# Part 1 - Setting up the Kubernetes Cluster

Launch a Kubernetes Cluster of Ubuntu 20.04 with two nodes (one master, one worker) using the Cloudformation Template to Create Kubernetes Cluster. Note: Once the master node is up and running, the worker node automatically joins the cluster.

Check if Kubernetes is running and nodes are ready.

kubectl cluster-info
kubectl get node

# Part 2 - Setup Docker files

Create two docker files for both Search and Web

FROM python:flask
COPY . /app
WORKDIR /app
RUN pip install –r requirements.txt
EXPOSE 80
CMD python ./app.py

# Part 3 - Pushed to Docker Hub Repository
Open the terminal in each folder where your project files and docker file are located

Docker build –t “<docker hub-account>/<image-name>: tag”

# Part 4 - Secret and ConfigMap Volumes
mkdir configuration_files
cd configuration_files

#  Touch configmap.yaml

Encode password

Echo –n ‘password’ | base64

---
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-configmap
data:
  mysql-database: phonebook #
  mysql-host: mysql-service

# Touch secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name:  mysql-secret
data:
  mysql-root-password: c2VjcmV0
  mysql-password: c2VjcmV0
  mysql-username: Y2xhcnVzd2F5
type: Opaque

# Part 5 - Persistent Volumes
# Db-pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: db-pv-vol
  labels:
    type: local #remote
spec:
  storageClassName: manual
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/home/ubuntu/mnt/data"
Db-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: database-persistent-volume-claim
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 1Gi

# Part 6 - DB deployment and Service
apiVersion: apps/v1
kind: Deployment
metadata:
  name:  mysql-deployment
  labels:
    app:  mysql
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name:  mysql
        image:  mysql:5.7
        ports:
        - containerPort: 3306
        env:
        - name:  MYSQL_ROOT_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: mysql-root-password
        - name:  MYSQL_PASSWORD
          valueFrom:
            secretKeyRef:
              name: mysql-secret
              key: mysql-password
        - name: MYSQL_USER
          valueFrom:
            configMapKeyRef:
              name: mysql-secret
              key: mysql-username
        - name: MYSQL_DATABASE
          valueFrom:
            configMapKeyRef:
              name: mysql-configmap
              key: mysql-database
        volumeMounts:
          - name: mysql-storage
            mountPath: /mnt/data
      volumes:
        - name: mysql-storage
          persistentVolumeClaim:
            claimName: database-persistent-volume-claim

Part 7 - Web Deployment and Service
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-deployment
  labels:
    name: web-search
    app: phonebook-web
spec:
  replicas: 3
  selector:
    matchLabels:
      name: web-search
      app: phonebook-web
  template:
    metadata:
      labels:
        name: web-search
        app: phonebook-web
    spec:
      containers:
        - image: engingltekin/phonebook-flask-app_web:1.0
          imagePullPolicy: Always
          name: myweb
          ports:
            - containerPort: 80
          env:
            - name: MYSQL_DATABASE_HOST
              valueFrom:
                configMapKeyRef:
                  name: mysql-configmap
                  key: mysql-host
            - name: MYSQL_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: mysql-password
            - name: MYSQL_DATABASE
              valueFrom:
                configMapKeyRef:
                  name: mysql-configmap
                  key: mysql-database
            - name: MYSQL_USER
              valueFrom:
                configMapKeyRef:
                  name: mysql-secret
                  key: mysql-username
          resources:
            limits:
              memory: 500Mi
              cpu: 100m
            requests:
              memory: 250Mi
              cpu: 80m	
---
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: phonebook-web
  type: NodePort
  ports:
    - protocol: TCP
      nodePort: 30002
      port: 5000
      targetPort: 80

# Part 8 - Search Deployment and Service
apiVersion: apps/v1
kind: Deployment
metadata:
  name: crud-deployment
  labels:
    name: crud-ops
    app: phonebook-crud
spec:
  replicas: 3
  selector:
    matchLabels:
      name: crud-ops
      app: phonebook-crud
  template:
    metadata:
      labels:
        name: crud-ops
        app: phonebook-crud
    spec:
      containers:
        - image: engingltekin/phonebook-flask-app_result:1.0
          imagePullPolicy: Always
          name: myweb
          ports:
            - containerPort: 80
          env:
            - name: MYSQL_DATABASE_HOST
              valueFrom:
                configMapKeyRef:
                  name: mysql-configmap
                  key: mysql-host
            - name: MYSQL_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: mysql-password
            - name: MYSQL_DATABASE
              valueFrom:
                configMapKeyRef:
                  name: mysql-configmap
                  key: mysql-database
            - name: MYSQL_USER
              valueFrom:
                configMapKeyRef:
                  name: mysql-secret
                  key: mysql-username
          resources:
            limits:
              memory: 500Mi
              cpu: 100m
            requests:
              memory: 250Mi
              cpu: 80m	
--- 
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  selector:
    app: phonebook-web
  type: NodePort
  ports:
    - protocol: TCP
      nodePort: 30002
      port: 5000
      targetPort: 80

# Part 9 - Apply Manifest files