{% docs __overview__ %}

# 📊 AdventureWorksDW2022 — Pipeline Analítico com Migração + dbt + Azure SQL + Analytics

Este projeto implementa uma camada de transformação e modelagem analítica
sobre o banco **AdventureWorksDW2022**, utilizando **dbt** e **Azure SQL Server**.

O objetivo é transformar os dados relacionais de origem em uma estrutura
analítica organizada, documentada, testada e preparada para consumo por
ferramentas de Business Intelligence, como o Power BI.

## 🎯 Objetivo

Construir um pipeline analítico seguindo boas práticas de Engenharia de Dados,
separando as responsabilidades em diferentes camadas de transformação.

O projeto permite:

- transformação e padronização dos dados de origem
- criação de modelos de staging
- construção de dimensões e fatos
- aplicação de testes de qualidade
- documentação das fontes e modelos
- rastreabilidade das transformações
- disponibilização dos dados para análises e BI

## 🏗️ Arquitetura do Projeto

O pipeline está organizado nas seguintes camadas:

### 🟠 Source — Dados de Origem

Os dados são provenientes do banco **AdventureWorksDW2022** hospedado
no Azure SQL Server.

As tabelas originais são declaradas no dbt por meio de `sources`,
permitindo rastreabilidade entre os dados de origem e os modelos
transformados.

### 🔵 Staging

A camada de staging representa a primeira etapa de transformação.

Nesta camada são realizadas operações como:

- seleção das colunas necessárias
- padronização dos nomes
- renomeação de campos
- organização dos tipos de dados
- preparação das entidades para as camadas analíticas

Os modelos seguem o padrão:

`stg_<entidade>`

Exemplos:

- `stg_dim_customer`
- `stg_dim_product`
- `stg_dim_geography`
- `stg_dim_product_category`

### 🟣 Marts

A camada de marts contém os modelos destinados ao consumo analítico.

Nesta camada são construídas as dimensões e fatos utilizados pelas análises
de negócio.

Exemplos:

- `marts_d_clientes`
- `marts_d_produtos`
- `marts_f_vendas`

Os modelos são estruturados para facilitar o consumo por ferramentas de BI e consultas analíticas.

## 🧩 Modelagem Dimensional

A modelagem segue princípios de **Data Warehouse** e **Star Schema**.

### Dimensões

As dimensões armazenam atributos descritivos utilizados para análise,
segmentação e filtragem.

Principais dimensões:

- Cliente
- Produto

### Fatos

As tabelas fato armazenam eventos e métricas utilizadas nas análises.

A principal tabela fato utilizada no projeto é:

- Internet Sales ( Vendas )

Ela permite análises relacionadas a vendas, produtos, clientes,
territórios e demais dimensões relacionadas.

## 🧪 Qualidade dos Dados

O projeto utiliza testes nativos do dbt para validar a qualidade e integridade dos dados.

Entre os testes utilizados estão:

- `unique`
- `not_null`
- `relationships`
- `accepted_values`

Esses testes ajudam a identificar problemas de integridade referencial, duplicidade e valores inválidos antes que os dados sejam disponibilizados para consumo analítico.

## 📚 Documentação

Os modelos, colunas, fontes e regras de qualidade são documentados diretamente no projeto dbt.

A documentação permite visualizar:

- descrição das tabelas
- descrição das colunas
- fontes de dados
- testes aplicados
- relacionamentos
- dependências entre modelos
- DAG do pipeline

## 🗂️ Organização dos Schemas

O projeto utiliza schemas distintos para separar as responsabilidades das diferentes camadas:

`staging`

Modelos intermediários responsáveis pela preparação e padronização dos dados de origem.

`marts`

Modelos analíticos finais destinados ao consumo por ferramentas de BI.

> Essa separação facilita a organização, manutenção e governança do ambiente de dados.

## 🛠️ Tecnologias Utilizadas

- dbt
- SQL
- Python
- Azure SQL Server
- Git
- GitHub
- Power BI

## 🔄 Fluxo do Pipeline

O fluxo geral do projeto pode ser representado como:

**Azure SQL Database**
↓
**Sources**
↓
**Staging**
↓
**Marts**
↓
**Power BI / Business Intelligence**

## 📈 Consumo Analítico

Os modelos finais são preparados para utilização em ferramentas de Business Intelligence.

O Power BI pode consumir as dimensões e fatos produzidos pelo dbt, permitindo a construção de dashboards e análises sobre vendas, clientes, produtos e geografia.

## 🚀 Benefícios

- Separação clara entre origem, transformação e consumo
- Padronização dos modelos
- Testes automatizados de qualidade
- Rastreabilidade dos dados
- Documentação centralizada
- Modelagem dimensional
- Estrutura preparada para BI
- Versionamento do código com Git
- Maior facilidade de manutenção e evolução



{% enddocs %}