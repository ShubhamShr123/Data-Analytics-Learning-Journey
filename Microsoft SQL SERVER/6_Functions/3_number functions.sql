--NUMBER FUNCTIONS

--ROUND
--will round the value based on its value after the specified decimal place
/*
if we have a number 3.516
we use ROUND(3.516, 2) this means we only want to keep 2 decimal places
the 3rd decimal digit will decide if the 2nd decimal digit will remain the same or increase by 1
if the 3rd decimal digit is greater than 5 then the 3.51 will change to 3.52
and if its smaller then it will remain the same
*/

--ROUND - to 2 digit places
select
	3.516,
	ROUND(3.516, 2) as approx
--ROUND - to 1 digit places
select
	3.516,
	ROUND(3.516, 1) as approx
--ROUND - to 0 digit places
select
	3.516,
	ROUND(3.516, 0) as approx


--ABS (absolute)
--this converts negative figures to positive
--if the numbers are already positive nothing gonna happen
--can be used in customers table where due to some calculation mistake the sales is in negative
select
-10,
ABS(-10)
