use SalesDB;

--CASE STATEMENT
--evaluates a list of conditions and returns a value when the first condition is met

/*
CASE --start of logic
	WHEN condition1 THEN result1 --result if condition is true
	WHEN condition2 THEN result2
	else result --if no condition is true above this will be executed (optional)

END --end of logic
*/

--Main purpose is data transformation
--create new data based on existing columns

--USECASES

--CATEGORIZATION OF DATA - 1
--group the data into different categories based on certain conditions

/*
generate a report showing the total_sales for each category:
High : if the sales is higher than 50
medium : if the sales is between 20 and 50
low : if the sales are equal to 20 or less

sort the result from the highest to lowest
*/
select
Sales_frequency,
SUM(Sales) as Total_Sales
from ( --here we used subquery we will learn about this later
select 
	o.OrderID,
	o.Sales,
	CASE
		WHEN o.Sales>50 THEN 'HIGH'
		WHEN o.Sales>20 AND o.Sales<=50 THEN 'MEDIUM'
		else 'LOW'
	end as Sales_frequency
from Sales.Orders as o
)t --the t is the alias without it there will be an error
Group By Sales_frequency
Order By Total_Sales desc


--CASE STATEMENT RULES
--The data type of the results must be matching (like above we used same datatype output for case statements)
--('HIGH', 'MEDIUM', 'LOW')

--USECASE 2 (MAPPING VALUES)
--transform the values from one form to another

--Retrieve employee details with gender displayed as full text
select
	EmployeeID,
	FirstName,
	LastName,
	CASE 
		WHEN Gender = 'M' THEN 'MALE'
		WHEN Gender = 'F' THEN 'FEMALE'
		ELSE 'N/A'
	end as Gender_Full
from Sales.Employees

--Retrieve customers details with abbreviated country code

--professional way
select
	CustomerID,
	FirstName,
	Country,
	LEFT(Country, 2)
from Sales.Customers

--normal way
select
	CustomerID,
	FirstName,
	Country,
	CASE 
		WHEN Country = 'Germany' THEN 'GE'
		WHEN Country = 'USA' THEN 'US'
		else 'n/a'
	end as Country_abbreviated
from Sales.Customers

--USECASE 2 (QUICK FORM)
/*
1ST WAY is like above which is big and complex and in this we have to write the samething multiple times
CASE 
		WHEN Country = 'Germany' THEN 'GE'
		WHEN Country = 'USA' THEN 'US'
		else 'n/a'
	end
*/

--2ND WAY is like below which saves time and helps writing query efficiently
select
	CustomerID,
	FirstName,
	Country,
	CASE Country
		WHEN 'Germany' THEN 'DE'
		WHEN 'USA' THEN 'US'
		ELSE 'N/A'
	end as Country_abbreviated
from Sales.Customers


--USECASE 3 (HANDLING NULLS)
--replace nulls with a specific value

--find the avg scores of customers and treat nulls as 0
select
	CustomerID,
	FirstName,
	Score,
	CASE 
		WHEN Score is null THEN 0
		ELSE Score
	end as ScoreClean,
	AVG(CASE --this will provide proper avg as this will consider the null as 0 so it will be counted in the avg
			WHEN Score is null THEN 0
			ELSE Score
	end) OVER() Avg_Cust_Clean,
	AVG(Score) OVER() Avg_Cust
from Sales.Customers

--USECASE 4 (CONDITIONAL AGGREGATION)
--perform aggregation based on certain conditions
--find total sales made in each region but only consider sales greater than 30
SELECT
	SUM(CASE 
			WHEN o.Sales > 30 THEN o.Sales
			ELSE 0
		end) as Total_Sales,
	c.Country
from Sales.Orders as o
LEFT JOIN Sales.Customers as C
on o.CustomerID = c.CustomerID
GROUP BY c.Country
--another way to do the same using CASE statement
select
	SUM(o.Sales) as Total_Sales,
	c.Country
from Sales.Orders as o
LEFT JOIN Sales.Customers as C
on o.CustomerID = c.CustomerID
where o.Sales > 30
GROUP BY c.Country;


--count how many times each customer has made an order with sales > than 30
SELECT
	CustomerID,
	SUM(CASE WHEN Sales > 30 
	THEN 1
	ELSE 0
	END) as SalesFlag --made an another col sales flag to help us during the aggregation
	--above we have added sales flag col and summed it and grouped by the customer id
from Sales.Orders
GROUP BY CustomerID
ORDER BY CustomerID;

--count how many times each product has been ordered with sales between 20 and 50
select
	ProductID,
	SUM(CASE WHEN Sales between 20 and 50 THEN 1 ELSE 0 END) as Sales_Flag
from Sales.Orders
GROUP BY ProductID
ORDER BY ProductID

--count how many times each employee has made a sale with quantity > 1
SELECT 
	e.EmployeeID,
	SUM(CASE WHEN o.Quantity > 1 THEN 1 ELSE 0 END) AS Qty_flag
from Sales.Employees as e
LEFT JOIN Sales.Orders as o
on e.EmployeeID = o.CustomerID
GROUP BY EmployeeID
ORDER BY Qty_flag

--CASE STATENMENT
--evaluates a list of conditions and returns a value when the first condition is met
/*
RULES
1. The data type of the results must be matching
2. ELSE part is optional

USES
1. Data Categorization
2. Mapping Values
3. Handling NULLs
4. Conditional Aggregation
*/