(cd app1 && docker build -t k8s_app1:latest .)
(cd app2 && docker build -t k8s_app2:latest .)
(cd front_envoy && docker build -t k8s_front_envoy:latest .)
(cd job && docker build -t k8s_job:latest .)
