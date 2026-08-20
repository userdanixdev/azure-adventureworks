"""
migration_plan.py

Gera um plano de migração a partir do inventory.json.

Entrada:
    inventory.json

Saídas:
    - migration_plan.json
    - resumo no terminal

Objetivo:
    Transformar o inventário do banco SQL Server em um plano
    estruturado para a futura migração para Azure SQL Database.

Este script NÃO modifica nenhum banco de dados.
"""

import json
from pathlib import Path
from datetime import datetime

BASE_DIR = Path(__file__).resolve().parent

INVENTORY_FILE = BASE_DIR.parent / "inventory" / "adventureworks_inventory.json"
PLAN_FILE = BASE_DIR / "migration_plan.json"

# LEITURA DO INVENTÁRIO: Abre e lê o arquivo 'inventory.json'
def load_inventory():
    """Carrega o inventory.json."""
    if not INVENTORY_FILE.exists():
        raise FileNotFoundError(
            f"Arquivo não encontrado: {INVENTORY_FILE}"
        )

    with open(INVENTORY_FILE, "r", encoding="utf-8") as file:
        return json.load(file)

# TRADUÇÃO DE TIPOS (AZURE SQL)
def get_azure_sql_type(col_data):
    """
    Traduz os metadados do inventário para a sintaxe DDL correta do Azure SQL Database.
    Evita erros como 'int(10,0)' que não são aceitos no CREATE TABLE.
    """
    base_type = col_data.get("data_type", "").upper()
    max_len = col_data.get("character_maximum_length")
    precision = col_data.get("numeric_precision")
    scale = col_data.get("numeric_scale")
    
    # Tipos de texto e binários precisam de tamanho especificado
    if base_type in ["VARCHAR", "NVARCHAR", "CHAR", "NCHAR", "VARBINARY", "BINARY"]:
        if max_len == -1:
            return f"{base_type}(MAX)"
        elif max_len:
            return f"{base_type}({max_len})"
            
    # Tipos decimais precisam de precisão e escala
    elif base_type in ["DECIMAL", "NUMERIC"]:
        if precision is not None and scale is not None:
            return f"{base_type}({precision},{scale})"
            
    return base_type

# NORMALIZAÇÃO: Função auxiliar que busca listas dentro do inventário usando diferentes nomes
# de chaves possíveis. Garantindo maior compatibilidade caso a estrutura do arquivo Json mude.
def get_list(data, *keys):
    """
    Procura uma lista em diferentes possíveis estruturas do inventory.json.
    Deixa o script mais tolerante a pequenas mudanças no formato.
    """
    current = data
    for key in keys:
        if isinstance(current, dict):
            current = current.get(key)
    return current if isinstance(current, list) else []

# EXTRAÇÃO DE TABELAS E COLUNAS
def build_tables(inventory):
    """
    Extrai as tabelas do inventário e organiza as informações
    necessárias para a criação do schema.
    """
    tables = []
    raw_tables = inventory.get("tables") if isinstance(inventory, dict) else None

    if not isinstance(raw_tables, list):
        return tables

    for table in raw_tables:
        if not isinstance(table, dict):
            continue
        schema_name = table.get("schema") or table.get("schema_name", "dbo")
        table_name = table.get("table") or table.get("name") 
        # Ajustado para pegar "name" caso "table" falhe
        if not table_name:
            continue
        raw_columns = table.get("columns", [])
        if not isinstance(raw_columns, list):
            raw_columns = []
         
        processed_columns = []
        for col in raw_columns:
# Preserva todos os atributos originais da coluna, mas injeta o tipo corrigido pro Azure
            new_col = dict(col)
            new_col["azure_sql_type"] = get_azure_sql_type(col)
            new_col["is_nullable"] = col.get("nullable", True)
            new_col["is_identity"] = col.get("identity", False)
            processed_columns.append(new_col)

        tables.append(
            {
                "schema": schema_name,
                "table": table_name,
                "full_name": f"[{schema_name}].[{table_name}]",
                "estimated_rows": table.get("row_count", 0),
                "columns": processed_columns,
            }
        )

    return tables

# EXTRAÇÃO DE PRIMARY KEYS
def build_primary_keys(inventory):
    possible_keys = ["primary_keys", "primaryKeys", "pks"]
    for key in possible_keys:
        value = inventory.get(key)
        if isinstance(value, list):
            return value
    return []

# EXTRAÇÃO DE FOREIGN KEYS
def build_foreign_keys(inventory):
    possible_keys = ["foreign_keys", "foreignKeys", "fks"]
    for key in possible_keys:
        value = inventory.get(key)
        if isinstance(value, list):
            return value
    return []

# EXTRAÇÃO DE ÍNDICES
def build_indexes(inventory):
    possible_keys = ["indexes", "indices"]
    for key in possible_keys:
        value = inventory.get(key)
        if isinstance(value, list):
            return value
    return []

# ORDENAÇÃO DAS TABELAS
def sort_tables(tables):
    return sorted(
        tables,
        key=lambda x: (x.get("schema", ""), x.get("table", ""))
    )

# GERAÇÃO DO PLANO
def build_migration_plan(inventory):
    tables = sort_tables(build_tables(inventory))
    primary_keys = build_primary_keys(inventory)
    foreign_keys = build_foreign_keys(inventory)
    indexes = build_indexes(inventory)

    schemas = sorted(
        {table["schema"] for table in tables if table.get("schema")}
    )

    plan = {
        "metadata": {
            "generated_at": datetime.now().isoformat(),
            "source": inventory.get("database", "AdventureWorks"),
            "target": "Azure SQL Database",
            "status": "planning",
        },
        "migration_strategy": {
            "1": "create_schemas",
            "2": "create_tables",
            "3": "create_primary_keys",
            "4": "create_indexes",
            "5": "load_data",
            "6": "create_foreign_keys",
            "7": "validate",
        },
        "summary": {
            "schemas": len(schemas),
            "tables": len(tables),
            "primary_keys": len(primary_keys),
            "foreign_keys": len(foreign_keys),
            "indexes": len(indexes),
            "total_rows_expected": inventory.get("summary", {}).get("total_row_count", sum(t.get("estimated_rows", 0) for t in tables))
        },
        "schemas": schemas,
        "tables": tables,
        "primary_keys": primary_keys,
        "foreign_keys": foreign_keys,
        "indexes": indexes,
    }

    return plan

# SALVAR PLANO E TERMINAL
def save_plan(plan):
    with open(PLAN_FILE, "w", encoding="utf-8") as file:
        json.dump(
            plan,
            file,
            indent=4,
            ensure_ascii=False,
            default=str,
        )

def print_summary(plan):
    metadata = plan["metadata"]
    summary = plan["summary"]

    print("\n" + "=" * 70)
    print("MIGRATION PLAN")
    print("=" * 70)
    print(f"\nOrigem : SQL Server ({metadata['source']})")
    print(f"Destino: {metadata['target']}")
    
    print("\nResumo")
    print("-" * 70)
    print(f"Schemas       : {summary['schemas']}")
    print(f"Tabelas       : {summary['tables']}")
    print(f"Primary Keys  : {summary['primary_keys']}")
    print(f"Foreign Keys  : {summary['foreign_keys']}")
    print(f"Índices       : {summary['indexes']}")
    print(f"Linhas Aprox. : {summary['total_rows_expected']:,}".replace(',', '.'))
    
    print("\nOrdem planejada")
    print("-" * 70)
    for number, step in plan["migration_strategy"].items():
        print(f"{number}. {step}")

    print("\nTabelas")
    print("-" * 70)
    for table in plan["tables"]:
        schema = table["schema"]
        name = table["table"]
        columns = table["columns"]
        print(f"- {schema}.{name} ({len(columns)} colunas)")

    print("\n" + "=" * 70)
    print(f"Plano salvo em: {PLAN_FILE}")
    print("=" * 70 + "\n")

# MAIN

def main():
    try:
        print("\nCarregando inventory.json...")
        inventory = load_inventory()
        print("Inventário carregado com sucesso.")
        
        print("Gerando plano de migração...")
        plan = build_migration_plan(inventory)
        save_plan(plan)
        print_summary(plan)

    except FileNotFoundError as error:
        print(f"\nERRO:\n{error}\n")
    except json.JSONDecodeError as error:
        print(f"\nERRO: inventory.json contém JSON inválido.\n{error}\n")
    except Exception as error:
        print(f"\nERRO inesperado:\n{error}\n")

if __name__ == "__main__":
    main()