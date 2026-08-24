## Data Visualization #2:

Esta pasta representa a etapa de preparação e organização dos dados para análise e visualização dentro do projeto AdventureWorksDW2022.

Aqui estão concentradas as primeiras consultas SQL desenvolvidas a partir das regras de negócio e dos requisitos analíticos do projeto. Essas consultas têm como objetivo transformar os dados disponíveis no ambiente de origem em estruturas mais adequadas para análise.

Conceitualmente, esta camada funciona de forma semelhante a uma camada de marts, disponibilizando dados organizados e preparados para consumo analítico.

O objetivo da pasta data_visualization é centralizar os artefatos relacionados à preparação dos dados para a camada de Business Intelligence.

Entre as atividades desenvolvidas nesta etapa estão:

- Consultas SQL baseadas em regras de negócio;
- Preparação dos dados para análise;
- Organização das primeiras estruturas analíticas;
- Desenvolvimento de consultas com foco em dimensões e fatos;
- Documentação visual da arquitetura e dos fluxos do projeto;
- Desenvolvimento e documentação dos modelos utilizando dbt.

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
