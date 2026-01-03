/*
In the SELECT clause, each item can be:

1. A column name
2. table.* to select all columns
3. Any expression (constants like NULL or 'UNKNOWN', functions, arithmetic, etc.)
*/

--Inserting data from a source table to target table

--selecing the data needed according to the structure of the persons table
select
	id,
	first_name,
	null,
	'UNKNOWN'
from customers

--just adding an insert into to insert the selected data form the customers table to persons table
insert into persons (id, person_name, birth_date, phone)
select
	id,
	first_name,
	null,
	'UNKNOWN'
from customers

--checking if the data is inserted successfully
select *
from persons

