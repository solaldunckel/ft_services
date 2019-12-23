# install kubectl
# install minikube
# brew install minikube
# start minikube

# TUTO
# kubectl create deployment hello-minikube --image=k8s.gcr.io/echoserver:1.10
# kubectl expose deployment hello-minikube --type=NodePort --port=8080
# kubectl get pod
# minikube service hello-minikube --url
# kubectl delete services hello-minikube

minikube start --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-30000

kubectl apply -f srcs/mysql.yaml ### MySQL
kubectl apply -f srcs/wordpress.yaml ### Wordpress
kubectl apply -f srcs/phpmyadmin.yaml ### Phpmyadmin
#kubectl apply -f srcs/ftps.yaml ### Phpmyadmin

# Dashboard

kubectl apply -f https://raw.githubusercontent.com/giantswarm/prometheus/master/manifests-all.yaml
kubectl port-forward --namespace monitoring service/grafana 3000:3000
# Ingress
# kubectl apply -f srcs/ingress.yaml
