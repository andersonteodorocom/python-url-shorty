# Encurtador de URL - URL Shortener

Um encurtador de URL desenvolvido em Python com Flask e SQLite, incluindo pipeline completo de CI/CD.

## Contribuidores

- **Anderson Teodoro**
- **Bruno Thobias**
- **Jonathan Cunha**
- **Marivaldo Lacerda**
- **Murilo Nascimento**

## Descrição

Um encurtador de URL simples desenvolvido em Python com Flask e SQLite, incluindo contador de acessos e estatísticas detalhadas.

## Funcionalidades

- Encurtamento de URLs
- Banco de dados SQLite local
- Contador de acessos/cliques
- Histórico de acessos com IP e User-Agent
- Interface web simples e responsiva
- Estatísticas detalhadas
- Lista de todas as URLs encurtadas

## Tecnologias Utilizadas

- **Backend**: Python 3.11, Flask
- **Banco de dados**: SQLite
- **Frontend**: HTML, CSS, JavaScript
- **Containerização**: Docker
- **CI/CD**: GitHub Actions
- **Testes**: pytest
- **Análise de código**: flake8
- **Segurança**: safety, Trivy

## Instalação e Execução

### Pré-requisitos
- Python 3.11+
- Docker (opcional)
- Git

### Instalação Local

1. Clone o repositório:
```bash
git clone https://github.com/andersonteodorocom/python-url-shorty.git
cd python-url-shorty
```

2. Instale as dependências:
```bash
pip install -r requirements.txt
```

3. Execute a aplicação:
```bash
python app.py
```

4. Acesse no navegador: `http://localhost:5000`

### Execução com Docker

1. Build da imagem:
```bash
docker build -t url-shortener .
```

2. Execute o container:
```bash
docker run -p 5000:5000 url-shortener
```

### Execução com Docker Compose

```bash
docker-compose up
```

## Como Usar

1. Acesse a aplicação no navegador
2. Digite a URL que deseja encurtar
3. Clique em "Encurtar URL"
4. Use a URL encurtada gerada
5. Acesse `/list` para ver todas as URLs
6. Acesse `/stats/<codigo>` para estatísticas

## Pipeline CI/CD

Este projeto implementa um pipeline completo de CI/CD com 6 etapas automatizadas:

### Estrutura do Pipeline

1. **Testes e Qualidade**
   - Checkout do código
   - Setup do ambiente Python 3.11
   - Cache das dependências
   - Instalação das dependências
   - Análise de código com Flake8
   - Verificação de segurança com Safety
   - Execução dos testes unitários
   - Teste básico de inicialização

2. **Build Docker**
   - Setup do Docker Buildx
   - Login no Docker Hub
   - Build multi-arquitetura (amd64/arm64)
   - Push da imagem para o registry
   - Cache otimizado para builds mais rápidos
   - Teste da imagem Docker

3. **Análise de Segurança**
   - Scan de vulnerabilidades com Trivy
   - Análise do filesystem
   - Upload dos resultados para GitHub Security
   - Relatórios SARIF

4. **Deploy Staging**
   - Deploy automático na branch develop
   - Ambiente protegido
   - Testes de fumaça
   - Validação pré-produção

5. **Deploy Produção**
   - Deploy automático na branch main
   - Ambiente protegido
   - Verificação pós-deploy
   - Monitoramento da aplicação

6. **Notificações**
   - Notificações de sucesso
   - Alertas de falha
   - Relatórios de status

### Triggers

O pipeline é executado automaticamente nos seguintes eventos:
- Push nas branches `main` ou `develop`
- Pull Request para a branch `main`

### Desenvolvimento Local

**Windows (PowerShell):**
```powershell
.\dev.ps1 ci    # Pipeline completa
.\dev.ps1 test  # Apenas testes  
.\dev.ps1 run   # Executar aplicação
```

**Linux/Mac:**
```bash
./dev.sh ci     # Pipeline completa
./dev.sh test   # Apenas testes
./dev.sh run    # Executar aplicação
```

## Testes

O projeto inclui testes unitários abrangentes:

```bash
# Executar todos os testes
pytest

# Executar com cobertura
pytest --cov=app

# Executar testes específicos
pytest tests/test_app.py -v
```

### Testes Implementados

- Teste de carregamento da página inicial
- Teste de encurtamento de URL
- Teste de redirecionamento
- Teste de URLs inválidas
- Teste da página de listagem
- Teste de estatísticas
- Teste de geração de códigos
- Teste de operações do banco de dados

## Análise de Código

```bash
# Análise com flake8
flake8 app.py

# Verificação de segurança
safety check
```

## Estrutura do Projeto

```
python-url-shorty/
├── .do/
│   └── app.yaml               # Configuração DigitalOcean
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # Pipeline CI/CD
├── static/
│   └── style.css              # Estilos CSS
├── templates/
│   ├── base.html              # Template base
│   ├── index.html             # Página inicial
│   ├── list.html              # Lista de URLs
│   ├── stats.html             # Estatísticas
│   └── error.html             # Página de erro
├── tests/
│   └── test_app.py            # Testes unitários
├── app.py                     # Aplicação principal
├── requirements.txt           # Dependências Python
├── Dockerfile                 # Configuração Docker otimizada
├── docker-compose.yml         # Orquestração Docker
├── deploy.ps1                 # Script deploy automático
├── dev.ps1                    # Script desenvolvimento (Windows)
├── dev.sh                     # Script desenvolvimento (Linux/Mac)
├── pytest.ini                # Configuração pytest
├── .flake8                    # Configuração flake8
├── .dockerignore              # Otimização Docker build
└── README.md                  # Documentação completa
```

## Banco de Dados

### Tabela `urls`
- `id`: Identificador único
- `original_url`: URL original
- `short_code`: Código encurtado
- `created_at`: Data de criação
- `click_count`: Contador de cliques

#### Tabela `access_logs`
- `id`: Chave primária
- `url_id`: Referência para a tabela urls
- `ip_address`: IP do usuário que acessou
- `user_agent`: Navegador usado
- `accessed_at`: Data e hora do acesso

## Deploy em Produção

### DigitalOcean App Platform (Recomendado)

O projeto está otimizado para deploy no DigitalOcean App Platform:

1. **Faça login no DigitalOcean**
2. **App Platform** → Create App  
3. **Conecte ao GitHub**: andersonteodorocom/python-url-shorty
4. **Use o arquivo** `.do/app.yaml` (configuração automática)
5. **Deploy automático** a cada push na branch main

**Custo**: $5/mês (basic-xxs - 512MB RAM)

### Script de Deploy

```powershell
# Windows
.\deploy.ps1 push    # Testa e faz deploy automaticamente

# Comandos individuais
.\deploy.ps1 test    # Executa testes
.\deploy.ps1 local   # Testa versão produção local
.\deploy.ps1 build   # Testa build Docker
```

### Outras Plataformas Cloud

O Dockerfile otimizado funciona em:
- ✅ **Heroku**
- ✅ **Railway** 
- ✅ **Render**
- ✅ **Google Cloud Run**
- ✅ **AWS App Runner**

### Configuração de Secrets (GitHub Actions)

Para o pipeline funcionar completamente:

1. Acesse: `Settings` → `Secrets and variables` → `Actions`
2. Adicione os secrets:
   - `DOCKER_HUB_USERNAME`: seu usuário do Docker Hub
   - `DOCKER_HUB_ACCESS_TOKEN`: token de acesso do Docker Hub

### Características Técnicas

- Banco de dados SQLite local (não precisa de servidor de banco)
- Códigos curtos de 6 caracteres (letras e números)
- Interface responsiva para mobile
- Sistema de logs completo
- Validação de URLs

---

## 🇺🇸 English

A simple URL shortener developed in Python with Flask and SQLite, including access counter and detailed statistics.

### Features

- ✅ URL shortening
- ✅ Local SQLite database
- ✅ Access/click counter
- ✅ Access history with IP and User-Agent
- ✅ Simple and responsive web interface
- ✅ Detailed statistics
- ✅ List of all shortened URLs

### Installation

1. Clone or download this project
2. Install dependencies:
```bash
pip install -r requirements.txt
```

### Usage

1. Run the application:
```bash
python app.py
```

2. Open your browser and access: `http://localhost:5000`

3. Enter the URL you want to shorten and click "Shorten URL"

4. Use the generated short URL - it will redirect to the original URL

5. Access `/stats/<code>` to see statistics for a specific URL

6. Access `/list` to see all shortened URLs

### Database Structure

#### `urls` Table
- `id`: Primary key
- `original_url`: Original URL
- `short_code`: Generated short code
- `created_at`: Creation date
- `click_count`: Access counter

#### `access_logs` Table
- `id`: Primary key
- `url_id`: Reference to urls table
- `ip_address`: IP of the user who accessed
- `user_agent`: Browser used
- `accessed_at`: Access date and time

### Technologies Used

- **Python 3.x**
- **Flask** - Web framework
- **SQLite** - Local database
- **HTML/CSS/JavaScript** - Frontend interface

### Technical Features

- Local SQLite database (no database server needed)
- 6-character short codes (letters and numbers)
- Mobile responsive interface
- Complete logging system
- URL validation

---

## 📄 License / Licença

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

### MIT License Summary / Resumo da Licença MIT

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

É concedida permissão, gratuitamente, a qualquer pessoa que obtenha uma cópia deste software e arquivos de documentação associados (o "Software"), para lidar com o Software sem restrição, incluindo sem limitação os direitos de usar, copiar, modificar, mesclar, publicar, distribuir, sublicenciar e/ou vender cópias do Software, e permitir que as pessoas a quem o Software é fornecido o façam, sujeito às seguintes condições:

- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
- O aviso de direitos autorais acima e este aviso de permissão devem ser incluídos em todas as cópias ou partes substanciais do Software.

## 🤝 Contributing / Contribuindo

## Pipeline CI/CD

Este projeto inclui um pipeline completo de CI/CD com **6 steps** automatizados:

### Execução Rápida Local

**Windows (PowerShell):**
```powershell
.\dev.ps1 ci    # Pipeline completa
.\dev.ps1 test  # Apenas testes
.\dev.ps1 run   # Executar aplicação
```

**Linux/Mac:**
```bash
./dev.sh ci     # Pipeline completa
./dev.sh test   # Apenas testes
./dev.sh run    # Executar aplicação
```

### Steps do Pipeline

1. **Testes e Qualidade** - Testes unitários, análise de código, verificação de segurança
2. **Build Docker** - Build multi-arquitetura e push para registry
3. **Análise de Segurança** - Scan de vulnerabilidades com Trivy
4. **Deploy Staging** - Deploy automático na branch develop
5. **Deploy Produção** - Deploy automático na branch main  
6. **Notificações** - Alertas de sucesso/falha

## Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para enviar um Pull Request.

### Development Workflow
1. Fork o projeto
2. Crie uma branch: `git checkout -b feature/nova-funcionalidade`
3. Execute os testes: `pytest`
4. Commit suas mudanças: `git commit -am 'Adiciona nova funcionalidade'`
5. Push para a branch: `git push origin feature/nova-funcionalidade`
6. Abra um Pull Request

## Licença

Este projeto está licenciado sob a Licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

## Trabalho Acadêmico

Este projeto foi desenvolvido como trabalho acadêmico demonstrando:

- **Desenvolvimento de aplicação web** com interface funcional
- **Implementação de pipeline CI/CD** com 6 etapas automatizadas
- **Boas práticas de desenvolvimento** com testes e análise de código
- **Containerização** com Docker
- **Automação completa** de build, teste e deploy

### Critérios Atendidos

- ✅ Aplicação com interface web
- ✅ Repositório Git funcional
- ✅ Pipeline com mínimo 3 steps (implementado 6 steps)
- ✅ Documentação completa
- ✅ Testes automatizados
- ✅ Análise de segurança

**Pontuação**: 6 steps = 3 (base) + 3 × 0.5 (extras) = +1.5 pontos adicionais

---

**Desenvolvido pelo Grupo de Desenvolvimento**
