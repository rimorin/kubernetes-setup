# Setting up Kubernetes in GCP

## Requirements

- gcloud cli
- kubectl cli
- GCP account

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
gcloud container clusters create cluster-name-here --num-nodes=no-of-nodes-here --zone zone-here
```

Configure kubectl to point to created cluster (optional)

```shell script
gcloud config set container/cluster cluster-name-here
```

Once cluster is up, create namespace for cluster isolation.

```shell script
kubectl create namespace namespace-here
```

Configure k8s context to current namespace

```shell script
kubectl config set-context --current --namespace=namespace-name-here
```

Create configmap for ENV. This store API endpoints, Application configs, etc.
Includes secrets for API Keys, Passwords ,etc.

```shell script
kubectl apply -f misc
```

Install Cert Manager for automated provisioning and renewal of TLS certificates

```shell script
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.2/cert-manager.yaml
```

Configure cluster cert issuers for staging and production.

```shell script
kubectl apply -f issuers
```

build docker image and push to GCP container registry

```shell script
docker build -t container:v1 .

docker tag container:v1 gcr.io/project-id-here/container:v1

docker push gcr.io/project-id-here/container:v1
```

To deploy a container, run deployment script.

```shell script
kubectl apply -f deployment
```

To expose deployment to k8 internal network, run service script

```shell script
kubectl apply -f service
```

Test out deployment locally by port forwarding

```shell script
kubectl port-forward pod 8080:container port
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

Configure custom domain A record to point to external ip.

To connect service to the ingress, run ingress script

```shell script
kubectl apply -f ingress.yml
```

Give GCP sometime to update their network and app should appear

Once staging TLS is tested, apply production cert issuer

```shell script
kubectl annotate ingress web-ingress cert-manager.io/cluster-issuer=letsencrypt-production --overwrite
```

## Kustomize

Used to deploy K8 dynamically to both staging & production

Create the following file structure

> ```
> ~/.kustomize
> ├── base
> │   ├── deployment.yaml
> │   ├── kustomization.yaml
> │   └── service.yaml
> └── overlays
>     ├── development
>     │   ├── deployment.yaml
>     │   ├── kustomization.yaml
>     └── production
>         ├── deployment.yaml
>         ├── kustomization.yaml
> ```

Deploy kustomize script according to CI/CD setup.

```shell script
kubectl kustomize .kustomize/overlays/$ENVIRONMENT  > update.yaml
kubectl apply -f update.yaml
```
