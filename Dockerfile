FROM php:8.4-cli-alpine

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

# Clonar pacotes necessários (se não estiverem no repositório)
RUN mkdir -p packages/portabilis && \
    if [ ! -d "packages/portabilis/i-educar-library-package" ]; then \
        git clone https://github.com/portabilis/i-educar-library-package.git packages/portabilis/i-educar-library-package || true; \
    fi && \
    if [ ! -d "packages/portabilis/pre-matricula-digital" ]; then \
        git clone https://github.com/portabilis/pre-matricula-digital.git packages/portabilis/pre-matricula-digital || true; \
    fi

# Instalar dependências
RUN composer install --no-dev --optimize-autoloader --no-interaction && \
    composer plug-and-play && \
    yarn install && \
    yarn build && \
    php artisan storage:link || true && \
    chmod -R 775 storage bootstrap/cache || true

# Expor porta (Railway define $PORT dinamicamente)
EXPOSE ${PORT:-8000}

# Comando de start
CMD sh -c "php artisan serve --host=0.0.0.0 --port=${PORT:-8000}"

