## Data Visualization #2:

A pasta **data_visualization/** representa a etapa de preparação e organização dos dados para análise e visualização dentro do projeto AdventureWorksDW2022.

Aqui estão concentradas as primeiras consultas SQL desenvolvidas a partir das regras de negócio e dos requisitos analíticos do projeto. Essas consultas têm como objetivo transformar os dados disponíveis no ambiente de origem em estruturas mais adequadas para análise.

Conceitualmente, esta camada funciona de forma semelhante à uma camada de marts, disponibilizando dados organizados e preparados para consumo analítico.

O objetivo da pasta **data_visualization** é centralizar os artefatos relacionados à preparação dos dados para a camada de Business Intelligence.

Entre as atividades desenvolvidas nesta etapa estão:

- Consultas SQL baseadas em regras de negócio;
- Preparação dos dados para análise;
- Organização das primeiras estruturas analíticas;
- Desenvolvimento de consultas com foco em dimensões e fatos;
- Documentação visual da arquitetura e dos fluxos do projeto;
- Desenvolvimento e documentação dos modelos utilizando dbt.

![](/data_visualization/images/fluxo_data_visualization.png)


### Estrutura da Pasta:

```
data_visualization/
│
├── README.md
│
├── images/
│     └── ...
│
└── dbt_adventureworks2022/
    ├── models/
    │   ├── staging/
    │   └── marts/
    │
    ├── macros/
    ├── tests/
    ├── dbt_project.yml
    └── ...
```    


🔗 A preparação se encontra logo abaixo:

- ➡️ [GitHub Pages - AdventureWorksDW2022](https://userdanixdev.github.io/azure-adventureworks/#!/overview)

Caso queira acessar para a página principal é só clicar aqui abaixo:
- ➡️ [README.md - Principal - Data Visualization #1](/README.md)

Caso queira acessar as boas práticas, insights e perguntas de negócios aplicadas:
- ➡️ [README.md - Power BI](/data_visualization/powerbi/README.md)
- ➡️ [Relatório Power BI](https://app.powerbi.com/view?r=eyJrIjoiZmFiMWE4YWItNmM5Yi00ZDE3LWEzYWUtYzlmYmJlYjAwZGNiIiwidCI6ImVkNTJhZDViLTU0YzktNDNlZi04YmNhLThlOWY4Y2U0Zjc1ZiJ9)
