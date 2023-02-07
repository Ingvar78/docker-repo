настраиваем workspace и выбираем в качестве рабочего "stage"

```
/1.1 $ terraform workspace list 
* default

/1.1 $ terraform workspace new stage
Created and switched to workspace "stage"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.

/1.1 $ terraform workspace list 
  default
* stage

/1.1 $ terraform workspace new prod
Created and switched to workspace "prod"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.

/1.1 $ terraform workspace list 
  default
* prod
  stage

/1.1 $ terraform workspace select stage
Switched to workspace "stage".
iva@c9v:~/Documents/Diplom/1.1 $ terraform workspace list 
  default
  prod
* stage


```

Создаём инфраструктуру "Stage"

```

/1.1 $ terraform plan

/1.1 $ terraform apply -auto-approve

/1.1 $ ./generate_inventory.sh 
[all]
node-1   ansible_host=10.0.10.33   ip=10.0.10.33   etcd_member_name=etcd-1
node-2   ansible_host=10.0.20.31   ip=10.0.20.31   etcd_member_name=etcd-2
node-3   ansible_host=10.0.30.34   ip=10.0.30.34   etcd_member_name=etcd-3
cp-1   ansible_host=158.160.56.132   ip=10.0.10.29
worker-1   ansible_host=158.160.56.132   ip=10.0.10.29

[all:vars]
ansible_user=ansible
supplementary_addresses_in_ssl_keys='["158.160.56.132"]

[bastion]ansible_user=ansible
bastion ansible_host='["158.160.50.226"]'

[kube_control_plane]
cp-1

[kube_node]
node-1
node-2
node-3

[etcd]
etcd-1
etcd-2
etcd-3

[worker_node]
worker-1

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr

```

```
/1.1 $ terraform output 
cicd_agent_nat_IP = [
  "84.201.129.17",
]
cicd_agents_IP = [
  "10.0.10.8",
]
cicd_master_IP = [
  "10.0.10.31",
]
cicd_master_nat_IP = [
  "84.201.173.5",
]
k8s_cp_IP = [
  "10.0.10.22",
]
k8s_cp_nat_IP = [
  "51.250.1.219",
]
k8s_deployer_IP = [
  "10.0.10.25",
]
k8s_deployer_nat_IP = [
  "51.250.92.86",
]
k8s_node_IP = [
  "10.0.10.11",
  "10.0.20.16",
  "10.0.30.30",
]
workspace = "stage"
```