use MyDatabase
--DELETE
--is used to delete existing rows in your table
/*
Delete from table_name
where <condition>
*/

--deleting all the customers having id greater than 5
delete from
customers
where id > 5
--checking the deletion result
select *
from customers
where id > 5 --this will give null if all the id's greater than 5 are removed

--TRUNCATE
--is used to delete all content from a table in one go
--it just deletes all the table content and not drops the table

truncate table persons

