--IN BUILT FUNCTIONS
/*
is a built in sql code:
	1. which accepts an input value
	2. processes it
	3. returns an output value
*/

--2 types of built in functions
--SINGLE ROW FUNCTIONS - used for cleanup, transformation, manipulation (like LOWER())
/*SRF FULL LIST - STRING, NUMERIC, DATE&TIME, NULL*/
--MULTI ROW FUNCTIONS (like SUM())
/*MRF FULL LIST - AGGREGATE, WINDOW*/

--NESTED FUNCTIONS?
--are functions used inside another function

--write a function to get the first two letters from the id 1 firstname in lowercase
select
	left(lower(first_name), 2)
from Mydatabase.dbo.customers
where id = 1;