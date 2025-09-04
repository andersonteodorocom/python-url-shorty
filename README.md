# 🔗 URL Shortener / Encurtador de URL

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.x-blue.svg)](https://python.org)
[![Flask](https://img.shields.io/badge/Flask-2.3.3-green.svg)](https://flask.palletsprojects.com)

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

## 🇧🇷 Português

Um encurtador de URL simples desenvolvido em Python com Flask e SQLite, incluindo contador de acessos e estatísticas detalhadas.

### Funcionalidades

- ✅ Encurtamento de URLs
- ✅ Banco de dados SQLite local
- ✅ Contador de acessos/cliques
- ✅ Histórico de acessos com IP e User-Agent
- ✅ Interface web simples e responsiva
- ✅ Estatísticas detalhadas
- ✅ Lista de todas as URLs encurtadas

### Instalação

1. Clone ou baixe este projeto
2. Instale as dependências:
```bash
pip install -r requirements.txt
```

### Como usar

1. Execute o aplicativo:
```bash
python app.py
```

2. Abra seu navegador e acesse: `http://localhost:5000`

3. Digite a URL que deseja encurtar e clique em "Encurtar URL"

4. Use a URL encurtada gerada - ela redirecionará para a URL original

5. Acesse `/stats/<codigo>` para ver estatísticas de uma URL específica

6. Acesse `/list` para ver todas as URLs encurtadas

### Estrutura do Banco de Dados

#### Tabela `urls`
- `id`: Chave primária
- `original_url`: URL original
- `short_code`: Código curto gerado
- `created_at`: Data de criação
- `click_count`: Contador de acessos

#### Tabela `access_logs`
- `id`: Chave primária
- `url_id`: Referência para a tabela urls
- `ip_address`: IP do usuário que acessou
- `user_agent`: Navegador usado
- `accessed_at`: Data e hora do acesso

### Tecnologias Utilizadas

- **Python 3.x**
- **Flask** - Framework web
- **SQLite** - Banco de dados local
- **HTML/CSS/JavaScript** - Interface frontend

### Características Técnicas

- Banco de dados SQLite local (não precisa de servidor de banco)
- Códigos curtos de 6 caracteres (letras e números)
- Interface responsiva para mobile
- Sistema de logs completo
- Validação de URLs

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

Contributions are welcome! Please feel free to submit a Pull Request.

Contribuições são bem-vindas! Sinta-se à vontade para enviar um Pull Request.

## 📞 Support / Suporte

If you have any questions or need help, please open an issue.

Se você tiver alguma dúvida ou precisar de ajuda, abra uma issue.
