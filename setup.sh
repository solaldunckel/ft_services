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

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml

kubectl apply -f srcs/mysql.yaml
kubectl apply -f srcs/phpmyadmin.yaml
kubectl apply -f srcs/wordpress.yaml
