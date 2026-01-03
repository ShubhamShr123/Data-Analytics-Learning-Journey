use MyDatabase

--update
--is used in order to change the pre existing content in the table
--TIP (always use where to avoid updating all the rows unintentionally)
/*
Udate table_name
	set col1 = value1,
	col2 = value2
where <condition>
*/

--changing the score of customer having id 6 to 0
--checking the data before updation
select *
from customers
--updating
update customers
set score = 0
where id = 6
--checking the updation result
select
	id,
	score
from customers
where id = 6

--changing the score of customer having id 8 to 0 and updating the country to UK
--checking the data before updation
select *
from customers
--updating
update customers
set score = 0,
	country = 'UK'
where id = 8
--checking the updation result
select *
from customers
where id = 8

--updating the columns having null score to 0
--checking the data before updation
select * 
from customers
--updating
update customers
set score = 0
where score IS NULL
--checking the updation result
select *
from customers