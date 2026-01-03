use MyDatabase

--LOGICAL OPERATOR
--AND OR NOT

--AND
--all the conditions must to be true to return true
--retrive all the customers having country has USA and score > than 500
select *
from customers
where country='USA'
and
score>500

--OR
--at least one conditions must be true to return true
--retrieve all the customers either having usa as country or score > 500
select *
from customers
where country='USA'
or
score>500

--NOT
--retrives all the data not fulfilling the conditions
--it reverses the whole answer
--only gives the answer not fulfilling the condition
--retrieve all the customers having score not less than 500
select *
from customers
where not score>500

--using with AND condition
--retrieving all the customers data having score not less than 500 and country not having USA
select *
from customers
where NOT (score>500) and NOT (country='USA')