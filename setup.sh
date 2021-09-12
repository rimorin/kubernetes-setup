gcloud container clusters update cluster-name --update-addons=HttpLoadBalancing=ENABLED

docker build -t dashboard:v1 .

docker tag dashboard:v1 gcr.io/s-a-322609/dashboard:v1

docker push gcr.io/s-a-322609/dashboard:v1

kubectl create configmap map-name

kubectl apply -f deployment.yaml

kubectl apply -f service.yaml

kubectl apply -f nginx.yaml


# for nginx ingress
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install nginx-ingress ingress-nginx/ingress-nginx
