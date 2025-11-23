FROM php:8.4-fpm

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    procps \
    supervisor \
    && docker-php-ext-install pdo_mysql bcmath intl zip pcntl

# Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create user
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID phper && \
    useradd -u $UID -g phper -m phper && \
    mkdir -p /var/www/html && \
    chown -R phper:phper /var/www/html

# Supervisor config
COPY docker/php/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN mkdir -p /var/log/supervisor && chown -R phper:phper /var/log/supervisor /var/run

# Entrypoint
COPY docker/php/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER phper

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["php-fpm"]
