# Check if the pod is deployed
function kubernetes_wait()
{
	printf "Deploying "$@"...\n"
	sleep 2;
	while [[ $(kubectl get pods -l app=$@ -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
		sleep 1;
	done
	printf $@" deployed!\n"
}

# Start the cluster
if [[ $(minikube status | grep -c "Running") == 0 ]]
then
	make clean
	minikube start --cpus=4 --memory 4000 --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000
fi

helm delete telegraf
helm delete influxdb
helm delete grafana

# Build Docker images
eval $(minikube docker-env)
docker build -t mysql_alpine srcs/mysql
docker build -t wordpress_alpine srcs/wordpress

# MySQL
kubectl apply -f srcs/mysql/mysql.yaml ### MySQL
kubernetes_wait mysql

# Wordpress
kubectl apply -f srcs/wordpress.yaml ### Wordpress
kubernetes_wait wordpress

# Phpmyadmin
kubectl apply -f srcs/phpmyadmin.yaml ### Phpmyadmin
kubernetes_wait phpmyadmin

helm install -f srcs/telegraf.yaml telegraf stable/telegraf
helm install -f srcs/influxdb.yaml influxdb stable/influxdb
helm install -f srcs/grafana.yaml grafana stable/grafana

# minikube addons enable ingress

#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
#kubectl apply -f srcs/nginx.yaml


# kubectl apply -f srcs/influxdb.yaml ### Phpmyadmin
# kubernetes_wait influxdb
#
# kubectl apply -f srcs/grafana.yaml ### Phpmyadmin
# kubernetes_wait grafana

minikube service wordpress --url

# helm install --name influxdb stable/influxdb
