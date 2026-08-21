![Azure](https://img.shields.io/badge/Microsoft%20Azure-0078D4?logo=microsoftazure&logoColor=white)
![Azure SQL](https://img.shields.io/badge/Azure%20SQL-0078D4?logo=microsoftsqlserver&logoColor=white)
![Blob Storage](https://img.shields.io/badge/Azure%20Blob%20Storage-0089D6?logo=microsoftazure&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?logo=microsoftsqlserver&logoColor=white)
![Azure SQL Managed Instance](https://img.shields.io/badge/Azure%20SQL%20Managed%20Instance-0078D4?logo=microsoftazure&logoColor=white)
![Microsoft Entra ID](https://img.shields.io/badge/Microsoft%20Entra%20ID-5E5E5E?logo=microsoft&logoColor=white)
![Managed Identity](https://img.shields.io/badge/Azure%20Managed%20Identity-0078D4?logo=microsoftazure&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white)
![PyODBC](https://img.shields.io/badge/PyODBC-3776AB?logo=python&logoColor=white)
![python-dotenv](https://img.shields.io/badge/python--dotenv-3776AB?logo=python&logoColor=white)
![Microsoft ODBC Driver](https://img.shields.io/badge/Microsoft%20ODBC%20Driver%2018-CC2927?logo=microsoftsqlserver&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?logo=powerbi&logoColor=black)

# AdventureWorksDW2022 - Azure SQL Managed Instance

Projeto de estudo e laboratório para restauração, gerenciamento e acesso ao banco de dados **AdventureWorksDW2022** utilizando **Azure SQL Managed Instance**, com foco em práticas de infraestrutura em nuvem, autenticação Microsoft Entra ID, automação com Python e principalmente **redução de custos por uso sob demanda**.

O banco AdventureWorksDW2022 é utilizado como base para estudos de SQL Server, consultas analíticas, integração com ferramentas de dados e posteriormente utilização em soluções como Power BI.

## Objetivo

O objetivo deste projeto é disponibilizar o banco AdventureWorksDW2022 em uma infraestrutura SQL Server hospedada na Azure, utilizando uma abordagem que permita manter os recursos necessários sem deixar a instância SQL ativa continuamente.

A arquitetura utiliza um arquivo de backup `.bak` armazenado no Azure Blob Storage. Esse arquivo funciona como uma cópia persistente do banco e pode ser utilizado para realizar a restauração na SQL Managed Instance quando necessário.

A ideia principal é evitar manter a infraestrutura computacional ativa durante períodos em que o banco não está sendo utilizado.

## Arquitetura

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
        │
        ├── Python
        ├── Power BI
        └── Ferramentas SQL
```

O arquivo de backup permanece armazenado no Blob Storage, enquanto o banco restaurado permanece dentro da SQL Managed Instance.

Para mais detalhes da implementação acesse o projeto ContosoRetailDW. Nele temos mais detalhes sobre todo o processo de restauração inicial de um banco legado.

[Projeto ContosoRetailDW_Cloud Azure](https://github.com/userdanixdev/azure-contoso)

## Estratégia de economia

A estratégia deste projeto é evitar que a SQL Managed Instance permaneça ativa sem necessidade.

A Managed Instance é o ambiente responsável por executar o SQL Server e disponibilizar o banco para conexões. Portanto, quando a instância está ativa, o banco pode ser acessado normalmente por aplicações, scripts Python, ferramentas de banco de dados e ferramentas de BI.

Quando a instância é desativada, o banco deixa de estar disponível para consultas e conexões enquanto a infraestrutura estiver parada.

Isso significa que:

* o banco já restaurado não precisa ser restaurado novamente apenas porque a instância foi desativada;
* os dados continuam associados à infraestrutura da Managed Instance;
* o banco somente poderá ser acessado novamente quando a instância estiver ativa;
* o arquivo `.bak` mantido no Blob Storage funciona como uma cópia persistente e independente da execução da instância;
* a instância pode ser mantida desativada durante períodos em que o projeto não estiver sendo utilizado, conforme as condições e recursos de parada/inicialização disponíveis para a configuração adotada na Azure.

A estratégia, portanto, é utilizar a infraestrutura computacional somente quando houver necessidade de trabalhar com o banco.

Por isso, o arquivo `.bak` armazenado no Blob Storage é importante como cópia de segurança e como mecanismo de recuperação.


## Estrutura do projeto

```text
project_adventureworksDW2022/
│
├── .vscode/
│
├── restore_database/
│   │
│   ├── __pycache__/
│   ├── 1.restore_bak.py
│   ├── 2.queries.py
│   ├── a.restore_status.py
│   └── connection.py
│
├── .env
├── environment.yml
└── README.md
```

### `restore_database/1.restore_bak.py`

Responsável pelo processo de restauração do backup AdventureWorksDW2022 na SQL Managed Instance.

### `restore_database/2.queries.py`

Utilizado para executar consultas SQL no banco restaurado e validar o acesso aos dados.

### `restore_database/a.restore_status.py`

Responsável por acompanhar o status do processo de restauração e verificar o andamento da operação.

### `restore_database/connection.py`

Centraliza a criação da conexão com a SQL Managed Instance utilizando autenticação Microsoft Entra ID.

> Após a restauração, o banco permanece disponível dentro da Managed Instance enquanto a instância estiver ativa.

## Possível evolução da arquitetura

Uma evolução possível deste projeto seria migrar o banco ou seus dados para outro serviço de dados da Azure.

A Azure disponibiliza recursos para cenários de migração de bancos SQL Server para serviços como Azure SQL Database e Azure SQL Managed Instance, incluindo ferramentas e serviços voltados à avaliação, migração e modernização de ambientes SQL Server.

Essa alternativa pode ser interessante caso o objetivo futuro seja manter os dados disponíveis para consultas sem depender diretamente da SQL Managed Instance atual.


## Estratégia adotada:

Para manter o projeto simples e econômico, a estratégia atual é:

1. Manter o backup do AdventureWorksDW2022 no Azure Blob Storage.
2. Utilizar a SQL Managed Instance para restaurar e executar o banco quando necessário.
3. Manter a Managed Instance desativada quando o ambiente não estiver sendo utilizado, considerando os recursos de parada/inicialização disponíveis.
4. Ativar a instância somente durante os períodos de estudo, desenvolvimento, consultas ou integração.
5. Desativar novamente a infraestrutura após a utilização.
6. Manter o backup no Blob Storage para recuperação ou uma nova restauração quando necessário.

Essa estratégia evita manter uma infraestrutura de banco de dados ativa continuamente quando ela não está sendo utilizada.

A segunda página do projeto apresenta a evolução da solução e as decisões tomadas ao longo do processo de migração. Embora existam diversos recursos disponíveis no Portal do Azure capazes de automatizar parte ou toda a migração, como BACPAC, Azure Data Factory, replicação e outras ferramentas nativas, a decisão de desenvolver uma abordagem mais hardcoded e programática foi intencional.

O objetivo foi compreender e controlar cada etapa do processo, desde a conexão com a infraestrutura local e em nuvem até a extração dos metadados, análise das tabelas, geração do plano de migração, criação dos schemas e carregamento dos dados.

Durante o desenvolvimento, foram utilizados conhecimentos em SQL e T-SQL, incluindo consultas para exploração e inventário do banco de dados, identificação de tabelas, colunas, tipos de dados, chaves primárias, chaves estrangeiras, índices e demais metadados necessários para a reconstrução da estrutura no ambiente de destino. Também foram trabalhados conceitos relacionados a PL/SQL e linguagens procedurais SQL, permitindo uma compreensão mais ampla sobre lógica executada próxima ao banco de dados, procedimentos, funções e automação de operações.

O projeto também permitiu aplicar e aprofundar conceitos fundamentais da linguagem Python, como criação de funções, modularização do código, reutilização de componentes, leitura e escrita de arquivos JSON, tratamento de estruturas de dados e construção de scripts independentes para cada etapa da migração.

Essa escolha tornou possível mensurar e compreender, de forma prática, aspectos relacionados à infraestrutura local e em nuvem, custos computacionais e operacionais, conectividade, autenticação, segurança, gerenciamento de permissões e comunicação entre serviços Azure.

Assim, mais do que apenas realizar uma migração utilizando ferramentas prontas, o projeto foi desenvolvido como uma oportunidade de estudar detalhadamente o que acontece por trás do processo de migração, utilizando queries, T-SQL, conceitos de PL/SQL, Python, módulos, bibliotecas, funções e automação, construindo uma solução capaz de analisar, transformar, adaptar e migrar estruturas e dados entre diferentes ambientes.

[Migração para Azure Database SQL](https://github.com/userdanixdev/azure-adventureworks/tree/migration-azure-database)

## Considerações

Este projeto tem caráter educacional e experimental, sendo utilizado para estudar a utilização de SQL Server na Azure, automação com Python, autenticação Microsoft Entra ID, armazenamento de backups e estratégias de otimização de infraestrutura.

A arquitetura também serve como base para estudos futuros envolvendo Power BI, processos de ETL/ELT, modelagem dimensional, análise de dados e migração de workloads SQL Server para serviços gerenciados da Azure.

O ponto central do projeto é demonstrar que **armazenar o backup e manter o ambiente computacional separado permite controlar quando a infraestrutura SQL precisa estar ativa**, reduzindo a utilização desnecessária de recursos durante períodos sem uso.


## 👨‍💻 Autoria:

**👤 Autor:** `Daniel Martins França` 

**🔗 GitHub:** [Siga-me no GitHub!](https://github.com/userdanixdev) 

**🔗 LinkedIn:** [Acesse a página!](https://www.linkedin.com/in/danixdev)
