--AGGREGATE WINDOW FUNCTIONS

/*
AGGREGATE FUNCTIONS
1.supported datatypes
COUNT(EXPR) - any data type 
SUM(EXPR) - numeric type    
AVG(EXPR) - numeric type    
MIN(EXPR) - numeric type    
MAX(EXPR) - numeric type    

2. clauses
COUNT(EXPR) PARTITION BY (OPT), ORDER BY(OPT), FRAME CLAUSE(OPT)
SUM(EXPR) PARTITION BY (OPT), ORDER BY(OPT), FRAME CLAUSE(OPT)
AVG(EXPR) PARTITION BY (OPT), ORDER BY(OPT), FRAME CLAUSE(OPT)
MIN(EXPR) PARTITION BY (OPT), ORDER BY(OPT), FRAME CLAUSE(OPT)
MAX(EXPR) PARTITION BY (OPT), ORDER BY(OPT), FRAME CLAUSE(OPT)

3.functions work
COUNT(EXPR) - RETURNS THE NUMBER OF ROWS IN A WINDOW
SUM(EXPR) - RETURNS THE SUM OF VALUES IN A WINDOW     
AVG(EXPR) - RETURNS THE AVG OF VALUES IN A WINDOW
MIN(EXPR) - RETURNS SMALLEST VALUE IN A WINDOW    
MAX(EXPR) - RETURNS BIGGEST VALUE IN A WINDOW 
*/

--COUNT()
--count the total number of products
SELECT
    COUNT(OrderID) OVER() as Total_Orders
from Sales.Orders;

--count the number of orders each product
SELECT 
    ProductID,
    OrderID,
    Sales,
    COUNT(OrderID) OVER(PARTITION BY ProductID) as [Number of Order per Product]
from Sales.Orders;

--count total number of order for each customers
--(used for group wise analysis; to understand patterns within different categories)
SELECT
    CustomerID,
    COUNT(OrderID) OVER(PARTITION BY CustomerID) OrderByCustomers
from Sales.Orders;

--find the total number of customers, also provide all customers details
SELECT
    CustomerID,
    FirstName,
    LastName,
    Country,
    Score,
    COUNT(CustomerID) OVER() Total_Customers
from Sales.Customers;

--find the total number of scores for the customers
SELECT
    CustomerID,
    FirstName,
    LastName,
    Country,
    Score,
    COUNT(CustomerID) OVER() Total_Customers,
    COUNT(Score) OVER() as NoOfScores
from Sales.Customers;

--DATA QUALITY ISSUES
--leads to inaccuracies in results
--COUNT() can be used to identify duplicates

--CHECK whether the table orders contains any duplicate rows
--IF WE WANT TO FILTER THE WINDOW FUNCTION
--We cant wrap the query in SUBQUERY OR CTE(COMMON TABLE EXPRESSION)
SELECT
    OrderID,
    COUNT(OrderID) OVER(PARTITION BY OrderID) as Total_Orders
from Sales.Orders;

SELECT
    OrderID,
    COUNT(OrderID) OVER(PARTITION BY OrderID) as Total_Orders
from Sales.OrdersArchive;
--using group by
SELECT
    OrderID,
    COUNT(OrderID) as duplicacyCheck
from Sales.OrdersArchive
GROUP BY OrderID;

--using the subquery add a filter in the query to see only rows having duplicate data
SELECT
*
FROM(
    SELECT
        OrderID,
        COUNT(OrderID) OVER(PARTITION BY OrderID) duplicacyCheck
    FROM Sales.OrdersArchive
)t WHERE duplicacyCheck > 1

--COUNT USE CASES
/*
1. Overall Analysis
2. Category Analysis
3. Quality checks : Checking Nulls
4. Quality check : Identify Duplicates
*/


--SUM(expr)
--returns the sum of all values within a window

--Find the total sales across all orders and total sales for each product along with all details orderid, and orderdate
SELECT
    OrderID,
    ProductID,
    SUM(Sales) OVER() Total_Sales,
    SUM(Sales) OVER(PARTITION BY ProductID) Total_Sales_of_Products
from Sales.Orders;

SELECT*
from Sales.Orders;

--COMPARISON ANALYSIS / AVERAGE ANALYSIS / PART TO WHOLE ANALYSIS / COMPARE TO EXTREME ANALYSIS
--compare the current value and aggregated value of window functions
--compare current sales to total sales

SELECT
    OrderID,
    ProductID,
    SUM(Sales) OVER() Total_Sales,
    SUM(Sales) OVER(PARTITION BY ProductID) Total_Sales_per_Product,
    MAX(Sales) OVER() Max_sale,
    MIN(Sales) OVER() Min_sale,
    AVG(Sales) OVER() Total_Avg,
    AVG(Sales) OVER(PARTITION BY ProductID) Avg_per_product
from Sales.Orders;

--find the %age contribution of each product's sales to the total sales
SELECT *
FROM(
SELECT
    OrderID,
    ProductID,
    Sales,
    SUM(Sales) OVER() Total_Sales,
    CONCAT(ROUND((CAST(Sales as float) / SUM(Sales) OVER()) * 100, 2), '%') as PercentageOfTotal
    from Sales.Orders)t
    ORDER BY Sales DESC;


--AVG()
--returns the avg of values within a window

--find the avg sales across all orders and avg sales for each product
--and provide details such as orderid and order date
--GROUP WISE ANALYSIS
SELECT
    OrderID,
    ProductID,
    Sales,
    AVG(Sales) OVER() as Overall_AVG,
    AVG(COALESCE(Sales,0)) OVER(PARTITION BY ProductID) as Avg_of_Sales
from Sales.Orders;

SELECT
    CustomerID,
    FirstName,
    LastName,
    AVG(Score) OVER() as AVGScore,
    COALESCE(Score, 0) as CustomerScores,
    AVG(COALESCE(Score, 0)) OVER() as AVGScoreWithoutNulls
from Sales.Customers;

--Find all orders where sales are higher than the avg sales across all orders
--we have used the sub query (because we cant do it in one query)
SELECT *
FROM(
    SELECT
        OrderID,
        ProductID,
        OrderDate,
        Sales,
        AVG(COALESCE(Sales, 0.0)) OVER () AS avg_sales_all
    FROM Sales.Orders
)t
WHERE Sales > avg_sales_all;


--MIN(), MAX()
--returns the lowest value within a window
--returns the highest value within a window

--find the highest sales for each product
--find the lowest sales for each product
SELECT
    OrderID,
    ProductID,
    Sales,
    MAX(Sales) OVER(PARTITION BY ProductID) as MaxSalePerProduct,
    MIN(Sales) OVER(PARTITION BY ProductID) as MinSalePerProduct
from Sales.Orders;

--find the highest and lowest sales across all orders and the highest and lowest sales for each product .
--Additionally provide details such as orderid, orderdate
SELECT
    OrderID,
    OrderDate,
    ProductID,
    MAX(Sales) OVER() as MaxSalesAllOrders,
    MIN(Sales) OVER() as MinSalesAllOrders,
    MAX(Sales) OVER(PARTITION BY ProductID) as MaxSalePerProduct,
    MIN(Sales) OVER(PARTITION BY ProductID) as MinSalePerProduct
from Sales.Orders;

--show the employee who have the highest salary and the lowest salary
SELECT *
FROM(SELECT
    *,
    MAX(Salary) OVER() as HighestSalary,
    MIN(Salary) OVER() as LowestSalary
    from Sales.Employees)t
WHERE Salary = HighestSalary OR Salary = LowestSalary;

--find the deviation of each sales from the max and min sales amounts
SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    MAX(Sales) OVER() HighestSale,
    MAX(Sales) OVER() - Sales as MaxSalesDeviation ,
    MIN(Sales) OVER() LowestSale,
    Sales - MIN(Sales) OVER() as MinSalesDev 
from Sales.Orders;


--RUNNING TOTAL AND ROLLING TOTAL
--they aggregate a squence of members, and the aggregation is updated each time a new member is added

--RUNNING TOTAL - aggregate all values from the beginning up to the current point without dropping off older data (very great in order to tracking or budget tracking or we track the current total sales from the target)
--ROLLING / SHIFTING WINDOW TOTAL  - aggregate all values within a fixed time window (e.g.30DAY) As new data is added the oldest datapoint will be dropped (we always do focused analysis).
/*
MAIN USE - 
1. Tracking current sales with target sales
2. Trend analysis - Providing insights into historical patterns
*/

--RUNNING TOTAL
--THE BELOW QUERY WILL BEHAVE LIKE RUNNING TOTAL
--the default frame is (UNBOUNDED PRECEDING AND CURRENT ROW)
SELECT
    OrderID,
    ProductID,
    OrderDate,
    DATENAME(MM, OrderDate) as MONTH,
    Sales,
    SUM(Sales) OVER(ORDER BY DATENAME(MM, OrderDate)) as TotalSaleForMonths
from Sales.Orders; 

--ROLLING TOTAL
--aggregate values within a fixed window (e.g., last 3 months); as new data is added, the oldest datapoint drops off
--fixed window effect
--summing only the two value above it and itself
--FIRST AGGREGATE BY MONTH, THEN APPLY ROLLING TOTAL
SELECT
    OrderID,
    OrderDate,
    DATENAME(MM, OrderDate) as Month_of_order,
    Sales,
    SUM(Sales) OVER(ORDER BY DATENAME(MM, OrderDate) ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as Rolling_Total_Sales
from Sales.Orders;


--calculate moving avg of sales for each product over time
SELECT
    OrderID,
    ProductID,
    OrderDate,
    Sales,
    AVG(Sales) OVER(PARTITION BY ProductID) as SalesPerProduct,
    AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) as MovingAvg,
    SUM(Sales) OVER(PARTITION BY ProductID) as SumPerProduct,
    SUM(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) as MovingSum
    --default frame =  unbounded preceding and current row
from Sales.Orders;

--calculate the moving avg of sales for each product over time, including only the next order
SELECT
    OrderID,
    ProductID,
    OrderDate,
    Sales,
    AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg
    --default frame =  unbounded preceding and current row
from Sales.Orders;


--USECASES OF AGGREGATE FUNCTIONS

--overall total
SELECT
    OrderID,
    OrderDate,
    Sales,
    SUM(Sales) OVER() TotalSales
from Sales.Orders;

--total per groups
SELECT
    OrderID,
    OrderDate,
    Sales,
    SUM(Sales) OVER(PARTITION BY ProductID) TotalSalesPerProduct
from Sales.Orders;

--running total
--to see progress overtime
SELECT
    OrderID,
    OrderDate,
    Sales,
    SUM(Sales) OVER(ORDER BY OrderDate) TotalSalesPerProduct
from Sales.Orders;

--rolling total
--to see progress over time in a specific timeframe or in a specific fixed window
SELECT
    OrderID,
    OrderDate,
    Sales,
    SUM(Sales) OVER(ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) TotalSalesPerProduct
from Sales.Orders;


--AGGREGATE WINDOW FUNCTIONS SUMMARY

/*
Aggregates set of values and return a single aggregated value
RULES : 
1. Except count() all functions only except numeric arguments
2. All clauses are optional in the over clause (like partition by, order by, frame clause)
USE CASES :
1. Overall Analysis
2. Total Per Group Analysis
3. Part to whole analysis
4. Comparison analysis = (AVG), (EXTREME : Highest / Lowest)
5. Identify Duplicates
6. Identify data quality issues
7. Outlier Detection
8. Running Total
9. Rolling Total
10. Moving AVG
*/