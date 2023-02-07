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

добавляем параметры к нашему окружению:

```
export YC_TOKEN='AQAEA7**************'
export AWS_ACCESS_KEY_ID='YCAJEou5UE*****************'
export AWS_SECRET_ACCESS_KEY='YCOX5m-*************************'
```
так же можно внести эти параметры в .bashrc

</br>
</details>
