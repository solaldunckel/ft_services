# Setup in /goinfre for 42
if [ -d "/goinfre/$USER" ]; then
	# Ensure USER variabe is set
	[ -z "${USER}" ] && export USER=`whoami`

	# Config
	docker_destination="/goinfre/$USER/docker" #=> Select docker destination (goinfre is a good choice)

	# Create needed files in destination and make symlinks
	if [ ! -d $docker_destination ]; then
		pkill Docker
		rm -rf ~/Library/Containers/com.docker.docker ~/.docker
		mkdir -p $docker_destination/{com.docker.docker,.docker}
		ln -sf $docker_destination/com.docker.docker ~/Library/Containers/com.docker.docker
		ln -sf $docker_destination/.docker ~/.docker
	fi

	# Set the minikube directory in /goinfre
	export MINIKUBE_HOME="/goinfre/$USER"
fi

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

# yaml list in $LIST
LIST=$(find ./srcs -name "*.yaml" -exec basename {} \;)

# Clean if arg1 is clean
if [[ $1 = 'clean' ]]
then
	for FILE in $LIST
	do
		kubectl delete -f srcs/$FILE
	done
	exit
fi

# Start the cluster if it's not running
if [[ $(minikube status | grep -c "Running") == 0 ]]
then
	minikube start --cpus=2 --memory 4000 --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000
	minikube addons enable ingress
fi

MINIKUBE_IP=$(minikube ip)

# Set the docker images in Minikube
eval $(minikube docker-env)

# Build Docker images
docker build -t mysql_alpine srcs/mysql
docker build -t wordpress_alpine srcs/wordpress
docker build -t nginx_alpine srcs/nginx
# docker build -t ftps_alpine srcs/ftps

apply_yaml mysql
apply_yaml wordpress
apply_yaml phpmyadmin
apply_yaml nginx

# Import Wordpress database
cp srcs/mysql/files/wordpress.sql srcs/mysql/files/wordpress-target.sql
sed -i '' "s/MINIKUBE_IP/$MINIKUBE_IP/g" srcs/mysql/files/wordpress-target.sql
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/mysql/files/wordpress-target.sql
rm -rf srcs/mysql/files/wordpress-target.sql

printf "✓	ft_services deployment complete !\n"
printf "➜	You can access ft_services via this url: $MINIKUBE_IP\n"

# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
# kubectl apply -f srcs/ingress-nginx.yaml
# kubectl apply -f srcs/ingress.yaml

# kubectl apply \
  #--filename https://raw.githubusercontent.com/giantswarm/prometheus/master/manifests-all.yaml

# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml

### TODO:
# - SSH for nginx
# - FTPS fix
# - Ingress Controller + Nginx
# - Grafana + InfluxDB
# - Monitor containers ??
# - Check restarts
