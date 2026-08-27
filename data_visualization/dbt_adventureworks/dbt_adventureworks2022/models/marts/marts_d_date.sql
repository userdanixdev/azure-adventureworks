SELECT
    data_id AS data_id,
    data,
    nome_mes AS mes_nome,
    numero_mes AS mes,
    ano AS ano

FROM {{ ref('stg_dim_date') }}

WHERE ano BETWEEN 2011 AND 2014

