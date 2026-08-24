![Microsoft Azure](https://img.shields.io/badge/Microsoft%20Azure-0089D6?style=flat-square&logo=microsoftazure&logoColor=white)
![Azure SQL Database](https://img.shields.io/badge/Azure%20SQL%20Database-0078D4?style=flat-square&logo=microsoftazure&logoColor=white)
![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=flat-square&logo=database&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white)
![dbt Core](https://img.shields.io/badge/dbt%20Core-FF694B?style=flat-square&logo=dbt&logoColor=white)
![dbt-sqlserver](https://img.shields.io/badge/dbt--sqlserver-FF694B?style=flat-square&logo=dbt&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)

![Microsoft Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat-square&logo=powerbi&logoColor=black)
![Power Query](https://img.shields.io/badge/Power%20Query-F2C811?style=flat-square&logo=microsoft&logoColor=black)
![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-222222?style=flat-square&logo=githubpages&logoColor=white)

# Data Visualization:

Esta etapa representa a fase de transformação, modelagem, visualização e análise dos dados do projeto de modernização e migração do dataset AdventureWorksDW2022 para o Microsoft Azure.

Após as etapas de restauração do banco de dados, preparação da infraestrutura e desenvolvimento do processo de migração, os dados disponibilizados no ambiente de destino passam por uma camada de transformação e modelagem utilizando dbt (data build tool).

O projeto demonstra um fluxo completo de dados, desde a disponibilização do dataset no ambiente Microsoft Azure, passando pela transformação e documentação dos modelos com dbt, até o consumo final das informações por meio do Microsoft Power BI.

Os modelos analíticos resultantes são organizados em camadas de staging e marts, servindo como base para a próxima etapa do projeto: a construção de uma solução de Business Intelligence utilizando Microsoft Power BI.

### Objetivo:

O objetivo desta etapa é transformar os dados armazenados no Azure SQL Database em uma estrutura analítica preparada para consumo por ferramentas de Business Intelligence.

O projeto contempla:

* Transformação e padronização dos dados utilizando dbt;
* Organização dos modelos em camadas de staging e marts;
* Criação de modelos analíticos para consumo;
* Documentação automática dos modelos e colunas;
* Validação da qualidade e dos relacionamentos dos dados;
* Publicação da documentação utilizando dbt Docs e GitHub Pages;
* Transformações complementares utilizando Power Query;
* Modelagem de dados e definição de relacionamentos;
* Desenvolvimento de medidas utilizando DAX;
* Criação de indicadores, métricas e visualizações;
* Desenvolvimento de dashboards e relatórios interativos.

## Arquitetura:

![](/data_visualization/images/fluxo_completo_project_adventureworks.png)

## Transformação e Modelagem com dbt:

A camada de transformação foi desenvolvida utilizando dbt Core e o adaptador dbt-sqlserver.

Os dados são organizados em duas camadas principais:

### Staging:

A camada de staging é responsável pela preparação e padronização inicial dos dados provenientes do banco de dados de origem.

Entre as atividades realizadas estão:

- Padronização de nomes;
- Seleção das colunas necessárias;
- Organização dos dados para consumo;

### Marts:

A camada de marts contém os modelos analíticos preparados para consumo por ferramentas de Business Intelligence.

Esses modelos representam estruturas como:

- Tabelas de dimensão;
- Tabelas fato;
- Entidades relacionadas ao domínio de vendas e clientes;
- Modelos preparados para análise no Power BI.
- Documentação dos Modelos

Abaixo podemos conferir a linhagem de dados, desde os dados brutos, tratamento e transformação até as regras de negócios:

![](../project_adventureworksDW2022/data_visualization/images/data_lineage.png)

A documentação do projeto foi gerada automaticamente utilizando o dbt Docs.

A documentação permite explorar:

- Modelos do projeto;
- Colunas e descrições;
- Dependências entre modelos;
- **Data lineage;**
- Estrutura das camadas staging e marts.

### Tecnologias Utilizadas:

- Microsoft Azure
- Azure SQL Managed Instance
- Azure SQL Database
- SQL Server
- SQL
- T-SQL
- dbt Core
- dbt-sqlserver
- Python
- Microsoft Power BI
- Power Query
- GitHub Pages

🔗 A documentação se encontra logo abaixo:

➡️ [GITHUB PAGES - AdventureWorksDW2022](https://userdanixdev.github.io/azure-adventureworks/#!/overview)

Status geral: 🚧 Em desenvolvimento 

