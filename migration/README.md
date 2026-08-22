## Inventário do banco:

O arquivo `3.inventory.py` foi desenvolvido para realizar um inventário estrutural do banco AdventureWorksDW2022 hospedado atualmente na `Azure SQL Managed Instance`. O script utiliza a conexão existente do projeto para coletar informações necessárias antes da migração para o Azure SQL Database.

O inventário identifica as tabelas, colunas, tipos de dados, tamanhos, precisão, escala, possibilidade de valores nulos, valores padrão e campos IDENTITY, além de contabilizar a quantidade de registros de cada tabela.

Também são levantadas as estruturas relacionais e de banco, incluindo `Primary Keys, Foreign Keys, índices, Views, Stored Procedures e Functions.` Essas informações permitem conhecer a estrutura atual do banco antes da migração e posteriormente utilizá-las para mapear e validar o banco de destino.

Além da exibição das informações no terminal, o script gera automaticamente um arquivo **adventureworks_inventory.json** dentro do diretório inventory/. O JSON funciona como um snapshot estruturado da origem, podendo ser utilizado posteriormente pelo processo de migração e na comparação entre o banco da Managed Instance e o Azure SQL Database.

O inventário foi definido como uma etapa anterior à migração para garantir que estrutura, relacionamentos, índices e quantidade de dados sejam conhecidos antes da criação e carga do banco definitivo.


## 🏗️ Arquitetura da Migração

A estratégia de migração foi dividida nas seguintes fases:

### 1. Fase de Inventário (`inventory.json`)
- Extração de todos os metadados do banco de dados de origem (AdventureWorksDW2022).
- Mapeamento de 31 tabelas e mais de 1 milhão de registros previstos.
- Coleta de metadados brutos (colunas, tipos de dados, chaves primárias, estrangeiras e índices).

### 2. Fase de Planejamento (`migration_plan.py`)
Script que consome o inventário e constrói um **Plano de Migração** definitivo (`migration_plan.json`). 

**Principais recursos:**

- **Tradução de Tipos (Azure SQL Dialect):** Conversão de tipos incompatíveis ou legados (ex: `int(10,0)`) para a sintaxe rigorosa aceita pelo Azure SQL (`INT`, `NVARCHAR(MAX)`, etc).
- **Extração e Estruturação:** Separação limpa de Schemas, Tabelas, Primary Keys (PKs), Foreign Keys (FKs) e Índices.
- **Estratégia de Execução Segura:** Define uma ordem lógica para evitar erros de dependência:
``` 
  1. Criação de Schemas
  2. Criação de Tabelas
  3. Criação de Primary Keys
  4. Criação de Índices
  5. Carga de Dados (Load Data)
  6. Criação de Foreign Keys
  7. Validação de Migração
```
### 3. Fase de Geração de Schema DDL (`migration_schema.py`)

Script em Python puro (sem uso de ORMs como SQLAlchemy) que lê o plano de migração gerado e constrói o código SQL exato para a infraestrutura no Azure.

**Saída Gerada:** Arquivo `01_create_schema_and_tables.sql`

**Principais recursos:**

- **Geração de Raw SQL Otimizado:** Escreve a sintaxe nativa do Azure SQL Database, aplicando os tipos de dados traduzidos, restrições de nulidade (`NULL`/`NOT NULL`) e auto-incremento (`IDENTITY`).
- **Idempotência (Segurança):** Todos os blocos DDL utilizam verificações `IF NOT EXISTS`, garantindo que o script possa ser rodado múltiplas vezes sem causar erros de "objeto já existente".
- **Omissão Proposital de Chaves:** Cria **apenas** Schemas e Tabelas. Primary Keys, Foreign Keys e Índices são intencionalmente ignorados nesta fase para evitar gargalos de performance e erros de restrição de integridade durante a futura carga de dados (Phase Load).

### Sobre o script gerado: `01_create_schema_and_tables.sql`
Este arquivo é o script DDL (Data Definition Language) bruto gerado automaticamente pelo Python. Ele atua como o "alicerce" do banco de dados no Azure e possui três características fundamentais:

- **Idempotência (Execução Segura):** Todo comando de criação utiliza a cláusula `IF NOT EXISTS`. Isso significa que o script pode ser executado múltiplas vezes sem gerar erros de "objeto já existente" e sem apagar dados acidentalmente.
- **Estrutura Pura (Raw SQL):** Contém estritamente a criação de *Schemas* e *Tabelas*, já com a sintaxe e os tipos de dados perfeitamente traduzidos para o dialeto do Azure SQL Database (incluindo regras de `NULL/NOT NULL` e `IDENTITY`).
- **Foco em Performance de Carga:** Chaves Primárias (PKs), Chaves Estrangeiras (FKs) e Índices **não** estão neste arquivo. Eles são intencionalmente deixados para o final do projeto. Criar a "carcaça" vazia garante que a futura inserção de milhões de linhas seja extremamente rápida e livre de erros de dependência.


### 4. Fase de Deploy de Infraestrutura (`deploy_schema.py`)
Este script é a ponte entre o seu projeto local e a nuvem. Ele é responsável por pegar o SQL gerado na etapa anterior e materializá-lo de fato no Azure.

**O que este script faz:**
- **Conexão Segura:** Estabelece comunicação com o Azure SQL Database utilizando a biblioteca `pyodbc`, lendo as credenciais de forma segura a partir de um arquivo `.env` (garantindo que senhas não fiquem expostas no código).
- **Processamento de Lotes (Batch Execution):** Como os drivers ODBC não compreendem o comando separador `GO` do SQL Server, o script lê o arquivo `01_create_schema_and_tables.sql` e inteligentemente o "fatia" em blocos de execução.
- **Execução e Transação (Commit/Rollback):** Envia os comandos DDL para o Azure um a um. Se tudo der certo, ele salva as alterações (*commit*). Se algum bloco falhar, ele desfaz a operação de segurança (*rollback*) e exibe o detalhe do erro.
- **Resultado:** Ao final da execução, o seu banco de dados no Azure estará com toda a "carcaça" pronta: os *Schemas* e *Tabelas* estarão criados, estruturados corretamente, mas ainda vazios, aguardando a fase de extração e carga de dados.

### 5. O script `load_data.py`

O script **`load_data.py`** é o motor responsável por extrair os dados da sua origem (Managed Instance) e inseri-los de forma segura, otimizada e monitorada no destino (Azure SQL Database).

### 5.1 - Como Funciona o Script

### 1. Leitura do Plano de Migração
* **O que faz:** Lê o arquivo `migration_plan.json` gerado anteriormente para descobrir exatamente quais tabelas precisam ser migradas, evitando que você precise digitar o nome de cada uma manualmente.

### 2. Conexão Segura com os Bancos
* **O que faz:** Utiliza o driver **ODBC Driver 18 for SQL Server** junto com as credenciais salvas no seu arquivo `.env` para abrir conexões seguras (`Encrypt=yes`) tanto para a origem quanto para o Azure.

### 3. Limpeza Preventiva de Dados
* **O que faz:** Antes de inserir os dados de uma tabela, o script tenta executar um `TRUNCATE` (ou `DELETE`) no destino. Isso garante que, se você precisar cancelar e reiniciar o processo, ele limpa os registros parciais e **evita erros de chave duplicada**.

### 4. Controle de Identidade (`IDENTITY_INSERT`)
* **O que faz:** Como tabelas com colunas autoincremento possuem restrições de identidade, o script ativa o comando `SET IDENTITY_INSERT ON` temporariamente para permitir que os IDs originais antigos sejam preservados no Azure.

### 5. Lotes Otimizados e Barra de Progresso
* **O que faz:** 
  * Divide os dados em blocos de **5.000 linhas** para economizar memória e garantir estabilidade de rede.
  * Ativa a flag `fast_executemany = True` do PyODBC para alcançar a **velocidade máxima de inserção**.
  * Utiliza a biblioteca `tqdm` para exibir uma barra de carregamento interativa no terminal, mostrando o progresso em tempo real.


*Referência: [Visão geral do Azure Database Migration Service](https://learn.microsoft.com/pt-br/azure/dms/dms-overview)*
