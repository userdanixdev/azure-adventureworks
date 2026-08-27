# 📊 Dashboard Financeiro e Análise de Vendas

## 📌 Visão Geral

A etapa final do projeto consiste no desenvolvimento de um **dashboard analítico no Power BI**, utilizando os dados tratados e disponibilizados após o processo de migração e transformação da base **AdventureWorksDW2022**.

O objetivo é transformar os dados em **informações estratégicas para análise financeira, comercial e operacional**, permitindo acompanhar indicadores-chave, identificar tendências, analisar a rentabilidade e explorar o desempenho por produtos, categorias, clientes e regiões.

O dashboard foi estruturado em **cinco páginas analíticas**, cada uma com um objetivo específico.

---

# 🗂️ Estrutura do Dashboard

Boas práticas foram aplicadas em todas as etapas de construção do dashboard, incluindo a preparação e organização dos dados no Power Query, a modelagem dimensional seguindo o esquema estrela, a criação de métricas em DAX e a implementação de recursos de interatividade. A estrutura do projeto também foi organizada para facilitar a manutenção, reutilização e escalabilidade da solução.

## 1. Organização no Power Query

Os processos de transformação foram organizados em pastas, separando tabelas de dimensão e fato. Foram criados parâmetros para centralizar as informações de conexão, como caminho do servidor e nome do banco de dados. Essa abordagem evita valores fixos nas consultas e facilita futuras alterações no ambiente de dados. Também foram utilizados os parâmetros RangeStart e RangeEnd, seguindo as boas práticas para definição de períodos e preparação do modelo para recursos como atualização incremental no Power BI.

![](../images/boas_praticas_power_query.png)

## 2. Modelagem Dimensional

O modelo de dados foi estruturado seguindo o esquema estrela, separando a tabela fato das tabelas dimensão e estabelecendo relacionamentos adequados entre elas. Essa abordagem contribui para uma modelagem mais organizada, melhor desempenho e maior facilidade na criação de análises e métricas.

![](../images/schema_star.png)

## 3. Interatividade e Experiência do Usuário

Foram implementados recursos de interatividade para permitir a exploração dos dados de forma dinâmica, utilizando filtros, segmentações e interações entre os visuais. Dessa forma, o usuário pode analisar os indicadores sob diferentes perspectivas e períodos.

## 1️⃣ Visão Geral Financeira

Fornecer uma visão rápida e consolidada dos principais indicadores financeiros do negócio.

Esta página funciona como o ponto de entrada do dashboard, permitindo que o usuário tenha uma compreensão imediata da situação financeira e da evolução dos principais resultados.

### 📈 Principais Métricas

* Receita Total:

```m
Receita = SUM(marts_f_vendas[receita])
```
* Custo Total:

```m
Custo = SUM(marts_f_vendas[custo_produto])
```

* Lucro Total:

```m
Lucro = SUM(marts_f_vendas[lucro_apos_frete_imposto])
```
* Lucro Bruto Total:

```m
Lucro Bruto = SUM(marts_f_vendas[lucro_bruto])
```

* Margem de Lucro Bruta:

```m
Margem Bruta = DIVIDE([Lucro Bruto],[Receita])
```

* Margem de Lucro Líquida:
```m
Margem = DIVIDE([Lucro],[Receita])
```

* Número de Pedidos ou Transações:
```m
Transações = DISTINCTCOUNT(marts_f_vendas[venda_id])
```


### 📊 Visuais

* **Cards** para apresentação dos principais KPIs.
* **Gráfico de Linha** para acompanhar a evolução temporal da receita.
* **Indicadores de variação** para demonstrar crescimento ou redução em relação ao período anterior.

### 🔎 Insights:

* Evolução da receita ao longo do tempo.
* Crescimento ou redução dos resultados.
* Relação entre receita, custos e lucro.
* Identificação rápida de períodos com melhor ou pior desempenho.

---

## 2️⃣ Análise de Vendas

Analisar a performance comercial ao longo do tempo, identificando tendências, períodos de crescimento ou queda e comparando os resultados realizados com as metas estabelecidas.

### 📈 Principais Métricas

* Receita Total por período
* Receita Realizada
* Meta de Vendas
* Variação entre Meta e Realizado
* Crescimento ou Declínio das Vendas

### 📊 Visuais

* **Gráfico de Linha ou Área** para acompanhar a evolução das vendas.
* Comparação entre **Meta vs. Realizado** ao longo dos períodos.
* Indicadores de crescimento percentual.

## 3️⃣ Resultados Financeiros

Apresentar uma análise detalhada da rentabilidade do negócio, destacando a composição dos custos e sua relação com a receita e o lucro.

### 📈 Principais Métricas

* Lucro Total
* Margem de Lucro
* Receita Total
* Custo Total
* Lucro Operacional
* Distribuição dos Custos

### 📊 Visuais

* **Gráfico de Barras Empilhadas** para demonstrar a relação entre receita, custos e lucro ao longo do tempo.
* **Gráfico de Rosca** para visualizar a participação das categorias ou produtos nos resultados.
* **Matriz ou Tabela** para detalhamento financeiro por categoria ou produto.

### 🔎 Insights:

* Categorias com maior participação no lucro.
* Produtos ou segmentos com maior custo operacional.
* Impacto dos custos sobre a rentabilidade.
* Comparação entre receita gerada e resultado efetivamente obtido.

---

## 4️⃣ Análise por Produto e Categoria

Explorar o desempenho financeiro por **produto, subcategoria e categoria**, permitindo identificar os segmentos mais relevantes e rentáveis para o negócio.

### 📈 Principais Métricas

* Receita por Produto
* Custo por Produto
* Lucro por Produto
* Margem de Lucro
* Receita por Categoria
* Receita por Subcategoria
* Meta vs. Realizado

### 📊 Visuais

* **Gráfico de Colunas Agrupadas** para comparação entre receita e lucro.
* **Treemap ou Gráfico de Barras** para identificar produtos e categorias com maior participação.
* **Matriz Interativa** com capacidade de **drill-down** entre:

```text
Categoria
   ↓
Subcategoria
   ↓
Produto
```

### 🔎 Insights:

* Produtos mais rentáveis.
* Categorias com maior volume de vendas.
* Subcategorias com melhor desempenho financeiro.
* Produtos com alta receita, mas baixa margem.
* Comparação entre metas e resultados realizados.

---

## 5️⃣ Análise de Clientes e Regiões

Analisar o desempenho financeiro segmentado por clientes e regiões, identificando padrões de consumo, oportunidades de mercado e regiões estratégicas para o negócio.

### 📈 Principais Métricas

* Receita por Cliente
* Lucro por Cliente
* Receita por Região
* Lucro por Região
* Ticket Médio
* Número de Pedidos

### 📊 Visuais

* **Mapa** para visualização geográfica das vendas utilizando informações de território ou região.
* **Gráfico de Colunas ou Barras** para comparação entre regiões.
* **Tabela ou Matriz Detalhada** para análise dos principais clientes.

### 🔎 Insights:

* Regiões com maior geração de receita.
* Clientes com maior participação no faturamento.
* Clientes mais rentáveis.
* Distribuição geográfica das vendas.
* Identificação de oportunidades de expansão.

---

# 🔗 Navegação e Interatividade

O dashboard será estruturado para proporcionar uma experiência analítica e interativa.

Entre os principais recursos utilizados estão:

* Segmentadores de período.
* Filtros por categoria e subcategoria.
* Filtros por produto.
* Filtros por região.
* Navegação entre páginas.
* Comparação dinâmica entre períodos.

# 🏗️ Fluxo Analítico do Projeto

---

# 🚀 Resultado:

Ao final do projeto, o dashboard deverá fornecer uma visão completa do desempenho financeiro e comercial da base **AdventureWorksDW2022**, permitindo análises desde uma visão executiva de alto nível até o detalhamento por produto, categoria, cliente e região.

A solução demonstra, na prática, o fluxo completo de um projeto de dados:

> **Migração → Transformação → Modelagem → Análise → Visualização → Geração de Insights**

Com isso, o projeto consolida conhecimentos em:

* ☁️ Azure SQL
* 🗄️ SQL Server
* 🔄 ETL e Transformação de Dados
* 🧹 Power Query
* 📊 Modelagem Dimensional
* 🧮 DAX
* 📈 Power BI
* 🧑‍💻 Git e GitHub
* 📚 Documentação Técnica

---

Link Github Pages: Documentação DBT
Link Dashboard
Link repositorio Minhan pagina
Link Inicial do projeto
Link linkedin

