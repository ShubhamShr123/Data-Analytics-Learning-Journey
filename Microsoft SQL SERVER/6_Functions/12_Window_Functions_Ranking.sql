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