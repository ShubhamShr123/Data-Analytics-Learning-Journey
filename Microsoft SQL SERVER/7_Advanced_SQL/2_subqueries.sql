--SUBQUERY
--Query inside another query is called subquery
--the subquery supports the main query with data
--the subquery can only be used from the main QUERY

/*
step 1 - Aggregations - (subquery)
step 2 - Transformations - (subquery)
step 3 - Filtering - (subquery)
step 4 - Join Tables - (MAIN Query)

We will be having different queries for every step
*/

--SUBQUERY CATEGORIES
--WHEN TO USE SUBQUERIES
/*
DEPENDENCY BETWEEN THE SUBQUERY AND THE MAIN QUERY
Mainly 2 types of subqueries 
[Non corelated subquery (independent from the main query)
, Corelated subquery (unindipendent from the main query)]

HOW TO GROUP UP THE SUBQUERIES DEPENDING ON THE RESULT TYPE
Scalar Subquery - it returns only 1 single value
Row Subquery - return multiple rows
Table Subquery - returns multiple rows and cols

LAST WAY TO CATEGORIZE SUBQUERY
(Based on the location and clauses)
We are describing here where the subquery gonna be used within the main query
Select
From
Join
Where - (can be uesd with -(Commparison Operators), (Logical Operators (in, any, all, EXISTS)))
*/


--SUBQUERY (RESULT TYPES)
--1. Scalar subquery - only 1 single value
SELECT
    SUM(Sales) as SumOfSales
FROM Sales.Orders;
--the result of above will be a single value we call that value a scalar value

--2. Row subquery - Returns multiple rows as output
SELECT
    CustomerID
FROM Sales.Orders;
--the result of above will be a full row which we call Row Query

--3. Table subquery - Returns multiple cols and rows as outupt
SELECT
    *
FROM Sales.Orders;
--the result of above will be a full table (having multiple cols and rows)


--SUBQUERY (From Clause)
--Used as temporary table for the main query
/*
example of subquery -
SELECT col1, col2
FROM(SELECT col FROM table1 WHERE condition)as alias
*/
--Find the products that have a price higher than the avg price of all products

--main query
SELECT
    ProductID,
    ProductID,
    AVG_Price,
    Price,
    Price - AVG_Price as PriceDeviation
FROM(SELECT--subquery
    ProductID,
    Product,
    Price,
    AVG(Price) OVER() AVG_Price
FROM Sales.Products)t
WHERE Price>AVG_Price;

--Rank the customers based on their total amount of sales
SELECT
    *,
    DENSE_RANK() OVER(ORDER BY TotalSales DESC) as Rank
FROM
    (SELECT
    CustomerID,
    SUM(Sales) as TotalSales
    FROM Sales.Orders
    GROUP BY CustomerID)t;

/*
How the query is exeucted above:
1. Subquery - the subquery is exeucted first
(the subquery fetches all the data we want and groups the rows by customers)
2. MainQuery - the main query is executed last
(the main query is executed at last and the selected results from the subquery are taken and ranked based on their total sales)
*/

--SUBQUERY (SELECT)
--used to aggregate data side by side with the main query's data, allowing direct comparison
--only scalar subqueries are allowed to be used (the result must be a single value, We can understand why by seeing the example below)

--show the prod ids, prod names, prices, and the total number of orders
SELECT
    ProductID,
    Product,
    Price,
    (SELECT
        COUNT(OrderID)
    FROM Sales.Orders) as TotalOrders
FROM Sales.products;


--SUBQUERY (JOIN)
--used to prepare the data (filtering or aggregation)
--to dynamically create a result sets for joining with another table

--show all the customer details and find the total orders of each customer
SELECT
c.*,
o.CountOfOrders
FROM Sales.Customers as c
LEFT JOIN(
    SELECT
    CustomerID,
    COUNT(OrderID) as CountOfOrders
    from Sales.Orders
    GROUP BY CustomerID) as o
on c.CustomerID = o.CustomerID

--SUBQUERY (WHERE)
--used for complex filtering logic and makes query more flexible and dynamic
--we can use COMPARISON, LOGICAL OPERATORS
--only scalar subquery is allowed ONLY
--the subquery should only be returning single value

/*
SELECT col1, col2
FROM Table
WHERE col = (SELECT col FROM table2 where condition)
*/
--subquery comparison operator
--find the products that have a price higher than the avg price of all products
SELECT
    ProductID,
    Product,
    Price,
    (SELECT AVG(Price) FROM Sales.Products) as AVGPrice
from Sales.Products
WHERE Price > (SELECT AVG(Price) FROM Sales.Products);

--SUBQUERY LOGICAL OPERATORS

--subquery in operator
--used to check whether a value matches any value from a list.

--show the details of orders made by customers in Germany
SELECT
*
FROM Sales.Orders
WHERE CustomerID in (SELECT CustomerID FROM Sales.Customers WHERE COUNTRY = 'Germany'); 

--subquery any operator
--checks if a value matches any value within a list.
--used to check if a val is true for at least 1 of the values in the list

--find female employees whose salaries are greater than the salaries of any male employee
SELECT
*
FROM Sales.Employees
WHERE Gender = 'F' and Salary > ANY(SELECT Salary FROM Sales.Employees WHERE Gender = 'M');

--subquery all operator
--check if a value matches ALL values within a list

--find female employees whose salaries are greater than the salaries of all male employees
SELECT
*
FROM Sales.Employees
WHERE Gender = 'F' and Salary>ALL(SELECT Salary FROM Sales.employees WHERE Gender = 'M');
