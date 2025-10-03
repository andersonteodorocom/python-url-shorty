from flask import Flask, render_template, request, redirect, jsonify
import sqlite3
import string
import random
from datetime import datetime
import os

app = Flask(__name__)

# Configuração do banco de dados
import os
DATABASE_DIR = os.environ.get('DATABASE_DIR', '.')
os.makedirs(DATABASE_DIR, exist_ok=True)
DATABASE = os.path.join(DATABASE_DIR, 'url_shortener.db')

def init_db():
    """Inicializa o banco de dados SQLite"""
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    
    # Tabela para armazenar as URLs
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS urls (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            original_url TEXT NOT NULL,
            short_code TEXT UNIQUE NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            click_count INTEGER DEFAULT 0
        )
    ''')
    
    # Tabela para armazenar histórico de acessos
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS access_logs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url_id INTEGER,
            ip_address TEXT,
            user_agent TEXT,
            accessed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (url_id) REFERENCES urls (id)
        )
    ''')
    
    conn.commit()
    conn.close()

def generate_short_code():
    """Gera um código curto aleatório"""
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for _ in range(6))

def get_db_connection():
    """Cria uma conexão com o banco de dados"""
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    return conn

@app.route('/')
def index():
    """Página principal"""
    return render_template('index.html')

@app.route('/shorten', methods=['POST'])
def shorten_url():
    """Encurta uma URL"""
    original_url = request.form.get('url')
    
    if not original_url:
        return jsonify({'error': 'URL é obrigatória'}), 400
    
    # Adiciona http:// se não tiver protocolo
    if not original_url.startswith(('http://', 'https://')):
        original_url = 'http://' + original_url
    
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Verifica se a URL já existe
    cursor.execute('SELECT short_code FROM urls WHERE original_url = ?', (original_url,))
    existing = cursor.fetchone()
    
    if existing:
        short_code = existing['short_code']
    else:
        # Gera um novo código curto
        short_code = generate_short_code()
        
        # Verifica se o código já existe
        while True:
            cursor.execute('SELECT id FROM urls WHERE short_code = ?', (short_code,))
            if not cursor.fetchone():
                break
            short_code = generate_short_code()
        
        # Insere a nova URL
        cursor.execute(
            'INSERT INTO urls (original_url, short_code) VALUES (?, ?)',
            (original_url, short_code)
        )
    
    conn.commit()
    conn.close()
    
    short_url = request.url_root + short_code
    return jsonify({'short_url': short_url, 'original_url': original_url})

@app.route('/<short_code>')
def redirect_to_original(short_code):
    """Redireciona para a URL original e conta o acesso"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    # Busca a URL original
    cursor.execute('SELECT id, original_url FROM urls WHERE short_code = ?', (short_code,))
    url_data = cursor.fetchone()
    
    if not url_data:
        return render_template('error.html', message='URL não encontrada'), 404
    
    # Incrementa o contador de cliques
    cursor.execute(
        'UPDATE urls SET click_count = click_count + 1 WHERE id = ?',
        (url_data['id'],)
    )
    
    # Registra o acesso no log
    cursor.execute(
        'INSERT INTO access_logs (url_id, ip_address, user_agent) VALUES (?, ?, ?)',
        (url_data['id'], request.remote_addr, request.headers.get('User-Agent', ''))
    )
    
    conn.commit()
    conn.close()
    
    return redirect(url_data['original_url'])

@app.route('/stats/<short_code>')
def url_stats(short_code):
    """Mostra estatísticas de uma URL"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute('''
        SELECT original_url, short_code, created_at, click_count
        FROM urls WHERE short_code = ?
    ''', (short_code,))
    
    url_data = cursor.fetchone()
    
    if not url_data:
        return render_template('error.html', message='URL não encontrada'), 404
    
    # Busca os últimos acessos
    cursor.execute('''
        SELECT ip_address, user_agent, accessed_at
        FROM access_logs
        WHERE url_id = ?
        ORDER BY accessed_at DESC
        LIMIT 10
    ''', (url_data['id'],))
    
    recent_accesses = cursor.fetchall()
    conn.close()
    
    return render_template('stats.html', 
                         url_data=url_data, 
                         recent_accesses=recent_accesses)

@app.route('/list')
def list_urls():
    """Lista todas as URLs encurtadas"""
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute('''
        SELECT original_url, short_code, created_at, click_count
        FROM urls
        ORDER BY created_at DESC
    ''')
    
    urls = cursor.fetchall()
    conn.close()
    
    return render_template('list.html', urls=urls)

if __name__ == '__main__':
    init_db()
    app.run(debug=True, host='0.0.0.0', port=5000)
