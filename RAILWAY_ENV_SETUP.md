# Guia de Configuração de Variáveis de Ambiente no Railway

Este guia explica como configurar as variáveis de ambiente no Railway para o i-Educar em produção.

## 📋 Passo a Passo

### 1. Acessar as Configurações do Projeto

1. Acesse o [Railway Dashboard](https://railway.app/dashboard)
2. Clique no seu projeto `ip-educar`
3. Clique no serviço da aplicação (não no banco de dados)
4. Vá na aba **"Variables"** (ou clique em **"Settings"** → **"Variables"**)

### 2. Adicionar Variáveis de Ambiente

No Railway, você pode adicionar variáveis de duas formas:

#### Opção A: Interface Web
1. Clique em **"+ New Variable"** ou **"Add Variable"**
2. Digite o nome da variável (ex: `APP_NAME`)
3. Digite o valor (ex: `i-Educar`)
4. Clique em **"Add"**

#### Opção B: Arquivo .env (Recomendado)
1. Clique em **"Raw Editor"** ou **"Edit as File"**
2. Cole todas as variáveis no formato:
   ```
   APP_NAME=i-Educar
   APP_ENV=production
   APP_KEY=
   ```
3. Clique em **"Save"**

### 3. Variáveis Obrigatórias

#### 🔑 Configurações Básicas da Aplicação

```env
APP_NAME="i-Educar"
APP_ENV=production
APP_KEY=base64:SUA_CHAVE_AQUI
APP_DEBUG=false
APP_URL=https://seu-projeto.railway.app
APP_TIMEZONE=America/Sao_Paulo
```

**⚠️ IMPORTANTE:** Para gerar o `APP_KEY`, execute no terminal do Railway:
```bash
php artisan key:generate --show
```
Copie a chave gerada e cole no valor de `APP_KEY`.

#### 🗄️ Banco de Dados PostgreSQL

**Se você adicionou um serviço PostgreSQL no Railway:**

O Railway cria automaticamente estas variáveis quando você adiciona um banco PostgreSQL. **IMPORTANTE:** O nome do serviço pode variar. Verifique o nome exato do seu serviço PostgreSQL no Railway.

**Método 1: Usando referências do Railway (Recomendado)**

1. No Railway, clique no serviço PostgreSQL
2. Vá em **"Variables"**
3. Procure pelas variáveis que começam com `PGHOST`, `PGPORT`, etc.
4. Use o nome do serviço exato. Se o serviço se chama "Postgres", use:

```env
DB_CONNECTION=pgsql
DB_HOST=${{Postgres.PGHOST}}
DB_PORT=${{Postgres.PGPORT}}
DB_DATABASE=${{Postgres.PGDATABASE}}
DB_USERNAME=${{Postgres.PGUSER}}
DB_PASSWORD=${{Postgres.PGPASSWORD}}
```

**Se o serviço tem outro nome (ex: "postgres", "database", "db"):**

```env
DB_CONNECTION=pgsql
DB_HOST=${{postgres.PGHOST}}  # ou ${{database.PGHOST}}, ${{db.PGHOST}}
DB_PORT=${{postgres.PGPORT}}
DB_DATABASE=${{postgres.PGDATABASE}}
DB_USERNAME=${{postgres.PGUSER}}
DB_PASSWORD=${{postgres.PGPASSWORD}}
```

**Método 2: Usando valores diretos**

Se as referências não funcionarem, copie os valores diretamente:

1. No serviço PostgreSQL, vá em **"Variables"**
2. Copie os valores de `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, `PGPASSWORD`
3. Configure assim:

```env
DB_CONNECTION=pgsql
DB_HOST=<valor-copiado-de-PGHOST>
DB_PORT=<valor-copiado-de-PGPORT>
DB_DATABASE=<valor-copiado-de-PGDATABASE>
DB_USERNAME=<valor-copiado-de-PGUSER>
DB_PASSWORD=<valor-copiado-de-PGPASSWORD>
```

**⚠️ IMPORTANTE:** 
- O `PGHOST` geralmente é algo como `containers-us-west-xxx.railway.app` ou um IP
- **NÃO** use `postgres.railway.internal` - isso é um hostname interno que pode não funcionar
- Use o valor exato que aparece na variável `PGHOST` do serviço PostgreSQL

**Se você usa um PostgreSQL externo:**

```env
DB_CONNECTION=pgsql
DB_HOST=seu-host-postgres.com
DB_PORT=5432
DB_DATABASE=ieducar
DB_USERNAME=seu_usuario
DB_PASSWORD=sua_senha
```

#### 🔴 Redis (Cache e Sessões)

**Se você adicionou um serviço Redis no Railway:**

```env
REDIS_HOST=${{Redis.REDIS_HOST}}
REDIS_PASSWORD=${{Redis.REDIS_PASSWORD}}
REDIS_PORT=${{Redis.REDIS_PORT}}
REDIS_CLIENT=predis

CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis
```

**Se você usa Redis externo ou não tem Redis:**

```env
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_CONNECTION=sync
```

#### 📧 Configurações de Email (Opcional)

```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=seu-email@gmail.com
MAIL_PASSWORD=sua-senha-app
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@ieducar.com.br
MAIL_FROM_NAME="${APP_NAME}"
```

#### 🔐 API Keys (Opcional)

```env
API_ACCESS_KEY=ieducar-access-key
API_SECRET_KEY=ieducar-secret-key
```

#### 📝 Logs

```env
LOG_CHANNEL=stack
LOG_LEVEL=error
LOG_DEPRECATIONS_CHANNEL=null
```

#### 🎨 Pré-Matrícula Digital (Se instalado)

```env
FRONTIER_PROXY_HOST=http://pmd:5173
FRONTIER_PROXY_RULES=/pre-matricula-digital::replace(/resources/ts/main.ts,http://localhost:5173/resources/ts/main.ts)::replace(/@vite/client,http://localhost:5173/@vite/client)

PMD_IBGE_CODES=
PMD_CITY=
PMD_STATE=
PMD_MAP_LATITUDE=
PMD_MAP_LONGITUDE=
PMD_MAP_ZOOM=
PMD_LOGO=
```

#### 🌐 Outras Configurações

```env
BROADCAST_DRIVER=log
FILESYSTEM_DISK=local
```

### 4. Adicionar Serviços no Railway

#### PostgreSQL

1. No projeto Railway, clique em **"+ New"**
2. Selecione **"Database"** → **"Add PostgreSQL"**
3. O Railway criará automaticamente e fornecerá as variáveis de ambiente
4. Use as variáveis `${{Postgres.*}}` conforme mostrado acima

#### Redis (Opcional, mas Recomendado)

1. Clique em **"+ New"**
2. Selecione **"Database"** → **"Add Redis"**
3. Use as variáveis `${{Redis.*}}` conforme mostrado acima

### 5. Comandos Pós-Deploy

Após configurar as variáveis e fazer o primeiro deploy, execute no terminal do Railway:

```bash
# Gerar APP_KEY (se ainda não foi gerado)
php artisan key:generate

# Executar migrations
php artisan migrate --force

# Criar link de storage
php artisan storage:link

# Popular banco de dados (opcional)
php artisan db:seed

# Limpar cache
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear
```

### 6. Verificar Configuração

Para verificar se as variáveis estão corretas:

```bash
# Ver todas as variáveis de ambiente
php artisan tinker
>>> config('database.connections.pgsql')
>>> config('app.key')
```

## 🔧 Troubleshooting

### Erro: "could not translate host name to address"

**Problema:** O hostname do PostgreSQL não está sendo resolvido.

**Solução:**

1. **Verifique se o PostgreSQL foi adicionado:**
   - No Railway, veja se há um serviço PostgreSQL no projeto
   - Se não houver, adicione: "+ New" → "Database" → "Add PostgreSQL"

2. **Verifique o nome do serviço:**
   - Clique no serviço PostgreSQL
   - Veja o nome exato (pode ser "Postgres", "postgres", "database", etc.)
   - Use esse nome nas referências: `${{NomeDoServico.PGHOST}}`

3. **Copie os valores diretamente:**
   - No serviço PostgreSQL, vá em "Variables"
   - Copie o valor de `PGHOST` (não use `postgres.railway.internal`)
   - Cole diretamente em `DB_HOST`:
     ```env
     DB_HOST=containers-us-west-xxx.railway.app  # exemplo
     ```

4. **Verifique se as variáveis estão no serviço correto:**
   - As variáveis `DB_*` devem estar no serviço da **aplicação**, não no PostgreSQL
   - O serviço PostgreSQL tem variáveis `PG*`
   - O serviço da aplicação deve ter variáveis `DB_*` que apontam para o PostgreSQL

### Erro: "APP_KEY não definido"
Execute: `php artisan key:generate`

### Erro: "Database connection failed"
- Verifique se o PostgreSQL está rodando (status "Running" no Railway)
- Verifique se as variáveis `DB_*` estão configuradas corretamente
- Verifique se está usando o hostname correto (não use `.internal`)

### Erro: "Storage não encontrado"
Execute: `php artisan storage:link`

### Erro: "Permissão negada"
Execute: `chmod -R 775 storage bootstrap/cache`

## 🔒 Segurança

- **NUNCA** commite o arquivo `.env` no Git
- Use variáveis de ambiente do Railway para dados sensíveis
- Gere uma `APP_KEY` única para produção
- Use senhas fortes para banco de dados
- Ative `APP_DEBUG=false` em produção

## 📚 Referências

- [Documentação do Railway - Variables](https://docs.railway.app/develop/variables)
- [Documentação do Laravel - Configuration](https://laravel.com/docs/12.x/configuration)

