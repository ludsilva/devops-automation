# Lab Docker

Este conjunto de labs práticos foi criado para te ensinar a usar Docker de forma eficiente no dia a dia de desenvolvimento e automação. Começaremos pelos comandos básicos e evoluiremos até troubleshooting, cópia de arquivos, criação de imagens personalizadas e uso do `docker-compose`.


## Pré-requisitos

- Docker instalado ([Instruções](https://docs.docker.com/get-docker/))
- Terminal Linux ou WSL/Mac

Verifique a versão instalada:
```bash
docker --version
```

Verifique se o serviço está ativo:
```bash
sudo systemctl status docker
```

 

## Lab Docker

### Objetivo

Executar os comandos básicos do Docker sem perder acesso ao terminal via SSH

 

## Lab 1 – Comandos Básicos com Segurança Remota

### 1. Baixar imagem do Nginx

```bash
docker pull nginx
```

### 2. Rodar container em modo detached

```bash
docker run -d --name webserver -p 8080:80 nginx
```

### 3. Verificar containers rodando

```bash
docker ps
```

### 4. Verificar se está funcionando

```bash
curl http://localhost:8080
```

### 5. Acessar o terminal do container

```bash
docker exec -it webserver bash
```

### 6. Parar e remover o container

```bash
docker stop webserver
docker rm webserver
```

### 7. Remover a imagem (opcional)

```bash
docker rmi nginx
```

## Lab 2 – Docker com Python e FastAPI

### 1. Criar estrutura do projeto

```bash
mkdir -p ~/labs/docker/fastapi-app
cd ~/labs/docker/fastapi-app
```

* Cria o diretório principal da aplicação.

### 2. Criar arquivos da aplicação

#### Criar o arquivo principal

```bash
touch main.py
```

#### Conteúdo do `main.py`

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello from a Dockerized FastAPI app!"}
```

### 3. Criar o arquivo `requirements.txt`

```bash
echo -e "fastapi\nuvicorn" > requirements.txt
```

* Define as dependências da aplicação.


### 4. Criar o Dockerfile

```Dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### 5. Build da imagem

```bash
docker build -t fastapi-app .
```

### 6. Executar o container

```bash
docker run -d -p 8000:8000 fastapi-app
```

### 7. Testar e visualizar logs

#### Testar via curl:

```bash
curl http://localhost:8000/
```

* Retorno esperado:

```json
{"message":"Hello from a Dockerized FastAPI app!"}
```

#### Ver logs:

```bash
docker logs $(docker ps -q --filter ancestor=fastapi-app)
```

### 8. Parar e remover o container (opcional)

```bash
docker ps -q --filter ancestor=fastapi-app | xargs docker stop | xargs docker rm
```


## Lab 3 – Docker Multistage com Node.js

### 1. Criar estrutura do projeto

```bash
mkdir -p ~/labs/docker/app
cd ~/labs/docker/app
```

* `mkdir -p` cria o diretório principal do projeto.
* `cd` navega até o diretório principal.


### 2. Criar arquivos da aplicação

#### Criar o diretório e o arquivo principal:

```bash
mkdir -p src
touch src/index.js
```

* `mkdir -p src` garante que o diretório `src` existe.
* `touch src/index.js` cria o arquivo principal da aplicação.

#### Editar o conteúdo do `index.js`:

```javascript
const http = require('http');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello from a professional Docker container!');
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Servidor rodando na porta ${PORT}`);
});
```

* Esse código cria um servidor web simples em Node.js que responde com texto puro.


### 3. Criar o arquivo `package.json`

#### Criar o arquivo:

```bash
touch package.json
```

#### Adicionar o conteúdo abaixo ao `package.json`:

```json
{
  "name": "docker-app",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "dependencies": {}
}
```
- Estrutura das pastas
```bash
➜  tree
.
├── dockerfile
└── src
    ├── index.js
    └── package.json
```

* Esse arquivo define as informações básicas da aplicação e o comando para iniciar.

### 4. Criar Dockerfile otimizado

```Dockerfile
# Etapa 1: build da aplicação (instalação de dependências)
FROM node:18 AS builder
WORKDIR /app
COPY src/package.json ./
RUN npm install
COPY src/ .

# Etapa 2: imagem final
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app .
EXPOSE 3000
CMD ["npm", "start"]
```

### 5. Build da imagem

```bash
docker build -t devopsautomation:latest .
```

### 6. Executar a imagem

```bash
docker run -d -p 3000:3000 devopsautomation:latest
```

### 7. Validar e visualizar logs

#### Testar a aplicação via curl:

```bash
curl http://localhost:3000
```

* O retorno esperado é: `Hello from a professional Docker container!`

#### Ver logs do container:

```bash
docker logs $(docker ps -q --filter ancestor=devopsautomation:latest)
```

* Deve exibir algo como:

```bash
Servidor rodando na porta 3000
```

### 8. Parar e remover o container (opcional)

```bash
docker ps -q --filter ancestor=devopsautomation:latest | xargs docker stop | xargs docker rm
```

## Lab 4 – Criando um .gitignore para Projetos Docker com Node.js

### 1. Reutilizando o Projeto Existente

Vamos aproveitar o projeto criado no **Lab 3 – Docker Multistage com Node.js**. Navegue até o diretório base do projeto:

```bash
cd ~/labs
```

Inicialize o repositório na raiz (caso ainda não exista):

```bash
git init
```

> Importante: toda a estrutura do projeto está em `docker/app/`

### 2. Criar o arquivo `.gitignore` na raiz do repositório

```bash
touch .gitignore
```

Adicione as regras considerando a estrutura do projeto:

```gitignore
# Ignorar arquivos sensíveis e temporários dentro de docker/app
/docker/app/node_modules/
/docker/app/dist/
/docker/app/*.log
/docker/app/.env
/docker/app/.env*

# Pycache, logs e arquivos temporários em geral
**/__pycache__/
**/*.pyc
.DS_Store
*.tgz
```

### 3. Testar comportamento do .gitignore

Crie arquivos simulando um ambiente real:

```bash
mkdir docker/app/node_modules
mkdir docker/app/dist
echo "segredo=abc" > docker/app/.env
```

Verifique com `git status`:

```bash
git status
```

* Os arquivos/pastas criados não devem aparecer como "Untracked files"

### 4. Adicionar e versionar apenas os arquivos necessários

```bash
git add .
git status
```

Confirme que apenas os arquivos relevantes estão sendo versionados, como:

* `.gitignore`
* `docker/app/dockerfile`
* `docker/app/src/index.js`
* `docker/app/src/package.json`

```bash
git commit -m "Configuração inicial com .gitignore para estrutura Docker/Node"
```

### 5. Verificar arquivos ignorados

```bash
git check-ignore -v docker/app/.env docker/app/node_modules/
```

## Lab 8 – Fazendo Push da Imagem Docker para o Docker Hub

### 1. Pré-requisitos

* Ter uma conta no [Docker Hub](https://hub.docker.com/)
* Ter feito login local com o Docker CLI:

```bash
docker login
```

### 2. Reutilizar a imagem do projeto

Vamos usar a imagem criada no **Lab 3 – Docker Multistage com Node.js**

Acesse a pasta do projeto:

```bash
cd ~/labs/docker/app
```

### 3. Taguear a imagem com o nome do repositório remoto

O padrão é:

```
<username-dockerhub>/<nome-repositorio>:<tag>
```

Exemplo:

```bash
docker tag devopsautomation:latest iesodias/docker-node-app:1.0.0
```

### 4. Fazer o push da imagem

```bash
docker push iesodias/docker-node-app:1.0.0
```

Se quiser enviar como `latest` também:

```bash
docker tag devopsautomation:latest iesodias/docker-node-app:latest
docker push iesodias/docker-node-app:latest
```

### 5. Verificar no Docker Hub

Acesse seu repositório no Docker Hub e confirme se as tags aparecem corretamente.


### 6. Baixar de qualquer lugar (simulando ambiente remoto)

Em qualquer host com Docker instalado:

```bash
docker pull iesodias/docker-node-app:1.0.0
docker run -p 3000:3000 iesodias/docker-node-app:1.0.0
```

### 7. Dica: Remover imagem local (simula CI/CD limpo)

```bash
docker rmi iesodias/docker-node-app:1.0.0
```

## Lab 9 – Orquestrando com Docker Compose

### 1. Objetivo

Utilizar Docker Compose para subir uma aplicação Node.js junto com um banco de dados PostgreSQL, simulando um ambiente completo de desenvolvimento.

### 2. Estrutura do projeto

Aproveitando o projeto do **Lab 3**, vamos usar esta estrutura:

```
docker-compose-lab/
├── docker-compose.yml
└── app/
    ├── dockerfile
    └── src/
        ├── index.js
        └── package.json
```

### 3. Criar o `docker-compose.yml`

Na raiz do projeto `docker-compose-lab/`, crie o arquivo:

```yaml
version: '3.8'

services:
  node-app:
    build:
      context: ./app
      dockerfile: dockerfile
    ports:
      - "3000:3000"
    container_name: node_compose_app
    restart: unless-stopped
    depends_on:
      - db
    environment:
      - DATABASE_URL=postgres://devuser:devpass@db:5432/devdb

  db:
    image: postgres:15
    container_name: postgres_compose_db
    restart: unless-stopped
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: devuser
      POSTGRES_PASSWORD: devpass
      POSTGRES_DB: devdb
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

### 4. Subir a aplicação com Docker Compose

```bash
docker-compose up -d
```

### 5. Validar funcionamento da aplicação

```bash
curl http://localhost:3000
```

Retorno esperado:

```text
Hello from a professional Docker container!
```

### 6. Acessar o banco de dados

```bash
docker exec -it postgres_compose_db psql -U devuser -d devdb
```

Exemplo de comando dentro do PostgreSQL:

```sql
\l  -- lista os bancos
\dt -- lista as tabelas
```

### 7. Verificar status dos containers

```bash
docker-compose ps
```

### 8. Ver logs da aplicação

```bash
docker-compose logs -f node-app
```

### 9. Parar e remover os containers

```bash
docker-compose down -v
```

Este lab mostra como usar Docker Compose para orquestrar uma aplicação Node.js com PostgreSQL, preparando uma base sólida para ambientes de desenvolvimento modernos.