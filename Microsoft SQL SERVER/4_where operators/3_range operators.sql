use MyDatabase

--BETWEEN
--used to find the value between the two values
--the values specified are inclusive
--if the value are between the specified values then it will return true otherwise false

--retrieve all the customers whose score falls in the range bw 100 and 500
select *
from customers
where score
between 100 and 500
--another way to to the same
select *
from customers
where score>=100
and
score<=500