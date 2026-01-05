--VALUE WINDOW FUNCTIONS
--these functions are used to access value from another row
/*
Lets suppose we have a table:
Month | Sales
jan   | 100
feb   | 200
mar   | 300
apr   | 400
may   | 500
jun   | 600
jul   | 700

if we are on the current row (let suppose on april row)
WE CAN USE
1. LAG() fucntion to access value from previous row (means mar row )
2. LEAD() function to access value from next row (means may row)
3. first_value() function to access value from first row (means jan row)
4. last_value() function to access value from last row (means jul row)

RULES
1. LAG(expr, OFFSET, default) [Expression : All data type, OFFSET : Number of rows forward or backward from current row default = 1, Default : Returns a default value if next or prev row is not available (default = null), Partition Clause : Optional, Order Clause : Required, Frame Clause : Not Allowed]
2. LEAD(expr, OFFSET, default) [Expression : All data type, OFFSET : Number of rows forward or backward from current row default = 1, Default : Returns a default value if next or prev row is not available (default = null), Partition Clause : Optional, Order Clause : Required, Frame Clause : Not Allowed]
3. first_value(expr) [Expression : All data type, Partition Clause : Optional, Order Clause : Required, Frame Clause : Optional]
4. last_value(expr) [Expression : All data type, Partition Clause : Optional, Order Clause : Required, Frame Clause : Should be used]

(so that we can compare the sales of different months)
ORDER BY is mandatory to use
*/

--VALUE WINDOW FUNCTIONS
--MIN / MAX

--LEAD() Access the value from the next row within a window
--LAG() Access the value from the previous row within a window


--USECASES - 1
--TIME SERIES ANALYSIS (analyzing the data to understand patterns trends and behaviours over time [Business's performance over time]) YoY - Year over Year, MoM - Month over Month

--analyze the month over month (MOM) performance by finding the percentage change in sales between the current and previus month
SELECT *,
Total_Sales - Previous_Month_Sale as Sale_Difference,
CONCAT(ROUND(CAST((Total_Sales - Previous_Month_Sale) AS FLOAT) / Previous_Month_Sale * 100, 2), '%') as MoM_Percentage
FROM(SELECT
    MONTH(OrderDate) as OrderMonth,
    SUM(Sales) as Total_Sales,
    LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) as Previous_Month_Sale
    from Sales.Orders
    GROUP BY MONTH(OrderDate))t


--USECASE - 2
--Customer Retention Analysis (Measuring customer behaviour and loyalty to help business build strong relationships with customers)

--analyze customer loyalty by ranking customers based on avg no of days between orders

SELECT
    CustomerID,
    AVG(Days_Interval) as avginterval,
    RANK() OVER(ORDER BY COALESCE(AVG(Days_Interval), 99999999)) as Rank_of_Customer
FROM(
SELECT
    OrderID,
    CustomerID,
    OrderDate,
    LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate) as Lead_order,
    DATEDIFF(DAY, OrderDate, LEAD(OrderDate) OVER(PARTITION BY CustomerID ORDER BY OrderDate)) AS Days_Interval
FROM Sales.Orders)t
GROUP BY CustomerID;


--FIRST_VALUE() - Access a vlaue from the first row within a window
--LAST_VALUE() - Access a value form the last row within a window

--FIND THE FIRST AND THE LAST VALUE OF THE Sales

--the below query of last value will not be working as expected because we haven't used the frame clause in that
SELECT
    DATENAME(MM, OrderDate) as MonthName,
    Sales,
    FIRST_VALUE(Sales) OVER(ORDER BY MONTH(OrderDate)) as FirstVal,
    LAST_VALUE(Sales) OVER(ORDER BY MONTH(OrderDate)) as LastVal
FROM Sales.Orders;

--so to get the expected results instead do like this
SELECT
    DATENAME(MM, OrderDate) as MonthName,
    Sales,
    LAST_VALUE(Sales) OVER(ORDER BY MONTH(OrderDate) ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) as LastVal
FROM Sales.Orders;

--find the highest and lowest sales by product
SELECT
    OrderID,
    ProductID,
    Sales,
    FIRST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) as LowestSale,
    LAST_VALUE(Sales) OVER (PARTITION BY ProductID ORDER BY Sales ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) as HighestSale,
    MIN(Sales) OVER(PARTITION BY ProductID) as MinSale,
    MAX(Sales) OVER(PARTITION BY ProductID) as MaxSale
from Sales.Orders;
/*first_value can also be used as last value (just by changing the order by to descending)
SO THESE FUNCTIONS CAN BE USED TO COMPARE HOW WELL A VALUE IS PERFORMING AS COMPARED TO THE EXTREMES*/

--SUMMARY WINDOW VALUE FUNCTIONS / ANALYTICAL FUNCTIONS
/*
Allow access of specific value from another row
1. LAG() - PREVIOUS VALUE
2. LEAD() - NEXT VALUE
3. FIRST_VALUE() - FIRST VALUE WITHIN A WINDOW
4. LAST_VALUE() - LAST VALUE WITHIN A WINDOW

RULES
1. Expression - any data type
2. OrderBy - Required
3. Frame - Optional (mostly leave it empty except the LAST_VALUE() function)

USECASES
1. Time series analysis (MoM, YoY)
2. Time Gap analysis (Customer retnetion)
3. Comparison Analysis : Extreme (HIGHEST, LOWEST)
*/
