# ft_services

## Final grade : 100/100

## Description

ft_services is a project that ask you to setup a Kubernetes cluster with multiple containers such as Wordpress, MySQL, Grafana...

## Usage

You must have ```VirtualBox```, ```minikube``` and ```kubectl``` installed.
```shell
# Start the setup
./setup.sh

# Remove all containers
./setup.sh clean
```
After setup you can access the services through the IP that was assigned to you (```minikube ip```)

## Features
* ```FTPS``` on port 21
* ```MySQL``` on port 3306
* ```Wordpress``` on port 5050
* ```Phpmyadmin``` on port 5050
* ```Grafana``` on port 3000
* ```Nginx``` on port 80, 443 (SSL) and 4000 (SSH)
