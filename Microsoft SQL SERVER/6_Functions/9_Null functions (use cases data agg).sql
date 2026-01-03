--ISNULL / COALESCE
--can be used to handle nulls before doing data aggregations
--sum, count, min, max, avg totally ignores the null values
--exception if COUNT(*) is used it will count the null values too


--find the avg scores for the customers
--here we didnt replaced the null values
--nulls are totally ignored
select 
	CustomerID,
	Score,
	AVG(Score) OVER() AvgScores --after avg (OVER() AvgScores) is a window func we will study about it later
from Sales.Customers;

--replacing nulls and then finding the avg
--after replacing nulls we will get different avg
--as nulls are now replaced with 0
select
	CustomerID,
	Score,
	AVG(COALESCE(Score, 0)) OVER() AvgScores --after avg (OVER() AvgScores) is a window func we will study about it later
from Sales.Customers;


--HANDLING NULLS
--mathematical operations

--display the full name of customers in a single field by merging their first and last names and add 10 points to score each customers
--the coalesce(Score,0) returns the full column of the score after replacing the null values showing replaced and unreplaced value
--below we just added 10 to all the scores 
select
	CustomerID,
	FirstName,
	LastName,
	FirstName + ' ' + COALESCE(LastName, '') as FullName,
	Score,
	COALESCE(Score, 0) + 10 as Score_with_bonus --removed 1 null from the last and added 10 to all of the scores
from Sales.Customers


--HANDLING NULL BEFORE JOINING TABLES
--when joining tables we need the keys to join the tables
--if either of the key is having a null value that record will not show up in the results
--so managing nulls is very important to get all the records

/*select
	a.year,
	a.type,
	a.orders,
	b.sales
from table1 a
join table2 b
on a.year = b.year
and ISNULL(a.type, '') = ISNULL(b.type, '')*/


--HANDLING NULL VALUES SORTING DATA
--handle the nulls before sorting data
--if we have nulls the sql goona show it at the start no matter order by desc, or asc

--sort the customers from lowest to highest scores, with nulls appearing last

--LAZY WAY
select
	CustomerID,
	Score,
	COALESCE(Score, 99999)
from Sales.Customers
order by Score

--PROFESSIONAL WAY
select
	CustomerID,
	Score,
	CASE WHEN Score IS NULL THEN 1 ELSE 0 END FLAG --made a col flag which will give 1 if null and 0 if not null
from Sales.Customers
order by FLAG, Score asc --after making the flag column sorting it by it and Score increasing

--NULL IF(value1, value2)
--can only take 2 values
--compares two expressions and returns :
--	Null, if they are equal
-- first value, if they are not equal
--NULL(ORIGINAL_PRICE, DISCOUNTED_PRICE)
/*
Like if we have data like this
Original price = 150, discounted price = 50 (null if will return 150)
Original price = 250, discounted price = 250 (null if will return null)
*/


--NULL IF usecase
--preventing the error of dividing by zero

--find the sales price for each order by dividing the sales by the quantity
select
	OrderID,
	Quantity,
	Sales,
	Sales / Quantity --here this will give error divide by zero error
from Sales.Orders

--logic behind below query
--the null iff will check if the quantity is 0 (if any of the quantity is 0 it will be replaced by 0)
select
	OrderID,
	Quantity,
	Sales,
	Sales / NULLIF(Quantity, 0) --here this will give error divide by zero error
from Sales.Orders

--IS NULL
--Returns true if the value is null other wise false
--IS NOT NULL
--Returns true if the value is not null otherwise false

--USECASE OF IS NULL
--searching for missing information or nulls
--identify the customers who have no scores
select *
from Sales.Customers
where Score is null

select *
from Sales.Customers
where Score is not null

--ANTI JOIN
--left anti join / right anti join
--finding the unmatched rows between 2 tables
select *
from Sales.Customers
select *
from Sales.Orders

select c.* --the c.* denotes all the cols from the customers table
from Sales.Customers as c
left join Sales.Orders as o
on c.CustomerID = o.CustomerID
where o.CustomerID is null