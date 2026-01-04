--RANKING FUNCTIONS

/*
In the first step the sql sorts in desc befre data ranking  

TYPES OF RANKING FUNCTIONS
1. INTEGER BASED RANKING - gives integer values as rank based on the values (top/bottom n analysis) [row_number(), rank(), dense_rank(), ntile(number)]

2. PERCENTAGE BASED RANKING - gives percentage values as rank based on the values (from the scale of 0 to 1) (distribution analysis) [cume_dist(), percent_rank()]

Rank functions must be empty (they dont accept any arguments) except for ntile()
PARTITION BY clause is optional
ORDER BY clause is mandatory
Frame clause is not allowed
*/

--ROW_NUMBER() - gives unique number as rank to each row / and it doesnt consider ties(means if two values are same it will give different ranks)

SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    ROW_NUMBER() OVER(ORDER BY Sales DESC) as SalesRank
from Sales.Orders;

--RANK() - gives number as rank to each row / and it considers ties(means if two values are same it can have same ranks) it leaves gaps in ranking
--means if the 2nd and 3rd value are same and both got the rank 2 then the 4th value will get the rank as 4 rather then getting 3
SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    ROW_NUMBER() OVER(ORDER BY Sales DESC) as SalesRank
from Sales.Orders;

--DENSE_RANK() - assigns rank to each row / it considers ties (means if two values are same it can have same ranks) but it doesnt leaves gaps in ranking
SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    DENSE_RANK() OVER(ORDER BY Sales DESC) as SalesRank
from Sales.Orders;

/*(row_number() = unique rank without gaps and doesnt consider ties,
rank() = shared rank with gaps & handles ties,
dense_rank() = shared rank without gaps & handles ties*/


--ROW_NUMBER()
--use cases - TOP N ANALYSIS
--find the top highest sales for each product
SELECT
    OrderID,
    OrderDate,
    ProductID,
    Sales,
    ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales desc) as Rank_by_Prod 
from Sales.Orders;
--now to filter above data we have to use subqueries
SELECT *
FROM(
    SELECT
        OrderID,
        OrderDate,
        ProductID,
        Sales,
        ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales desc) as Rank_by_Prod 
    from Sales.Orders)t
WHERE Rank_by_Prod = 1;

--BOTTOM N ANALYSIS
--find the lowest 2 customers based on their total sales
--with more details such as fullname, country name
--to filter we are using the subquery
SELECT
    t.CustomerID,
    CONCAT(c.FirstName,' ' ,c.LastName, '-', c.Country) as FullNameWithCountry,
    t.Total_Sales,
    t.Rank_by_cust
FROM(
SELECT 
    CustomerID,
    SUM(Sales) as Total_Sales,
    ROW_NUMBER() OVER(ORDER BY SUM(Sales) ASC) as Rank_by_cust
from Sales.Orders
GROUP BY CustomerID)t
INNER JOIN Sales.Customers as c
on t.CustomerID = c.CustomerID
WHERE t.Rank_by_cust <= 2;

--GENERATE UNIQUE IDs
--these unique id's can be used as an identifier
-- and used for paginating (process of breaking down a large data set into smaller manageable chunks)
--assign unique IDs to the rows of the ordersarchieve table
SELECT
    OrderID,
    OrderDate,
    CustomerID,
    Sales,
    ROW_NUMBER() OVER(ORDER BY OrderID,OrderDate) as Unique_ID
from Sales.OrdersArchive;

--IDENTIFY DUPLICATES
--identify duplicates rows in the table ordersarchive and return a clean result without duplicates
/*
PARTITION BY OrderID - Divides the data into groups by OrderID. The row numbering resets to 1 for each new OrderID group
ORDER BY CreationTime - Within each OrderID partition, rows are numbered in the order of CreationTime (earliest first)
*/
SELECT *
FROM (
SELECT
    OrderID,
    ProductID,
    OrderDate,
    CustomerID,
    ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime) as rn
from Sales.OrdersArchive)t
where rn=1;
--to see any duplicate data
SELECT *
FROM (
SELECT
    OrderID,
    ProductID,
    OrderDate,
    CustomerID,
    ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime) as rn
from Sales.OrdersArchive)t
where rn>1;

--SUMMARY (ROW_NUMBER()) USECASES
/*
TOP N ANALYSIS
BOTTOM N ANALYSIS
ASSIGN UNIQUE IDS for duplicacy check
QUALITY CHECKS: Identify Duplicates
*/

--NTILE(number_of_buckets)
--divides the rows into a specified number of approximately equal groups (Buckets)
--we have to define a numerical value inside the ntile
--Bucket size = Number of row / Number of buckets

/*
NTILE(2)
LIKE WE HAVE A DATA
SALES | NTILE
100   | 1
80    | 1
80    | 2
50    | 2

the bucket size is calulcated with the help of total number of rows / number of buckets
4/2 = 2 (means each bucket will have 2 rows)
WE CAN SEE THAT THE DATA IS DIVIDED INTO 2 BUCKETS
where the first 2 rows are in bucket 1 and the next 2 rows are in bucket 2

If there are odd number of rows then the extra row will be added to the earlier buckets
NTILE(2)
LIKE WE HAVE A DATA
SALES | NTILE
100   | 1
80    | 1
80    | 1
50    | 2
30    | 2

so above we have 5 rows and 2 buckets
sql rule = larger groups come first
*/

--NTILE()
SELECT
    OrderID,
    Sales,
    NTILE(1) OVER(ORDER BY Sales DESC) as Bucket1,
    NTILE(2) OVER(ORDER BY Sales DESC) as Bucket2,
    NTILE(3) OVER(ORDER BY Sales DESC) as Bucket3
from Sales.Orders;

--NTILE() usecase
--will do data segmentation as a data analyst
--equalizing load processing and etl as a data engineer

--DATA SEGMENTATION
--divides a dataset into distinct subsets based on certain criteria.
--for ex - like grouping up the customers based on their behaviour
--(we can segment customer with their sales, employees with their slaries, products by prices and so on)

--segment all orders into 3 categories high, medium and low sales
SELECT
    OrderID,
    ProductID,
    Sales,
    CASE Sales_Rank
    WHEN 1 THEN 'HIGH'
    WHEN 2 THEN 'MID'
    WHEN 3 THEN 'LOW'
    END as Sales_Rank
FROM(SELECT
        OrderID,
        ProductID,
        Sales,
        NTILE(3) OVER(ORDER BY Sales DESC) as Sales_Rank
from Sales.Orders)t

--EQUALIZING LOAD
--load balancing

/*
When moving large table from one db to another db
if we move the full table in one go which is large it may take a long time and we can get errors too
so we can transfer the table to another db in parts to make sure we dont get errors
after transfering we can use the union to see the full table
*/

--in order to export the data devide the orders table into two groups
SELECT *,
    NTILE(2) OVER(ORDER BY OrderID ASC) as Table_Group
from Sales.Orders;

--%AGE BASED RANKING
--cume_dist(), percent_rank()
--these functions are amazing in order to do distribution analysis


--CUME_DIST()
--cumulative distribution calculates the distribution of data point within a window
--CUME_DIST = position number of the value / number of rows
--tie rule = the position of the last occurence of the same value will be considered as the position number of the value
--Inclusive (the current row is included)
--range [0, 1] never 0

SELECT
    OrderID,
    ProductID,
    Sales,
    CUME_DIST() OVER(ORDER BY Sales DESC)
FROM Sales.Orders;

--find the product that falls within the highest 40% of prices

SELECT
    ProductID,
    Product,
    Category,
    Price,
    Price_Rank,
    CONCAT(Price_Rank * 100, '%') as Dist_Rank
FROM(SELECT
        ProductID,
        Product,
        Category,
        Price,
        CUME_DIST() OVER(ORDER BY PRICE DESC) as Price_Rank 
FROM Sales.Products)t
WHERE Price_Rank<=0.4;


--PERCENT_RANK()
--calculates the relative position of each row within a window
--PERCENT_RANK = postition number of the value - 1 / number of rows - 1
--tie rule = the position of the first occurence of the same value will be considered as the position number of the value
--Exclusive (the current row is exclusive)
--range [0, 1] can be 0

SELECT
    OrderID,
    ProductID,
    Sales,
    ROUND(PERCENT_RANK() OVER(ORDER BY Sales DESC), 2)as Rank_Percentage
FROM Sales.Orders;

--find the product that falls within the highest 40% of prices
SELECT
    ProductID,
    Product,
    Category,
    Price,
    Price_Rank,
    CONCAT(Price_Rank * 100, '%') as Dist_Rank
FROM(SELECT
        ProductID,
        Product,
        Category,
        Price,
        PERCENT_RANK() OVER(ORDER BY PRICE DESC) as Price_Rank 
FROM Sales.Products)t
WHERE Price_Rank<=0.4;


--RANK WINDOW FUNCTIONS SUMMARY
/*
Assign a rank for each row within a window

Types

INTEGER BASED RANKING
1. ROW_NUMBER()
2. RANK()
3. DENSE_RANK()
4. NTILE()

PERCENTAGE BASED RANKING
1. CUME_DIST()
2. PERCENT_RANK()

RULES
1. expression should be empty (arguments not allowed)
2. we must use order by
3. frame clause is not allowed

USECASES
1. top n alaysis / bottom n alaysis
2. Identify and remove duplicates
3. find data quality issues
4. generate unique id's (if our table dont have clean primary key) + paginating
5. data segmentation
6. data distribution analysis
7. Equalizing load processing

*/