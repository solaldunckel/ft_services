kubectl delete -f srcs/mysql/mysql.yaml ### MySQL
kubectl delete -f srcs/wordpress.yaml ### Wordpress
kubectl delete -f srcs/phpmyadmin.yaml ### Phpmyadmin
kubectl delete -f srcs/influxdb.yaml ### Phpmyadmin
kubectl delete -f srcs/grafana.yaml ### Phpmyadmin
kubectl delete -f srcs/nginx.yaml ### Phpmyadmin
helm delete telegraf
helm delete influxdb
helm delete grafana
# kubectl delete -f srcs/ingress.yaml

# minikube delete
