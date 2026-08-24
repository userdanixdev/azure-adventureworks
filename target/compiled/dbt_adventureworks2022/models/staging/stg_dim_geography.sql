WITH source AS (

    SELECT
        GeographyKey,
        City,
        StateProvinceName,
        EnglishCountryRegionName,
        PostalCode,
        SalesTerritoryKey

    FROM "free-sql-db-3211278"."dbo"."DimGeography"

)

SELECT
    GeographyKey AS geografia_id,

    City AS cidade,
    StateProvinceName AS estado,
    EnglishCountryRegionName AS pais_regiao,
    PostalCode AS codigo_postal,

    SalesTerritoryKey AS territorio_vendas_id

FROM source