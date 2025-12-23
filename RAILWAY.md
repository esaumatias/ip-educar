# Deploy no Railway

Este guia explica como fazer deploy do i-Educar no Railway.

## Pré-requisitos

1. Conta no [Railway](https://railway.app)
2. Repositório no GitHub/GitLab/Bitbucket

## Passo a Passo

### 1. Conectar o Repositório

1. Acesse [Railway Dashboard](https://railway.app/dashboard)
2. Clique em "New Project"
3. Selecione "Deploy from GitHub repo"
4. Escolha o repositório `ip-educar`
5. Selecione a branch `2.10`

### 2. Configurar Variáveis de Ambiente

No Railway, adicione as seguintes variáveis de ambiente:

#### Banco de Dados PostgreSQL
```
DB_CONNECTION=pgsql
DB_HOST=<host-do-postgres-railway>
DB_PORT=5432
DB_DATABASE=<nome-do-banco>
DB_USERNAME=<usuario>
DB_PASSWORD=<senha>
```

#### Configurações da Aplicação
```
APP_NAME="i-Educar"
APP_ENV=production
APP_KEY=<chave-laravel>
APP_DEBUG=false
APP_URL=<url-do-railway>
```

#### Cache e Sessão
```
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis
```

#### Redis (se usar serviço separado)
```
REDIS_HOST=<host-do-redis>
REDIS_PASSWORD=<senha-redis>
REDIS_PORT=6379
```

#### Outras Configurações
```
LOG_CHANNEL=stack
LOG_LEVEL=error
```

### 3. Adicionar Serviços

#### PostgreSQL
1. No projeto Railway, clique em "+ New"
2. Selecione "Database" → "Add PostgreSQL"
3. Railway criará automaticamente e fornecerá as variáveis de ambiente

#### Redis (Opcional)
1. Clique em "+ New"
2. Selecione "Database" → "Add Redis"
3. Configure as variáveis de ambiente

### 4. Gerar APP_KEY

Após o primeiro deploy, execute no terminal do Railway:

```bash
php artisan key:generate
```

Ou adicione manualmente no `.env` do Railway.

### 5. Executar Migrations

No terminal do Railway, execute:

```bash
php artisan migrate --force
```

### 6. Criar Link de Storage

```bash
php artisan storage:link
```

### 7. Configurar Permissões (se necessário)

```bash
chmod -R 775 storage bootstrap/cache
```

## Comandos Úteis

### Acessar Terminal do Railway
No dashboard do Railway, clique no serviço e depois em "Shell"

### Ver Logs
No dashboard, clique em "Deployments" → selecione um deployment → "View Logs"

### Executar Artisan Commands
```bash
php artisan <comando>
```

## Troubleshooting

### Erro: "APP_KEY não definido"
Execute: `php artisan key:generate`

### Erro: "Database connection failed"
Verifique as variáveis de ambiente do PostgreSQL no Railway

### Erro: "Storage não encontrado"
Execute: `php artisan storage:link`

### Erro: "Permissão negada"
Execute: `chmod -R 775 storage bootstrap/cache`

## Notas

- O Railway detecta automaticamente PHP/Laravel
- O build instala dependências do Composer e Yarn automaticamente
- O servidor inicia na porta definida pela variável `$PORT` (Railway define automaticamente)
- Para produção, considere usar um servidor web (Nginx/Apache) em vez de `php artisan serve`

