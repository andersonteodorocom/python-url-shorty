#!/bin/bash

# 🚀 Script de Desenvolvimento - URL Shortener
# Este script facilita o desenvolvimento e testes locais

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 URL Shortener - Script de Desenvolvimento${NC}"
echo "=============================================="

# Função para mostrar ajuda
show_help() {
    echo "Uso: $0 [COMANDO]"
    echo ""
    echo "Comandos disponíveis:"
    echo "  install     - Instala dependências"
    echo "  test        - Executa testes"
    echo "  lint        - Executa análise de código"
    echo "  security    - Verifica vulnerabilidades"
    echo "  build       - Faz build da imagem Docker"
    echo "  run         - Executa a aplicação localmente"
    echo "  docker-run  - Executa via Docker"
    echo "  clean       - Limpa arquivos temporários"
    echo "  ci          - Executa pipeline completa localmente"
    echo "  help        - Mostra esta ajuda"
}

# Instalar dependências
install_deps() {
    echo -e "${YELLOW}📦 Instalando dependências...${NC}"
    pip install --upgrade pip
    pip install -r requirements.txt
    echo -e "${GREEN}✅ Dependências instaladas!${NC}"
}

# Executar testes
run_tests() {
    echo -e "${YELLOW}🧪 Executando testes...${NC}"
    pytest -v --cov=app --cov-report=term-missing
    echo -e "${GREEN}✅ Testes concluídos!${NC}"
}

# Análise de código
run_lint() {
    echo -e "${YELLOW}🔍 Executando análise de código...${NC}"
    flake8 app.py --count --select=E9,F63,F7,F82 --show-source --statistics
    flake8 app.py --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
    echo -e "${GREEN}✅ Análise de código concluída!${NC}"
}

# Verificação de segurança
run_security() {
    echo -e "${YELLOW}🔒 Verificando vulnerabilidades...${NC}"
    safety check
    echo -e "${GREEN}✅ Verificação de segurança concluída!${NC}"
}

# Build Docker
build_docker() {
    echo -e "${YELLOW}🐳 Fazendo build da imagem Docker...${NC}"
    docker build -t url-shortener:latest .
    echo -e "${GREEN}✅ Build Docker concluído!${NC}"
}

# Executar aplicação
run_app() {
    echo -e "${YELLOW}🚀 Executando aplicação...${NC}"
    echo -e "${BLUE}Acesse: http://localhost:5000${NC}"
    python app.py
}

# Executar via Docker
run_docker() {
    echo -e "${YELLOW}🐳 Executando via Docker...${NC}"
    echo -e "${BLUE}Acesse: http://localhost:5000${NC}"
    docker run --rm -p 5000:5000 url-shortener:latest
}

# Limpeza
clean() {
    echo -e "${YELLOW}🧹 Limpando arquivos temporários...${NC}"
    rm -rf __pycache__/
    rm -rf .pytest_cache/
    rm -rf htmlcov/
    rm -rf .coverage
    rm -rf coverage.xml
    rm -rf *.egg-info/
    find . -name "*.pyc" -delete
    echo -e "${GREEN}✅ Limpeza concluída!${NC}"
}

# Pipeline completa local
run_ci() {
    echo -e "${BLUE}🔄 Executando pipeline completa localmente...${NC}"
    echo ""
    
    echo -e "${YELLOW}Step 1: Instalando dependências${NC}"
    install_deps
    echo ""
    
    echo -e "${YELLOW}Step 2: Análise de código${NC}"
    run_lint
    echo ""
    
    echo -e "${YELLOW}Step 3: Verificação de segurança${NC}"
    run_security
    echo ""
    
    echo -e "${YELLOW}Step 4: Executando testes${NC}"
    run_tests
    echo ""
    
    echo -e "${YELLOW}Step 5: Build Docker${NC}"
    build_docker
    echo ""
    
    echo -e "${GREEN}🎉 Pipeline local concluída com sucesso!${NC}"
}

# Switch baseado no argumento
case "${1:-help}" in
    install)
        install_deps
        ;;
    test)
        run_tests
        ;;
    lint)
        run_lint
        ;;
    security)
        run_security
        ;;
    build)
        build_docker
        ;;
    run)
        run_app
        ;;
    docker-run)
        run_docker
        ;;
    clean)
        clean
        ;;
    ci)
        run_ci
        ;;
    help|*)
        show_help
        ;;
esac