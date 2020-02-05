# ft_services

## Description

ft_services is a project that ask you to setup a Kubernetes cluster with multiple containers such as Wordpress, MySQL, Grafana...

## Usage

You must have ```Docker```, ```VirtualBox```, ```minikube``` and ```kubectl``` installed.

* Setup :
```shell
# Start the setup
./setup.sh

# Remove all containers
./setup.sh clean
```

* Exposed services access :

```ip_address:port```

* SSH :
```shell
ssh admin@$(minikube ip) -p 4000
```

* FTPS :

Use ```Filezilla``` and connect with ```admin:admin``` on port 21

## Features
* ```FTPS``` on port 21
* ```MySQL``` on port 3306
* ```Wordpress``` on port 5050
* ```Phpmyadmin``` on port 5050
* ```Grafana``` on port 3000
* ```InfluxDB``` on port 8086
* ```Nginx``` on port 80, 443 (SSL) and 4000 (SSH)
