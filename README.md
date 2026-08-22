# Data Visualization

Esta etapa representa a fase de **visualização e análise dos dados** do projeto de modernização e migração para o Microsoft Azure.

Após as etapas de restauração do banco de dados, preparação da infraestrutura e desenvolvimento do processo de migração, os dados disponibilizados no ambiente de destino serão utilizados como fonte para a construção de um projeto de **Business Intelligence com Power BI**.

## Objetivo

O objetivo desta etapa é transformar os dados armazenados no **Azure SQL Database** em informações visuais e indicadores que permitam analisar diferentes perspectivas do negócio.

O desenvolvimento no Power BI incluirá atividades como:

* Conexão com o Azure SQL Database;
* Extração e preparação dos dados;
* Transformações utilizando Power Query;
* Modelagem de dados e definição de relacionamentos;
* Criação de tabelas de dimensão e fatos;
* Desenvolvimento de medidas utilizando DAX;
* Criação de indicadores e métricas;
* Desenvolvimento de dashboards e relatórios interativos;
* Análise dos dados do dataset AdventureWorksDW2022.

## Arquitetura

```text
AdventureWorksDW2022
        │
        ▼
Azure SQL Managed Instance
        │
        ▼
Processo de Migration
        │
        ▼
Azure SQL Database
        │
        ▼
Power BI
        │
        ├── Power Query
        ├── Modelagem de Dados
        ├── DAX
        └── Visualizações
                │
                ▼
         Dashboard Analítico
```

## Tecnologias

* Microsoft Power BI
* Power Query
* Linguagem M
* DAX
* Azure SQL Database
* SQL
* T-SQL

*Nesta branch serão desenvolvidas as etapas relacionadas à preparação, modelagem e visualização dos dados. O objetivo é concluir o projeto com uma solução analítica capaz de demonstrar todo o fluxo de dados, desde a infraestrutura e migração para a nuvem até a apresentação das informações por meio de dashboards interativos.*

---

Esta etapa complementa o projeto de ponta a ponta, conectando as fases de **infraestrutura, restauração, migração, banco de dados e análise de dados** em uma única solução.

**Status:** 🚧 Em desenvolvimento
