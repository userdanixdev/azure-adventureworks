WITH source AS (

    SELECT
        ProductCategoryKey,
        ProductCategoryAlternateKey,
        EnglishProductCategoryName

    FROM {{ source('adventureworks', 'DimProductCategory') }}

)

SELECT
    ProductCategoryKey AS categoria_id,
    ProductCategoryAlternateKey AS categoria_id_alternativo,
    EnglishProductCategoryName AS categoria

FROM source