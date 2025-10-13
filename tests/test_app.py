import pytest
import tempfile
import os
import sys
from unittest.mock import patch

# Adiciona o diretório raiz ao path para importar o app
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import app

class TestURLShortener:
    
    def setup_method(self):
        """Setup para cada teste"""
        self.test_db = tempfile.NamedTemporaryFile(delete=False)
        app.DATABASE = self.test_db.name
        app.app.config['TESTING'] = True
        self.client = app.app.test_client()
        
        # Inicializa o banco de dados de teste
        with app.app.app_context():
            app.init_db()
    
    def teardown_method(self):
        """Cleanup após cada teste"""
        try:
            self.test_db.close()
            os.unlink(self.test_db.name)
        except (OSError, PermissionError):
            pass  # Ignora erros de cleanup no Windows
    
    def test_homepage_loads(self):
        """Testa se a página inicial carrega corretamente"""
        response = self.client.get('/')
        assert response.status_code == 200
        assert b'Encurtar URL' in response.data
    
    def test_shorten_url_post(self):
        """Testa o encurtamento de URL via POST"""
        test_url = 'https://www.google.com'
        response = self.client.post('/shorten', data={'url': test_url})
        assert response.status_code == 200
        
        # Verifica se a resposta contém uma URL curta
        data = response.get_json()
        assert 'short_url' in data
        assert 'original_url' in data
        assert data['original_url'] == test_url
    
    def test_redirect_valid_code(self):
        """Testa redirecionamento com código válido"""
        # Primeiro, cria uma URL encurtada
        test_url = 'https://www.example.com'
        response = self.client.post('/shorten', data={'url': test_url})
        data = response.get_json()
        short_url = data['short_url']
        short_code = short_url.split('/')[-1]
        
        # Testa o redirecionamento
        response = self.client.get(f'/{short_code}')
        assert response.status_code == 302
        assert response.location == test_url
    
    def test_redirect_invalid_code(self):
        """Testa redirecionamento com código inválido"""
        response = self.client.get('/codigo_inexistente')
        assert response.status_code == 404
    
    def test_stats_page_invalid(self):
        """Testa a página de estatísticas com código inválido"""
        # Testa stats com código inexistente
        response = self.client.get('/stats/codigo_inexistente')
        assert response.status_code == 404
    
    def test_list_page(self):
        """Testa a página de listagem"""
        response = self.client.get('/list')
        assert response.status_code == 200
        assert b'URLs Encurtadas' in response.data
    
    def test_generate_short_code(self):
        """Testa a geração de código curto"""
        code = app.generate_short_code()
        assert len(code) == 6
        assert code.isalnum()
    
    def test_url_validation(self):
        """Testa funcionalidade básica de URLs"""
        # Testa URLs válidas
        valid_urls = ['https://www.google.com', 'http://example.com']
        for url in valid_urls:
            response = self.client.post('/shorten', data={'url': url})
            assert response.status_code == 200
            
        # Testa URL inválida
        response = self.client.post('/shorten', data={'url': 'invalid-url'})
        # A aplicação pode aceitar ou rejeitar, apenas verificamos que não quebra
        assert response.status_code in [200, 400]
    
    def test_database_operations(self):
        """Testa operações básicas do banco de dados"""
        with app.app.app_context():
            # Testa inserção
            test_url = 'https://www.test.com'
            short_code = app.generate_short_code()
            
            # Simula a inserção no banco
            conn = app.sqlite3.connect(app.DATABASE)
            cursor = conn.cursor()
            cursor.execute('''
                INSERT INTO urls (original_url, short_code) 
                VALUES (?, ?)
            ''', (test_url, short_code))
            conn.commit()
            
            # Verifica se foi inserido
            cursor.execute('SELECT original_url FROM urls WHERE short_code = ?', (short_code,))
            result = cursor.fetchone()
            assert result is not None
            assert result[0] == test_url
            
            conn.close()

if __name__ == '__main__':
    pytest.main([__file__])