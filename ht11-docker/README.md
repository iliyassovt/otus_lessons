# Docker
 
## Задачи 
1. Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен
отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx)
2. Определите разницу между контейнером и образом. Вывод опишите в домашнем задании.
3. Ответьте на вопрос: Можно ли в контейнере собрать ядро?
4. Собранный образ необходимо запушить в docker hub и дать ссылку на ваш
репозиторий.
5. Задание со * (звездочкой)
Создайте кастомные образы nginx и php, объедините их в docker-compose.
После запуска nginx должен показывать php info.
Все собранные образы должны быть в docker hub


-------------------------------------------------------

Выполнение



1) Создание своего кастомного образа (Dockerfile)
```
FROM alpine:3.11
RUN apk update && apk add nginx && rm -rf /var/cache/apk/*
COPY ./nginx.conf /etc/nginx/
COPY ./default.conf /etc/nginx/conf.d/
RUN mkdir -p /usr/share/nginx/html  && echo "Hello World! From Otus" > /usr/share/nginx/html/index.html
EXPOSE 80
CMD [ "nginx" ]
```


Собираем образ на основе Dockerfile

```
root@temir8173-X555LJ:/home/temir8173/otus_lessons/ht11-docker# docker build -t temir8173/custom_nginx:v1 .
Sending build context to Docker daemon  4.608kB
Step 1/7 : FROM alpine:3.11
3.11: Pulling from library/alpine
cbdbe7a5bc2a: Pull complete 
Digest: sha256:9a839e63dad54c3a6d1834e29692c8492d93f90c59c978c1ed79109ea4fb9a54
Status: Downloaded newer image for alpine:3.11
 ---> f70734b6a266
Step 2/7 : RUN apk update && apk add nginx && rm -rf /var/cache/apk/*
 ---> Running in 3e465e6250b5
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.11/community/x86_64/APKINDEX.tar.gz
v3.11.6-88-gb2f81f5a10 [http://dl-cdn.alpinelinux.org/alpine/v3.11/main]
v3.11.6-86-gf4e478f351 [http://dl-cdn.alpinelinux.org/alpine/v3.11/community]
OK: 11271 distinct packages available
(1/2) Installing pcre (8.43-r0)
(2/2) Installing nginx (1.16.1-r6)
Executing nginx-1.16.1-r6.pre-install
Executing busybox-1.31.1-r9.trigger
OK: 7 MiB in 16 packages
Removing intermediate container 3e465e6250b5
 ---> fe4ecce2ed7b
Step 3/7 : COPY ./nginx.conf /etc/nginx/
 ---> ac2f93c8b230
Step 4/7 : COPY ./default.conf /etc/nginx/conf.d/
 ---> cf3b0c661c2b
Step 5/7 : RUN mkdir -p /usr/share/nginx/html  && echo "Hello World! From Otus" > /usr/share/nginx/html/index.html
 ---> Running in 4e6baac5c1ab
Removing intermediate container 4e6baac5c1ab
 ---> fda307696ba5
Step 6/7 : EXPOSE 80
 ---> Running in b947391e4607
Removing intermediate container b947391e4607
 ---> 090b0189ffe8
Step 7/7 : CMD [ "nginx" ]
 ---> Running in 5937104f0937
Removing intermediate container 5937104f0937
 ---> 5c2a83886a95
Successfully built 5c2a83886a95
Successfully tagged temir8173/custom_nginx:v1



root@temir8173-X555LJ:/home/temir8173/otus_lessons/ht11-docker# 
root@temir8173-X555LJ:/home/temir8173/otus_lessons/ht11-docker# docker images
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
temir8173/custom_nginx   v1                  5c2a83886a95        9 seconds ago       7.02MB
ubuntu                   latest              74435f89ab78        8 days ago          73.9MB
nginx                    latest              2622e6cca7eb        2 weeks ago         132MB
alpine                   3.11                f70734b6a266        2 months ago        5.61MB
hello-world              latest              bf756fb1ae65        5 months ago        13.3kB
```

Запускаем контайнер и проверяем работу nginx
```
root@temir8173-X555LJ:/home/temir8173/otus_lessons/ht11-docker# docker run -d -p 80:80 temir8173/custom_nginx:v1
578f155179b711f7e3cfc25ed6d7396851d3e45d60fa314a104b4dbd4935fc74
root@temir8173-X555LJ:/home/temir8173/otus_lessons/ht11-docker# curl localhost
Hello World! From Otus
```

Отправляем собранный образ в docker hub

```
root@temir8173-X555LJ:/home/temir8173/otus_lessons/ht11-docker# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: temir8173
Password: 
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
root@temir8173-X555LJ:/home/temir8173/otus_lessons/ht11-docker# docker push temir8173/custom_nginx:v1
The push refers to repository [docker.io/temir8173/custom_nginx]
47ff343c0c94: Pushed 
26ae70d94729: Pushed 
71c2c8d974c0: Pushed 
2068e2648293: Pushed 
3e207b409db3: Mounted from library/alpine 
v1: digest: sha256:edfb2fe5490c4baf5d0661dc3b5c18f8d5dfba88da2064b320d1a65393e854a0 size: 1359
```

2) Определите разницу между контейнером и образом
Образ это это read-only шаблон. Образы используются для создания контейнеров. ocker позволяет легко создавать новые образы, обновлять существующие, или вы можете скачать образы созданные другими людьми. Образы — это компонента сборки docker-а.
Контейнер это экземпляр образа. Каждый контейнер изолирован и является безопасной платформой для приложения. Контейнеры могут быть созданы, запущены, остановлены, перенесены или удалены.

3) Можно ли в контейнере собрать ядро?
Собрать ядро можно, но загрузить - нет.

4) Ссылка на репозиторий [https://hub.docker.com/repository/docker/temir8173/custom_nginx](https://hub.docker.com/repository/docker/temir8173/custom_nginx)