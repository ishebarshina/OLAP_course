USE [stg]

CREATE TABLE [SalesOrderDetail](
	[SalesOrderID] [int] NOT NULL,
	[SalesOrderDetailID] [int] NOT NULL,
	[CarrierTrackingNumber] [nvarchar](25) NULL,
	[OrderQty] [smallint] NOT NULL,
	[ProductID] [int] NOT NULL,
	[SpecialOfferID] [int] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[UnitPriceDiscount] [money] NOT NULL,
	[LineTotal]  AS (isnull(([UnitPrice]*((1.0)-[UnitPriceDiscount]))*[OrderQty],(0.0))),
	[ModifiedDate] [datetime] NOT NULL
);

CREATE TABLE [SalesOrderHeader](
	[SalesOrderID] [int] NOT NULL,
	[RevisionNumber] [tinyint] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[DueDate] [datetime] NOT NULL,
	[ShipDate] [datetime] NULL,
	[Status] [tinyint] NOT NULL,
	[OnlineOrderFlag] [bit] NOT NULL,
	[SalesOrderNumber] [nvarchar](25) NOT NULL,
	[PurchaseOrderNumber] [nvarchar](25) NULL,
	[AccountNumber] [nvarchar](15) NULL,
	[CustomerID] [int] NOT NULL,
	[SalesPersonID] [int] NULL,
	[TerritoryID] [int] NULL,
	[BillToAddressID] [int] NOT NULL,
	[ShipToAddressID] [int] NOT NULL,
	[ShipMethodID] [int] NOT NULL,
	[CreditCardID] [int] NULL,
	[CreditCardApprovalCode] [varchar](15) NULL,
	[CurrencyRateID] [int] NULL,
	[SubTotal] [money] NOT NULL,
	[TaxAmt] [money] NOT NULL,
	[Freight] [money] NOT NULL,
	[TotalDue]  AS (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))),
	[Comment] [nvarchar](128) NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
);

CREATE TABLE [Product](
	[ProductID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[ProductNumber] [nvarchar](25) NOT NULL,
	[MakeFlag] [bit] NOT NULL,
	[FinishedGoodsFlag] [bit] NOT NULL,
	[Color] [nvarchar](15) NULL,
	[SafetyStockLevel] [smallint] NOT NULL,
	[ReorderPoint] [smallint] NOT NULL,
	[StandardCost] [money] NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Size] [nvarchar](5) NULL,
	[SizeUnitMeasureCode] [nchar](3) NULL,
	[WeightUnitMeasureCode] [nchar](3) NULL,
	[Weight] [decimal](8, 2) NULL,
	[DaysToManufacture] [int] NOT NULL,
	[ProductLine] [nchar](2) NULL,
	[Class] [nchar](2) NULL,
	[Style] [nchar](2) NULL,
	[ProductSubcategoryID] [int] NULL,
	[ProductModelID] [int] NULL,
	[SellStartDate] [datetime] NOT NULL,
	[SellEndDate] [datetime] NULL,
	[DiscontinuedDate] [datetime] NULL,
	[rowguid] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
);

insert into [stg].dbo.SalesOrderDetail (
	[SalesOrderID],
	[SalesOrderDetailID],
	[CarrierTrackingNumber],
	[OrderQty],
	[ProductID],
	[SpecialOfferID],
	[UnitPrice],
	[UnitPriceDiscount],
	[ModifiedDate]
)
select [SalesOrderID],
	[SalesOrderDetailID],
	[CarrierTrackingNumber],
	[OrderQty],
	[ProductID],
	[SpecialOfferID],
	[UnitPrice],
	[UnitPriceDiscount],
	[ModifiedDate]
from [AdventureWorks2019].[Sales].[SalesOrderDetail]
where ModifiedDate = (select max(ModifiedDate) from [AdventureWorks2019].[Sales].[SalesOrderDetail])

truncate table [stg].dbo.Product;

insert into [stg].dbo.Product (
	[ProductID],
	[Name],
	[ProductNumber],
	[MakeFlag],
	[FinishedGoodsFlag],
	[Color],
	[SafetyStockLevel],
	[ReorderPoint],
	[StandardCost],
	[ListPrice],
	[Size],
	[SizeUnitMeasureCode],
	[WeightUnitMeasureCode],
	[Weight],
	[DaysToManufacture],
	[ProductLine],
	[Class],
	[Style],
	[ProductSubcategoryID],
	[ProductModelID],
	[SellStartDate],
	[SellEndDate],
	[DiscontinuedDate],
	[ModifiedDate])
select 
	[ProductID],
	[Name],
	[ProductNumber],
	[MakeFlag],
	[FinishedGoodsFlag],
	[Color],
	[SafetyStockLevel],
	[ReorderPoint],
	[StandardCost],
	[ListPrice],
	[Size],
	[SizeUnitMeasureCode],
	[WeightUnitMeasureCode],
	[Weight],
	[DaysToManufacture],
	[ProductLine],
	[Class],
	[Style],
	[ProductSubcategoryID],
	[ProductModelID],
	[SellStartDate],
	[SellEndDate],
	[DiscontinuedDate],
	[ModifiedDate]
from [AdventureWorks2019].[Production].[Product]
where ModifiedDate = (select max(ModifiedDate) from [AdventureWorks2019].[Production].[Product]);

where ModifiedDate between 
(select max(ModifiedDate)-1 from [AdventureWorks2019].[Production].[Product])  and 
(select max(ModifiedDate) from [AdventureWorks2019].[Production].[Product]) 

insert into [stg].dbo.SalesOrderHeader (
	[SalesOrderID],
	[RevisionNumber],
	[OrderDate],
	[DueDate],
	[ShipDate],
	[Status],
	[OnlineOrderFlag],
	[SalesOrderNumber],
	[PurchaseOrderNumber],
	[AccountNumber],
	[CustomerID],
	[SalesPersonID],
	[TerritoryID],
	[BillToAddressID],
	[ShipToAddressID],
	[ShipMethodID],
	[CreditCardID],
	[CreditCardApprovalCode],
	[CurrencyRateID],
	[SubTotal],
	[TaxAmt],
	[Freight],
	[Comment],
	[rowguid],
	[ModifiedDate]
)
select
	[SalesOrderID],
	[RevisionNumber],
	[OrderDate],
	[DueDate],
	[ShipDate],
	[Status],
	[OnlineOrderFlag],
	[SalesOrderNumber],
	[PurchaseOrderNumber],
	[AccountNumber],
	[CustomerID],
	[SalesPersonID],
	[TerritoryID],
	[BillToAddressID],
	[ShipToAddressID],
	[ShipMethodID],
	[CreditCardID],
	[CreditCardApprovalCode],
	[CurrencyRateID],
	[SubTotal],
	[TaxAmt],
	[Freight],
	[Comment],
	[rowguid],
	[ModifiedDate]
from
	[AdventureWorks2019].[Sales].[SalesOrderHeader]
where
	ModifiedDate = (select max(ModifiedDate) from [AdventureWorks2019].[Sales].[SalesOrderHeader]);


select d.ProductId,
		d.SalesOrderID,
		d.OrderQty,
		d.UnitPrice,
		d.ModifiedDate
	into ods.[dbo].[FctSales]
from [stg].[dbo].[SalesOrderDetail] d;

create table [ods].[dbo].[DmnOrder] (
	[SalesOrderID] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](25) NOT NULL,
	[AccountNumber] [nvarchar](15) NULL,
	[CreditCardID] [int] NULL,
	[OrderDate] [datetime] NOT NULL,
	[ModifierDate] [datetime] NOT NULL
);

insert into [ods].[dbo].[DmnOrder] (
	[SalesOrderID],
	[SalesOrderNumber],
	[AccountNumber],
	[CreditCardID],
	[OrderDate],
	[ModifierDate]
)
select 
	d.SalesOrderID,
	d.SalesOrderNumber,
	d.AccountNumber,
	d.CreditCardID,
	d.OrderDate,
	d.ModifiedDate
from 
	[stg].[dbo].[SalesOrderHeader] d;

create table [ods].[dbo].[DmnProduct] (
	[ProductID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[ProductNumber] [nvarchar](25) NOT NULL,
	[ModifiedDate] [datetime] NOT NULL
);

insert into [ods].[dbo].[DmnProduct]
	(
	[ProductID],
	[Name],
	[ProductNumber],
	[ModifiedDate]
	)
select 
	ProductID,
	Name,
	ProductNumber,
	ModifiedDate
from [stg].[dbo].[Product];

select ProductID, f.SalesOrderID, h.OrderDate, sum(f.OrderQty * f.UnitPrice) as Sum
into dwh.dbo.FctSales
from [ods].[dbo].[FctSales] f
inner join [ods].[dbo].DmnOrder h on h.SalesOrderID = f.SalesOrderID
where 1=2
group by ProductID, f.SalesOrderID, OrderDate;

MERGE dwh.dbo.FctSales AS TARGET 
USING (
	select ProductID, f.SalesOrderID, h.OrderDate, sum(f.OrderQty * f.UnitPrice) as Sum
	from [ods].[dbo].[FctSales] f
	inner join [ods].[dbo].DmnOrder h on h.SalesOrderID = f.SalesOrderID
	group by ProductID, f.SalesOrderID, OrderDate
) AS SOURCE
ON (
	TARGET.ProductID = SOURCE.ProductID and 
	TARGET.SalesOrderID = SOURCE.SalesOrderID and
	TARGET.OrderDate = SOURCE.OrderDate
)
WHEN MATCHED THEN
	UPDATE SET TARGET.Sum = SOURCE.Sum
WHEN NOT MATCHED THEN 
	INSERT (ProductID, SalesOrderID, OrderDate, Sum)
	VALUES (SOURCE.ProductID, SOURCE.SalesOrderID, SOURCE.OrderDate, SOURCE.Sum);

select SalesOrderID, SalesOrderNumber, AccountNumber, CreditCardID
into dwh.dbo.DmnOrder
from ods.dbo.DmnOrder
where 1=2;

MERGE dwh.dbo.DmnOrder AS TARGET 
USING (
	select SalesOrderID, SalesOrderNumber, AccountNumber, CreditCardID
	from ods.dbo.DmnOrder
) AS SOURCE
ON (
	TARGET.SalesOrderID = SOURCE.SalesOrderID
)
WHEN MATCHED THEN
	UPDATE SET TARGET.SalesOrderNumber = SOURCE.SalesOrderNumber,
			   TARGET.AccountNumber = SOURCE.AccountNumber,
			   TARGET.CreditCardID = SOURCE.CreditCardID
WHEN NOT MATCHED THEN 
	INSERT (SalesOrderID, SalesOrderNumber, AccountNumber, CreditCardID)
	VALUES (SOURCE.SalesOrderID, SOURCE.SalesOrderNumber, SOURCE.AccountNumber, SOURCE.CreditCardID);

select ProductID, Name, ProductNumber
into dwh.dbo.[DmnProduct]
from [ods].[dbo].[DmnProduct]
where 1=2;

MERGE dwh.dbo.[DmnProduct] AS TARGET 
USING (
	select ProductID, Name, ProductNumber
	from ods.dbo.DmnProduct
) AS SOURCE
ON (
	TARGET.ProductID = SOURCE.ProductID
)
WHEN MATCHED THEN
	UPDATE SET TARGET.Name = SOURCE.Name,
			   TARGET.ProductNumber = SOURCE.ProductNumber
WHEN NOT MATCHED THEN 
	INSERT (ProductID, Name, ProductNumber)
	VALUES (SOURCE.ProductID, SOURCE.Name, SOURCE.ProductNumber);

select distinct OrderDate,
				YEAR(OrderDate) as Year,
				MONTH(OrderDate) as Month,
				DATENAME(month, OrderDate) as MonthName,
				DAY(OrderDate) as Day
into dwh.dbo.DmnDate
from [ods].[dbo].[DmnOrder]
where 1=2;

MERGE dwh.dbo.[DmnDate] AS TARGET 
USING (
	select distinct OrderDate,
				YEAR(OrderDate) as Year,
				MONTH(OrderDate) as Month,
				DATENAME(month, OrderDate) as MonthName,
				DAY(OrderDate) as Day
  from [ods].[dbo].[DmnOrder]
) AS SOURCE
ON (
	TARGET.OrderDate = SOURCE.OrderDate
)
WHEN MATCHED THEN
	UPDATE SET TARGET.Year = SOURCE.Year,
			   TARGET.Month = SOURCE.Month,
			   TARGET.MonthName = SOURCE.MonthName,
			   TARGET.Day = SOURCE.Day
WHEN NOT MATCHED THEN 
	INSERT (OrderDate, Year, Month, MonthName, Day)
	VALUES (SOURCE.OrderDate, SOURCE.Year, SOURCE.Month, SOURCE.MonthName, SOURCE.Day);

select * from [dwh].[dbo].[FctSales];