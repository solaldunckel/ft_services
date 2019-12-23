all:
	@bash ./setup.sh

list:
	minikube service list

pods:
	kubectl get pods

clean:
	@bash ./clean.sh
