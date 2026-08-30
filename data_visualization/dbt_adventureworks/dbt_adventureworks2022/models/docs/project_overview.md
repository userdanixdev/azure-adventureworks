{% docs __overview__ %}

# 📊 AdventureWorksDW2022 - Pipeline Analítico com Azure, dbt e Power BI

Este projeto apresenta a construção de um **pipeline analítico completo**, partindo da restauração e migração de um banco de dados SQL Server até a transformação, modelagem e análise dos dados.

O projeto utiliza **Azure SQL**, **dbt** e **Power BI** para estruturar os dados relacionais em uma camada analítica organizada, documentada e testada, preparada para consumo por ferramentas de Business Intelligence.

## Etapas do projeto

O desenvolvimento foi dividido em quatro etapas principais:

### 1. 🔄 Restauração
Restauração do banco de dados legado **AdventureWorksDW2022** em uma infraestrutura gerenciada na Azure SQL Server.

➡️ **[Acessar documentação da Restauração](https://github.com/userdanixdev/azure-adventureworks)**

### 2. ☁️ Migração
Planejamento e execução da migração para um recurso Azure mais adequado ao projeto, considerando **recursos disponíveis, escalabilidade e custo-benefício**.

➡️ **[Acessar documentação da Migração](https://github.com/userdanixdev/azure-adventureworks/tree/migration-azure-database)**

### 3. ⚙️ Transformação
Utilização do **dbt** para transformação, organização e modelagem dos dados, incluindo documentação e testes dos modelos analíticos.

➡️ **[Acessar documentação do dbt](https://github.com/userdanixdev/azure-adventureworks/tree/data-visualization)**

### 4. 📈 Análise
Construção da camada analítica e disponibilização dos dados para análise e visualização utilizando **Power BI**.

---

**O pipeline está organizado nas seguintes camadas:**

### 🟠 Source - Dados de Origem

Os dados são provenientes do banco **AdventureWorksDW2022** hospedado
no Azure SQL Database.

As tabelas originais são declaradas no dbt por meio de **sources**,
permitindo rastreabilidade entre os dados de origem e os modelos
transformados.

### 🔵 Staging - Intermediária

A camada de staging representa a primeira etapa de transformação.

Nesta camada são realizadas operações de:

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

*Os modelos são estruturados para facilitar o consumo por ferramentas de BI e consultas analíticas.*

## 🧩 Modelagem Dimensional

A modelagem segue princípios de **Data Warehouse** e **Star Schema**.

### Dimensões

As dimensões armazenam atributos descritivos utilizados para análise, segmentação e filtragem.

As principais dimensões são:

- Cliente
- Produto

### Fatos

As tabelas fato armazenam eventos e métricas utilizadas nas análises.

A principal tabela fato utilizada no projeto é:

- Internet Sales ( Vendas )

*Ela permite análises relacionadas a vendas, produtos, clientes, territórios e demais dimensões relacionadas.Essa separação facilita a organização, manutenção e governança do ambiente de dados.*

## 🧪 Qualidade dos Dados

O projeto utiliza testes nativos do dbt para validar a qualidade e integridade dos dados.

Entre os testes utilizados estão:

- `unique`
- `not_null`
- `relationships`
- `accepted_values`

*Esses testes ajudam a identificar problemas de integridade referencial, duplicidade e valores inválidos antes que os dados sejam disponibilizados para consumo analítico.*

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

## 🛠️ Tecnologias Utilizadas

- dbt
- SQL
- Azure SQL Database
- Git
- GitHub
- Power BI

## 📈 Consumo Analítico

Os modelos finais são preparados para utilização em ferramentas de Business Intelligence.

O Power BI pode consumir as dimensões e fatos produzidos pelo dbt, permitindo a construção de dashboards e análises sobre vendas, clientes, produtos e geografia.

---

➡️ **[Acesso as análises do Power BI](https://userdanixdev.github.io/adventureworks-analytics/)**

➡️ **[Acesso ao relatório](https://app.powerbi.com/view?r=eyJrIjoiZmFiMWE4YWItNmM5Yi00ZDE3LWEzYWUtYzlmYmJlYjAwZGNiIiwidCI6ImVkNTJhZDViLTU0YzktNDNlZi04YmNhLThlOWY4Y2U0Zjc1ZiJ9)**

---



{% enddocs %}