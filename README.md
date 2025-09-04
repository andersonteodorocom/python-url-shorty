# 🔗 Encurtador de URL

Um encurtador de URL simples desenvolvido em Python com Flask e SQLite, incluindo contador de acessos.

## Funcionalidades

- ✅ Encurtamento de URLs
- ✅ Banco de dados SQLite local
- ✅ Contador de acessos/cliques
- ✅ Histórico de acessos com IP e User-Agent
- ✅ Interface web simples e responsiva
- ✅ Estatísticas detalhadas
- ✅ Lista de todas as URLs encurtadas

## Instalação

1. Clone ou baixe este projeto
2. Instale as dependências:
```bash
pip install -r requirements.txt
```

## Como usar

1. Execute o aplicativo:
```bash
python app.py
```

2. Abra seu navegador e acesse: `http://localhost:5000`

3. Digite a URL que deseja encurtar e clique em "Encurtar URL"

4. Use a URL encurtada gerada - ela redirecionará para a URL original

5. Acesse `/stats/<codigo>` para ver estatísticas de uma URL específica

6. Acesse `/list` para ver todas as URLs encurtadas

## Estrutura do Banco de Dados

### Tabela `urls`
- `id`: Chave primária
- `original_url`: URL original
- `short_code`: Código curto gerado
- `created_at`: Data de criação
- `click_count`: Contador de acessos

### Tabela `access_logs`
- `id`: Chave primária
- `url_id`: Referência para a tabela urls
- `ip_address`: IP do usuário que acessou
- `user_agent`: Navegador usado
- `accessed_at`: Data e hora do acesso

## Tecnologias Utilizadas

- **Python 3.x**
- **Flask** - Framework web
- **SQLite** - Banco de dados local
- **HTML/CSS/JavaScript** - Interface frontend

## Características Técnicas

- Banco de dados SQLite local (não precisa de servidor de banco)
- Códigos curtos de 6 caracteres (letras e números)
- Interface responsiva para mobile
- Sistema de logs completo
- Validação de URLs
