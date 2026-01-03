--USES OF SET OPERATORS
/*
1. Combining similar info before analyzing the data

	I. Normally what we do is writing separate sql queries for making a report of INDIVIDUALS
	II. Whether they are customers, employees, suppliers, students (getting diff-diff tables for all of them)
	which makes report untidy)
	III. What we can do is combine all of them using UNION and making just 1 table that holds all the info
	for individuals

2. Combining multiple tables divided into multiple tables by developers to optimize performance
	I. Like multiple tables having data for differnt different year orders (like order 2021, order 2022 and so on)
*/


--tips
--NEVER USE * TO COMBINE TABLES
--you can use directly the names of the cols list (by right clicking on the table in obj explorer and select top 1000rows)
--in that query will be having the full list of col names just simply copy and paste
--SHIFT + TAB to remove tab character before the col names
--because if the 

--Orders are stored in separate tables (orders and ordersArchive). Combine all into one report without duplicates
--checking tables before combining
select *
from Sales.Orders;
select *
from Sales.OrdersArchive;
--combining
select
'Orders' as SourceTable --this will add a new col in the result (showing the source of the table)
	,[OrderID]
	,[ProductID]
	,[CustomerID]
	,[SalesPersonID]
	,[OrderDate]
	,[ShipDate]
	,[OrderStatus]
	,[ShipAddress]
	,[BillAddress]
	,[Quantity]
	,[Sales]
	,[CreationTime]
from Sales.Orders

UNION

select
'OrdersArchive' as SourceTable
	,[OrderID]
	,[ProductID]
	,[CustomerID]
	,[SalesPersonID]
	,[OrderDate]
	,[ShipDate]
	,[OrderStatus]
	,[ShipAddress]
	,[BillAddress]
	,[Quantity]
	,[Sales]
	,[CreationTime]
from Sales.OrdersArchive as oa
order by OrderDate desc


--EXCEPT USE CASES
--1.DELTA DELETION
/*
We use the EXCEPT in order to indentify the differences or changes(delta) between two batches of data
*/
--data engineers build data pipelines in order to load daily new data from source to datawarehouse or datalake
/*
like on the day 1 we get a data
1, JohnDoe, john@gmail.com, 2024-09-17
2, Jan Doe, jan@outlook.com, 2024-09-18

on the day 2 we get
1, JohnDoe, john@gmail.com, 2024-09-17
3, Alice, alice@outlook.com, 2024-09-19

now the day 1 data is already uploaded to the data warehouse
so that duplicates are not uploaded to the data warehouse
we can use EXCEPT
which will filter out the data which is already existing in the data warehouse
*/

--2.Data completenes check
/*
can be used to compare tables to detect discrepancies between databases

like we migrated a data from database a to database b
now to check that all the data is successfully transfered from a to b
we will check with the EXCEPT operator
IF ALL THE DATA IS TRANSFERED SUCCESSFULLY THE RESULT WILL BE NULL
same we can do vice versa
checking b to a if there are records which are in b and not in a
*/

--QUICK SUMMARY SET OPERATORS
/*
TYPES: - UNION, UNION ALL, EXCEPT, INTERSECT
RULES: - Same no of cols, Datatypes, order of cols / 1st query controls the col names
USES: - Combine Info(UNION + UNION ALL), Delta Deletion(EXCEPT), Data Completeness(EXCEPT)
*/
