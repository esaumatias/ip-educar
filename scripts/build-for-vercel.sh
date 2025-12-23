#!/bin/bash

# Script para preparar o projeto para deploy na Vercel
# Este script instala as dependências do Composer e prepara o vendor

echo "Instalando dependências do Composer..."
composer install --no-dev --optimize-autoloader --no-interaction

echo "Build concluído! O diretório vendor está pronto para commit."

