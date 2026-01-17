--CTE (COMMON TABLE EXPRESSIONS)
--what we will learn
/*
CTE TYPES
WHY IS IT IMPORTANT
SYNTAXES
    EXAMPLES
    HOW SQL EXECUTES CTE's step by step
*/

--CTE
--Temprory named result set (virtual table), that can be used mutliple times within your query to simplify and organize complex query

/*
Inside a query
there is cte query and a main query

first between the main and cte query the cte query is executed first
The cte will be having an intermediate virtual table
then the main query will be executed using that virtual table

the main query has two sources of data
1. either get the data directly from the database tables
2. or get the data from the cte virtual table

when everything is done the final result of the main query gonna be presented for the user
as a final result

THE INTERMEDIATE VIRTUAL TABLE THAT IS CREATED BY THE CTE HAS 2 FEATURES:
1. It is temprory (once the query ends the sql gonna go and destroy this virtual table) and we will not be able to query it anymore
2. If use join and want to use this virutal table create by cte it will not be working (because its only available locally within the main query)

We can say its somewhere similar to a subquery but there are differences: 
1. but its more organized and readable
2. the cte is written before the main query (top to bottom) but subquery (bottom to top)
3. the sub query is introducing an intermediate result that is used later from the main query and the same thing for the cte 

MAIN DIFFERENCES BETWEEN CTE AND SUBQUERY
1. In the subquery the result can only be used only once (if we want to use it at multiple places we have to write the subquery multiple times)
2. CTE (we can think this as a virtual table) can be used multiple times within the main query

WHEN TO USE CTE
lets say in a complex sql task we have to do the following:
4. AGGREGATIONS (AVG)
3. JOIN again the same tables in order to prepare the data and perform different aggregations (avg)
2. AGGREGATIONS based on different data (sum)
1. JOIN tables together in order to prepare all the data that we need for the next step

Now normally we were using the subquery
4. AGGREGATIONS (AVG) - Main query     
3. JOIN again the same tables - SUBQUERY
2. AGGREGATIONS based on different data (sum) - SUBQUERY
1. JOIN - SUBQUERY

now if we continue to do this we are in a problem
we are repeating the same step more than once (like the JOIN step)
this is the weak point of the subquery it might introduce redundancy and repetition

Now with CTE we can solve this problem
We will just use the following steps with CTE:
1. Join - CTE Qeury
2. Aggregations (sum) - Main query
3. Aggregations (AVG) - Main query

so the step 1 will me used more than once as being a CTE which will reduce redundancy and repetition and the size of the query

USING THE CTE
we have to select different different stuff 

1. like we have to find the top cusotmers
so we will put this in one 

CTE_TOP_CUSTOMERS
(select --- from customers where ---)

2. have to get the data of top products 
CTE_TOP_PRODUCTS
(select --- from products where ---)

3. have to get the daily revenue
CTE_DAILY_REVENUE
(select --- from orders where ---)

Once we have all those parts
we can put everything together in the main query

select --
---
---

So now our code is divided into different sections with increased readability, organizaiton, Reusability and modularity(breaking queries into parts or chunks)


HOW DATABASE EXECUTES CTE'S STEP BY STEP
1. let suppose making a cte query (with details as(select --- from customers where ---))
2. now we are writing the main query (select -- from orders join details join details join details)
3. the database engine will read they query and will keep the cte at its priority
4. first it will execute the cte query and create an intermediate virtual table (details) and will store the result named DETAILS in the cache memory (very fast memory)
5. now it will execute the main query using the orders table that is in the disk storage and the intermediate virtual table CTE (details) at high speeds because it is stored in the cache memory which is way faster than retrieving data from disk storage like table orders which is storder in disk (hdd or ssd which is slower than cache memory) 


CTE TYPES:
1. RECURSIVE CTE
2. NON RECURSIVE CTE - two types
    a. SIMPLE CTE (standalone cte) - Define and used independently (runs independently and its self contained and doesnt rely on other CTE's or quries)
    means the CTE can qurey data from the database tables directly and the main query can use the CTE virtual table directly INDEPENDENT FROM ANYTHING ELSE

    b. NESTED CTE (cte inside another cte) - uses the result of another CTE, so it can't run independently.

SYNTAX STANDALONE CTE:
WITH CTE_NAME As (
select column1, column2, ...
from table_name
where condition
)
select column1, column2, ...
from CTE_NAME
where condition;

outside this definition
we can use this cte like above
*/

--STANDALONE CTE
--Find the total sales per customer using CTE
WITH CTE_TOTAL_SALES AS (
    SELECT
    CustomerID,
    SUM(Sales) as Total_Sales
from Sales.Orders
GROUP BY CustomerID
)
SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.Country,
    cts.Total_Sales
from Sales.Customers as c
LEFT JOIN CTE_TOTAL_SALES As cts
on c.CustomerID = cts.CustomerID
ORDER BY c.CustomerID;
--normal way without CTE
SELECT
    CustomerID,
    SUM(Sales) as Total_Sales
from Sales.Orders
GROUP BY CustomerID;

--MULTIPLE STANDALONE CTE
--syntax
/*
WITH CTE_NAME As (
select column1, column2, ...
from table_name
where condition
)
,CTE_NAME2 As(
select column1, column2, ...
from table_name
where condition
)
,CTE_NAME3 As(
select column1, column2, ...
from table_name
where condition
)
,CTE_NAME4 As(
select column1, column2, ...
from table_name
where condition
)
select column1, column2, ...
from CTE_NAME
where condition;
*/

--step1 = find the total sales per customer
--step2 = find the last order date per customer
WITH CTE_TOTAL_SALES as (
    SELECT
        CustomerID,
        SUM(Sales) as TotalSales
    from Sales.Orders
    GROUP BY CustomerID
)
, CTE_LAST_ORDER AS (
    SELECT
        CustomerID,
        MAX(OrderDate) as LastOrder
    from Sales.Orders
    GROUP BY CustomerID
)
SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ',c.LastName) as FullName,
    cts.TotalSales,
    clo.LastOrder
from Sales.Customers as c
LEFT JOIN CTE_TOTAL_SALES AS cts
on c.CustomerID = cts.CustomerID
LEFT JOIN CTE_LAST_ORDER AS clo
on c.CustomerID = clo.CustomerID


--NESTED CTE (CTE INSIDE ANOTHER CTE)
--just like nested loops and nested conditional statements we have learnt in python
--syntax
/*
WITH CTE_NAME As ( --STANDALONE CTE
select column1, column2, ...
from table_name
where condition
)
,CTE_NAME2 As( --NESTED CTE
select column1, column2, ...
from CTE_NAME
where condition
)
SELECT
FROM CTE_NAME2
where----

so above basically the cte_name2 cte is dependent on the cte_name
cte
*/

--step1 = find the total sales per customer
--step2 = find the last order date per customer
--step3 = Rank customer based on total sales per customer
--step4 = segment customers based on their total sales

WITH CTE_TOTAL_SALES as (
    SELECT
        CustomerID,
        SUM(Sales) as TotalSales
    from Sales.Orders
    GROUP BY CustomerID
)
, CTE_LAST_ORDER AS (
    SELECT
        CustomerID,
        MAX(OrderDate) as LastOrder
    from Sales.Orders
    GROUP BY CustomerID
)
, CTE_RANK_CUSTOMERS AS (
    SELECT
        CustomerID,
        TotalSales,
        DENSE_RANK() OVER (ORDER BY TotalSales DESC) AS CustomerRank
    from CTE_TOTAL_SALES
)
, CTE_CUST_SEGMENT AS (
    SELECT
        CustomerID,
        CASE
            WHEN TotalSales > 100 THEN 'HIGH'
            WHEN TotalSales BETWEEN 50 AND 100 THEN 'MED'
            ELSE 'LOW'
        END AS SalesFrequency
    from CTE_TOTAL_SALES
)
SELECT
    c.CustomerID,
    CONCAT(c.FirstName, ' ', c.LastName) as FullName,
    clo.LastOrder,
    cts.TotalSales,
    crc.CustomerRank,
    ccs.SalesFrequency
from Sales.Customers as c 
LEFT JOIN CTE_TOTAL_SALES as cts
on c.CustomerID = cts.CustomerID
LEFT JOIN CTE_LAST_ORDER as clo
on c.CustomerID = clo.CustomerID
LEFT JOIN CTE_RANK_CUSTOMERS as crc
on c.CustomerID = crc.CustomerID
LEFT JOIN CTE_CUST_SEGMENT as ccs
on c.CustomerID = ccs.CustomerID
WHERE cts.TotalSales is not NULL
ORDER BY crc.CustomerRank

--CTE BEST PRACTICES
/*
1. Rethink and refactor your cte's before starting a new one (means if one cte can do the work of both the two cte's then there is no sense of making a new one)
2. Dont use more than 5 cte's in a query otherwise our code will be hard to understand and maintain
*/