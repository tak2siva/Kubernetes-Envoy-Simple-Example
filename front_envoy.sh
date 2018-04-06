(cd front_envoy; docker build -t $FPROXY_IMAGE:latest .)
#(cd front_envoy; docker push $FPROXY_IMAGE:latest)

kubectl delete deployments front-envoy
kubectl delete service front-envoy
kubectl delete configmap front-envoy-config

kubectl create configmap front-envoy-config --from-file=front_envoy/front-envoy.json
kubectl create -f k_front_envoy/deployment.yml
kubectl create -f k_front_envoy/service.yml