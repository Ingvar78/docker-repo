FROM nginx:stable
# Создаём директорию размещения
RUN mkdir /var/wwww
# Копируем конфигурацию
COPY ./nginxconfig/nginx.conf /etc/nginx/nginx.conf
# копируем данные сайта (index.html)
#COPY index.html /var/www/
COPY ./site /var/www/
# Порт для публикации
EXPOSE 80 
# запускаем nginx в докер контейнере 
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
