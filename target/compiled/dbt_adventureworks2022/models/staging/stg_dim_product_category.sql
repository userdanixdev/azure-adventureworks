WITH source AS (

    SELECT
        ProductCategoryKey,
        ProductCategoryAlternateKey,
        EnglishProductCategoryName

    FROM "free-sql-db-3211278"."dbo"."DimProductCategory"

)

SELECT
    ProductCategoryKey AS categoria_id,
    ProductCategoryAlternateKey AS categoria_id_alternativo,
    EnglishProductCategoryName AS categoria

FROM source