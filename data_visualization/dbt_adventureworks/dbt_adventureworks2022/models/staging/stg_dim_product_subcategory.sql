WITH source AS (

    SELECT
        ProductSubcategoryKey,
        ProductSubcategoryAlternateKey,
        EnglishProductSubcategoryName,
        ProductCategoryKey

    FROM {{ source('adventureworks', 'DimProductSubcategory') }}

)

SELECT
    ProductSubcategoryKey AS subcategoria_id,
    ProductSubcategoryAlternateKey AS subcategoria_id_alternativo,
    EnglishProductSubcategoryName AS subcategoria,

    ProductCategoryKey AS categoria_id

FROM source