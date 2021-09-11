# Setting up Kubernetes in GCP

## Requirements
* gcloud cli
* kubectl cli
* GCP account

## Getting started

After creating GCP account, configure gcloud cli using

```shell script
gcloud auth login 
```

Configure gcloud to point to project configured in GCP

```shell script
gcloud config set project GCP-PROJECT-ID
```

Configure compute/cluster zone

```shell script
gcloud config set compute/zone asia-southeast1-a
```

Create kubernetes cluster. Indicate cluster name and number of nodes.

```shell script
gcloud container clusters create cluster-name-here --num-nodes=1
```

Once cluster is up, create configmap for ENV. Indicate config naming.

```shell script
kubectl create configma config-name-here
```

create secrets for storing api-keys, passwords, etc

```shell script
kubectl create secrets generic secret-name-here
```

To modify secrets, 

```shell script
kubectl edit secret secret-name-here
```

create TLS to configure SSL

```shell script
kubectl create secret tls cert-name-here --cert cert-path-here --key cert-key-here
```

build docker image and push to GCP container registry

```shell script
docker build -t container:v1 .

docker tag container:v1 gcr.io/project-id-here/container:v1

docker push gcr.io/project-id-here/container:v1
```

To deploy a container, run deployment script. 
```shell script
kubectl apply -f deployment.yaml
```
 
To expose deployment to k8 internal network, run service script
```shell script
kubectl apply -f service.yaml
```

To expose service to the internet, configure ingress and run script

Install nginx ingress by using helm command

```shell script
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx
```

After the above, a ingress service will be created in the cluster

Retrieve the assigned external IP from the service.

```shell script
kubectl get service nginx-ingress-nginx-ingress
```

configure custom domain A record to point to external ip

To connect service to the ingress, run ingress script

```shell script
kubectl apply -f nginx.yml
```

Go GCP sometime to update their network and app should appear

