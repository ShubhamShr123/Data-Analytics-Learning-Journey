--order by query
--ordering the results in increasing order
select *
from customers
order by score asc
--ordering the results in decreasing order
select * 
from customers
order by score desc

--order by (nested)
select * 
from customers
order by country asc,
score desc