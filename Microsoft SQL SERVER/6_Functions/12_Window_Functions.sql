use SalesDB;
--WINDOW FUNCTIONS
--perform calculations (e.g. aggregation) on a specific subset of data, without losing the level of details of each row
/*
it is very similary to the group by

lets suppose we have 4 orders
order_id | Product | Sales
1        | CAPS       | 10
2        | CAPS       | 30
3        | GLOVES       | 5
4        | GLOVES       | 20

If we want to calculate the total sales for each product earlier we were using GROUP BY:
that group by was combining the same product rows into one row like (2 caps rows become 1 row with total sales 40 and 2 gloves rows become 1 row with total sales 25)
the output will be like this:

Product | Total_Sales
CAPS       | 40
GLOVES       | 25

IF WE USE WINDOW FUNCTIONS:
to find the total sales for each product without losing the details of each order row we can use window functions (it performs row level calculations)

the output will be like this:
order_id | Product | Sales | Total_Sales
1        | CAPS       | 10    | 40
2        | CAPS       | 30    | 40
3        | GLOVES       | 5     | 25
4        | GLOVES       | 20    | 25   


so by using the window function we are able to see the total sales for each product while still keeping the details of each order row on the other hand group by would have combined the rows and we would have lost that details

so difference
GROUP BY            | WINDOW FUNCTION
simple aggregations | aggregations + details of each row
simple data analysis | advanced data analysis

GROUP BY FUNCTIONS
Aggregate functions : count, sum, avg, min, max

WINDOW FUNCTIONS FUNCTIONS
Aggregate functions [EXCEPT COUNT (only numeric datatype is allowed)] : count(expr), sum(expr), avg(expr), min(expr), max(expr)
Ranking functions [EMPTY] : row_number(), rank(), dense_rank(), cume_dist(), percent_rank(), ntile(number)
Value (analytic) functions [ALL DATA TYPE] : lead(expr, offset, default), lag(expr, offset, default), first_value(expr), last_value(expr), nth_value(expr, n)
*/

--we will find why group by is not sufficient and how window functions can help us:

--Find the total sales across all orders
SELECT
    SUM(Sales) AS Total_Sales
fROM Sales.Orders;

--Find the total sales for each product
SELECT
    ProductID,
    SUM(Sales) AS Total_Sales
from Sales.Orders
GROUP BY ProductID
ORDER BY Total_Sales DESC;

--Find the total sales for each product along order id and Order date
SELECT
    OrderID,
    ProductID,
    OrderDate,
    Sales,
    SUM(Sales) Total_Sales
from Sales.Orders
GROUP BY OrderID;
--this query will give error because we are using group by on order id only so we cant select other columns without aggregating them

--now using window functions we can achieve this
SELECT
    OrderID,
    ProductID,
    OrderDate,
    SUM(Sales) OVER(PARTITION BY ProductID) AS Total_Sales_by_Product
from Sales.Orders;
/*1. here we will get 10 rows because window functions returns a result for each row
2. we are using OVER() clause to specify that we are using window function
3. PARTITION BY is similar to GROUP BY 
4. it divides the result set into partitions to which the window function is applied
5. above query will give total sales for each product along with order id and order date*/

--WINDOW FUNCTIONS SYNTAX
/*
1. window function (any aggregate / ranking / value(analytics functions) function)
    1.1 like = AVG(Sales) inside avg there is a function expression (arguments we pass to a function)
2. OVER (partition clause, Order by clause, frame clause)
    2.2 all the argument inside over are optional we can leave it empty
--for ex we have the following query
AVG(Sales) OVER(Partition By Category Order by OrderDate)
*/


--PARTITION BY
--divides the result set into partitions to which the window function will be applied
--if we dont use partition by then the entire result set is treated as a single partition
--and calculation is performed on entire data set
--if we apply the PARTITION BY then calculation is done individually on each window(partition)
--Flexibility of window : allows aggregation of data at different granularities within the same query 
/*
let suppose we have data of
Month | Product | Sales  (having the month of order, product name and sales)

if we apply (SUM(Sales) OVER())  --> no partition by
then it will give total sales across all months and products
means if we have 10 rows it will return total sales across all rows (entire result set) because we haven't used the PARTITION BY clause

IF WE APPLY SUM(Sales) OVER(PARTITION BY Month)
then it will give total sales for each month
*/

--Find the total sales across all orders additionally provide details order id and order date
SELECT
    OrderID,
    OrderDate,
    SUM(Sales) OVER() as Total_Sales
from Sales.Orders;

--Find the total sales for each product, additionally provide details such as order id and order date

SELECT
    o.OrderID,
    p.ProductID,
    p.Product,
    o.OrderDate,
    SUM(o.Sales) OVER(PARTITION BY o.ProductID) as Total_Sales
from Sales.Orders as o
LEFT JOIN Sales.Products as p
on o.ProductID = p.ProductID;

--Find the total sales for each combination of product and order status
SELECT 
    o.OrderID,
    o.ProductID,
    p.Product,
    o.OrderStatus,
    SUM(o.Sales) OVER(PARTITION BY o.ProductID, o.OrderStatus) as [TotalSalesByProdct&OrderStatus]
from Sales.Orders as o
LEFT JOIN Sales.Products as p
on o.ProductID = p.ProductID
ORDER BY o.OrderStatus;

--ORDER BY (SORT THE DATA WITHIN A WINDOW ASC/DESC)
--for the RANK FUNCTIONS AND VALUE FUNCTIONS they are must

--rank each order based on their sales from highest to lowest additionally provide order id and order date 
SELECT
    OrderID,
    OrderDate,
    Sales,
    RANK() OVER (ORDER BY Sales DESC) RankSales
from Sales.Orders;


--WINDOW FRAME CLAUSE
--defines a subset of rows within each window that is relevant for the calculation

/*
understanding with the help of an example

1. we have entire data
2. let suppose after putting a partition by the data is partitioned in 2 windows
3. now what frame does is (selects a subset of data from a window on which the calculations need to be done (means window inside a window))
4. We are here defining scope of rows (means all the rows in the windows should not be included in the calculation only the chosen rows should be included)
*/

/*
SYNTAX OF FRAME CLAUSE
1. AVG(Sales) 2. OVER(3. PARTITION BY Category 3. ORDER BY OrderDate 4. ROWS BETWEEN CURRENT ROW AND UNBOUNDED PRECEEDING) 

[] MEANS on the keywords means they are used above in the syntax

I.FRAME TYPES = [ROWS], RANGE (means on the place of rows the range can also be used)
II. [BETWEEN]
III. FRAME BOUNDARY (Lower Value) = [CURRENT ROW] (accepts 3 types of keywords : CURRENT ROW, N PRECEEDING (number of preceeding), UNBOUNDED PRECEEDING)
IV. FRAME BOUNDARY (Higher Value) = accepts 3 types of keywords : ([CURRENT ROW], N FOLLOWING, UNBOUNDED FOLLOWING)
*/

/*
RULES OF FRAME CLAUSE
1. can only be used together with order by clause
2. Lower Value must be before the Higher Value
*/



--SUM(Sales)
--Over (ORDER BY Month ROWS BETWEEN CURRENT ROW and 2 FOLLOWING)
/*
EXAMPLE-

we have a data
month    | sales
january  | 20
february | 10
march    | 30
april    | 5
june     | 70

WORKING OF THE FRAME CLAUSE QUERY
1. sql gonna process the data row by row
2. the current row (means the 1st row)
3. we say the range until 2 rows
4. next pointer will be on the MARCH row because we have defined 2 following
5. so sql got the scope for the calculations
6. so it will sum the sales from january to march (20+10+30=60) the result will be 60 for the january row
7. then sql will move to the next row (february)
8. now the current row is february
9. and 2 followign rows (means from february to april)
10. so it will sum the sales from february to april (10+30+5=45) the result will be 45 for the february row
11. then sql will move to the next row (march)
12. now the current row is march
13. and 2 followign rows (means from march to june)
14. so it will sum the sales from march to june (30+5+70=105) the result will be 105 for the march row
15. then sql will move to the next row (april)
16. now the current row is april
17. and 2 followign rows (means april, june, and nothing (because there are nore more rows))
18. so it will sum the sales april, june(5+70=75) the result will be 75 for the april row
19. then sql will move to the next row (june)
20. now the current row is june
21. and 2 followign rows (means only june (because there are no rows below june))
22. so it will sum the sales june(70) the result will be 70 for the june row
*/


--SUM(Sales)
--Over (ORDER BY Month ROWS BETWEEN CURRENT ROW and UNBOUNDED FOLLOWING)
/*
--UNBOUNDED FOLLOWING - the last possible row in the partition
EXAMPLE-
we have a data
month    | sales
january  | 20
february | 10
march    | 30
april    | 5
june     | 70

WORKING OF THE FRAME CLAUSE QUERY
1. sql gonna process the data row by row
2. the current row (means the 1st row)
3. we say the range until UNBOUNDED FOLLOWING (means until the last row)
4. so sql got the scope for the calculations
5. so it will sum the sales from january to june (20+10+30+5+70=135) the result will be 135 for the january row
6. then sql will move to the next row (february)
7. now the current row is february
8. and UNBOUNDED FOLLOWING (means until the last row)
9. so it will sum the sales from february to june (10+30+5+70=115) the result will be 115 for the february row
10. then sql will move to the next row (march)
11. now the current row is march
12. and UNBOUNDED FOLLOWING (means until the last row)
13. so it will sum the sales from march to june (30+5+70=105) the result will be 105 for the march row
14. then sql will move to the next row (april)
15. now the current row is april
16. and UNBOUNDED FOLLOWING (means until the last row)
17. so it will sum the sales from april to june (5+70=75) the result will be 75 for the april row
18. then sql will move to the next row (june)
19. now the current row is june
20. and UNBOUNDED FOLLOWING (means until the last row)
21. so it will sum the sales june(70) the result will be 70 for the june row
*/


--SUM(Sales)
--Over (ORDER BY Month ROWS BETWEEN 1 PRECEDING and CURRENT ROW)  
/*
1 PRECEDING - means the row before the current row
--means the 1 PRECEDING will always point to the row before the current row
EXAMPLE-
month    | sales
january  | 20
february | 10
march    | 30
april    | 5
june     | 70

1. we are on the 1st row (january)
2. there is no preceding row so only january sales will be considered (20)
3. the result will be 20 for january row
4. then we move to the next row (february)
5. now we are on february row
6. the preceding row is january -- means the row before the february row
7. so sales of january and february will be considered (20+10=30) the result will be 30 for february row
8. then we move to the next row (march)
9. now we are on march row
10. the preceding row is february -- means the row before the march row
11. so sales of february and march will be considered (10+30=40) the result will be 40 for march row
10. and then so on.

*/


--SUM(Sales)
--Over (ORDER BY Month ROWS BETWEEN UNBOUNDED PRECEDING and CURRENT ROW)  
/*
UNBOUNDED PRECEDING - means the first possible row in the partition/WINDOW
--means the UNBOUNDED PRECEDING will always point to the first row of the partition/window
EXAMPLE-
month    | sales
january  | 20
february | 10
march    | 30
april    | 5
june     | 70

1. we are on the 1st row (january)
2. the UNBOUNDED PRECEDING will point to the january row
3. so only january sales will be considered (20)
4. the result will be 20 for january row
5. then we move to the next row (february)
6. now we are on february row
7. the UNBOUNDED PRECEDING will point to the january row
8. so sales of january and february will be considered (20+10=30) the result will be 30 for february row
9. and then so on.
*/

--SUM(Sales)
--Over (ORDER BY Month ROWS BETWEEN 1 PRECEDING and 1 FOLLOWING)  
/*
1 PRECEDING - means the row before the current row
1 FOLLOWING - means the row after the current row
--means the 1 PRECEDING will always point to the row before the current row
--means the 1 FOLLOWING will always point to the row after the current row

EXAMPLE-
month    | sales
january  | 20
february | 10
march    | 30
april    | 5
june     | 70

1. we are on the 1st row (january)
2. there is no preceding row but there is 1 following row so only january and february sales will be considered (20+10=30)
3. the result will be 30 for january row
4. then we move to the next row (february)
5. now we are on february row
6. the preceding row is january -- means the row before the february row
7. the following row is march -- means the row after the february row
8. so sales of january, february and march will be considered (20+10+30=60) the result will be 60 for february row
9. then we move to the next row (march)
10. now we are on march row
11. the preceding row is february -- means the row before the march row
12. the following row is april -- means the row after the march row
13. so sales of february, march and april will be considered (10+30+5=45) the result will be 45 for march row
14. and then so on.
*/


--SUM(Sales)
--Over (ORDER BY Month ROWS BETWEEN UNBOUNDED PRECEDING and UNBOUNDED FOLLOWING)  
/*
UNBOUNDED PRECEDING - means the first possible row in the partition/WINDOW
UNBOUNDED FOLLOWING - means the last possible row in the partition/WINDOW
--means the UNBOUNDED PRECEDING will always point to the first row of the partition/window
--means the UNBOUNDED FOLLOWING will always point to the last row of the partition/window

EXAMPLE-
month    | sales
january  | 20
february | 10
march    | 30
april    | 5
june     | 70

1. starting will be from (unbounded preceeding) january row (the first possible row of the partition/window)
2. ending will be at (unbounded following) june row (the last possible row of the partition/window)
3. so the sum of all the rows will be considered (20+10+30+5+70=135)
4. so the result will be 135 for all the rows
*/

SELECT *
from Sales.Orders;

SELECT
    OrderID,
    OrderDate,
    OrderStatus,
    Sales,
    SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate ROWS BETWEEN CURRENT ROW and 2 FOLLOWING) as Total_Sales
from Sales.Orders;
/*
Result Set Batch 1 - Query 1
========================================

OrderID     OrderDate   OrderStatus  Sales       Total_Sales
----------  ----------  -----------  ----------  -----------
1           2025-01-01  Delivered    10          55         
3           2025-01-10  Delivered    20          95         
5           2025-02-01  Delivered    25          105        
6           2025-02-05  Delivered    50          80         
7           2025-02-15  Delivered    30          30         
2           2025-01-05  Shipped      15          165        
4           2025-01-20  Shipped      60          170        
8           2025-02-18  Shipped      90          170        
9           2025-03-10  Shipped      20          80         
10          2025-03-15  Shipped      60          60  

here we can see in the order id 7 that that (the total sales is coming as 30)
because after the order id 7 is another partition or another window (of another orderstatus)
*/

--COMPACT FRAME
--for only preceeding, the syntax of current row can be skipped
/*
NORMAL FORM - ROWS BETWEEN CURRENT ROW AND 2 preceeding
SHORT FORM - ROWS 2 PRECEEDING
*/
--EXAMPLE 1
SELECT
    OrderID,
    OrderDate,
    OrderStatus,
    Sales,
    SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate ROWS 2 PRECEDING) AS two_preceding
from Sales.Orders;
--EXAMPLE 2
SELECT
    OrderID,
    OrderDate,
    OrderStatus,
    Sales,
    SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate ROWS 2 PRECEDING) AS two_preceding
from Sales.Orders;

--DEFAULT FRAME
--is only working with the order by
--FRAME CLAUSE ONLY WORKS WITH ORDER BY
--sql uses default frame if order by is used without frame
--default is (rows between unbounded preceding and current row) / (rows unbounded preceding)
--both are same  the 1st is normal and 2nd is the shortcut and compact
SELECT
    OrderID,
    OrderDate,
    OrderStatus,
    Sales,
    SUM(Sales) OVER(PARTITION BY OrderStatus ORDER BY OrderDate) AS two_preceding
from Sales.Orders;

--if we remove the order by
--full window will be aggregated
SELECT
    OrderID,
    OrderDate,
    OrderStatus,
    Sales,
    SUM(Sales) OVER(PARTITION BY OrderStatus)
from Sales.Orders;


--RULES OF WINDOW FUNCTIONS
/*
1. Wnindow functions can only be used in the select clause or the order by clause of a query
2. cannot be used in WHERE, GROUP BY, HAVING clauses
3. nested window functions are not allowed (means we cant use window function inside another window function)
4. sql executes the window functions after the where clause
5. window function can be used together with GROUP BY clause in the same query, only if the same columns are used
*/

--Rank the customers based on their total sales
--use the group by for simpler aggregations
SELECT
    CustomerID,
    SUM(Sales) as Total_Sales,
    RANK() OVER(ORDER BY SUM(Sales)) as Rank
from Sales.Orders
GROUP BY CustomerID;
--(always be careful while using window function with the group by)
--(as long as we are using the same columns nothing is going to go wrong and sql will allow)


--SUMMARY (WINDOW FUNCTIONS)
--performs the claculation on the subset of data without losing the another important details
/*
WINDOW FUNCTIONS VS GROUP BY
1. WINDOW FUNCTION IS MORE POWER FUL AND DYNAMIC THAN GROUP BY
2. DATA ANALYSIS = ADVANCED WITH WINDOW FUNCTIONS / SIMPLE WITH GROUP BY
3. Use GROUP BY + WINDOW in same query, only if same column is used
*/

--STEP 1 - TO USE GROUP BY
--SETP 2 - TO USE WINDOW FUNCTION