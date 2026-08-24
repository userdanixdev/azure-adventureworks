WITH source AS (

    SELECT
        ProductKey,
        ProductAlternateKey,
        ProductSubcategoryKey,

        WeightUnitMeasureCode,
        SizeUnitMeasureCode,

        EnglishProductName,
        SpanishProductName,

        StandardCost,
        FinishedGoodsFlag,

        Color,
        SafetyStockLevel,
        ReorderPoint,
        ListPrice,

        Size,
        SizeRange,
        Weight,

        DaysToManufacture,
        ProductLine,
        DealerPrice,

        Class,
        Style,
        ModelName,

        LargePhoto,
        EnglishDescription,

        StartDate,
        EndDate,
        Status

    FROM "free-sql-db-3211278"."dbo"."DimProduct"

)

SELECT
    ProductKey AS produto_id,
    ProductAlternateKey AS produto_id_alternativo,
    ProductSubcategoryKey AS subcategoria_id,

    WeightUnitMeasureCode AS codigo_unidade_peso,
    SizeUnitMeasureCode AS codigo_unidade_tamanho,

    EnglishProductName AS produto,
    SpanishProductName AS produto_espanhol,

    StandardCost AS custo_padrao,
    FinishedGoodsFlag AS produto_acabado,

    Color AS cor,
    SafetyStockLevel AS nivel_estoque_seguranca,
    ReorderPoint AS ponto_reposicao,
    ListPrice AS preco_lista,

    Size AS tamanho,
    SizeRange AS faixa_tamanho,
    Weight AS peso,

    DaysToManufacture AS dias_fabricacao,
    ProductLine AS linha_produto,
    DealerPrice AS preco_revendedor,

    Class AS classe,
    Style AS estilo,
    ModelName AS modelo,

    LargePhoto AS foto_produto,
    EnglishDescription AS descricao,

    StartDate AS data_inicio,
    EndDate AS data_fim,
    Status AS status

FROM source