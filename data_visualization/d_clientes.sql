-- Dimensão Clientes:
-- A tabela DimCustomer contém os dados cadastrais e demográficos dos clientes.
SELECT
    cus.CustomerKey AS CustomerID,
    Concat(cus.FirstName,' ',cus.LastName) AS Nome,
    case when cus.MaritalStatus = 'M' then 'Married'
         when cus.MaritalStatus = 'S' then 'Single'
    end as EstadoCivil,
    case when cus.Gender = 'M' then 'Male'
         when cus.Gender = 'F' then 'Female'
    end as Genero,
    geo.StateProvinceName AS Estado,
    geo.EnglishCountryRegionName AS PaisRegiao
FROM DimCustomer cus
INNER JOIN DimGeography geo
    ON cus.GeographyKey = geo.GeographyKey                         

--1. A tabela possui o nome e o sobrenome separados.
-- A função CONCAT() junta essas duas informações, colocando
--  um espaço entre elas.

--2. Na tabela original, o estado civil está armazenado como códigos.
-- Com 'Case when' transformamos em descrições
--2.1 A mesma coisa para Gender ( Gênero )
--3. Relacionamento com a dimensão geográfica:
-- Essa coluna é chave estrangeira da tabela DimGeography, assim:
-- O INNER JOIN conecta cada cliente à sua respectiva localização geográfica.
-- Dessa forma conseguimos adicionar informações geográficas que
-- não estão diretamente detalhadas na tabela de clientes.
-- 4. Inclusão do estado da tabela DimGeography como Estado e;
-- 4.1 - 'EnglishCountryRegionName como Estado da tabela DimGeography


-- Resumo:

-- A consulta pega os dados brutos de cadastro do cliente,
-- cria campos mais amigáveis, traduz códigos como M e S para
--  valores descritivos e adiciona informações geográficas por meio 
-- do relacionamento entre DimCustomer e DimGeography. 
-- O resultado é uma tabela de dimensão mais adequada para ser
-- carregada e utilizada em análises no Power BI.

