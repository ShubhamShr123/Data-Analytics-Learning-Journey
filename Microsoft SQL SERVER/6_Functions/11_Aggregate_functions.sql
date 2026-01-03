use SalesDB;

--COUNT (*) - Counts all rows in a specified table, including those with NULL values.
SELECT 
    COUNT(*) AS TotalRows
from Sales.Customers;
--if you want to count only non-NULL values in a specific column, use COUNT(column_name) instead.
SELECT
    COUNT(Score)
from Sales.Customers;

--SUM(column_name) - Calculates the total sum of a numeric column, ignoring NULL values.
SELECT
    SUM(Sales) as TotalSales
from Sales.Orders;

--AVG(column_name) - Computes the average value of a numeric column, ignoring NULL values.
SELECT
    Country,
    AVG(Score) as AverageScore
from Sales.Customers
GROUP BY Country
ORDER BY AverageScore DESC;

--MIN(column_name) - Finds the minimum value in a specified column, ignoring NULL values.
SELECT
    MIN(Sales) as MinimumSales
FROM Sales.Orders;

--MAX(column_name) - Finds the maximum value in a specified column, ignoring NULL values.
SELECT
    MAX(Sales) as MaximumSales
from Sales.Orders;


--find the total / avg sales, max and min sales of all order of all orders for all the customers
SELECT
    CustomerID,
    COUNT(*) as TotalOrders,
    SUM(Sales) as Total_Sales,
    AVG(Sales) as AVG_Orders,
    MAX(Sales) as Max_sales,
    MIN(Sales) as Min_sales
from Sales.Orders
GROUP BY CustomerID