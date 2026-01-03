--LIKE OPERATOR
--is used to search for a pattern inside the text
--% is used (0, 1, MANY)
--The _ is used if exact 1 value is needed to find

--(% before the text means)=>anything in the start and specified characters at the last
--For example a name - MARTIN (to find the last 'in' we have to write %in) which means starting can be any but the ending must be in
--To find the 'MA' we will write MA% which means ending can be any but the starting should be from MA
--to find the 'R' in the MARTIN we will write %R% which means R anywhere in the text

use MyDatabase

--finding all the customers name starting with M
select *
from customers
where first_name like 'M%'

--finding all the customers name ending with n
select * 
from customers
where first_name like '%n'

--finding all the customers name containing r
select *
from customers
where first_name like '%r%'

--find all customers whose first name has r in the 3rd pos
select *
from customers
where first_name like '__r%'

--NOT LIKE operator

--finding the customers names not starting with M
select * 
from customers
where first_name not like 'M%'

--finding all the customers name not ending with n
select *
from customers
where first_name not like '%n'