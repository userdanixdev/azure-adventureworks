-- Dimensão Produtos:

SELECT 
    p.ProductKey AS ProductID,
    p.EnglishProductName AS Produto,
    sc.EnglishSubCategoryName AS SubCategoria,
    pc.EnglishProductCategoryName AS Categoria
FROM DimProduct AS p
INNER JOIN DimProductSubcategory AS sc
    ON p.ProductSubcategoryKey = sc.ProductSubcategoryKey
INNER JOIN DimProductCategory AS pc
    ON sc.ProductCategoryKey = pc.ProductCategoryKey        

-- Essa consulta combina informações das tabelas DimProduct, DimProductSubcategory e DimProductCategory.    
-- Nesta preparação, foram selecionados apenas os campos mais importantes
-- para identificar o produto e sua classificação.
--1.- Relacionamento com a tabela DimProductSubcategory:
-- Cada produto possui sua respectiva subcategoria.