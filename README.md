# Lynx DevOps Task

## build the application

from the root of the repo, run the following commands

### Building the container
```bash
docker build -t task-server:0.1 .
```

### Test run the image
```bash
docker run -d -p 8000:8000 --name task-server-test task-server:0.1
```

### Interact with the container (get all items)
```bash
curl http://localhost:8000/items
```
you should get something like:
```
[{"id":1,"name":"Item 1"}]
```
### stop the container
```bash
docker kill task-server-test
```
<br>

## Testing on minikube

### Spin up a minikube cluster
in order to run a minikube cluster use the minikube guide:<BR>
https://minikube.sigs.k8s.io/docs/start/

### Configure minikube for running the application
```bash
minikube addons enable ingress
```

### Deploy postgres instance to the cluster (using the included values.yaml)
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
kubectl create namespace postgresql
helm upgrade --install postgresql bitnami/postgresql -n postgresql --version 12.5.6 --values postgresql/values.yaml
```

### Load the application local image to the minikube node.
```bash 
minikube image load task-server:0.1
```

### Deploy the application using the provided chart.
```bash
kubectl create namespace task-server
helm install task-server chart/lynx-app -n task-server --values chart/lynx-app/values.yaml
```

### Test the deployment
```bash
curl --resolve "task-server.test:80:$( minikube ip )" -i http://task-server.test/items
```
proper reply should be:
```bash
HTTP/1.1 200 OK
Date: Tue, 13 Jun 2023 11:32:41 GMT
Content-Type: application/json
Content-Length: 20
Connection: keep-alive

[{"name":"Item 1"}]
```
