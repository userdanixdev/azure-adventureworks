# Esse Script lê o migration_plan.json e gera o script DDL (SQL) para criar 
# os schemas e as tabelas no Azure SQL Database.
# Entrada:     migration_plan.json
# Saída:     01_create_schema_and_tables.sql

import json
from pathlib import Path
from datetime import datetime


# CONFIGURAÇÃO de Criação de caminhos

BASE_DIR = Path(__file__).resolve().parent
PLAN_FILE = BASE_DIR / "migration_plan.json"
OUTPUT_SQL = BASE_DIR / "01_create_schema_and_tables.sql"

# Carrega o plano de migração gerado no passo anterior.
# Se o arquivo não for encontrado na pasta esperada,
# ela dispara um erro informando que o plano precisa ser gerado primeiro.

def load_plan():
    if not PLAN_FILE.exists():
        raise FileNotFoundError(
            f"Arquivo de plano não encontrado: {PLAN_FILE}. "
            "Execute migration_plan.py primeiro."
        )

    with open(PLAN_FILE, "r", encoding="utf-8") as file:
        return json.load(file)

# GERAÇÃO DDL - SCHEMAS
# Gera o código SQL (DDL) necessário para criar os schemas no banco de destino.
# Ela ignora automaticamente o schema padrão dbo (pois ele já vem criado por padrão no SQL Server/Azure) 
# e cria os demais schemas verificando se eles já existem (IF NOT EXISTS),
#  garantindo que o script seja seguro para reexecuções.

def build_schemas_ddl(schemas):
  
    sql_blocks = [
        "-- ==========================================\n"
        "-- FASE 1: CRIAÇÃO DE SCHEMAS\n"
        "-- ==========================================\n"
    ]

    for schema in schemas:
        if schema.lower() == 'dbo':
            continue
            
        # Template DDL para o Schema: Controle de Fluxo e estrutura do T-SQL
        schema_sql = f"""-- Schema: {schema}
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = '{schema}')
BEGIN
    EXEC('CREATE SCHEMA [{schema}]');
END;
GO
"""
        sql_blocks.append(schema_sql)

    return "\n".join(sql_blocks)

# GERAÇÃO DDL - TABELAS

def build_tables_ddl(tables):
    """Gera o SQL para criação de Tabelas usando multi-line strings."""
    sql_blocks = [
        "-- ==========================================\n"
        "-- FASE 2: CRIAÇÃO DE TABELAS\n"
        "-- ==========================================\n"
    ]

    for table in tables:
        full_name = table.get("full_name")
        columns = table.get("columns", [])
        
        # Constrói as linhas de cada coluna
        col_lines = []
        for col in columns:
            col_name = f"[{col['name']}]"
            col_type = col['azure_sql_type']
            identity_str = " IDENTITY(1,1)" if col.get('is_identity') else ""
            null_str = " NULL" if col.get('is_nullable') else " NOT NULL"
            
            col_lines.append(f"    {col_name} {col_type}{identity_str}{null_str}")
            
        # Junta as colunas formatadas
        columns_formatted = ",\n".join(col_lines)
        
        # Template DDL para a Tabela
        table_sql = f"""-- Tabela: {full_name}
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'{full_name}'))
BEGIN
    CREATE TABLE {full_name} (
{columns_formatted}
    );
END;
GO
"""
        sql_blocks.append(table_sql)

    return "\n".join(sql_blocks)

# MAIN

def main():
    try:
        print("\nCarregando plano de migração...")
        plan = load_plan()
        
        metadata = plan.get("metadata", {})
        print(f"Alvo: {metadata.get('target', 'Azure SQL Database')}")
        
        print("\nGerando DDL para Schemas...")
        schemas_sql = build_schemas_ddl(plan.get("schemas", []))
        
        print("Gerando DDL para Tabelas...")
        tables_sql = build_tables_ddl(plan.get("tables", []))
        
        # Cabeçalho do arquivo usando multi-line f-string
        header_sql = f"""-- ==========================================
-- SCRIPT DE MIGRAÇÃO GERADO AUTOMATICAMENTE
-- Data: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
-- Origem: {metadata.get('source', 'SQL Server')}
-- Destino: {metadata.get('target', 'Azure SQL Database')}
-- ==========================================

"""
        final_sql = header_sql + schemas_sql + "\n" + tables_sql
        
        print(f"Salvando script SQL em: {OUTPUT_SQL}")
        with open(OUTPUT_SQL, "w", encoding="utf-8") as file:
            file.write(final_sql)
            
        print("\n" + "=" * 70)
        print("SUCESSO!")
        print("O script de criação do banco foi gerado com êxito.")
        print(f"Arquivo: {OUTPUT_SQL.name}")
        print("=" * 70 + "\n")
        
    except FileNotFoundError as error:
        print(f"\nERRO:\n{error}\n")
    except Exception as error:
        print(f"\nERRO inesperado:\n{error}\n")

if __name__ == "__main__":
    main()