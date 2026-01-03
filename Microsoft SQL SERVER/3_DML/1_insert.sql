use MyDatabase
--INSERT
--inserting data into a table
--if in the insert statement no cols are specifiecd the sql expects values for all the cols
--you can skip the columns names if you are inserting into every column
select * from customers

insert into customers (id, first_name, country, score)
values
(6, 'Shubham Sharma', 'India', 580),
(7, 'Nitin Sharma', 'India', 680);

insert into customers (id, first_name, country)
values
(8, 'Mohit Sharma', 'India')