FROM node as node
WORKDIR /var/www
COPY . .
RUN npm install && npm run prod

FROM composer as composer
WORKDIR /var/www
COPY . .
RUN composer install

FROM bycedric/serve-laravel as laravel
WORKDIR /var/www
COPY . .
COPY --from=node /var/www/public /var/www/public
COPY --from=composer /var/www/vendor /var/www/vendor

ENV SERVER_ROOT /var/www/public
ENV SERVER_NAME laravel-now

EXPOSE 80

RUN mkdir -p \
	storage/app \
	storage/app/public \
	storage/framework \
	storage/framework/cache \
	storage/framework/sessions \
	storage/framework/testing \
	storage/framework/views \
	storage/logs

RUN chmod -R 777 storage
