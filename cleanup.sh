#!/usr/bin/env bash

kubectl delete deployments front-envoy
kubectl delete service front-envoy
kubectl delete configmap front-envoy-config

kubectl delete deployments app1
kubectl delete service app1
kubectl delete configmap app1-sidecar-config

kubectl delete deployments app2
kubectl delete service app2
kubectl delete configmap app2-sidecar-config

kubectl delete deployments zipkin
kubectl delete service zipkin
