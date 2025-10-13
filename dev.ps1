# 🚀 Script de Desenvolvimento - URL Shortener (PowerShell)
# Este script facilita o desenvolvimento e testes locais no Windows

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
    Write-ColorOutput Blue "🚀 URL Shortener - Script de Desenvolvimento"
    Write-Output "=============================================="
}

function Show-Help {
    Write-Output "Uso: .\dev.ps1 [COMANDO]"
    Write-Output ""
    Write-Output "Comandos disponíveis:"
    Write-Output "  install     - Instala dependências"
    Write-Output "  test        - Executa testes"
    Write-Output "  lint        - Executa análise de código"
    Write-Output "  security    - Verifica vulnerabilidades"
    Write-Output "  build       - Faz build da imagem Docker"
    Write-Output "  run         - Executa a aplicação localmente"
    Write-Output "  docker-run  - Executa via Docker"
    Write-Output "  clean       - Limpa arquivos temporários"
    Write-Output "  ci          - Executa pipeline completa localmente"
    Write-Output "  help        - Mostra esta ajuda"
}

function Install-Dependencies {
    Write-ColorOutput Yellow "📦 Instalando dependências..."
    python -m pip install --upgrade pip
    pip install -r requirements.txt
    Write-ColorOutput Green "✅ Dependências instaladas!"
}

function Run-Tests {
    Write-ColorOutput Yellow "🧪 Executando testes..."
    pytest -v --cov=app --cov-report=term-missing
    Write-ColorOutput Green "✅ Testes concluídos!"
}

function Run-Lint {
    Write-ColorOutput Yellow "🔍 Executando análise de código..."
    flake8 app.py --count --select=E9,F63,F7,F82 --show-source --statistics
    flake8 app.py --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
    Write-ColorOutput Green "✅ Análise de código concluída!"
}

function Run-Security {
    Write-ColorOutput Yellow "🔒 Verificando vulnerabilidades..."
    safety check
    Write-ColorOutput Green "✅ Verificação de segurança concluída!"
}

function Build-Docker {
    Write-ColorOutput Yellow "🐳 Fazendo build da imagem Docker..."
    docker build -t url-shortener:latest .
    Write-ColorOutput Green "✅ Build Docker concluído!"
}

function Run-App {
    Write-ColorOutput Yellow "🚀 Executando aplicação..."
    Write-ColorOutput Blue "Acesse: http://localhost:5000"
    python app.py
}

function Run-Docker {
    Write-ColorOutput Yellow "🐳 Executando via Docker..."
    Write-ColorOutput Blue "Acesse: http://localhost:5000"
    docker run --rm -p 5000:5000 url-shortener:latest
}

function Clean-Files {
    Write-ColorOutput Yellow "🧹 Limpando arquivos temporários..."
    
    $itemsToRemove = @(
        "__pycache__",
        ".pytest_cache",
        "htmlcov",
        ".coverage",
        "coverage.xml"
    )
    
    foreach ($item in $itemsToRemove) {
        if (Test-Path $item) {
            Remove-Item -Recurse -Force $item
        }
    }
    
    # Remove .pyc files
    Get-ChildItem -Recurse -Filter "*.pyc" | Remove-Item -Force
    
    # Remove .egg-info directories
    Get-ChildItem -Recurse -Filter "*.egg-info" | Remove-Item -Recurse -Force
    
    Write-ColorOutput Green "✅ Limpeza concluída!"
}

function Run-CI {
    Write-ColorOutput Blue "🔄 Executando pipeline completa localmente..."
    Write-Output ""
    
    Write-ColorOutput Yellow "Step 1: Instalando dependências"
    Install-Dependencies
    Write-Output ""
    
    Write-ColorOutput Yellow "Step 2: Análise de código"
    Run-Lint
    Write-Output ""
    
    Write-ColorOutput Yellow "Step 3: Verificação de segurança"
    Run-Security
    Write-Output ""
    
    Write-ColorOutput Yellow "Step 4: Executando testes"
    Run-Tests
    Write-Output ""
    
    Write-ColorOutput Yellow "Step 5: Build Docker"
    Build-Docker
    Write-Output ""
    
    Write-ColorOutput Green "🎉 Pipeline local concluída com sucesso!"
}

# Execução principal
Show-Header

switch ($Command.ToLower()) {
    "install" {
        Install-Dependencies
    }
    "test" {
        Run-Tests
    }
    "lint" {
        Run-Lint
    }
    "security" {
        Run-Security
    }
    "build" {
        Build-Docker
    }
    "run" {
        Run-App
    }
    "docker-run" {
        Run-Docker
    }
    "clean" {
        Clean-Files
    }
    "ci" {
        Run-CI
    }
    default {
        Show-Help
    }
}