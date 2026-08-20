import json
from pathlib import Path

from connection import get_connection


# ============================================================
# CONFIGURAÇÃO
# ============================================================

DATABASE_NAME = "AdventureWorksDW2022"

INVENTORY_DIR = (
    Path(__file__).resolve().parent.parent / "inventory"
)

INVENTORY_FILE = (
    INVENTORY_DIR / "adventureworks_inventory.json"
)


# ============================================================
# TABELAS
# ============================================================

def listar_tabelas(cursor):
    """Lista todas as tabelas físicas do banco."""

    cursor.execute("""
        SELECT
            TABLE_SCHEMA,
            TABLE_NAME
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_TYPE = 'BASE TABLE'
        ORDER BY
            TABLE_SCHEMA,
            TABLE_NAME;
    """)

    return cursor.fetchall()


# ============================================================
# COLUNAS
# ============================================================

def listar_colunas(cursor, schema, tabela):
    """Lista todas as colunas de uma tabela."""

    cursor.execute("""
        SELECT
            c.COLUMN_NAME,
            c.ORDINAL_POSITION,
            c.DATA_TYPE,
            c.CHARACTER_MAXIMUM_LENGTH,
            c.NUMERIC_PRECISION,
            c.NUMERIC_SCALE,
            c.IS_NULLABLE,
            c.COLUMN_DEFAULT,
            COLUMNPROPERTY(
                OBJECT_ID(
                    c.TABLE_SCHEMA + '.' + c.TABLE_NAME
                ),
                c.COLUMN_NAME,
                'IsIdentity'
            ) AS IS_IDENTITY
        FROM INFORMATION_SCHEMA.COLUMNS AS c
        WHERE c.TABLE_SCHEMA = ?
          AND c.TABLE_NAME = ?
        ORDER BY c.ORDINAL_POSITION;
    """, (schema, tabela))

    return cursor.fetchall()


def formatar_tipo(coluna):
    """Monta o tipo de dado completo."""

    tipo = coluna.DATA_TYPE

    tamanho = coluna.CHARACTER_MAXIMUM_LENGTH
    precisao = coluna.NUMERIC_PRECISION
    escala = coluna.NUMERIC_SCALE

    if tamanho is not None:

        if tamanho == -1:
            tipo += "(MAX)"
        else:
            tipo += f"({tamanho})"

    elif precisao is not None:

        if escala is not None:
            tipo += f"({precisao},{escala})"
        else:
            tipo += f"({precisao})"

    return tipo


def construir_coluna(coluna):
    """Converte uma coluna SQL em dicionário."""

    return {
        "name": coluna.COLUMN_NAME,
        "position": coluna.ORDINAL_POSITION,
        "data_type": coluna.DATA_TYPE,
        "formatted_type": formatar_tipo(coluna),
        "character_maximum_length": coluna.CHARACTER_MAXIMUM_LENGTH,
        "numeric_precision": coluna.NUMERIC_PRECISION,
        "numeric_scale": coluna.NUMERIC_SCALE,
        "nullable": coluna.IS_NULLABLE == "YES",
        "default": coluna.COLUMN_DEFAULT,
        "identity": bool(coluna.IS_IDENTITY),
    }


# ============================================================
# REGISTROS
# ============================================================

def contar_registros(cursor, schema, tabela):
    """Retorna a quantidade de registros."""

    query = f"""
        SELECT COUNT_BIG(*) AS total
        FROM [{schema}].[{tabela}];
    """

    cursor.execute(query)

    return int(cursor.fetchone().total)


# ============================================================
# PRIMARY KEYS
# ============================================================

def listar_primary_keys(cursor):
    """Lista todas as Primary Keys do banco."""

    cursor.execute("""
        SELECT
            tc.TABLE_SCHEMA,
            tc.TABLE_NAME,
            tc.CONSTRAINT_NAME,
            kcu.COLUMN_NAME,
            kcu.ORDINAL_POSITION
        FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS tc
        INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS kcu
            ON tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
            AND tc.TABLE_SCHEMA = kcu.TABLE_SCHEMA
            AND tc.TABLE_NAME = kcu.TABLE_NAME
        WHERE tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
        ORDER BY
            tc.TABLE_SCHEMA,
            tc.TABLE_NAME,
            tc.CONSTRAINT_NAME,
            kcu.ORDINAL_POSITION;
    """)

    return cursor.fetchall()


def construir_primary_keys(cursor):
    """Organiza Primary Keys por tabela."""

    rows = listar_primary_keys(cursor)

    primary_keys = {}

    for row in rows:

        key = (
            row.TABLE_SCHEMA,
            row.TABLE_NAME
        )

        if key not in primary_keys:

            primary_keys[key] = {
                "name": row.CONSTRAINT_NAME,
                "columns": []
            }

        primary_keys[key]["columns"].append(
            row.COLUMN_NAME
        )

    return primary_keys


# ============================================================
# FOREIGN KEYS
# ============================================================

def listar_foreign_keys(cursor):
    """Lista todas as Foreign Keys do banco."""

    cursor.execute("""
        SELECT
            fk.name AS constraint_name,

            OBJECT_SCHEMA_NAME(
                fk.parent_object_id
            ) AS parent_schema,

            OBJECT_NAME(
                fk.parent_object_id
            ) AS parent_table,

            parent_column.name AS parent_column,

            OBJECT_SCHEMA_NAME(
                fk.referenced_object_id
            ) AS referenced_schema,

            OBJECT_NAME(
                fk.referenced_object_id
            ) AS referenced_table,

            referenced_column.name AS referenced_column,

            fkc.constraint_column_id AS column_order,

            fk.delete_referential_action_desc
                AS delete_action,

            fk.update_referential_action_desc
                AS update_action

        FROM sys.foreign_keys AS fk

        INNER JOIN sys.foreign_key_columns AS fkc
            ON fk.object_id = fkc.constraint_object_id

        INNER JOIN sys.columns AS parent_column
            ON fkc.parent_object_id =
               parent_column.object_id
            AND fkc.parent_column_id =
                parent_column.column_id

        INNER JOIN sys.columns AS referenced_column
            ON fkc.referenced_object_id =
               referenced_column.object_id
            AND fkc.referenced_column_id =
                referenced_column.column_id

        ORDER BY
            parent_schema,
            parent_table,
            constraint_name,
            column_order;
    """)

    return cursor.fetchall()


def construir_foreign_keys(cursor):
    """Organiza Foreign Keys."""

    rows = listar_foreign_keys(cursor)

    foreign_keys = {}

    for row in rows:

        key = (
            row.parent_schema,
            row.parent_table,
            row.constraint_name
        )

        if key not in foreign_keys:

            foreign_keys[key] = {
                "name": row.constraint_name,
                "schema": row.parent_schema,
                "table": row.parent_table,
                "referenced_schema": row.referenced_schema,
                "referenced_table": row.referenced_table,
                "columns": [],
                "referenced_columns": [],
                "delete_action": row.delete_action,
                "update_action": row.update_action
            }

        foreign_keys[key]["columns"].append(
            row.parent_column
        )

        foreign_keys[key]["referenced_columns"].append(
            row.referenced_column
        )

    return list(foreign_keys.values())


# ============================================================
# ÍNDICES
# ============================================================

def listar_indices(cursor):
    """Lista os índices das tabelas."""

    cursor.execute("""
        SELECT
            s.name AS schema_name,
            t.name AS table_name,
            i.name AS index_name,
            i.type_desc AS index_type,
            i.is_unique,
            i.is_primary_key,
            i.is_unique_constraint,
            i.is_disabled,
            ic.key_ordinal,
            ic.is_included_column,
            c.name AS column_name

        FROM sys.indexes AS i

        INNER JOIN sys.tables AS t
            ON i.object_id = t.object_id

        INNER JOIN sys.schemas AS s
            ON t.schema_id = s.schema_id

        INNER JOIN sys.index_columns AS ic
            ON i.object_id = ic.object_id
            AND i.index_id = ic.index_id

        INNER JOIN sys.columns AS c
            ON ic.object_id = c.object_id
            AND ic.column_id = c.column_id

        WHERE
            i.name IS NOT NULL

        ORDER BY
            s.name,
            t.name,
            i.name,
            ic.key_ordinal,
            ic.index_column_id;
    """)

    return cursor.fetchall()


def construir_indices(cursor):
    """Organiza os índices por tabela."""

    rows = listar_indices(cursor)

    indices = {}

    for row in rows:

        key = (
            row.schema_name,
            row.table_name,
            row.index_name
        )

        if key not in indices:

            indices[key] = {
                "schema": row.schema_name,
                "table": row.table_name,
                "name": row.index_name,
                "type": row.index_type,
                "unique": bool(row.is_unique),
                "primary_key": bool(row.is_primary_key),
                "unique_constraint": bool(
                    row.is_unique_constraint
                ),
                "disabled": bool(row.is_disabled),
                "columns": [],
                "included_columns": []
            }

        if row.is_included_column:

            indices[key]["included_columns"].append(
                row.column_name
            )

        else:

            indices[key]["columns"].append(
                row.column_name
            )

    return list(indices.values())


# ============================================================
# VIEWS
# ============================================================

def listar_views(cursor):
    """Lista todas as views."""

    cursor.execute("""
        SELECT
            TABLE_SCHEMA,
            TABLE_NAME
        FROM INFORMATION_SCHEMA.VIEWS
        ORDER BY
            TABLE_SCHEMA,
            TABLE_NAME;
    """)

    rows = cursor.fetchall()

    return [
        {
            "schema": row.TABLE_SCHEMA,
            "name": row.TABLE_NAME
        }
        for row in rows
    ]


# ============================================================
# STORED PROCEDURES
# ============================================================

def listar_procedures(cursor):
    """Lista todas as Stored Procedures."""

    cursor.execute("""
        SELECT
            s.name AS schema_name,
            p.name AS procedure_name,
            p.create_date,
            p.modify_date
        FROM sys.procedures AS p
        INNER JOIN sys.schemas AS s
            ON p.schema_id = s.schema_id
        ORDER BY
            s.name,
            p.name;
    """)

    rows = cursor.fetchall()

    return [
        {
            "schema": row.schema_name,
            "name": row.procedure_name,
            "create_date": (
                row.create_date.isoformat()
                if row.create_date
                else None
            ),
            "modify_date": (
                row.modify_date.isoformat()
                if row.modify_date
                else None
            )
        }
        for row in rows
    ]


# ============================================================
# FUNCTIONS
# ============================================================

def listar_functions(cursor):
    """Lista todas as Functions."""

    cursor.execute("""
        SELECT
            s.name AS schema_name,
            o.name AS function_name,
            o.type_desc,
            o.create_date,
            o.modify_date
        FROM sys.objects AS o
        INNER JOIN sys.schemas AS s
            ON o.schema_id = s.schema_id
        WHERE o.type IN (
            'FN',
            'IF',
            'TF'
        )
        ORDER BY
            s.name,
            o.name;
    """)

    rows = cursor.fetchall()

    return [
        {
            "schema": row.schema_name,
            "name": row.function_name,
            "type": row.type_desc,
            "create_date": (
                row.create_date.isoformat()
                if row.create_date
                else None
            ),
            "modify_date": (
                row.modify_date.isoformat()
                if row.modify_date
                else None
            )
        }
        for row in rows
    ]


# ============================================================
# CONSTRUÇÃO DO INVENTÁRIO
# ============================================================

def gerar_inventory():

    connection = get_connection()
    cursor = connection.cursor()

    try:

        print()
        print("=" * 80)
        print("INVENTÁRIO DO BANCO")
        print("=" * 80)
        print(f"Banco: {DATABASE_NAME}")
        print()

        # ----------------------------------------------------
        # Primary Keys
        # ----------------------------------------------------

        print("Coletando Primary Keys...")

        primary_keys = construir_primary_keys(cursor)

        # ----------------------------------------------------
        # Foreign Keys
        # ----------------------------------------------------

        print("Coletando Foreign Keys...")

        foreign_keys = construir_foreign_keys(cursor)

        # ----------------------------------------------------
        # Índices
        # ----------------------------------------------------

        print("Coletando índices...")

        indices = construir_indices(cursor)

        # ----------------------------------------------------
        # Views
        # ----------------------------------------------------

        print("Coletando Views...")

        views = listar_views(cursor)

        # ----------------------------------------------------
        # Procedures
        # ----------------------------------------------------

        print("Coletando Stored Procedures...")

        procedures = listar_procedures(cursor)

        # ----------------------------------------------------
        # Functions
        # ----------------------------------------------------

        print("Coletando Functions...")

        functions = listar_functions(cursor)

        # ----------------------------------------------------
        # Tabelas
        # ----------------------------------------------------

        print("Coletando tabelas e colunas...")

        tabelas = listar_tabelas(cursor)

        inventory = {
            "database": DATABASE_NAME,

            "summary": {
                "table_count": len(tabelas),
                "view_count": len(views),
                "procedure_count": len(procedures),
                "function_count": len(functions),
                "primary_key_count": len(primary_keys),
                "foreign_key_count": len(foreign_keys),
                "index_count": len(indices),
                "total_row_count": 0
            },

            "tables": [],

            "primary_keys": [],

            "foreign_keys": foreign_keys,

            "indexes": indices,

            "views": views,

            "stored_procedures": procedures,

            "functions": functions
        }

        # ----------------------------------------------------
        # Processar tabelas
        # ----------------------------------------------------

        for tabela in tabelas:

            schema = tabela.TABLE_SCHEMA
            nome_tabela = tabela.TABLE_NAME

            row_count = contar_registros(
                cursor,
                schema,
                nome_tabela
            )

            colunas = listar_colunas(
                cursor,
                schema,
                nome_tabela
            )

            tabela_info = {
                "schema": schema,
                "name": nome_tabela,
                "row_count": row_count,
                "column_count": len(colunas),
                "columns": [
                    construir_coluna(coluna)
                    for coluna in colunas
                ]
            }

            inventory["tables"].append(
                tabela_info
            )

            inventory["summary"]["total_row_count"] += (
                row_count
            )

        # ----------------------------------------------------
        # Primary Keys
        # ----------------------------------------------------

        for key, value in primary_keys.items():

            schema, tabela = key

            inventory["primary_keys"].append({
                "schema": schema,
                "table": tabela,
                "name": value["name"],
                "columns": value["columns"]
            })

        return inventory

    finally:

        cursor.close()
        connection.close()


# ============================================================
# TERMINAL
# ============================================================

def exibir_inventory(inventory):

    summary = inventory["summary"]

    print()
    print("=" * 80)
    print("RESUMO DO INVENTÁRIO")
    print("=" * 80)

    print(
        f"Tabelas:             {summary['table_count']}"
    )

    print(
        f"Views:               {summary['view_count']}"
    )

    print(
        f"Stored Procedures:   {summary['procedure_count']}"
    )

    print(
        f"Functions:           {summary['function_count']}"
    )

    print(
        f"Primary Keys:        {summary['primary_key_count']}"
    )

    print(
        f"Foreign Keys:        {summary['foreign_key_count']}"
    )

    print(
        f"Índices:             {summary['index_count']}"
    )

    print(
        f"Registros totais:    "
        f"{summary['total_row_count']:,}"
    )

    print("=" * 80)

    print()
    print("TABELAS")
    print("=" * 80)

    for tabela in inventory["tables"]:

        print(
            f"{tabela['schema']}."
            f"{tabela['name']}"
        )

        print(
            f"    Registros: {tabela['row_count']:,}"
        )

        print(
            f"    Colunas:   {tabela['column_count']}"
        )

    print()
    print("PRIMARY KEYS")
    print("=" * 80)

    for pk in inventory["primary_keys"]:

        print(
            f"{pk['schema']}."
            f"{pk['table']} "
            f"-> {pk['name']}"
        )

        print(
            f"    Colunas: "
            f"{', '.join(pk['columns'])}"
        )

    print()
    print("FOREIGN KEYS")
    print("=" * 80)

    for fk in inventory["foreign_keys"]:

        origem = (
            f"{fk['schema']}."
            f"{fk['table']}"
        )

        destino = (
            f"{fk['referenced_schema']}."
            f"{fk['referenced_table']}"
        )

        print(
            f"{fk['name']}: "
            f"{origem} -> {destino}"
        )

        print(
            f"    Colunas: "
            f"{', '.join(fk['columns'])}"
        )

        print(
            f"    Referência: "
            f"{', '.join(fk['referenced_columns'])}"
        )

    print()
    print("VIEWS")
    print("=" * 80)

    for view in inventory["views"]:

        print(
            f"{view['schema']}."
            f"{view['name']}"
        )

    print()
    print("STORED PROCEDURES")
    print("=" * 80)

    for procedure in inventory["stored_procedures"]:

        print(
            f"{procedure['schema']}."
            f"{procedure['name']}"
        )

    print()
    print("FUNCTIONS")
    print("=" * 80)

    for function in inventory["functions"]:

        print(
            f"{function['schema']}."
            f"{function['name']} "
            f"({function['type']})"
        )

    print()
    print("ÍNDICES")
    print("=" * 80)

    for index in inventory["indexes"]:

        print(
            f"{index['name']}"
        )

        print(
            f"    Tipo: {index['type']}"
        )

        print(
            f"    Tabela: "
            f"{index.get('schema', '')}."
            f"{index.get('table', '')}"
        )

        if index["columns"]:

            print(
                f"    Colunas: "
                f"{', '.join(index['columns'])}"
            )

        if index["included_columns"]:

            print(
                f"    Included: "
                f"{', '.join(index['included_columns'])}"
            )


# ============================================================
# JSON
# ============================================================

def salvar_inventory(inventory):

    INVENTORY_DIR.mkdir(
        parents=True,
        exist_ok=True
    )

    with open(
        INVENTORY_FILE,
        "w",
        encoding="utf-8"
    ) as arquivo:

        json.dump(
            inventory,
            arquivo,
            indent=4,
            ensure_ascii=False
        )

    print()
    print("=" * 80)
    print("INVENTÁRIO SALVO")
    print("=" * 80)
    print(
        f"Arquivo: {INVENTORY_FILE}"
    )
    print("=" * 80)
    print()


# ============================================================
# EXECUÇÃO
# ============================================================

if __name__ == "__main__":

    inventory = gerar_inventory()

    exibir_inventory(inventory)

    salvar_inventory(inventory)