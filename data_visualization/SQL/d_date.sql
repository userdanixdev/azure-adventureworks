-- Essa consulta está preparando uma Dimensão de Data simplificada,
-- selecionando apenas os campos necessários para a análise de vendas
-- dos anos de 2013 e 2014.
-- Dimensão Data:
SELECT
    DateKey AS DateID,
    FullDateAlternateKey AS [Date],
    EnglishMonthName as MesNome,
    MonthNumberOfYear as Mes,
    CalendarYear as Ano
FROM DimDate
WHERE 
    CalendarYear in (2011,2012)    

--1 - A Coluna FullDateAlternateKey AS [Date] possui a data completa.
--2. -Em vez de carregar todo o calendário disponível na tabela DimDate
-- a consulta traz somente o período necessário para a análise.
