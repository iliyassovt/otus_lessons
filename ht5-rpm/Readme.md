Был взят пакет NGINX и собран с поддержкой openssl

SPEC файл NGINX с необходимыми опциями:

![](pics/1.png)

Собираем RPM пакет

rpmbuild -bb rpmbuild/SPECS/nginx.spec

Смотрим пакеты 

![](pics/2.png)

Создаем репозиторий

![](pics/3.png)

Ссылка на репо - http://shaqiru.kz/repo

Проверяем репо установив пакет percona-release

![](pics/4.png)