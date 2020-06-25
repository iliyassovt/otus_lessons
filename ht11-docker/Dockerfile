FROM alpine:3.11
RUN apk update && apk add nginx && rm -rf /var/cache/apk/*
COPY ./nginx.conf /etc/nginx/
COPY ./default.conf /etc/nginx/conf.d/
RUN mkdir -p /usr/share/nginx/html  && echo "Hello World! From Otus" > /usr/share/nginx/html/index.html
EXPOSE 80
CMD [ "nginx" ]