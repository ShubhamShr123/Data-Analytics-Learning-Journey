--DATE AND TIME
--date format: - YYYY-MM-DD
--time format: - HH:MM:SS
select
	o.OrderID,
	o.OrderDate,
	o.ShipDate,
	o.CreationTime
from Sales.Orders as o

/*
3 different sources in order to query the dates
	I. dates stored inside db (like above)
	II. Hardcoded const str value (means writing date on our own after select '2025-10-30'
	III. using function GETDATE()
*/

--GETDATE
--returns the current date and time at the moment when the query is executed
select
	GETDATE()
--add a col in orders table having current date and time
select
	o.OrderID,
	o.OrderDate,
	o.ShipDate,
	o.CreationTime,
	GETDATE() as Today
from Sales.Orders as o


--MANIPULATING THESE WITH THE HELP OF SQL FUNCTIONS
/*
WE CAN DO
1. PART EXTRACTION (like separate year 2025, separate month 08, separate date 25)
2. CHANGING THE FORMAT of the date and separators also used between them (like 08/20/25, 20 Aug 2025, 20.08.2025)
3. CALCULATION (like adding 3 years, subtracting 30days)
*/


--DATE AND TIME FUNCTIONS
/*
PART EXTRACTION - Day, Month, Year, Datepart, Datename, Datetrunc, Eomonth
FORMAT AND CASTING - Format, Convert, Casting
CALCULATIONS - Dateadd, Datediff
VALIDATION - Isdate
*/