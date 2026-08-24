-- Fact_Vendas:

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

-- 1.Inner Join com DimDate:
--A FactInternetSales possui a chave da data do pedido.
-- Aqui fazemos o relacionamento com DimDate para
-- permitir análises temporais, como:
-- vendas por ano; vendas por mês; evolução da receita; comparação entre períodos.
-- Assim o resultado terá apenas vendas realizadas nos anos de 2013/2014.

--2. Inner Join com DimProduct:
-- Relaciona cada venda ao produto corresponde com ID
-- Assim permite visualizar produto mais lucrativo, produtos mais vendido, etc.

--3. Inner Join com DimCustomer:
-- Cada venda também recebe a identificação do cliente.
-- Permitindo mais análises como receita por cliente, quantidade de pedidos,
-- Lucro por cliente ou com maior faturamento

--4. SalesAmount: Representa o valor da venda
--5. (fis.Freight + fis.TaxAmt) representa FRETE + IMPOSTO
--6. (fis.SalesAmount - (fis.Freight + fis.TaxAmt)) 
-- representa o Lucro = Receita - Custo

-- Resumo:
-- Uma linha de venda, associada 
-- a um pedido, uma data, um produto e um cliente,
-- contendo as principais métricas financeiras e de quantidade.

