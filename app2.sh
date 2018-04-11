(cd app2; docker build -t $APP2_IMAGE:latest .)
#(cd app2; docker push $APP2_IMAGE:latest)

#kubectl delete deployments app2
#kubectl delete service app2
#kubectl delete configmap app2-sidecar-config
#
#kubectl create configmap app2-sidecar-config --from-file=k_app2/sidecar-envoy.json
#kubectl create -f k_app2/deployment.yml
#kubectl create -f k_app2/service.yml