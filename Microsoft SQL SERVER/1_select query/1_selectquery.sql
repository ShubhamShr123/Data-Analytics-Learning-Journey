--ctrl + r to toggle the results window
/*
ORDER OF THE SELECT QUERY

SELECT
DISTINCT
TOP
FROM
WHERE
GROUP BY
HAVING
ORDER BY
*/
--you can use the below command to chose your desired database
use MyDatabase

--selecting all the data from the table  
select * 
from customers

select * 
from orders

--selecting only required columns from the table
select 
	country,
	score
from customers

--WHERE	query
--only getting the data having score > 500
select *
from customers
where score>500
--getting the data where score>0
select * 
from customers
where score != 0
--getting the data where country is germany
select * 
from customers 
where country='Germany'

--order by
