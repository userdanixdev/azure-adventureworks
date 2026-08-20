-- ==========================================
-- SCRIPT DE MIGRAÇÃO GERADO AUTOMATICAMENTE
-- Data: 2026-08-19 20:35:15
-- Origem: AdventureWorksDW2022
-- Destino: Azure SQL Database
-- ==========================================

-- ==========================================
-- FASE 1: CRIAÇÃO DE SCHEMAS
-- ==========================================

-- ==========================================
-- FASE 2: CRIAÇÃO DE TABELAS
-- ==========================================

-- Tabela: [dbo].[AdventureWorksDWBuildVersion]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[AdventureWorksDWBuildVersion]'))
BEGIN
    CREATE TABLE [dbo].[AdventureWorksDWBuildVersion] (
    [DBVersion] NVARCHAR(50) NULL,
    [VersionDate] DATETIME NULL
    );
END;
GO

-- Tabela: [dbo].[DatabaseLog]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DatabaseLog]'))
BEGIN
    CREATE TABLE [dbo].[DatabaseLog] (
    [DatabaseLogID] INT IDENTITY(1,1) NOT NULL,
    [PostTime] DATETIME NOT NULL,
    [DatabaseUser] NVARCHAR(128) NOT NULL,
    [Event] NVARCHAR(128) NOT NULL,
    [Schema] NVARCHAR(128) NULL,
    [Object] NVARCHAR(128) NULL,
    [TSQL] NVARCHAR(MAX) NOT NULL,
    [XmlEvent] XML NOT NULL
    );
END;
GO

-- Tabela: [dbo].[DimAccount]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimAccount]'))
BEGIN
    CREATE TABLE [dbo].[DimAccount] (
    [AccountKey] INT IDENTITY(1,1) NOT NULL,
    [ParentAccountKey] INT NULL,
    [AccountCodeAlternateKey] INT NULL,
    [ParentAccountCodeAlternateKey] INT NULL,
    [AccountDescription] NVARCHAR(50) NULL,
    [AccountType] NVARCHAR(50) NULL,
    [Operator] NVARCHAR(50) NULL,
    [CustomMembers] NVARCHAR(300) NULL,
    [ValueType] NVARCHAR(50) NULL,
    [CustomMemberOptions] NVARCHAR(200) NULL
    );
END;
GO

-- Tabela: [dbo].[DimCurrency]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimCurrency]'))
BEGIN
    CREATE TABLE [dbo].[DimCurrency] (
    [CurrencyKey] INT IDENTITY(1,1) NOT NULL,
    [CurrencyAlternateKey] NCHAR(3) NOT NULL,
    [CurrencyName] NVARCHAR(50) NOT NULL
    );
END;
GO

-- Tabela: [dbo].[DimCustomer]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimCustomer]'))
BEGIN
    CREATE TABLE [dbo].[DimCustomer] (
    [CustomerKey] INT IDENTITY(1,1) NOT NULL,
    [GeographyKey] INT NULL,
    [CustomerAlternateKey] NVARCHAR(15) NOT NULL,
    [Title] NVARCHAR(8) NULL,
    [FirstName] NVARCHAR(50) NULL,
    [MiddleName] NVARCHAR(50) NULL,
    [LastName] NVARCHAR(50) NULL,
    [NameStyle] BIT NULL,
    [BirthDate] DATE NULL,
    [MaritalStatus] NCHAR(1) NULL,
    [Suffix] NVARCHAR(10) NULL,
    [Gender] NVARCHAR(1) NULL,
    [EmailAddress] NVARCHAR(50) NULL,
    [YearlyIncome] MONEY NULL,
    [TotalChildren] TINYINT NULL,
    [NumberChildrenAtHome] TINYINT NULL,
    [EnglishEducation] NVARCHAR(40) NULL,
    [SpanishEducation] NVARCHAR(40) NULL,
    [FrenchEducation] NVARCHAR(40) NULL,
    [EnglishOccupation] NVARCHAR(100) NULL,
    [SpanishOccupation] NVARCHAR(100) NULL,
    [FrenchOccupation] NVARCHAR(100) NULL,
    [HouseOwnerFlag] NCHAR(1) NULL,
    [NumberCarsOwned] TINYINT NULL,
    [AddressLine1] NVARCHAR(120) NULL,
    [AddressLine2] NVARCHAR(120) NULL,
    [Phone] NVARCHAR(20) NULL,
    [DateFirstPurchase] DATE NULL,
    [CommuteDistance] NVARCHAR(15) NULL
    );
END;
GO

-- Tabela: [dbo].[DimDate]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimDate]'))
BEGIN
    CREATE TABLE [dbo].[DimDate] (
    [DateKey] INT NOT NULL,
    [FullDateAlternateKey] DATE NOT NULL,
    [DayNumberOfWeek] TINYINT NOT NULL,
    [EnglishDayNameOfWeek] NVARCHAR(10) NOT NULL,
    [SpanishDayNameOfWeek] NVARCHAR(10) NOT NULL,
    [FrenchDayNameOfWeek] NVARCHAR(10) NOT NULL,
    [DayNumberOfMonth] TINYINT NOT NULL,
    [DayNumberOfYear] SMALLINT NOT NULL,
    [WeekNumberOfYear] TINYINT NOT NULL,
    [EnglishMonthName] NVARCHAR(10) NOT NULL,
    [SpanishMonthName] NVARCHAR(10) NOT NULL,
    [FrenchMonthName] NVARCHAR(10) NOT NULL,
    [MonthNumberOfYear] TINYINT NOT NULL,
    [CalendarQuarter] TINYINT NOT NULL,
    [CalendarYear] SMALLINT NOT NULL,
    [CalendarSemester] TINYINT NOT NULL,
    [FiscalQuarter] TINYINT NOT NULL,
    [FiscalYear] SMALLINT NOT NULL,
    [FiscalSemester] TINYINT NOT NULL
    );
END;
GO

-- Tabela: [dbo].[DimDepartmentGroup]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimDepartmentGroup]'))
BEGIN
    CREATE TABLE [dbo].[DimDepartmentGroup] (
    [DepartmentGroupKey] INT IDENTITY(1,1) NOT NULL,
    [ParentDepartmentGroupKey] INT NULL,
    [DepartmentGroupName] NVARCHAR(50) NULL
    );
END;
GO

-- Tabela: [dbo].[DimEmployee]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimEmployee]'))
BEGIN
    CREATE TABLE [dbo].[DimEmployee] (
    [EmployeeKey] INT IDENTITY(1,1) NOT NULL,
    [ParentEmployeeKey] INT NULL,
    [EmployeeNationalIDAlternateKey] NVARCHAR(15) NULL,
    [ParentEmployeeNationalIDAlternateKey] NVARCHAR(15) NULL,
    [SalesTerritoryKey] INT NULL,
    [FirstName] NVARCHAR(50) NOT NULL,
    [LastName] NVARCHAR(50) NOT NULL,
    [MiddleName] NVARCHAR(50) NULL,
    [NameStyle] BIT NOT NULL,
    [Title] NVARCHAR(50) NULL,
    [HireDate] DATE NULL,
    [BirthDate] DATE NULL,
    [LoginID] NVARCHAR(256) NULL,
    [EmailAddress] NVARCHAR(50) NULL,
    [Phone] NVARCHAR(25) NULL,
    [MaritalStatus] NCHAR(1) NULL,
    [EmergencyContactName] NVARCHAR(50) NULL,
    [EmergencyContactPhone] NVARCHAR(25) NULL,
    [SalariedFlag] BIT NULL,
    [Gender] NCHAR(1) NULL,
    [PayFrequency] TINYINT NULL,
    [BaseRate] MONEY NULL,
    [VacationHours] SMALLINT NULL,
    [SickLeaveHours] SMALLINT NULL,
    [CurrentFlag] BIT NOT NULL,
    [SalesPersonFlag] BIT NOT NULL,
    [DepartmentName] NVARCHAR(50) NULL,
    [StartDate] DATE NULL,
    [EndDate] DATE NULL,
    [Status] NVARCHAR(50) NULL,
    [EmployeePhoto] VARBINARY(MAX) NULL
    );
END;
GO

-- Tabela: [dbo].[DimGeography]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimGeography]'))
BEGIN
    CREATE TABLE [dbo].[DimGeography] (
    [GeographyKey] INT IDENTITY(1,1) NOT NULL,
    [City] NVARCHAR(30) NULL,
    [StateProvinceCode] NVARCHAR(3) NULL,
    [StateProvinceName] NVARCHAR(50) NULL,
    [CountryRegionCode] NVARCHAR(3) NULL,
    [EnglishCountryRegionName] NVARCHAR(50) NULL,
    [SpanishCountryRegionName] NVARCHAR(50) NULL,
    [FrenchCountryRegionName] NVARCHAR(50) NULL,
    [PostalCode] NVARCHAR(15) NULL,
    [SalesTerritoryKey] INT NULL,
    [IpAddressLocator] NVARCHAR(15) NULL
    );
END;
GO

-- Tabela: [dbo].[DimOrganization]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimOrganization]'))
BEGIN
    CREATE TABLE [dbo].[DimOrganization] (
    [OrganizationKey] INT IDENTITY(1,1) NOT NULL,
    [ParentOrganizationKey] INT NULL,
    [PercentageOfOwnership] NVARCHAR(16) NULL,
    [OrganizationName] NVARCHAR(50) NULL,
    [CurrencyKey] INT NULL
    );
END;
GO

-- Tabela: [dbo].[DimProduct]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimProduct]'))
BEGIN
    CREATE TABLE [dbo].[DimProduct] (
    [ProductKey] INT IDENTITY(1,1) NOT NULL,
    [ProductAlternateKey] NVARCHAR(25) NULL,
    [ProductSubcategoryKey] INT NULL,
    [WeightUnitMeasureCode] NCHAR(3) NULL,
    [SizeUnitMeasureCode] NCHAR(3) NULL,
    [EnglishProductName] NVARCHAR(50) NOT NULL,
    [SpanishProductName] NVARCHAR(50) NOT NULL,
    [FrenchProductName] NVARCHAR(50) NOT NULL,
    [StandardCost] MONEY NULL,
    [FinishedGoodsFlag] BIT NOT NULL,
    [Color] NVARCHAR(15) NOT NULL,
    [SafetyStockLevel] SMALLINT NULL,
    [ReorderPoint] SMALLINT NULL,
    [ListPrice] MONEY NULL,
    [Size] NVARCHAR(50) NULL,
    [SizeRange] NVARCHAR(50) NULL,
    [Weight] FLOAT NULL,
    [DaysToManufacture] INT NULL,
    [ProductLine] NCHAR(2) NULL,
    [DealerPrice] MONEY NULL,
    [Class] NCHAR(2) NULL,
    [Style] NCHAR(2) NULL,
    [ModelName] NVARCHAR(50) NULL,
    [LargePhoto] VARBINARY(MAX) NULL,
    [EnglishDescription] NVARCHAR(400) NULL,
    [FrenchDescription] NVARCHAR(400) NULL,
    [ChineseDescription] NVARCHAR(400) NULL,
    [ArabicDescription] NVARCHAR(400) NULL,
    [HebrewDescription] NVARCHAR(400) NULL,
    [ThaiDescription] NVARCHAR(400) NULL,
    [GermanDescription] NVARCHAR(400) NULL,
    [JapaneseDescription] NVARCHAR(400) NULL,
    [TurkishDescription] NVARCHAR(400) NULL,
    [StartDate] DATETIME NULL,
    [EndDate] DATETIME NULL,
    [Status] NVARCHAR(7) NULL
    );
END;
GO

-- Tabela: [dbo].[DimProductCategory]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimProductCategory]'))
BEGIN
    CREATE TABLE [dbo].[DimProductCategory] (
    [ProductCategoryKey] INT IDENTITY(1,1) NOT NULL,
    [ProductCategoryAlternateKey] INT NULL,
    [EnglishProductCategoryName] NVARCHAR(50) NOT NULL,
    [SpanishProductCategoryName] NVARCHAR(50) NOT NULL,
    [FrenchProductCategoryName] NVARCHAR(50) NOT NULL
    );
END;
GO

-- Tabela: [dbo].[DimProductSubcategory]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimProductSubcategory]'))
BEGIN
    CREATE TABLE [dbo].[DimProductSubcategory] (
    [ProductSubcategoryKey] INT IDENTITY(1,1) NOT NULL,
    [ProductSubcategoryAlternateKey] INT NULL,
    [EnglishProductSubcategoryName] NVARCHAR(50) NOT NULL,
    [SpanishProductSubcategoryName] NVARCHAR(50) NOT NULL,
    [FrenchProductSubcategoryName] NVARCHAR(50) NOT NULL,
    [ProductCategoryKey] INT NULL
    );
END;
GO

-- Tabela: [dbo].[DimPromotion]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimPromotion]'))
BEGIN
    CREATE TABLE [dbo].[DimPromotion] (
    [PromotionKey] INT IDENTITY(1,1) NOT NULL,
    [PromotionAlternateKey] INT NULL,
    [EnglishPromotionName] NVARCHAR(255) NULL,
    [SpanishPromotionName] NVARCHAR(255) NULL,
    [FrenchPromotionName] NVARCHAR(255) NULL,
    [DiscountPct] FLOAT NULL,
    [EnglishPromotionType] NVARCHAR(50) NULL,
    [SpanishPromotionType] NVARCHAR(50) NULL,
    [FrenchPromotionType] NVARCHAR(50) NULL,
    [EnglishPromotionCategory] NVARCHAR(50) NULL,
    [SpanishPromotionCategory] NVARCHAR(50) NULL,
    [FrenchPromotionCategory] NVARCHAR(50) NULL,
    [StartDate] DATETIME NOT NULL,
    [EndDate] DATETIME NULL,
    [MinQty] INT NULL,
    [MaxQty] INT NULL
    );
END;
GO

-- Tabela: [dbo].[DimReseller]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimReseller]'))
BEGIN
    CREATE TABLE [dbo].[DimReseller] (
    [ResellerKey] INT IDENTITY(1,1) NOT NULL,
    [GeographyKey] INT NULL,
    [ResellerAlternateKey] NVARCHAR(15) NULL,
    [Phone] NVARCHAR(25) NULL,
    [BusinessType] VARCHAR(20) NOT NULL,
    [ResellerName] NVARCHAR(50) NOT NULL,
    [NumberEmployees] INT NULL,
    [OrderFrequency] CHAR(1) NULL,
    [OrderMonth] TINYINT NULL,
    [FirstOrderYear] INT NULL,
    [LastOrderYear] INT NULL,
    [ProductLine] NVARCHAR(50) NULL,
    [AddressLine1] NVARCHAR(60) NULL,
    [AddressLine2] NVARCHAR(60) NULL,
    [AnnualSales] MONEY NULL,
    [BankName] NVARCHAR(50) NULL,
    [MinPaymentType] TINYINT NULL,
    [MinPaymentAmount] MONEY NULL,
    [AnnualRevenue] MONEY NULL,
    [YearOpened] INT NULL
    );
END;
GO

-- Tabela: [dbo].[DimSalesReason]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimSalesReason]'))
BEGIN
    CREATE TABLE [dbo].[DimSalesReason] (
    [SalesReasonKey] INT IDENTITY(1,1) NOT NULL,
    [SalesReasonAlternateKey] INT NOT NULL,
    [SalesReasonName] NVARCHAR(50) NOT NULL,
    [SalesReasonReasonType] NVARCHAR(50) NOT NULL
    );
END;
GO

-- Tabela: [dbo].[DimSalesTerritory]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimSalesTerritory]'))
BEGIN
    CREATE TABLE [dbo].[DimSalesTerritory] (
    [SalesTerritoryKey] INT IDENTITY(1,1) NOT NULL,
    [SalesTerritoryAlternateKey] INT NULL,
    [SalesTerritoryRegion] NVARCHAR(50) NOT NULL,
    [SalesTerritoryCountry] NVARCHAR(50) NOT NULL,
    [SalesTerritoryGroup] NVARCHAR(50) NULL,
    [SalesTerritoryImage] VARBINARY(MAX) NULL
    );
END;
GO

-- Tabela: [dbo].[DimScenario]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[DimScenario]'))
BEGIN
    CREATE TABLE [dbo].[DimScenario] (
    [ScenarioKey] INT IDENTITY(1,1) NOT NULL,
    [ScenarioName] NVARCHAR(50) NULL
    );
END;
GO

-- Tabela: [dbo].[FactAdditionalInternationalProductDescription]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[FactAdditionalInternationalProductDescription]'))
BEGIN
    CREATE TABLE [dbo].[FactAdditionalInternationalProductDescription] (
    [ProductKey] INT NOT NULL,
    [CultureName] NVARCHAR(50) NOT NULL,
    [ProductDescription] NVARCHAR(MAX) NOT NULL
    );
END;
GO

-- Tabela: [dbo].[FactCallCenter]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[FactCallCenter]'))
BEGIN
    CREATE TABLE [dbo].[FactCallCenter] (
    [FactCallCenterID] INT IDENTITY(1,1) NOT NULL,
    [DateKey] INT NOT NULL,
    [WageType] NVARCHAR(15) NOT NULL,
    [Shift] NVARCHAR(20) NOT NULL,
    [LevelOneOperators] SMALLINT NOT NULL,
    [LevelTwoOperators] SMALLINT NOT NULL,
    [TotalOperators] SMALLINT NOT NULL,
    [Calls] INT NOT NULL,
    [AutomaticResponses] INT NOT NULL,
    [Orders] INT NOT NULL,
    [IssuesRaised] SMALLINT NOT NULL,
    [AverageTimePerIssue] SMALLINT NOT NULL,
    [ServiceGrade] FLOAT NOT NULL,
    [Date] DATETIME NULL
    );
END;
GO

-- Tabela: [dbo].[FactCurrencyRate]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[FactCurrencyRate]'))
BEGIN
    CREATE TABLE [dbo].[FactCurrencyRate] (
    [CurrencyKey] INT NOT NULL,
    [DateKey] INT NOT NULL,
    [AverageRate] FLOAT NOT NULL,
    [EndOfDayRate] FLOAT NOT NULL,
    [Date] DATETIME NULL
    );
END;
GO

-- Tabela: [dbo].[FactFinance]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[FactFinance]'))
BEGIN
    CREATE TABLE [dbo].[FactFinance] (
    [FinanceKey] INT IDENTITY(1,1) NOT NULL,
    [DateKey] INT NOT NULL,
    [OrganizationKey] INT NOT NULL,
    [DepartmentGroupKey] INT NOT NULL,
    [ScenarioKey] INT NOT NULL,
    [AccountKey] INT NOT NULL,
    [Amount] FLOAT NOT NULL,
    [Date] DATETIME NULL
    );
END;
GO

-- Tabela: [dbo].[FactInternetSales]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[FactInternetSales]'))
BEGIN
    CREATE TABLE [dbo].[FactInternetSales] (
    [ProductKey] INT NOT NULL,
    [OrderDateKey] INT NOT NULL,
    [DueDateKey] INT NOT NULL,
    [ShipDateKey] INT NOT NULL,
    [CustomerKey] INT NOT NULL,
    [PromotionKey] INT NOT NULL,
    [CurrencyKey] INT NOT NULL,
    [SalesTerritoryKey] INT NOT NULL,
    [SalesOrderNumber] NVARCHAR(20) NOT NULL,
    [SalesOrderLineNumber] TINYINT NOT NULL,
    [RevisionNumber] TINYINT NOT NULL,
    [OrderQuantity] SMALLINT NOT NULL,
    [UnitPrice] MONEY NOT NULL,
    [ExtendedAmount] MONEY NOT NULL,
    [UnitPriceDiscountPct] FLOAT NOT NULL,
    [DiscountAmount] FLOAT NOT NULL,
    [ProductStandardCost] MONEY NOT NULL,
    [TotalProductCost] MONEY NOT NULL,
    [SalesAmount] MONEY NOT NULL,
    [TaxAmt] MONEY NOT NULL,
    [Freight] MONEY NOT NULL,
    [CarrierTrackingNumber] NVARCHAR(25) NULL,
    [CustomerPONumber] NVARCHAR(25) NULL,
    [OrderDate] DATETIME NULL,
    [DueDate] DATETIME NULL,
    [ShipDate] DATETIME NULL
    );
END;
GO

-- Tabela: [dbo].[FactInternetSalesReason]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[FactInternetSalesReason]'))
BEGIN
    CREATE TABLE [dbo].[FactInternetSalesReason] (
    [SalesOrderNumber] NVARCHAR(20) NOT NULL,
    [SalesOrderLineNumber] TINYINT NOT NULL,
    [SalesReasonKey] INT NOT NULL
    );
END;
GO

-- Tabela: [dbo].[FactProductInventory]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[FactProductInventory]'))
BEGIN
    CREATE TABLE [dbo].[FactProductInventory] (
    [ProductKey] INT NOT NULL,
    [DateKey] INT NOT NULL,
    [MovementDate] DATE NOT NULL,
    [UnitCost] MONEY NOT NULL,
    [UnitsIn] INT NOT NULL,
    [UnitsOut] INT NOT NULL,
    [UnitsBalance] INT NOT NULL
    );
END;
GO

-- Tabela: [dbo].[FactResellerSales]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[FactResellerSales]'))
BEGIN
    CREATE TABLE [dbo].[FactResellerSales] (
    [ProductKey] INT NOT NULL,
    [OrderDateKey] INT NOT NULL,
    [DueDateKey] INT NOT NULL,
    [ShipDateKey] INT NOT NULL,
    [ResellerKey] INT NOT NULL,
    [EmployeeKey] INT NOT NULL,
    [PromotionKey] INT NOT NULL,
    [CurrencyKey] INT NOT NULL,
    [SalesTerritoryKey] INT NOT NULL,
    [SalesOrderNumber] NVARCHAR(20) NOT NULL,
    [SalesOrderLineNumber] TINYINT NOT NULL,
    [RevisionNumber] TINYINT NULL,
    [OrderQuantity] SMALLINT NULL,
    [UnitPrice] MONEY NULL,
    [ExtendedAmount] MONEY NULL,
    [UnitPriceDiscountPct] FLOAT NULL,
    [DiscountAmount] FLOAT NULL,
    [ProductStandardCost] MONEY NULL,
    [TotalProductCost] MONEY NULL,
    [SalesAmount] MONEY NULL,
    [TaxAmt] MONEY NULL,
    [Freight] MONEY NULL,
    [CarrierTrackingNumber] NVARCHAR(25) NULL,
    [CustomerPONumber] NVARCHAR(25) NULL,
    [OrderDate] DATETIME NULL,
    [DueDate] DATETIME NULL,
    [ShipDate] DATETIME NULL
    );
END;
GO

-- Tabela: [dbo].[FactSalesQuota]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[FactSalesQuota]'))
BEGIN
    CREATE TABLE [dbo].[FactSalesQuota] (
    [SalesQuotaKey] INT IDENTITY(1,1) NOT NULL,
    [EmployeeKey] INT NOT NULL,
    [DateKey] INT NOT NULL,
    [CalendarYear] SMALLINT NOT NULL,
    [CalendarQuarter] TINYINT NOT NULL,
    [SalesAmountQuota] MONEY NOT NULL,
    [Date] DATETIME NULL
    );
END;
GO

-- Tabela: [dbo].[FactSurveyResponse]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[FactSurveyResponse]'))
BEGIN
    CREATE TABLE [dbo].[FactSurveyResponse] (
    [SurveyResponseKey] INT IDENTITY(1,1) NOT NULL,
    [DateKey] INT NOT NULL,
    [CustomerKey] INT NOT NULL,
    [ProductCategoryKey] INT NOT NULL,
    [EnglishProductCategoryName] NVARCHAR(50) NOT NULL,
    [ProductSubcategoryKey] INT NOT NULL,
    [EnglishProductSubcategoryName] NVARCHAR(50) NOT NULL,
    [Date] DATETIME NULL
    );
END;
GO

-- Tabela: [dbo].[NewFactCurrencyRate]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[NewFactCurrencyRate]'))
BEGIN
    CREATE TABLE [dbo].[NewFactCurrencyRate] (
    [AverageRate] REAL NULL,
    [CurrencyID] NVARCHAR(3) NULL,
    [CurrencyDate] DATE NULL,
    [EndOfDayRate] REAL NULL,
    [CurrencyKey] INT NULL,
    [DateKey] INT NULL
    );
END;
GO

-- Tabela: [dbo].[ProspectiveBuyer]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[ProspectiveBuyer]'))
BEGIN
    CREATE TABLE [dbo].[ProspectiveBuyer] (
    [ProspectiveBuyerKey] INT IDENTITY(1,1) NOT NULL,
    [ProspectAlternateKey] NVARCHAR(15) NULL,
    [FirstName] NVARCHAR(50) NULL,
    [MiddleName] NVARCHAR(50) NULL,
    [LastName] NVARCHAR(50) NULL,
    [BirthDate] DATETIME NULL,
    [MaritalStatus] NCHAR(1) NULL,
    [Gender] NVARCHAR(1) NULL,
    [EmailAddress] NVARCHAR(50) NULL,
    [YearlyIncome] MONEY NULL,
    [TotalChildren] TINYINT NULL,
    [NumberChildrenAtHome] TINYINT NULL,
    [Education] NVARCHAR(40) NULL,
    [Occupation] NVARCHAR(100) NULL,
    [HouseOwnerFlag] NCHAR(1) NULL,
    [NumberCarsOwned] TINYINT NULL,
    [AddressLine1] NVARCHAR(120) NULL,
    [AddressLine2] NVARCHAR(120) NULL,
    [City] NVARCHAR(30) NULL,
    [StateProvinceCode] NVARCHAR(3) NULL,
    [PostalCode] NVARCHAR(15) NULL,
    [Phone] NVARCHAR(20) NULL,
    [Salutation] NVARCHAR(8) NULL,
    [Unknown] INT NULL
    );
END;
GO

-- Tabela: [dbo].[sysdiagrams]
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE object_id = OBJECT_ID(N'[dbo].[sysdiagrams]'))
BEGIN
    CREATE TABLE [dbo].[sysdiagrams] (
    [name] NVARCHAR(128) NOT NULL,
    [principal_id] INT NOT NULL,
    [diagram_id] INT IDENTITY(1,1) NOT NULL,
    [version] INT NULL,
    [definition] VARBINARY(MAX) NULL
    );
END;
GO
