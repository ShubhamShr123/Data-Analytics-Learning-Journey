--LEFT ANTI JOIN (left exclusive join)
--uses -> just for checking existence (filtering)
--return the rows from the left which has no match in the right
--the matching data will is not shown in the results
--only that data will be shown which is exclusively in the left table and is not in the right table
--in this the the left table (a) is the primary source of data and the right table is just for filter
use MyDatabase

--retireve all the customers who haven't ordered 
select *
from customers as a
left join orders as b
on a.id = b.customer_id
where b.customer_id is null

--RIGHT ANTI JOIN (right exclusive join)
--returns the rows form the right which has no match in the left table

--retrieve all the orders not having customer details in the customers table
select *
from customers as a
right join orders as b
on a.id = b.customer_id
where a.id is null
--we should use the left anti join to do the work of right anti join also

--retrieve all the orders not having customer details in the customers table with leftantijoin
select *
from orders as a
left join customers as b
on b.id = a.customer_id
where b.id is null

--FULL ANTI JOIN (FULL EXCLUSIVE JOIN)
--uses -> checking existence (filtering)
--only returns	rows that dont match in either tables
--overlapping data between both the tables will not be shown

--find customers without orders and orders without customers
--here we used or operator because if we use and it will need both the conditions to be true which is not possible
select *
from customers as a
full join orders as b
on a.id = b.customer_id
where b.customer_id is null
or
a.id is null

--challenge
--get all customers along with their  orders but only for customers who have placed an order without using an inner join

--by left join
select *
from orders as a
left join customers as b
on b.id = a.customer_id
where b.id is not null

--by inner join
select *
from customers as a
inner join orders as b
on a.id = b.customer_id

--by full join
--getting all the orders
select *
from customers as a
full join orders as b
on a.id = b.customer_id
where b.customer_id is not null
and
a.id is not null


--CROSS JOIN
--combines every row from the left and every row from the right
--very rarely used
--in every possible ways
--the output will  be -> the rows in the table a x table b.

--generate all possible combinations of customers and orders
select *
from customers
cross join orders