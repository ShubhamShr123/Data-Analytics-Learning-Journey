use MyDatabase

--IN
--used to give list as or single element as input to check if it exists in the table
--use in instead of OR for multiple values in the same column to simplify SQL

--retrieve all the customers from either germany or usa
select *
from customers
where country in ('Germany', 'USA')

--another way
select *
from customers
where country='Germany' or country='USA'

--retrieve all the customers not from germany, India, africa
select *
from customers
where country not in ('Germany', 'India', 'Africa')