(cd app1; docker build -t $APP1_IMAGE:latest .)
#(cd app1; docker push $APP1_IMAGE:latest)

kubectl delete deployments app1
kubectl delete service app1
kubectl delete configmap app1-sidecar-config

kubectl create configmap app1-sidecar-config --from-file=k_app1/sidecar-envoy.json
kubectl create -f k_app1/deployment.yml
kubectl create -f k_app1/service.yml