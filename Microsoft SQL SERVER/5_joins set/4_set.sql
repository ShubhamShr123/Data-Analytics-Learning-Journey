--SET operators
--used in combining the rows of the table
--Basic types of set operators - UNION, UNION ALL, EXCEPT(MINUS), INTERSECT
--To combine rows with set operators tables in the query should has the exact same number of columns
--set operators dont need key cols like the join query to join the tables
--the set operators appends the data of the table b beneath the data of table a
/*
RULES :-
1. Set operators can be used almost in all the clauses
2. ORDER BY	is only allowed once at the end of the query
3. The number of cols in each query must be the same
4. Datatypes of cols in each query must be compatible (or same)
5. The order of the cols in each query must be the same
6. The col names in the result are determined by the column names set in the first query
(means the first query will be controlling the names of the column in the results, and col names
given to the second query will be totally ignored)
*/

--append the employee names beneath the names of customer names

--rule no 2 (order by can be used only once at the last)
select
	FirstName,
	LastName
from Sales.Customers
UNION
select
	FirstName,
	LastName
from Sales.Employees
order by FirstName asc

--rule no 3 (no of cols in each query must be the same)
--the below query will not work as no of cols in each column are not the same
select
	c.CustomerID,
	c.FirstName,
	c.LastName
from Sales.Customers as c

UNION

select
	e.FirstName,
	e.LastName
from Sales.Employees as e

--rule no 4 (Datatypes of cols in each query must be compatible (or same))
--in this the conversion from varchar will be failed
select
	c.CustomerID, --different data type from the first name
	c.LastName
from Sales.Customers as c

UNION

select
	e.FirstName,
	e.LastName
from Sales.Employees as e

--rule no 5 (The order of the cols in each query must be the same)
--the query below will not work as the order is not correct in both the queries
select
	c.FirstName,
	c.CustomerID
from Sales.Customers as c

UNION

select
	e.EmployeeID,
	e.FirstName
from Sales.Employees as e

/*RULE NO 6 The col names in the result are determined by the column names set in the first query
(means the first query will be controlling the names of the column in the results, and col names
given to the second query will be totally ignored)*/
select
	c.FirstName as Name,
	c.LastName as Surname
from Sales.Customers as c

UNION

select
	e.FirstName,
	e.LastName
from Sales.Employees as e;

--RULE NO 7
/*Even if all rules are met and SQL shows no error, the result may be incorrect
(Incorrect column selection leads to inaccurate results)*/
--here we didn't got any error but the answer is incorrect
--because in the second query the last name is written on the place of firstname
--and it will change the results and put last name on the place of firstname
select
	c.FirstName as Name,
	c.LastName as Surname
from Sales.Customers as c

UNION

select
	e.LastName,
	e.FirstName
from Sales.Employees as e


--UNION
--returns all distinct rows from both the queries
--remove duplicate results from the result
--means if (Firstname - Shubham, Lastname - Sharma) is present in the first query
--(Firstname - Shubham, Lastname - Sharma) is also present in the last query
--the one result will be removed from this and only one will be visible in the result

--COMBINE the data from employees and customers into one table
--checking first which information we can map together
select *
from Sales.Employees

select *
from Sales.Customers
--combining
select
	c.CustomerID,
	c.FirstName,
	c.LastName
from Sales.Customers as c

UNION

select
	e.EmployeeID,
	e.FirstName,
	e.LastName
from Sales.Employees as e


--UNION ALL
--returns all rows from both the queries, including duplicates
--its faster than union because it dont need to find for duplicates
--use union all to find duplicates and quality issues

--combine the customers table and employees table including duplicates
--this will include duplicates too
select
	c.CustomerID,
	c.FirstName,
	c.LastName
from Sales.Customers as c

UNION ALL

select
	e.EmployeeID,
	e.FirstName,
	e.LastName
from Sales.Employees as e


--EXCEPT (MINUS)
--returns all distinct rows from the first query that are not found in the second query
--the 2nd query just works as a filter (the results will not have 2nd query elements)
--its the only one where the order of the queries affects the final result
--ITS LIKE A LEFT ANTI JOIN
/*
EXCEPT works only on the first query’s results. The second query is used purely as a filter:
- Step 1: Take all rows from the first query.
- Step 2: Look at the second query.
- Step 3: Remove any rows from Step 1 that also appear in Step 2.
- Step 4: Done — you never see rows from the second query itself.
*/

--find the employees who are not customers at the same time
select
	c.CustomerID,
	c.FirstName,
	c.LastName
from Sales.Customers as c

EXCEPT

select
	e.EmployeeID,
	e.FirstName,
	e.LastName
from Sales.Employees as e


--INTERSECT
--returns only the rows which are common in both the queries
--order of the queries doesn't affect the results
--ITS LIKE INNER JOIN

--find the employees who are also customers
select
	e.EmployeeID,
	e.FirstName,
	e.LastName
from Sales.Employees as e

INTERSECT

select
	c.CustomerID,
	c.FirstName,
	c.LastName
from Sales.Customers as c