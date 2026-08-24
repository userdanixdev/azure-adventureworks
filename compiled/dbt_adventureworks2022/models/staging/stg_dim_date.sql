WITH source AS (

    SELECT
        DateKey,
        FullDateAlternateKey,
        DayNumberOfWeek,
        EnglishDayNameOfWeek,
        DayNumberOfMonth,
        DayNumberOfYear,
        WeekNumberOfYear,
        EnglishMonthName,
        MonthNumberOfYear,
        CalendarQuarter,
        CalendarSemester,
        CalendarYear,
        FiscalQuarter,
        FiscalSemester,
        FiscalYear

    FROM "free-sql-db-3211278"."dbo"."DimDate"

    

)

SELECT
    DateKey AS data_id,
    FullDateAlternateKey AS data,

    EnglishDayNameOfWeek AS nome_dia_semana,
    DayNumberOfWeek AS numero_dia_semana,
    DayNumberOfMonth AS dia_mes,
    DayNumberOfYear AS dia_ano,
    WeekNumberOfYear AS semana_ano,

    EnglishMonthName AS nome_mes,
    MonthNumberOfYear AS numero_mes,

    CalendarQuarter AS trimestre,
    CalendarSemester AS semestre,
    CalendarYear AS ano,

    FiscalQuarter AS trimestre_fiscal,
    FiscalSemester AS semestre_fiscal,
    FiscalYear AS ano_fiscal

FROM source