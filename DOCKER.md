# 🐳 Docker - Encurtador de URL

Este documento explica como executar o encurtador de URL usando Docker.

## 📋 Pré-requisitos

- Docker instalado
- Docker Compose instalado

## 🚀 Executando com Docker Compose (Recomendado)

### 1. Construir e executar a aplicação

```bash
docker-compose up --build
```

### 2. Executar em background

```bash
docker-compose up -d --build
```

### 3. Parar a aplicação

```bash
docker-compose down
```

### 4. Ver logs

```bash
docker-compose logs -f
```

## 🔧 Executando apenas com Docker

### 1. Construir a imagem

```bash
docker build -t url-shortener .
```

### 2. Executar o container

```bash
docker run -p 5000:5000 -v $(pwd)/data:/app/data -e DATABASE_DIR=/app/data url-shortener
```

## 📁 Estrutura de Volumes

- `./data:/app/data` - Persiste o banco de dados SQLite
- Os dados ficam salvos no diretório `data/` do seu projeto

## 🌐 Acessando a Aplicação

Após executar, acesse: `http://localhost:5000`

## 🔍 Comandos Úteis

### Ver containers em execução
```bash
docker ps
```

### Entrar no container
```bash
docker exec -it <container_id> /bin/bash
```

### Ver logs do container
```bash
docker logs <container_id>
```

### Parar e remover containers
```bash
docker-compose down
```

### Reconstruir sem cache
```bash
docker-compose build --no-cache
```

## 🛠️ Desenvolvimento

Para desenvolvimento, você pode montar o código fonte:

```bash
docker run -p 5000:5000 -v $(pwd):/app -v $(pwd)/data:/app/data -e DATABASE_DIR=/app/data url-shortener
```

## 🔒 Segurança

- A aplicação roda com usuário não-root
- Health check configurado
- Restart automático em caso de falha
- Variáveis de ambiente para configuração

## 📊 Monitoramento

O health check verifica se a aplicação está respondendo a cada 30 segundos.
