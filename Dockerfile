# Multi-stage build para otimizar tamanho da imagem
FROM python:3.11-slim as builder

# Instala dependências de build
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Define diretório de trabalho
WORKDIR /app

# Copia requirements e instala dependências
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# Imagem final - mais leve
FROM python:3.11-slim

# Instala apenas dependências runtime necessárias
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Cria usuário não-root para segurança
RUN useradd --create-home --shell /bin/bash --uid 1000 app

# Define diretório de trabalho
WORKDIR /app

# Copia dependências Python do stage builder
COPY --from=builder /root/.local /home/app/.local

# Copia código da aplicação
COPY --chown=app:app . .

# Cria diretório para dados persistentes
RUN mkdir -p /app/data && chown app:app /app/data

# Muda para usuário não-root
USER app

# Adiciona .local/bin ao PATH
ENV PATH=/home/app/.local/bin:$PATH

# Variáveis de ambiente para produção
ENV FLASK_APP=app.py
ENV FLASK_ENV=production
ENV PYTHONPATH=/app
ENV PYTHONUNBUFFERED=1
ENV DATABASE_DIR=/app/data

# Porta que a aplicação vai usar (DigitalOcean App Platform usa PORT)
ENV PORT=5000
EXPOSE $PORT

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:$PORT/ || exit 1

# Comando para executar a aplicação
# Usando gunicorn para produção ao invés do servidor de desenvolvimento do Flask
CMD gunicorn --bind 0.0.0.0:$PORT --workers 2 --timeout 120 app:app
