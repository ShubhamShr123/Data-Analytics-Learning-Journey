/*
IF YOU USE AN AGGREGATE FUNCTION IN A QUERY THE EVERY OTHER COL IN THE SELECT LIST MUST BE EITHER
INSIDE AN AGGREGATE FUNCTION OR APPEAR IN THE GROUP BY CLAUSE
*/

--DATEADD(part,interval,date)
--adds or subtracts a specific time interval from or to a date

--increase 2 years, 4 months, and 10 days from every order date
select
	OrderID,
	OrderDate,
	DATEADD(YEAR,2,OrderDate) as two_yrs_later,
	DATEADD(MONTH,-4,OrderDate) as before_4months,
	DATEADD(DAY,-10,OrderDate) as before_10days
from Sales.Orders

--DATEDIFF(part, start_date, end_date)
--find the differences between 2 dates

--find the no of days orders took to ship for each month
select
	FORMAT(OrderDate, 'MMM yyyy'),
	AVG(DATEDIFF(DD, OrderDate, ShipDate)) as avg_delivery_days
from Sales.Orders
Group by FORMAT(OrderDate, 'MMM yyyy')

--Calculate the age of employees
select
	EmployeeID,
	FirstName,
	DATEDIFF(yyyy, BirthDate, GETDATE()) as Age
from Sales.Employees

--TIME GAP ANALYSIS
--will use window func (lag() in order to access a value from the previous value)
--find the no of days between each order and the previus order
select
	OrderID,
	OrderDate as Current_Orderdate,
	LAG(OrderDate) OVER (Order by OrderDate) as Previous_Order_date,--this will find the previuos order date
	DATEDIFF(DAY, LAG(OrderDate) OVER (Order by OrderDate), OrderDate) as NoOfDays
from Sales.Orders
