WITH source AS (

    SELECT
        ProductKey,
        OrderDateKey,
        DueDateKey,
        ShipDateKey,
        CustomerKey,
        PromotionKey,
        CurrencyKey,
        SalesTerritoryKey,

        SalesOrderNumber,
        SalesOrderLineNumber,

        OrderQuantity,
        UnitPrice,
        ExtendedAmount,
        UnitPriceDiscountPct,
        DiscountAmount,
        ProductStandardCost,
        TotalProductCost,
        SalesAmount,
        TaxAmt,
        Freight

    FROM "free-sql-db-3211278"."dbo"."FactInternetSales"

)

SELECT
    ProductKey AS produto_id,

    OrderDateKey AS data_pedido_id,
    DueDateKey AS data_vencimento_id,
    ShipDateKey AS data_envio_id,

    CustomerKey AS cliente_id,
    PromotionKey AS promocao_id,
    CurrencyKey AS moeda_id,
    SalesTerritoryKey AS territorio_vendas_id,

    SalesOrderNumber AS pedido_id,
    SalesOrderLineNumber AS linha_pedido_id,

    OrderQuantity AS quantidade,
    UnitPrice AS preco_unitario,
    ExtendedAmount AS valor_bruto,

    UnitPriceDiscountPct AS percentual_desconto,
    DiscountAmount AS valor_desconto,

    ProductStandardCost AS custo_padrao_produto,
    TotalProductCost AS custo_total_produto,

    SalesAmount AS valor_venda,
    TaxAmt AS valor_imposto,
    Freight AS valor_frete

FROM source