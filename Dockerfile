# Use a imagem oficial do Python como base
FROM python:3.11-slim

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Instala dependências do sistema necessárias
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copia o arquivo de dependências
COPY requirements.txt .

# Instala as dependências Python
RUN pip install --no-cache-dir -r requirements.txt

# Copia todo o código da aplicação
COPY . .

# Cria um usuário não-root para segurança
RUN useradd --create-home --shell /bin/bash app && chown -R app:app /app
USER app

# Expõe a porta 5000
EXPOSE 5000

# Define variáveis de ambiente
ENV FLASK_APP=app.py
ENV FLASK_ENV=production

# Comando para executar a aplicação
CMD ["python", "app.py"]
