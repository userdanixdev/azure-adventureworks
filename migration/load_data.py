import os
import pyodbc
import json
from dotenv import load_dotenv
import pandas as pd
import tqdm
# Carrega as variáveis de ambiente do arquivo .env
load_dotenv()

# Credenciais do Destino (Azure SQL Database)
AZURE_SERVER = os.getenv("AZURE_SQL_SERVER")
AZURE_DATABASE = os.getenv("AZURE_SQL_DATABASE")
AZURE_USERNAME = os.getenv("ADMIN")
AZURE_PASSWORD = os.getenv("PASSWORD")

# Credenciais/String de Conexão da Origem (Managed Instance)

MI_SERVER = os.getenv("AZURE_SQL_MI_SERVER")
MI_DATABASE = os.getenv("AZURE_SQL_MI_DATABASE")
MI_USERNAME = os.getenv("ADMIN_1")
MI_PASSWORD = os.getenv("PASSWORD_1")

def get_azure_connection():
    conn_str = (
        f"DRIVER={{ODBC Driver 18 for SQL Server}};"
        f"SERVER={AZURE_SERVER};"
        f"DATABASE={AZURE_DATABASE};"
        f"UID={AZURE_USERNAME};"
        f"PWD={AZURE_PASSWORD};"
        f"Encrypt=yes;"
        f"TrustServerCertificate=no;"
    )
    return pyodbc.connect(conn_str)

def get_mi_connection():
    conn_str = (
        f"DRIVER={{ODBC Driver 18 for SQL Server}};"
        f"SERVER={MI_SERVER};"
        f"DATABASE={MI_DATABASE};"
        f"UID={MI_USERNAME};"
        f"PWD={MI_PASSWORD};"
        f"Encrypt=yes;"
        f"TrustServerCertificate=no;"
    )
    return pyodbc.connect(conn_str)

def load_tables_from_plan():
    """Lê o plano de migração gerado anteriormente para obter a lista de tabelas"""
    plan_path = os.path.join(os.path.dirname(__file__), "migration_plan.json")
    if not os.path.exists(plan_path):
        raise FileNotFoundError(f"Arquivo {plan_path} não encontrado! Execute o migration_plan.py primeiro.")
    
    with open(plan_path, "r", encoding="utf-8") as f:
        plan_data = json.load(f)
    
    # O JSON tem uma chave 'tables' que é uma lista. 
    # Aqui verificamos se cada item é uma string (nome direto) ou um dicionário.
    raw_tables = plan_data.get("tables", [])
    
    tables = []
    for item in raw_tables:
        if isinstance(item, str):
            tables.append(item)
        elif isinstance(item, dict):
            # Tenta pegar o nome da tabela independentemente de qual chave foi usada no JSON
            name = item.get("table_name") or item.get("name") or item.get("table") or item.get("TableName")
            if name:
                tables.append(name)
                
    return tables

def bulk_insert_dataframe(cursor, table_name, df):
    total_rows = len(df)
    if total_rows == 0:
        print(f" A tabela {table_name} está vazia na origem. Pulando...")
        return

    # 1. Limpa a tabela no destino antes de inserir (evita duplicidade se rodar de novo)
    print(f" Limpando dados antigos da tabela [{table_name}] no Azure...")
    try:
        # Se houver tabelas com FKs pendentes, o TRUNCATE pode falhar. Se falhar, usa DELETE.
        try:
            cursor.execute(f"TRUNCATE TABLE dbo.[{table_name}]")
        except:
            cursor.execute(f"DELETE FROM dbo.[{table_name}]")
        cursor.commit()
    except Exception as e:
        print(f" Aviso ao limpar tabela {table_name}: {e}")

    # 2. Divide em lotes menores para performance e feedback visual
    chunk_size = 5000
    cols = list(df.columns)
    placeholders = ", ".join(["?"] * len(cols))
    col_names = ", ".join([f"[{col}]" for col in cols])
    sql = f"INSERT INTO dbo.[{table_name}] ({col_names}) VALUES ({placeholders})"
    
    cursor.fast_executemany = True
    
    # Habilita Identity Insert para aceitar os IDs originais
    try:
        cursor.execute(f"SET IDENTITY_INSERT dbo.[{table_name}] ON")
    except:
        pass

    try:
        # Barra de progresso interativa no terminal
        with tqdm.tqdm(total=total_rows, desc=f"Migrando {table_name}", unit="linhas") as pbar:
            for i in range(0, total_rows, chunk_size):
                chunk = df.iloc[i:i + chunk_size]
                data = [tuple(None if pd.isna(val) else val for val in row) for row in chunk.to_numpy()]
                
                cursor.executemany(sql, data)
                cursor.commit()
                
                pbar.update(len(chunk))
        
        print(f" [{table_name}] - {total_rows} linhas migradas com sucesso!\n")
        
    except Exception as e:
        print(f" Erro durante a inserção na tabela {table_name}: {e}")
        cursor.rollback()

    # Desliga o Identity Insert
    try:
        cursor.execute(f"SET IDENTITY_INSERT dbo.[{table_name}] OFF")
    except:
        pass

def run_migration():
    print(" Carregando lista de tabelas do migration_plan.json...")
    try:
        tables_to_migrate = load_tables_from_plan()
        print(f"Total de {len(tables_to_migrate)} tabelas identificadas para migração.\n")
    except Exception as e:
        print(f"Erro ao ler o plano de migração: {e}")
        return
    print("Conectando à origem (Managed Instance) e ao destino (Azure SQL Database)...")
    try:
        conn_mi = get_mi_connection()
        conn_azure = get_azure_connection()
        print(" Conexões estabelecidas com sucesso!\n")
    except Exception as e:
        print(f" Erro crítico ao conectar nos bancos: {e}")
        return

    cursor_azure = conn_azure.cursor()

    for table in tables_to_migrate:
        print(f" Lendo dados da tabela {table} na origem...")
        try:
            # Lê os dados da tabela de origem usando pandas
            df = pd.read_sql(f"SELECT * FROM dbo.{table}", conn_mi)
            
            # Insere os dados no Azure SQL Database
            bulk_insert_dataframe(cursor_azure, table, df)
            
        except Exception as e:
            print(f" Erro ao processar a tabela {table}: {e}")

    # Encerra as conexões
    cursor_azure.close()
    conn_azure.close()
    conn_mi.close()
    print("\n Processo de migração de dados concluído!")

if __name__ == "__main__":
    run_migration()

# O script agora procura automaticamente pelo arquivo migration_plan.json gerado.
# Dessa forma extrai de lá a lista completa de todas as tabelas do banco.

