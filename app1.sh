(cd app1; docker build -t tak2siva/k8s_app1:latest .)
(cd app1; docker push tak2siva/k8s_app1:latest)

kubectl delete deployments app1
kubectl delete service app1
kubectl delete configmap app1-sidecar-config

kubectl create configmap app1-sidecar-config --from-file=k_app1/sidecar-envoy.json
kubectl create -f k_app1/deployment.yml
kubectl create -f k_app1/service.yml