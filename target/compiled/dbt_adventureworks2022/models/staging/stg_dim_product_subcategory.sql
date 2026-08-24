WITH source AS (

    SELECT
        ProductSubcategoryKey,
        ProductSubcategoryAlternateKey,
        EnglishProductSubcategoryName,
        ProductCategoryKey

    FROM "free-sql-db-3211278"."dbo"."DimProductSubcategory"

)

SELECT
    ProductSubcategoryKey AS subcategoria_id,
    ProductSubcategoryAlternateKey AS subcategoria_id_alternativo,
    EnglishProductSubcategoryName AS subcategoria,

    ProductCategoryKey AS categoria_id

FROM source