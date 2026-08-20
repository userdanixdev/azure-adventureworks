# Migration Azure Database - AdventureWorksDW2022

Esta branch apresenta os estudos relacionados à possibilidade de migrar o banco de dados **AdventureWorksDW2022**, atualmente restaurado em uma **Azure SQL Managed Instance**, para um serviço de banco de dados que permita acesso independente da Managed Instance.

O objetivo não é simplesmente mover os arquivos físicos do SQL Server, mas compreender como funciona a migração de um banco SQL Server para serviços gerenciados da Azure, especialmente o **Azure SQL Database**.

## Contexto passado:

O projeto possui um backup do AdventureWorksDW2022 armazenado no **Azure Blob Storage**.

A arquitetura atual é:

```text
AdventureWorksDW2022.bak
          │
          ▼
Azure Blob Storage
          │
          │ RESTORE
          ▼
Azure SQL Managed Instance
          │
          ▼
AdventureWorksDW2022
```

A Managed Instance funciona como o ambiente SQL Server responsável por restaurar e executar o banco.

Quando a instância está ativa, o banco pode ser acessado normalmente através de Python, Power BI, DBeaver e outras ferramentas compatíveis.

Quando a instância está desativada, o banco continua associado à infraestrutura, mas não fica disponível para conexões.

## Por que não basta mover o arquivo do banco?

Um banco SQL Server possui arquivos físicos, como:

```text
AdventureWorksDW2022.mdf
AdventureWorksDW2022.ndf
AdventureWorksDW2022.ldf
```

Esses arquivos fazem parte da implementação física do SQL Server.

Em um SQL Server tradicional, dependendo do ambiente, é possível realizar operações como `ATTACH` e `DETACH` utilizando os arquivos físicos do banco.

Entretanto, o **Azure SQL Database** funciona como um serviço PaaS gerenciado.

Nesse modelo, o usuário não possui acesso direto ao sistema operacional e ao armazenamento físico da infraestrutura para simplesmente copiar um `.mdf`, `.ndf` ou `.ldf` para dentro do serviço.

Portanto:

```text
SQL Server
    │
    ├── MDF
    ├── NDF
    └── LDF
    │
    X
    │
    └── Não podem simplesmente ser copiados
        para o Azure SQL Database
```

É necessário utilizar um processo de migração compatível com o serviço de destino.

## Por que o fato de ser SQL Server é importante?

O AdventureWorksDW2022 é um banco desenvolvido para o ecossistema SQL Server.

Por isso, uma migração para outro serviço SQL da Azure pode aproveitar diversos componentes e conceitos existentes no SQL Server, como:

* T-SQL;
* tabelas;
* views;
* índices;
* constraints;
* relacionamentos;
* funções;
* procedures;
* estruturas de dados;
* modelos dimensionais.

Entretanto, **SQL Server, Azure SQL Managed Instance e Azure SQL Database não são produtos idênticos**.

Existem diferenças de arquitetura, recursos, permissões e funcionalidades disponíveis.

Por esse motivo, antes de migrar um banco SQL Server para Azure SQL Database, é necessário verificar a compatibilidade do workload.

## Backup não é banco acessível

Outro ponto importante é diferenciar o backup do banco de dados.

O arquivo `AdventureWorksDW2022.bak` é um **backup**.

Ele pode ser armazenado no Azure Blob Storage de forma independente da execução da Managed Instance.

Porém, não significa que o banco esteja disponível para consultas SQL.

Para executar:

```sql
SELECT *
FROM dbo.AlgumaTabela;
```

é necessário que os dados estejam carregados em um mecanismo de banco capaz de executar SQL.

> Por isso, o Blob Storage funciona como armazenamento do backup, e não como substituto direto de um servidor SQL.

## Por que considerar a migração?

A principal motivação desta branch é avaliar uma arquitetura em que o banco possa permanecer disponível sem depender diretamente da Managed Instance utilizada para a restauração.

Atualmente:

```text
Managed Instance ativa
        │
        ▼
AdventureWorksDW2022
        │
        ▼
Banco acessível
```

Quando a Managed Instance está desativada:

```text
Managed Instance desativada
        │
        ▼
AdventureWorksDW2022
        │
        ▼
Banco não acessível
```

Uma eventual migração para outro serviço poderia permitir uma arquitetura diferente, dependendo das características de disponibilidade e custo desejadas.

## Trade-off entre economia e disponibilidade

A decisão depende do objetivo do projeto.

### Manter apenas o backup

**Vantagens:**

* armazenamento persistente;
* baixo custo relativo;
* backup independente da execução do SQL Server;
* possibilidade de restauração futura.

**Desvantagem:**

* não permite consultas SQL diretamente;
* é necessário um ambiente SQL para restaurar o banco.

### Manter o banco na Managed Instance

**Vantagens:**

* compatibilidade elevada com SQL Server;
* banco pronto para consultas quando a instância está ativa;
* adequado para estudos de SQL Server.

**Desvantagem:**

* depende da disponibilidade da Managed Instance;
* manter infraestrutura ativa continuamente pode aumentar custos.

### Migrar para Azure SQL Database

**Vantagens potenciais:**

* serviço PaaS;
* gerenciamento de infraestrutura abstraído;
* possibilidade de utilizar o banco independentemente da Managed Instance atual;
* integração com ferramentas de dados e BI.

**Desvantagens:**

* necessidade de realizar a migração;
* necessidade de avaliar compatibilidade;
* possíveis alterações em objetos e funcionalidades;
* custo deve ser analisado de acordo com o nível de serviço escolhido.

## O objetivo desta branch

A branch `migration-azure-database` existe para estudar justamente essa possibilidade.

O objetivo não é substituir imediatamente a arquitetura atual, mas avaliar:

1. Compatibilidade do AdventureWorksDW2022 com Azure SQL Database.
2. Estratégias de migração.
3. Transferência de schema e dados.
4. Ferramentas disponíveis na Azure.
5. Possíveis limitações.
6. Impacto sobre Power BI.
7. Impacto sobre as conexões Python.
8. Custo da nova arquitetura.
9. Benefícios de manter o banco disponível independentemente da Managed Instance.

## Conclusão

O AdventureWorksDW2022 não pode ser tratado simplesmente como um conjunto de arquivos `.mdf`, `.ndf` e `.ldf` que podem ser copiados diretamente para o Azure SQL Database.

O Azure SQL Database é um serviço PaaS que abstrai a infraestrutura física do SQL Server. Por isso, a transferência para esse serviço exige uma estratégia de migração compatível com sua arquitetura.

O arquivo `.bak` continua sendo extremamente útil como backup e pode permanecer no Azure Blob Storage independentemente da execução da Managed Instance.

A SQL Managed Instance permanece como o ambiente atual para restauração e execução do AdventureWorksDW2022.

A migração para Azure SQL Database representa uma possível evolução arquitetural para um cenário em que seja desejável utilizar o banco fora da Managed Instance atual.

Assim, esta branch documenta a evolução do projeto de uma abordagem baseada em:

```text
Backup → Blob Storage → SQL Managed Instance
```

para a avaliação de uma nova arquitetura:

```text
Backup → Blob Storage
             │
             ▼
      Processo de migração
             │
             ▼
     Azure SQL Database
             │
             ▼
      Python / Power BI
```

A decisão final deve considerar principalmente **compatibilidade, disponibilidade, complexidade operacional e custo**.


## Inventário do banco:

O arquivo `3.inventory.py` foi desenvolvido para realizar um inventário estrutural do banco AdventureWorksDW2022 hospedado atualmente na Azure SQL Managed Instance. O script utiliza a conexão existente do projeto para coletar informações necessárias antes da migração para o Azure SQL Database.

O inventário identifica as tabelas, colunas, tipos de dados, tamanhos, precisão, escala, possibilidade de valores nulos, valores padrão e campos IDENTITY, além de contabilizar a quantidade de registros de cada tabela.

Também são levantadas as estruturas relacionais e de banco, incluindo Primary Keys, Foreign Keys, índices, Views, Stored Procedures e Functions. Essas informações permitem conhecer a estrutura atual do banco antes da migração e posteriormente utilizá-las para mapear e validar o banco de destino.

Além da exibição das informações no terminal, o script gera automaticamente um arquivo adventureworks_inventory.json dentro do diretório inventory/. O JSON funciona como um snapshot estruturado da origem, podendo ser utilizado posteriormente pelo processo de migração e na comparação entre o banco da Managed Instance e o Azure SQL Database.

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
  1. Criação de Schemas
  2. Criação de Tabelas
  3. Criação de Primary Keys
  4. Criação de Índices
  5. Carga de Dados (Load Data)
  6. Criação de Foreign Keys
  7. Validação de Migração

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

## Como Funciona o Script

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

## ☁️ Arquitetura de Nuvem: Azure SQL Database vs. Managed Instance

Para a infraestrutura deste Data Warehouse, a escolha da plataforma de banco de dados na nuvem seguiu critérios rigorosos de **desempenho, escalabilidade, compatibilidade e otimização de custos**. Optou-se pelo **Azure SQL Database** em detrimento de uma instância *Managed Instance (MI)* ou de infraestrutura como serviço (IaaS/VM).

Abaixo está o comparativo técnico que fundamenta essa decisão para o ecossistema do projeto:

### 📊 Tabela Comparativa de Decisão

| Critério | Azure SQL Database (PaaS) | SQL Server Managed Instance (MI) |
| :--- | :--- | :--- |
| **Modelo de Serviço** | PaaS (Banco de Dados como Serviço) | PaaS (Instância Gerenciada de Servidor) |
| **Foco Principal** | Aplicações modernas e microsserviços | Migração *Lift-and-Shift* de legados |
| **Gerenciamento** | Totalmente automatizado (SaaS/PaaS) | Gerenciado, mas exige foco em instâncias |
| **Escalabilidade** | Imediata (Opção Serverless disponível) | Requer redimensionamento de nós/tier |
| **Modelo de Custos** | Baseado em consumo (vCore / DTU) | Fixo por nó alocado (geralmente mais alto) |
| **Escopo de Isolamento** | Baseado em banco de dados isolado | Instância completa (vários DBs, Agent, etc.) |

---
## 🗂️ Estrutura do Projeto

O repositório está organizado em módulos que separam as etapas de restauração de backup, auditoria estrutural (inventário), planejamento e implantação do schema no Azure:

```text
project_adventureworksDW2022/
│
├── .vscode/                 # Configurações do editor
├── inventory/               # Dados estruturais extraídos da origem
│   └── adventureworks_inventory.json  # Snapshot completo do schema original
│
├── migration/               # Scripts de engenharia e deploy para o Azure SQL
│   ├── 01_create_schema_and_tables.sql  # DDL limpo gerado para o Azure
│   ├── deploy_schema.py     # Script de conexão e execução automatizada via ODBC
│   ├── migration_plan.json  # Plano estruturado e mapeado de tipos de dados
│   ├── migration_plan.py    # Conversor/Planejador de migração inteligente
│   └── migration_schema.py  # Gerador de código DDL em Raw SQL (sem ORM)
│   └── load_data.py         # Extrair os dados de origem
│
├── restore_database/        # Módulo de manipulação e auditoria na Managed Instance
│   ├── 1.restore_bak.py     # Automação de restore do .bak via Blob Storage
│   ├── 2.queries.py         # Consultas de validação inicial
│   ├── 3.inventory.py       # Extração de metadados, PKs, FKs e contagem de linhas
│   ├── a.restore_status.py  # Monitoramento do status do banco
│   └── connection.py        # Configuração centralizada de conexão com a MI
│
├── .env                     # Variáveis de ambiente e credenciais (excluído do Git)
├── .gitignore               # Arquivos ignorados pelo controle de versão
├── environment.yml          # Dependências e ambiente conda do projeto
└── README.md                # Documentação oficial da arquitetura e projeto
```

### Análise dos Requisitos:

#### 1. Requisitos e Compatibilidade
* **Azure SQL Database:** Perfeito para o projeto, pois o escopo se concentra na estruturação de um modelo relacional analítico (Data Warehouse) e ingestão via scripts Python. Ele oferece suporte a quase 100% dos recursos transacionais e analíticos do SQL Server sem a necessidade de gerenciar uma instância inteira.
* **Managed Instance:** Projetada estritamente para cenários onde sistemas legados dependem de recursos a nível de instância (como *SQL Agent Jobs* complexos, *Cross-Database Queries* pesadas ou CLR). Como este projeto é uma pipeline moderna, a MI introduziria uma complexidade e sobrecarga desnecessárias.

#### 2. Desempenho e Escalabilidade
* **Azure SQL Database:** Oferece suporte à modalidade **Serverless**, permitindo pausar automaticamente o banco de dados em períodos de ociosidade — gerando economia significativa de recursos — e escalando os recursos computacionais de forma instantânea mediante a chegada de novas cargas de trabalho ou consultas do Power BI.
* **Managed Instance:** Os recursos computacionais permanecem alocados e cobrados de forma contínua, o que faz sentido para ambientes corporativos pesados 24/7, mas representa desperdício financeiro em ambientes de desenvolvimento e portfólios analíticos.

#### 3. Custos e Otimização Financeira
* **Azure SQL Database:** Modelo de cobrança altamente flexível, ideal para projetos de médio porte e portfólios de dados, permitindo pagar estritamente pelo uso computacional ou pelas DTUs consumidas.
* **Managed Instance:** Possui um piso de custo mensal elevado devido à exigência de provisionamento de uma infraestrutura de instância dedicada inteira, sendo inviável para projetos enxutos.

---

### Veredito da Arquitetura:
A adoção do **Azure SQL Database** garantiu:
1. **Agilidade no Deploy:** Provisionamento e ajustes de schema automatizados via scripts Python/DDL.
2. **Manutenção Zero:** Foco absoluto na engenharia de dados e modelagem, delegando a aplicação de patches e atualizações de infraestrutura para a Microsoft.
3. **Integração Nativa com Power BI:** Conectividade otimizada e nativa para a camada de visualização de dados sem barreiras de rede complexas.


# Atenção: Migração para Azure e o Azure Database Migration Service (DMS)

## 1. O que é o Azure Database Migration Service (DMS)?
O Azure DMS é um serviço totalmente gerenciado, projetado para permitir migrações perfeitas de várias fontes de banco de dados para as plataformas de dados do Azure com tempo de inatividade mínimo.

## 2. Custos do DMS: É caro?
A resposta curta é: **não, ele não é caro**, e para a maioria dos cenários de migração, ele é **totalmente gratuito**.

### Níveis de Serviço e Precificação:

*   **Nível Standard (Gratuito):**
    *   **Finalidade:** Ideal para migrações "offline".
    *   **Cenário:** Quando você pode permitir uma janela de manutenção onde a aplicação para, permitindo a cópia dos dados.
    *   **Custo:** **$0 (Gratuito)**. É a opção ideal para a maioria dos projetos de pequeno e médio porte.

*   **Nível Premium (Tempo de Indisponibilidade Mínimo):**
    *   **Finalidade:** Ideal para bancos de dados críticos que exigem migração "online" com sincronização contínua.
    *   **Custo:** **Gratuito pelos primeiros 183 dias** (aprox. 6 meses).
    *   **Após o período:** Cobrado por vCore por hora. Na prática, como a maioria das migrações é concluída muito antes desse prazo, o custo da ferramenta acaba sendo zero para a maioria das empresas.

## 3. Onde está o custo real da migração?
Embora a ferramenta DMS seja gratuita, você deve considerar os custos operacionais do projeto:

1.  **Destino (Azure SQL Database):** Este é o seu custo fixo mensal. O preço depende do nível de performance (vCores ou DTUs) e do armazenamento (GB) que você selecionar.
2.  **Armazenamento e Transferência de Dados:** Podem existir custos de armazenamento de backups ou tráfego de dados, dependendo do volume.
3.  **Mão de Obra e Consultoria:** O maior investimento em projetos de migração geralmente é o tempo da equipe técnica para preparar o ambiente, garantir a compatibilidade e validar a integridade dos dados pós-migração.

## 4. Conclusão
A abordagem manual (via script Python) é extremamente econômica, não pago por ferramentas extras. Migrar usando o DMS oficial é uma excelente escolha para automatizar processos, e como a ferramenta é gratuita (ou tem um período de tolerância muito longo), **o custo da ferramenta DMS não deve ser uma barreira para o seu projeto**.

---
*Referência: [Visão geral do Azure Database Migration Service](https://learn.microsoft.com/pt-br/azure/dms/dms-overview)*

---

*A evolução arquitetural documentada nesta branch demonstra que a transição de um ambiente pesado de SQL Managed Instance para um serviço enxuto e escalável como o Azure SQL Database traz ganhos expressivos em termos de agilidade de desenvolvimento, automação via código Python e otimização financeira significativa (especialmente através do modelo Serverless e do controle de infraestrutura ociosa).*

*Com a infraestrutura de banco de dados modelada, deployada e validada com sucesso, o projeto encerra sua fase de infraestrutura de dados e está pronto para avançar para a camada analítica e de visualização utilizando o Power BI.*

