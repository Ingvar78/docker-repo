Пункт 1. приводится как справочный для настройки базовых 

<details>
    <summary>1. Готовим окружение для работы с YC</summary>
    <br>

1.1. Cоздаём сервисный аккаунт, предоставляем роль editor

```
$ yc iam service-account create --name neto-robot --description "Service account for Netology"
```
1.2. Создаём авторизованный ключ для вашего сервисного аккаунта и сохраняем его в файл, он понадобится нам в дальнейшем при развёртывании инфраструктуры:

```
$ yc iam key create --service-account-name neto-robot --output key.json
```

1.3. Создайте ключ доступа для сервисного аккаунта:

```
iva@c9:~/Documents/YC $ yc iam access-key create --service-account-name neto-robot
access_key:
  id: ajee50ng7jcav6p2c6oq
  service_account_id: ajegb4hm7vmc8mtflcdq
  created_at: "2022-03-25T23:39:13.295548648Z"
  key_id: YCAJEou5UEaZBnd8uIJte-gcn
secret: YCOX5m-V59haXjhUWAKTWxFDNjwn1nSdZmFAnh0B
```

1.4. Узнайте идентификатор сервисного аккаунта по его имени:

```
iva@c9:~/Documents/YC $ yc iam service-account get neto-robot
id: ajegb4hm7vmc8mtflcdq
folder_id: b1gm6im3mcuc36r6kn8s
created_at: "2022-03-25T22:28:10Z"
name: neto-robot
description: Service account for Netology
```
или из списка доступных

```
iva@c9:~/Documents/YC $ yc iam service-account list
+----------------------+------------+
|          ID          |    NAME    |
+----------------------+------------+
| ajegb4hm7vmc8mtflcdq | neto-robot |
+----------------------+------------+
```

1.5. Назначьте роль сервисному аккаунту neto-robot, используя его идентификатор:

```
yc resource-manager folder add-access-binding netology \
    --role editor \
    --subject serviceAccount:ajegb4hm7vmc8mtflcdq
```

Параметры командной строки

--access-key STR: Идентификатор ключа доступа

--secret-key STR: Секретный ключ доступа

1.6. Переменные окружения. Если какой-либо параметр аутентификации не указан в командной строке, YDB CLI пробует его получить из следующих переменных окружения:

AWS_ACCESS_KEY_ID: Идентификатор ключа доступа

AWS_SECRET_ACCESS_KEY: Секретный ключ доступа

-- добавляем параметры к нашему окружению:

```
export YC_TOKEN='AQAEA7**************'
export AWS_ACCESS_KEY_ID='YCAJEou5UE*****************'
export AWS_SECRET_ACCESS_KEY='YCOX5m-*************************'
```
-- так же можно внести эти параметры в .bashrc

</details>


<details>
    <summary>2. Создаём сервисный аккаунт для работы с YC в рамках проекта и bucket</summary>
    <br>

2.1. В директории репозитория [deploy/1.0](./1.0/) расположены скрипты terraform для создания сервисного аккаунта и bucket для хранения текущего состояния инфраструктуры.

Перед выполнением terraform необходимо внести изменения в terraform.tfvars, указав соответсвующие параметры YC и данные сервисного аккаунта созданного на "Шаге 1" либо имеющегося административного аккаунта.

```
$ cat terraform.tfvars 
yc_cloud_id              = "b1gos10ashr7cgusvgg9"
yc_folder_id             = "b1gm6im3mcuc36r6kn8s"
yc_zone                  = "ru-central1-a"
service_account_key_file = "../YC/tf_sa_key.json"
sa_name			 = "neto-fdevops-13"
bucket_tf		 = "neto-bucket-fdevops-13"

```

```
$ terraform plan
$ terraform apply -auto-approve
$ terraform output -json sa_json_key_terraform >../YC/sa_json_key_terraform.json
```

Результатом выполнения будет создание bucket S3, сервисного аккаунта с ролью editor, файла с данными сервисного аккаунта - понадобятся нам в дальнейшем и будут использованы на всём протяжении.

</details>

<details>
    <summary>3. Создаyние инфраструктуры в YC</summary>
    <br>

3.1. астраиваем workspace и выбираем в качестве рабочего "stage"

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

3.2 Создаём инфраструктуру "Stage"

Перед созданием необходимо внести соответсвующие правки в конфигурационный файл переменных terraform.tfvars -указать данные для сервисного аккаунта полученные на "шаге 2", и данные для будущей авторизации на хостах

```
$ cat metadata.txt
#cloud-config
users:
  - name: ansible
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAAD<cut></cut>
```

```
/1.1 $ terraform plan - строим план, проверяем что получим в итоге

/1.1 $ terraform apply -auto-approve - применяем план

/1.1 $ terraform output - выводим данные инфраструктуры, они нам понадабятся при дальнейшем развёртывании. Включает в себя три ноды и контрол плэйн. а так же вспомогательные сервера для развёртывания деплоя и агентов teamcity
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
</details>

<details>
    <summary>4. Разворачиваем кластер используя kubesray</summary>
    <br>

4.1. Разворачивать будем с отдельновыделенного хоста который в будущем не будет входить в кластер. 

подключаемся из-вне:

```
$ ssh ansible@51.250.92.86

```

После подключения необходимо установить необходимые для дальнейшей работы пакеты:

```
$ sudo apt-get update -y && sudo apt-get install git mc python3-pip -y
```

разместить в директории сертификат и закрытый ключ id_rsa, выставить соответсвующие права и проверить что работает подлкючение с удалённой машины на целевые хосты

```
cd .ssh/
chmod 600 id_rsa
ls -la
clear
cd
ssh ansible@10.0.10.22
ssh ansible@10.0.10.11
ssh ansible@10.0.20.16
ssh ansible@10.0.30.30
```

клонируем репозиторий kubespray и производим настройку - выполняется на будущем controlplayn либо на deploer-хосте (в данном примере установка производилась с deployer)...

```
$ git clone https://github.com/kubernetes-sigs/kubespray
$ cd kubespray/
$ sudo pip3 install -r requirements.txt
$ cp -rfp inventory/sample inventory/mycluster
$ declare -a IPS=(10.0.10.22 10.0.10.11 10.0.20.16 10.0.30.30)
$ CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
$ cd inventory/mycluster/

ansible@deployer:~/kubespray/inventory/mycluster$ cat hosts.yaml
all:
  hosts:
    cp1:
      ansible_host: 10.0.10.22
      ip: 10.0.10.22
      access_ip: 10.0.10.22
    node1:
      ansible_host: 10.0.10.11
      ip: 10.0.10.11
      access_ip: 10.0.10.11
    node2:
      ansible_host: 10.0.20.16
      ip: 10.0.20.16
      access_ip: 10.0.20.16
    node3:
      ansible_host: 10.0.30.30
      ip: 10.0.30.30
      access_ip: 10.0.30.30
  children:
    kube_control_plane:
      hosts:
        cp1:
    kube_node:
      hosts:
        node1:
        node2:
        node3:
    etcd:
      hosts:
        cp1:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}

```

Для доступа из-вне необходимо раскоментировать соответствующую настройку в файле k8s-cluster.yml.

```
ansible@deployer:~/kubespray/inventory/mycluster/group_vars/k8s_cluster$ cat k8s-cluster.yml | grep suppl
supplementary_addresses_in_ssl_keys: [51.250.1.219]
```
Так же необходимо перед развёртыванием раскоментировать/выставить соответсвующие плагины.

Пример готовой конфигурации можно посмотреть в [deploy/2.0](./2.0)

Развёртывание подготовленной конфигурации выполняется командой:

```
ansible@deployer:~/kubespray$ ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -b -v
```

После окончания установки подключаемся к хосту controlplane по ssh и выполняем копируем сертификаты для доступа к нашему кластеру.

```
$ {     mkdir -p $HOME/.kube;     sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config;     sudo chown $(id -u):$(id -g) $HOME/.kube/config; }


$ kubectl get pods -n kube-system

$ kubectl get nodes
NAME    STATUS   ROLES           AGE   VERSION
cp1     Ready    control-plane   18d   v1.25.6
node1   Ready    <none>          18d   v1.25.6
node2   Ready    <none>          18d   v1.25.6
node3   Ready    <none>          18d   v1.25.6

```

</details>

details>
    <summary>2. Создаём сервисный аккаунт для работы с YC в рамках проекта</summary>
    <br>

    </br>
</details>

