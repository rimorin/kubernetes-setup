gcloud container clusters create cluster-name-here --num-nodes=1 --zone gcp-zone

docker build -t dashboard:v1 .

docker tag dashboard:v1 gcr.io/s-a-322609/dashboard:v1

docker push gcr.io/s-a-322609/dashboard:v1

kubectl apply -f deployment

kubectl apply -f service

kubectl apply -f misc

# for TLS certificate
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.2/cert-manager.yaml

kubectl apply -f issuers

# for nginx ingress
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx

kubectl apply -f ingress.yaml

kubectl annotate ingress dev-ingress cert-manager.io/cluster-issuer=production-issuer-here --overwrite