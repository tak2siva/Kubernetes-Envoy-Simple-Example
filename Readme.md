### Installation

Install minikube on your machine

### Setup

```
export FPROXY_IMAGE="k8s_front_proxy"
export APP1_IMAGE="k8s_app1"
export APP2_IMAGE="k8s_app2"
```

On the project directory run
```
eval $(minikube docker-env)
```

To start all services
```
sh start.sh
```

Check if all the pods are running.

To stop all services
```
sh stop.sh
```

To restart individiual services
```
sh front_envoy.sh
sh app1.sh
sh app2.sh
```

## Req Tracing
#### HTTP

Get node IP by
```
minikube ip
```

Hit
```
http://NODE_IP:30080/app/1/ping
pong from app1
```

app1 commuincate with app2
```
http://NODE_IP:30080/app/1/test
result from app2 - 1
```

Now the corresponding logs can be seen in zipkin
```
http://192.168.99.100:30011/
```

#### Grpc

Install grpc ruby tools

```
    gem install grpc
    gem install grpc-tools
```

Change dir
```
cd app1/src/
```

Change the ip address to match your NODE_IP in `grpc_client.rb`

```
ruby grpc_client.rb
```
```
Result: Hello from grpc - app1
 Response from app2: Hello from grpc - app2
```