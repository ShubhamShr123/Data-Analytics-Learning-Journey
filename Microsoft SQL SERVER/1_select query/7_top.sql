--TOP(LIMIT)
--restricts the number of results returned in the results


--retrieving top 3 customers with the highest scores
select top 3 *
from customers
order by score desc

--retireve the top 2 customers with the lowest scores
select top 2 *
from customers
order by score asc

--retrieve the two most recent orders
select top 3 *
from orders
order by order_date asc
