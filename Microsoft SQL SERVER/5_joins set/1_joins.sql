3--JOINS
--used in combining the columns of the tables
--Basic types of joins - NO, INNER, FULL, RIGHT , LEFT
--Advanced joins - LEFT ANTI JOIN, RIGHT ANTI JOIN, FULL ANTI JOIN, CROSS
--In order to join the tables we need to define the key cols between the two tables
--the joins can be performed if their is a column which is in both the tables we want to join

use MyDatabase;

--TIP -> always stick with the left join (as both right and left join work similarly)
--just keep in mind the table name placement before left join or after the left join
	
--NO JOIN
--returns data flow tables without combining them
--two results no need to combine

--retrieve all data from customers and orders as separate results
select *
from customers;
select *
from orders;

--INNER JOIN
--returns only the matching rows from both the tables (only overlapping data)
--all customers data along with their orders (but only for customers who have placed an order)
--uses - recombine data(combine multiple tables), data enrichment(extra info about data), check existence(filtering) 
select
	a.id,
	a.first_name,
	a.country, 
	a.score,
	b.sales
from customers as a
inner join orders as b
on a.id = b.customer_id
where b.sales!=0;

--LEFT JOIN
--returns all the rows from the left table and only matching data from the right table
--left table is the primary source of data and the right table is secondary source of data (only for additional data)

--get all customers along with their orders including those who didn't ordered
--here in the left table is and right table is b
select
	a.id,
	a.first_name,
	b.sales
from customers as a
left join orders as b
on a.id = b.customer_id

--getting the customers data who didnt ordered
select
	a.id,
	a.first_name,
	b.sales
from customers as a
left join	orders as b
on a.id = b.customer_id
where b.customer_id is null

--RIGHT JOIN
--returns all the rows from the RIGHT table and only matching data from the left table
--Right table is the primary source of data and Left table is secondary source of data (only for additional data)

--get all customers along with their orders,indluding orders without matching customers
select
	a.customer_id,
	a.sales,
	b.first_name,
	b.country,
	b.score
from orders as a
right join customers as b
on a.customer_id = b.id
--same quesiton with left join
select
	a.customer_id,
	a.sales,
	b.first_name,
	b.country,
	b.score
from customers as b
left join orders as a
on b.id = a.customer_id


--FULL JOIN
--returns all the rows from both the tables
select *
from customers as a
full join orders as b
on a.id = b.customer_id