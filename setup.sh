LIST=$(find ./srcs -name "*.yaml" -exec basename {} \;)

if [[ $1 = 'clean' ]]
then
	for FILE in $LIST
	do
		kubectl delete -f srcs/$FILE
	done
	exit
fi

# Start the cluster
if [[ $(minikube status | grep -c "Running") == 0 ]]
then
	minikube start --cpus=4 --memory 4000 --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000
	minikube addons enable ingress
fi

# Build Docker images
eval $(minikube docker-env)

docker build -t wordpress_alpine srcs/wordpress
docker build -t nginx_alpine srcs/nginx
docker build -t ftps_alpine srcs/ftps

# Build all services
for FILE in $LIST
do
	printf "Deploying "${FILE%%.*}"...\n"
	kubectl apply -f srcs/$FILE > /dev/null
	while [[ $(kubectl get pods -l app=${FILE%%.*} -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
		sleep 1;
	done
	printf "✓ "${FILE%%.*}" deployed!\n"
done

# Import wordpress database
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/mysql/wordpress.sql > /dev/null

printf "✓ ft_services deployment complete !\n"
printf "➜ You can access the project via this url: "$(minikube ip)"\n"

unset LIST

# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml

### TODO:
# - SSH for nginx
# - FTPS fix
# - Ingress Controller + Nginx
# - Grafana + InfluxDB
# - Monitor containers ??
# - Check restarts
