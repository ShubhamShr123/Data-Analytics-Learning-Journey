--DDL commands doesnt return data it changes the structure of data
use MyDatabase

--CREATE
--creating a new table called persons
--with columns :id, person_name, birth_date, and phone
create table persons (
	ID int not null,
	Person_Name varchar(30) not null,
	Birth_Date Date,
	phone varchar(15)  not null,
	CONSTRAINT pk_key primary key (ID)
)

select * from persons

--ALTER
--is used when we want to edit our definition of the table
--to add multiple cols only 1 add can be used
--use of multiple add will led to error
ALTER table persons
add pincode char(6) not null,
email varchar(50) not null;

select *
from persons

ALTER table persons
drop column pincode,
email;

--DROP
--is used to delete the table or databse
drop table persons