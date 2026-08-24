WITH clientes AS (
    SELECT
        cliente_id,
        primeiro_nome,
        sobrenome,
        estado_civil,
        genero,
        geografia_id

    FROM {{ ref('stg_dim_customer') }}
),
geografias AS (
    SELECT
        geografia_id,
        estado,
        pais_regiao
    FROM {{ ref('stg_dim_geography') }}
)
SELECT
    cli.cliente_id AS cliente_id,
    CONCAT(
        cli.primeiro_nome,
        ' ',
        cli.sobrenome
    ) AS nome,
    CASE
        WHEN cli.estado_civil = 'M' THEN 'Married'
        WHEN cli.estado_civil = 'S' THEN 'Single'
        ELSE 'Unknown'
    END AS estado_civil,
    CASE
        WHEN cli.genero = 'M' THEN 'Male'
        WHEN cli.genero = 'F' THEN 'Female'
        ELSE 'Unknown'
    END AS genero,
    geo.estado,
    geo.pais_regiao
FROM clientes AS cli
INNER JOIN geografias AS geo
    ON cli.geografia_id = geo.geografia_id

-- Obs: ELSE: 'Unknown". Isso evita valores NULL 
-- É uma pequena regra de qualidade para a dimensão.    

