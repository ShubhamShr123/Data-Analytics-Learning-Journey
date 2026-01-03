--JOINTING TWO OR MORE TABLES
--their can be a master table means the main tables
--the other tables with be for extra information
use SalesDB

--using the salesdb, retrieve a list of all orders, 
--along with the related customer, product, and emp details
--here the master table is the orders table
select
	O.OrderID,
	O.Sales,
	O.CustomerID,
	c.FirstName,
	c.LastName,
	c.Country,
	c.Score,
	p.Product,
	p.Category,
	e.EmployeeID as SalesPersonID,
	e.FirstName as SalesPersonName,
	e.ManagerID
from Sales.Orders as o
left join Sales.Customers as c
on o.CustomerID = c.CustomerID
left join Sales.Products as p
on o.ProductID = p.ProductID
left join sales.Employees as E
on e.EmployeeID = o.SalesPersonID