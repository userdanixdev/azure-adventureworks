WITH source AS (

    SELECT
        CustomerKey,
        CustomerAlternateKey,
        FirstName,
        MiddleName,
        LastName,
        BirthDate,
        MaritalStatus,
        Gender,
        EmailAddress,
        Phone,
        GeographyKey

    FROM {{ source('adventureworks', 'DimCustomer') }}

)

SELECT
    CustomerKey AS cliente_id,
    CustomerAlternateKey AS cliente_id_alternativo,

    FirstName AS primeiro_nome,
    MiddleName AS nome_meio,
    LastName AS sobrenome,

    BirthDate AS data_nascimento,
    MaritalStatus AS estado_civil,
    Gender AS genero,

    EmailAddress AS email,
    Phone AS telefone,

    GeographyKey AS geografia_id

FROM source