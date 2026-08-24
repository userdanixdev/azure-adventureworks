WITH produtos AS (
    SELECT
        produto_id,
        produto,
        modelo,
        subcategoria_id
    FROM {{ ref('stg_dim_product') }}
),
subcategorias AS (
    SELECT
        subcategoria_id,
        subcategoria,
        categoria_id
    FROM {{ ref('stg_dim_product_subcategory') }}
),
categorias AS (
    SELECT
        categoria_id,
        categoria
    FROM {{ ref('stg_dim_product_category') }}
)
SELECT
    p.produto_id,
    p.produto,
    p.modelo,

    sc.subcategoria,
    c.categoria
FROM produtos AS p
INNER JOIN subcategorias AS sc
    ON p.subcategoria_id = sc.subcategoria_id
INNER JOIN categorias AS c
    ON sc.categoria_id = c.categoria_id