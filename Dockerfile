FROM node as node
WORKDIR /var/www
COPY . .
RUN npm install && npm run prod

FROM composer as composer
WORKDIR /var/www
COPY . .
RUN composer install

FROM bycedric/laravel-serve as laravel
WORKDIR /var/www
COPY . .
COPY --from=node /var/www/public /var/www/public
COPY --from=composer /var/www/vendor /var/www/vendor

ENV SERVER_ROOT /var/www/public
ENV SERVER_NAME laravel-now

RUN chmod -R 777 storage
