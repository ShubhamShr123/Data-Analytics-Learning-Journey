--DISTINCT
--removes repeated values (duplicates)
--each value appears only once
--dont use DISTINT unless neccessary (it can slow down our query)


--returning unique list of all the countries
select 
DISTINCT country
from customers