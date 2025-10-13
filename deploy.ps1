# Script de Deploy - DigitalOcean App Platform
# Este script facilita o deploy da aplicação no DigitalOcean

param(
    [Parameter(Position=0)]
    [string]$Command = "help"
)

function Write-ColorOutput([ConsoleColor]$ForegroundColor) {
    $fc = $host.UI.RawUI.ForegroundColor
    $host.UI.RawUI.ForegroundColor = $ForegroundColor
    if ($args) {
        Write-Output $args
    } else {
        $input | Write-Output
    }
    $host.UI.RawUI.ForegroundColor = $fc
}

function Show-Header {
    Write-ColorOutput Blue "DigitalOcean Deploy - URL Shortener"
    Write-Output "===================================="
}

function Show-Help {
    Write-Output "Uso: .\deploy.ps1 [COMANDO]"
    Write-Output ""
    Write-Output "Comandos disponíveis:"
    Write-Output "  build       - Testa build local da imagem Docker"
    Write-Output "  test        - Executa testes antes do deploy"
    Write-Output "  validate    - Valida configuração para produção"
    Write-Output "  local       - Roda versão de produção local"
    Write-Output "  push        - Faz push das mudanças para GitHub"
    Write-Output "  info        - Mostra informações de deploy"
    Write-Output "  help        - Mostra esta ajuda"
}

function Test-Build {
    Write-ColorOutput Yellow "Testando build da imagem Docker..."
    docker build -t url-shortener-prod .
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput Green "Build Docker realizado com sucesso!"
    } else {
        Write-ColorOutput Red "Erro no build Docker!"
        exit 1
    }
}

function Run-Tests {
    Write-ColorOutput Yellow "Executando testes..."
    python -m pytest tests/ -v
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput Green "Todos os testes passaram!"
    } else {
        Write-ColorOutput Red "Alguns testes falharam!"
        exit 1
    }
}

function Test-Production {
    Write-ColorOutput Yellow "Validando configuração de produção..."
    
    # Verifica se o arquivo de configuração existe
    if (Test-Path ".do/app.yaml") {
        Write-ColorOutput Green "Arquivo de configuração DigitalOcean encontrado"
    } else {
        Write-ColorOutput Red "Arquivo .do/app.yaml não encontrado!"
        exit 1
    }
    
    # Verifica se gunicorn está no requirements
    $requirements = Get-Content "requirements.txt"
    if ($requirements -match "gunicorn") {
        Write-ColorOutput Green "Gunicorn encontrado no requirements.txt"
    } else {
        Write-ColorOutput Red "Gunicorn não encontrado no requirements.txt!"
        exit 1
    }
    
    Write-ColorOutput Green "Configuração de produção validada!"
}

function Run-Local-Production {
    Write-ColorOutput Yellow "Executando versão de produção localmente..."
    Write-ColorOutput Blue "Acesse: http://localhost:5000"
    
    $env:FLASK_ENV = "production"
    $env:PORT = "5000"
    
    # Tenta usar gunicorn se disponível, senão usa python
    try {
        gunicorn --bind 0.0.0.0:5000 --workers 2 app:app
    } catch {
        Write-ColorOutput Yellow "Gunicorn não encontrado, usando servidor Flask..."
        python app.py
    }
}

function Push-Changes {
    Write-ColorOutput Yellow "Fazendo push das mudanças para GitHub..."
    
    git add .
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m "Deploy update - $timestamp"
    git push origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput Green "Push realizado com sucesso!"
        Write-ColorOutput Blue "DigitalOcean irá fazer deploy automaticamente"
    } else {
        Write-ColorOutput Red "Erro no push!"
        exit 1
    }
}

function Show-DeployInfo {
    Write-ColorOutput Blue "Informações de Deploy"
    Write-Output "====================="
    Write-Output ""
    Write-Output "Plataforma: DigitalOcean App Platform"
    Write-Output "Repositório: andersonteodorocom/python-url-shorty"
    Write-Output "Branch: main"
    Write-Output "Arquivo de config: .do/app.yaml"
    Write-Output ""
    Write-ColorOutput Yellow "Passos para deploy no DigitalOcean:"
    Write-Output "1. Faça login no DigitalOcean"
    Write-Output "2. Vá para App Platform"
    Write-Output "3. Crie nova aplicação"
    Write-Output "4. Conecte ao repositório GitHub"
    Write-Output "5. Use o arquivo .do/app.yaml para configuração"
    Write-Output "6. O deploy será automático a cada push"
    Write-Output ""
    Write-ColorOutput Green "Comandos úteis:"
    Write-Output ".\deploy.ps1 test     - Testa antes do deploy"
    Write-Output ".\deploy.ps1 push     - Faz deploy"
    Write-Output ".\deploy.ps1 local    - Testa produção local"
}

# Execução principal
Show-Header

switch ($Command.ToLower()) {
    "build" {
        Test-Build
    }
    "test" {
        Run-Tests
    }
    "validate" {
        Test-Production
    }
    "local" {
        Run-Local-Production
    }
    "push" {
        Run-Tests
        Test-Production
        Push-Changes
    }
    "info" {
        Show-DeployInfo
    }
    default {
        Show-Help
    }
}