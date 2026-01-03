--DATE AGGREGATION USE CASES

--return how many orders were placed each year
select
	YEAR(OrderDate) as Order_year,
	Count(OrderID) as Orders_Places
from Sales.Orders
group by YEAR(OrderDate)
--return how many orders were placed each year with month
select
	DATENAME(MM, OrderDate) as Order_Month,
	Count(OrderID) as Orders_Places
from Sales.Orders
group by DATENAME(MM, OrderDate)

--PART EXTRACTION USE CASES (DATA FILTERING)
--TIP: - filtering data using int is faster than using str

--show all orders that are placed during the month of feb
select
	DATENAME(MM, OrderDate) as Order_month,
	COUNT(OrderId) as Orders_Placed
from Sales.Orders
where Month(OrderDate) = 02
group by DATENAME(MM, OrderDate)


/*
DATATYPE OF THE RESULTS: -
DAY, MONTH, YEAR, DATEPART = int
DATENAME = str
DATETRUNC = Datetime
EOMONTH = Date 
*/