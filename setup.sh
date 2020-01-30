### Setup in /goinfre for 42

if [ -d "/goinfre" ]; then
	# Ensure USER variabe is set
	[ -z "${USER}" ] && export USER=`whoami`

	mkdir -p /goinfre/$USER

	# Set the minikube directory in /goinfre
	export MINIKUBE_HOME="/goinfre/$USER"
fi

###

# Build function

function apply_yaml()
{
	kubectl apply -f srcs/$@.yaml > /dev/null
	printf "➜	Deploying $@...\n"
	sleep 2;
	while [[ $(kubectl get pods -l app=$@ -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
		sleep 1;
	done
	printf "✓	$@ deployed!\n"
}

# Deployment list

SERVICE_LIST="mysql phpmyadmin nginx wordpress ftps influxdb grafana telegraf"

# Clean if arg1 is clean

if [[ $1 = 'clean' ]]
then
	printf "➜	Cleaning all services...\n"
	for SERVICE in $SERVICE_LIST
	do
		kubectl delete -f srcs/$SERVICE.yaml > /dev/null
	done
	kubectl delete -f srcs/ingress.yaml > /dev/null
	printf "✓	Clean complete !\n"
	exit
fi

# Start the cluster if it's not running

if [[ $(minikube status | grep -c "Running") == 0 ]]
then
	minikube start --cpus=2 --memory 4000 --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000
	minikube addons enable metrics-server
	minikube addons enable ingress
	minikube addons enable dashboard
fi

MINIKUBE_IP=$(minikube ip)

# Set the docker images in Minikube

eval $(minikube docker-env)

# MINIKUBE_IP EDIT
cp srcs/wordpress/files/wordpress.sql srcs/wordpress/files/wordpress-tmp.sql
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/wordpress/files/wordpress-tmp.sql
cp srcs/ftps/scripts/start.sh srcs/ftps/scripts/start-tmp.sh
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/ftps/scripts/start-tmp.sh

# Build Docker images

printf "✓	Building Docker images...\n"

docker build -t mysql_alpine srcs/mysql
docker build -t wordpress_alpine srcs/wordpress
docker build -t nginx_alpine srcs/nginx
docker build -t ftps_alpine srcs/ftps
docker build -t grafana_alpine srcs/grafana

# Deploy services

printf "✓	Deploying services...\n"

for SERVICE in $SERVICE_LIST
do
	apply_yaml $SERVICE
done

kubectl apply -f srcs/ingress.yaml > /dev/null

# Import Wordpress database
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql -u root -e 'CREATE DATABASE wordpress;'
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/wordpress/files/wordpress-tmp.sql

# Remove TMP files
rm -rf srcs/ftps/scripts/start-tmp.sh
rm -rf srcs/wordpress/files/wordpress-tmp.sql

printf "✓	ft_services deployment complete !\n"
printf "➜	You can access ft_services via this url: $MINIKUBE_IP\n"

### Launch Dashboard
# minikube dashboard

### Test SSH
# ssh admin@$(minikube ip) -p 4000

### Crash Container
# kubectl exec -it $(kubectl get pods | grep mysql | cut -d" " -f1) -- /bin/sh -c "kill 1"

### Export/Import Files from containers
# kubectl cp srcs/grafana/grafana.db default/$(kubectl get pods | grep grafana | cut -d" " -f1):/var/lib/grafana/grafana.db
