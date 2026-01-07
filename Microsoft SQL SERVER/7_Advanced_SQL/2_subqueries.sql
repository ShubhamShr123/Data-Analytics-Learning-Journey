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

--subquery logical operators

--subquery in operator
--used to check whether a value matches any value from a list.

--show the details of orders made by customers in Germany
SELECT
*
FROM Sales.Orders

--subquery any operator
--checks if a value matches any value within a list.
--used to check if a val is true for at least 1 of the values in the list

--find female employees whose salaries are greater than the salaries of any male employee
SELECT
*
FROM Sales.Employees
WHERE CustomerID in (SELECT CustomerID FROM Sales.Customers WHERE COUNTRY = 'Germany'); 
WHERE Gender = 'F' and Salary > ANY(SELECT Salary FROM Sales.Employees WHERE Gender = 'M');

--subquery all operator
--check if a value matches ALL values within a list

--find female employees whose salaries are greater than the salaries of all male employees
SELECT
*
FROM Sales.Employees
WHERE Gender = 'F' and Salary>ALL(SELECT Salary FROM Sales.employees WHERE Gender = 'M');

--SUBQUERY (CO RELATED / NON CO RELATED)
--before this all the subqueries we learnt were non co related

--NON CO RELATED SUBQUERY - a subquery that can run independently from the main query

--CO RELATED SUBQUERY - a subquery that depends on the main query for its values
/*
- Dependency on outer query: The inner query references columns from the outer query, making them “correlated.”
- Row-by-row execution: Unlike a regular subquery (which runs once independently), a correlated subquery runs repeatedly—once for each row processed by the outer query.
- Dynamic evaluation: Results change depending on the current row being evaluated in the outer query.
- Common use cases: Filtering, comparisons, conditional updates, and ranking.
*/

--show all customer details and find the total orders for each customer

--with corelated subquery
SELECT
*,
(SELECT COUNT(OrderID) from Sales.Orders as o WHERE c.CustomerID = o.CustomerID) TotalOrders
from Sales.Customers as c;

--with join and subquery (old way)
SELECT
c.*,
o.TotalOrders
from Sales.Customers as c
left JOIN 
    (SELECT
    CustomerID,
    COUNT(OrderID) as TotalOrders    
    from Sales.Orders
    GROUP BY CustomerID) o
on c.CustomerID = o.CustomerID;

/*
CoRelated                    |       NonCoRelated
---------------------------------------------------------------------------
subquery is idependent       |subquery is dependent on main query from main query    
subquery runs once           |   subquery runs multiple times (for each row of main query
can be exeucted alone        |   cannot be executed alone
easier to read and understand|harder to read and understand
executed only once leads to  | executed multiple times leads to poor performance
better performance 
static comparisons, filtering|Rows by row comparisons, Dynamic filtering
with constants
*/

--subquery EXISTS operator
--check if a subquery returns any rows

--co related subquery in where clause in where clause exists operator
/*
SELECT col1, col2
from table
where EXISTS(select 1
from table2
where table.id = table2.id)

here we are just checking if the subquery is return atleast 1 row
no othe
*/

--show the details of orders made by customers in germany
SELECT
*
FROM Sales.Orders as o
WHERE EXISTS (SELECT
*
FROM Sales.Customers as c
where Country = 'Germany'
and o.CustomerID = c.CustomerID);
--above in the subquery no matter what we are writing in the select list (it is ignored by the EXIST operator)
--show the details of orders not made by customers in germany
SELECT
*
FROM Sales.Orders as o
WHERE NOT EXISTS (SELECT
*
FROM Sales.Customers as c
where Country = 'Germany'
and o.CustomerID = c.CustomerID);
--above the results are row by row evaluated (means the condition is checked row by row)


--SUBQUERY SUMMARY
/*
Query inside another QUERY
breakes a complex query into smaller, manageable pieces

USECASES
1. Create temp result sets
2. Prepare data before joining TABLE
3. Dynamic and complex filtering
4. Check the existence of rows from another table(EXISTS)
5. Row by Row comparison - corelated subquery
*/



