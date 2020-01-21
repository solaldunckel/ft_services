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

function build_yaml()
{
	kubectl apply -f srcs/$@.yaml > /dev/null
	printf "➜	Deploying $@...\n"
	sleep 2;
	while [[ $(kubectl get pods -l app=$@ -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
		sleep 1;
	done
	printf "✓	$@ deployed!\n"
}

# Set the minikube directory in /goinfre
export MINIKUBE_HOME="/goinfre"

# Start the cluster if it's not running
if [[ $(minikube status | grep -c "Running") == 0 ]]
then
	minikube start --cpus=2 --memory 4000 --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000
	minikube addons enable ingress
fi

# Set the docker images in Minikube
eval $(minikube docker-env)

# Build Docker images
docker build -t mysql_alpine srcs/mysql
docker build -t wordpress_alpine srcs/wordpress
docker build -t nginx_alpine srcs/nginx
# docker build -t ftps_alpine srcs/ftps

build_yaml mysql
build_yaml wordpress
build_yaml phpmyadmin
build_yaml nginx

# Import Wordpress database
kubectl exec -i $(kubectl get pods | grep mysql | cut -d" " -f1) -- mysql wordpress -u root < srcs/mysql/conf/wordpress.sql

# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
# kubectl apply -f srcs/ingress-nginx.yaml
# kubectl apply -f srcs/ingress.yaml

# kubectl apply \
  #--filename https://raw.githubusercontent.com/giantswarm/prometheus/master/manifests-all.yaml

printf "✓	ft_services deployment complete !\n"
printf "➜	You can access ft_services via this url: "$(minikube ip)"\n"

# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml

### TODO:
# - SSH for nginx
# - FTPS fix
# - Ingress Controller + Nginx
# - Grafana + InfluxDB
# - Monitor containers ??
# - Check restarts
