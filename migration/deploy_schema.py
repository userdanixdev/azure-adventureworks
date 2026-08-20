"""
deploy_schema.py

Conecta ao Azure SQL Database usando pyodbc e python-dotenv para executar 
o script DDL (01_create_schema_and_tables.sql) criado na etapa anterior.
"""

import os
import pyodbc
from pathlib import Path
from dotenv import load_dotenv

# ============================================================
# CONFIGURAÇÃO DE AMBIENTE E ARQUIVOS
# ============================================================
# Carrega as variáveis do arquivo .env localizado na raiz do projeto
load_dotenv()

BASE_DIR = Path(__file__).resolve().parent
SQL_FILE = BASE_DIR / "01_create_schema_and_tables.sql"

# ============================================================
# CREDENCIAIS DO AZURE SQL (Via .env)
# ============================================================
AZURE_SERVER = os.getenv("AZURE_SQL_SERVER")
AZURE_DATABASE = os.getenv("AZURE_SQL_DATABASE")
AZURE_USER = os.getenv("AZURE_SQL_USER") or os.getenv("ADMIN")
AZURE_PASSWORD = os.getenv("AZURE_SQL_PASSWORD") or os.getenv("PASSWORD")
ODBC_DRIVER = os.getenv("ODBC_DRIVER", "{ODBC Driver 17 for SQL Server}")

def get_azure_connection():
    """Cria e retorna a conexão com o Azure SQL via pyodbc."""
    
    # Validação rápida para garantir que o .env foi carregado
    if not AZURE_SERVER or not AZURE_USER:
        raise ValueError("Credenciais ausentes! Verifique se o arquivo .env está configurado corretamente.")

    conn_str = (
        f"DRIVER={ODBC_DRIVER};"
        f"SERVER={AZURE_SERVER};"
        f"DATABASE={AZURE_DATABASE};"
        f"UID={AZURE_USER};"
        f"PWD={AZURE_PASSWORD};"
        "Encrypt=yes;TrustServerCertificate=no;Connection Timeout=60;"
    )
    return pyodbc.connect(conn_str)

# ============================================================
# EXECUÇÃO DO SCRIPT
# ============================================================
def execute_schema_script():
    if not SQL_FILE.exists():
        print(f"ERRO: Arquivo {SQL_FILE.name} não encontrado. Gere-o primeiro.")
        return

    print(f"\nLendo script SQL: {SQL_FILE.name}...")
    with open(SQL_FILE, 'r', encoding='utf-8') as f:
        sql_content = f.read()

    # O pyodbc não entende o comando 'GO', então dividimos o script em blocos
    sql_batches = sql_content.split('\nGO')

    print(f"Conectando ao Azure SQL Database ({AZURE_SERVER})...")
    
    try:
        conn = get_azure_connection()
        cursor = conn.cursor()
        print("Conexão estabelecida com sucesso!\n")

        total_batches = len([b for b in sql_batches if b.strip()])
        executed = 0

        print("Iniciando a criação de Schemas e Tabelas...")
        for batch in sql_batches:
            clean_batch = batch.strip()
            if clean_batch:
                try:
                    cursor.execute(clean_batch)
                    executed += 1
                except pyodbc.Error as e:
                    print(f"\n[!] Erro ao executar o bloco:\n{clean_batch[:100]}...\n")
                    print(f"Detalhe do Erro: {e}")
                    conn.rollback() # Desfaz o que deu errado
                    return

        # Confirma as alterações no banco de dados
        conn.commit()
        
        print("\n" + "=" * 70)
        print("MIGRAÇÃO DE SCHEMA CONCLUÍDA COM SUCESSO! ")
        print(f"{executed} de {total_batches} blocos executados.")
        print("=" * 70 + "\n")

    except pyodbc.Error as e:
        print(f"\n[ERRO DE CONEXÃO]: Não foi possível conectar ao banco de dados.")
        print(f"Detalhes: {e}\n")
        print("DICA: Verifique se o seu endereço IP está liberado no Firewall do Azure (Networking).")
    except ValueError as ve:
        print(f"\n[ERRO DE AMBIENTE]: {ve}\n")
    finally:
        if 'conn' in locals() and conn:
            conn.close()
            print("Conexão encerrada.")

if __name__ == "__main__":
    execute_schema_script()