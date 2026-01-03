use MyDatabase

--comparison operators
--(=), (<>, !=), >, <, >=, <=

--retireve all the customers from germany
select *
from customers
where country = 'Germany'

--retrieve all the customers who are not fromm germany
--(<> and != work the same in microsoft sql server)
select * 
from customers
where country!='Germany'

--retrive all the customers where score is greater than 500
select *
from customers
where score>500

--retrive all the customers where score is greater than or equal  to 500
select *
from customers
where score>=500

--retrive all the customers where score is lesser than 500
select *
from customers
where score<500

--retrive all the customers where score is lesser than or equal to 500
select *
from customers
where score<=500