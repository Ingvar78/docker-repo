
```

  Enter a value: yes

yandex_compute_instance.k8s_deployer[0]: Creating...
yandex_compute_instance.cicd_agent[0]: Creating...
yandex_compute_instance.cicd_master[0]: Creating...
yandex_compute_instance.cicd_agent[0]: Creation complete after 27s [id=fhmt5l812lie67ns5sao]
yandex_compute_instance.k8s_deployer[0]: Creation complete after 29s [id=fhm446490t4h1nfaqo4s]
yandex_compute_instance.cicd_master[0]: Creation complete after 35s [id=fhme06chggl5qie2eubj]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

cicd_agent_nat_IP = [
  "51.250.64.168",
]
cicd_agents_IP = [
  "10.0.10.12",
]
cicd_master_IP = [
  "10.0.10.6",
]
cicd_master_nat_IP = [
  "51.250.73.25",
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

```
$ ansible-playbook -i inventory/cicd/hosts.yml jenkins.yml
```