--WHERE	query
--is used when we want to filter the data before the aggregation
--is used to filter the original data
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