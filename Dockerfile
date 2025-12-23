FROM php:8.3-fpm-alpine

# Instalar dependências do sistema
RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libzip-dev \
    postgresql-dev \
    oniguruma-dev \
    nodejs \
    npm \
    yarn

# Instalar extensões PHP
RUN docker-php-ext-install \
    pdo \
    pdo_pgsql \
    pgsql \
    gd \
    zip \
    mbstring \
    bcmath \
    pcntl

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Definir diretório de trabalho
WORKDIR /app

# Copiar arquivos do projeto
COPY . .

# Instalar dependências
RUN composer install --no-dev --optimize-autoloader --no-interaction && \
    yarn install && \
    yarn build && \
    php artisan storage:link || true && \
    chmod -R 775 storage bootstrap/cache || true

# Expor porta (Railway define $PORT dinamicamente)
EXPOSE ${PORT:-8000}

# Comando de start
CMD sh -c "php artisan serve --host=0.0.0.0 --port=${PORT:-8000}"

