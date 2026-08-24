




# Tabela: `FactInternetSales`

## Descrição
Esta tabela representa um **registro de transações de vendas** detalhado, contendo informações sobre pedidos, produtos, clientes e métricas financeiras. É estruturada tipicamente como uma tabela de fatos em um data warehouse.

## Colunas

### Identificadores e Chaves
*   **ProductKey**: Código identificador único do produto.
*   **OrderDateKey / DueDateKey / ShipDateKey**: Datas (pedido, vencimento, envio) em formato numérico.
*   **CustomerKey**: Código identificador único do cliente.
*   **PromotionKey**: Código da promoção aplicada, se houver.
*   **CurrencyKey**: Código da moeda da transação.
*   **SalesTerritoryKey**: Código da região/território de vendas.

### Detalhes do Pedido
*   **SalesOrderNumber**: Número identificador do pedido de venda.
*   **SalesOrderLineNumber**: Número da linha do item no pedido.
*   **RevisionNumber**: Número de revisão do pedido.
*   **OrderQuantity**: Quantidade de itens vendidos.

### Valores Financeiros e Custos
*   **UnitPrice**: Preço unitário do produto.
*   **ExtendedAmount**: Valor total estendido (Preço × Quantidade).
*   **UnitPriceDiscountPct**: Percentual de desconto aplicado.
*   **DiscountAmount**: Valor monetário do desconto.
*   **ProductStandardCost**: Custo padrão unitário do produto.
*   **TotalProductCost**: Custo total do produto no pedido.
*   **SalesAmount**: Valor líquido final da venda.
*   **TaxAmt**: Valor do imposto.
*   **Freight**: Custo de frete.

### Rastreamento e Datas (Formatadas)
*   **CarrierTrackingNumber**: Número de rastreamento da transportadora.
*   **CustomerPONumber**: Número do pedido de compra do cliente.
*   **OrderDate / DueDate / ShipDate**: Datas do pedido, vencimento e envio (formato legível).
"""

# Descrição da Tabela: DimClientes (Cadastro de Clientes) 

Esta tabela contém um cadastro detalhado e completo de clientes, sendo ideal para segmentação de marketing, análise de perfil de renda e estudos de comportamento de compra.

## Identificação e Contato
*   **CustomerKey / CustomerAlternateKey**: Identificadores únicos do cliente (interno e alternativo).
*   **Title / FirstName / MiddleName / LastName**: Título, nome, nome do meio e sobrenome.
*   **EmailAddress**: Endereço de e-mail.
*   **Phone**: Número de telefone.
*   **AddressLine1 / AddressLine2**: Endereço residencial (rua/número).

## Dados Demográficos e Pessoais
*   **BirthDate**: Data de nascimento.
*   **MaritalStatus**: Estado civil (M = Casado, S = Solteiro).
*   **Gender**: Gênero (M = Masculino, F = Feminino).
*   **TotalChildren**: Número total de filhos.
*   **NumberChildrenAtHome**: Número de filhos que moram na residência.

## Perfil Socioeconômico e Educação
*   **YearlyIncome**: Renda anual do cliente.
*   **EnglishEducation / SpanishEducation / FrenchEducation**: Nível de escolaridade em diferentes idiomas.
*   **EnglishOccupation / SpanishOccupation / FrenchOccupation**: Ocupação profissional em diferentes idiomas.

## Estilo de Vida e Comportamento
*   **HouseOwnerFlag**: Indicador se o cliente é proprietário da casa (1 = Sim, 0 = Não).
*   **NumberCarsOwned**: Quantidade de carros que o cliente possui.
*   **CommuteDistance**: Distância percorrida no trajeto diário de ida ao trabalho.
*   **DateFirstPurchase**: Data da primeira compra realizada pelo cliente.

## Outros
*   **GeographyKey**: Chave de referência para dados geográficos.
*   **NameStyle / Suffix**: Detalhes de formatação do nome e sufixos.
"""

# Descrição da Tabela: DimDate (Dimensão de Tempo / Calendário)

Esta tabela representa uma **Dimensão de Tempo (Calendário)** típica de um Data Warehouse, servindo para expandir análises temporais e cruzar dados de vendas com dias da semana, meses, trimestres, anos e períodos fiscais.

## Identificação e Data
*   **DateKey**: Código numérico identificador da data (ex: `20050101`).
*   **FullDateAlternateKey**: Data completa no formato padrão `AAAA-MM-DD` (ex: `2005-01-01`).

## Dias da Semana e Mês
*   **DayNumberOfWeek**: Número do dia da semana (ex: 1 a 7).
*   **EnglishDayNameOfWeek / SpanishDayNameOfWeek / FrenchDayNameOfWeek**: Nome do dia da semana em inglês, espanhol e francês.
*   **DayNumberOfMonth**: Número do dia dentro do mês (1 a 31).
*   **DayNumberOfYear**: Número do dia dentro do ano (1 a 366).
*   **WeekNumberOfYear**: Número da semana do ano.

## Meses
*   **EnglishMonthName / SpanishMonthName / FrenchMonthName**: Nome do mês nos respectivos idiomas.
*   **MonthNumberOfYear**: Número do mês no ano (1 a 12).

## Períodos Calendário e Fiscais
*   **CalendarQuarter**: Trimestre do calendário (1 a 4).
*   **CalendarYear**: Ano do calendário (ex: `2005`).
*   **CalendarSemester**: Semestre do calendário (1 ou 2).
*   **FiscalQuarter**: Trimestre fiscal da empresa (1 a 4).
*   **FiscalYear**: Ano fiscal da empresa.
*   **FiscalSemester**: Semestre fiscal da empresa.
"""


# Descrição da Tabela: Dimensão de Produtos 

Esta tabela representa a **Dimensão de Produtos** (equivalente a `DimProduct` em Data Warehouses), contendo especificações detalhadas do catálogo de itens da empresa.

## Identificação e Hierarquia do Produto
*   **ProductKey**: Código identificador interno e único do produto.
*   **ProductAlternateKey**: Código alternativo ou SKU do produto.
*   **ProductSubcategoryKey**: Chave estrangeira que indica a subcategoria do produto.
*   **ModelName**: Nome do modelo do produto.
*   **ProductLine**: Linha de produto (ex: M para Mountain, R para Road).

## Nomes e Descrições Multilíngues
*   **EnglishProductName / SpanishProductName / FrenchProductName**: Nome comercial do produto em inglês, espanhol e francês.
*   **EnglishDescription / FrenchDescription / ChineseDescription / ArabicDescription / HebrewDescription / ThaiDescription / GermanDescription / JapaneseDescription / TurkishDescription**: Descrições detalhadas traduzidas para vários idiomas.

## Especificações Físicas e Medidas
*   **Weight**: Peso do produto.
*   **WeightUnitMeasureCode**: Unidade de medida do peso.
*   **Size**: Tamanho do produto.
*   **SizeRange**: Faixa de tamanho.
*   **SizeUnitMeasureCode**: Unidade de medida do tamanho.
*   **Color**: Cor do produto.
*   **LargePhoto**: Representação visual/imagem do produto.

## Custos, Preços e Estoque
*   **StandardCost**: Custo padrão de fabricação ou aquisição.
*   **ListPrice**: Preço de tabela sugerido para venda.
*   **DealerPrice**: Preço negociado ou de revendedor.
*   **SafetyStockLevel**: Nível de estoque de segurança.
*   **ReorderPoint**: Ponto de pedido para reabastecimento.

## Fabricação e Logística
*   **DaysToManufacture**: Número de dias necessários para fabricar o produto.
*   **FinishedGoodsFlag**: Indicador se é um produto acabado pronto para venda (Verdadeiro/Falso).

## Classificação e Vigência
*   **Class**: Classe ou categoria de qualidade/mercado.
*   **Style**: Estilo do produto.
*   **StartDate**: Data de início da vigência do produto no catálogo.
*   **EndDate**: Data de encerramento da comercialização.
*   **Status**: Status atual do produto (ex: *Current*).
"""

###  Dimensão Produtos SQL:
```SQL
SELECT 
    p.ProductKey AS ProductID,
    p.EnglishProductName AS Produto,
    sc.EnglishSubCategoryName AS SubCategoria,
    pc.EnglishProductCategoryName AS Categoria
FROM DimProduct AS p
INNER JOIN DimProductSubcategory AS sc
    ON p.ProductSubcategoryKey = sc.ProductSubcategoryKey
INNER JOIN DimProductCategory AS pc
    ON sc.ProductCategoryKey = pc.ProductCategoryKey   
```

O resultado é uma tabela preparada para responder perguntas como:

- Quais são os produtos mais vendidos?
- Qual categoria gera mais vendas?
- Quais produtos pertencem a cada categoria?
- Qual subcategoria possui maior volume de vendas?
- Quais produtos apresentam melhor desempenho?
- Qual categoria possui a maior variedade de produtos?
- Como as vendas estão distribuídas entre categorias e subcategorias?
- Quais produtos contribuem mais para o faturamento?
- Qual categoria ou subcategoria deve receber maior atenção comercial?

> Além disso, essa dimensão pode ser relacionada à tabela fato de vendas através do ProductID, permitindo analisar métricas como quantidade vendida, faturamento, custo e desempenho dos produtos.


### Query Fact_vendas:

```SQL
SELECT 
    fis.SalesOrderNumber AS SalesID,
    d.DateKey AS DateID,
    p.ProductKey AS ProductID,
    c.CustomerKey AS CustomerID,
    fis.SalesAmount AS Receita,
    (fis.Freight + fis.TaxAmt) AS Custo,
    (fis.SalesAmount - (fis.Freight + fis.TaxAmt)) AS Lucro,
    fis.OrderQuantity Quantidade
FROM FactInternetSales AS fis
INNER JOIN DimDate AS d
    ON fis.OrderDatekey = d.DateKey
INNER JOIN DimProduct AS p
    ON fis.ProductKey = p.ProductKey
INNER JOIN DimCustomer AS c
    ON fis.CustomerKey = c.CustomerKey
WHERE
    d.CalendarYear IN (2013,2014)        
```

### O resultado é uma tabela preparada para responder perguntas como:

- Qual foi a receita em 2013 e 2014?
- Qual produto vendeu mais?
- Qual cliente gerou mais receita?
- Qual foi o resultado financeiro por período?
- Quantos produtos foram vendidos?
- Como a receita e o lucro evoluíram ao longo do tempo?

### Dimensão Clientes:

- A tabela DimCustomer contém os dados cadastrais e demográficos dos clientes.

```SQL
SELECT
    cus.CustomerKey AS CustomerID,
    Concat(cus.FirstName,' ',cus.LastName) AS Nome,
    case when cus.MaritalStatus = 'M' then 'Married'
         when cus.MaritalStatus = 'S' then 'Single'
    end as EstadoCivil,
    case when cus.Gender = 'M' then 'Male'
         when cus.Gender = 'F' then 'Female'
    end as Genero,
    geo.StateProvinceName AS Estado,
    geo.EnglishCountryRegionName AS PaisRegiao
FROM DimCustomer cus
INNER JOIN DimGeography geo
    ON cus.GeographyKey = geo.GeographyKey       
```
**O resultado é uma tabela preparada para responder perguntas como:**

- Qual é a quantidade de clientes por estado?
- Em quais países ou regiões estão concentrados os clientes?
- Qual é a distribuição de clientes por gênero?
- Quantos clientes são casados ou solteiros?
- Qual estado possui a maior quantidade de clientes?
- Qual é o perfil demográfico dos clientes por localização?
- Existe diferença na concentração de clientes entre homens e mulheres em cada estado?
- Como os clientes estão distribuídos geograficamente para análises comerciais e de vendas?

*Essas informações podem ser utilizadas no Power BI para criar segmentações, gráficos de distribuição geográfica, análises demográficas e cruzamentos com a tabela de vendas.*

### Dimensão Data:

```SQL
SELECT
    DateKey AS DateID,
    FullDateAlternateKey AS [Date],
    EnglishMonthName as MesNome,
    MonthNumberOfYear as Mes,
    CalendarYear as Ano
FROM DimDate
WHERE 
    CalendarYear in (2013,2014)    
```

O resultado é uma tabela preparada para responder perguntas como:

- Como as vendas evoluíram ao longo dos meses?
- Qual mês apresentou o maior volume de vendas?
- Como foi o desempenho das vendas em 2013 comparado com 2014?
- Em qual período do ano ocorreram mais vendas?
- Qual foi a evolução mensal ou anual do faturamento?
- Existem períodos de crescimento ou queda nas vendas?
- Qual foi o melhor mês de cada ano?
- Como comparar o desempenho de janeiro de 2013 com janeiro de 2014?

*Essa dimensão também serve como uma base de relacionamento temporal com a tabela de fatos de vendas, permitindo analisar métricas como faturamento, quantidade vendida e lucro ao longo do tempo.*