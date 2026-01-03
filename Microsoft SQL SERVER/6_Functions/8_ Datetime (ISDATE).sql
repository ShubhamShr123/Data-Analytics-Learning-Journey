--ISDATE(value)
--check if a value is a date
--returns 1 if the string value is a valid date 0 if not a valid date

select
ISDATE('123') Datecheck1,
ISDATE('2025-08-20') Datecheck2,
ISDATE('20-08-2025') Datecheck3,
ISDATE('2025') Datecheck4,
ISDATE('08') Datecheck5;


/*Below we can see in the subquery that last row contains unidentified date format
so it will give error
what we can do is we can check if the orderdate is in correct format
and set a case statement if the isdate output is 1 then only we will cast it to date
other wise it will convert to 2000-01-01*/
select
	OrderDate,
	ISDATE(OrderDate) Datecheck,
	CASE WHEN ISDATE(OrderDate) = 1 THEN 'VALID'
		ELSE 'INVALID'
	End Date_Format,
	CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS date)
		ELSE '2000-01-01'
	END New_order_Date
from
--below we just made a subquery
/*
SQL Server requires that every derived table (a subquery in the FROM clause) has an alias.
That t is simply the alias name you gave to the subquery:
*/
(
	select ('2025-08-20') as OrderDate UNION
	select ('2025-08-21') UNION
	select ('2025-08-23') UNION
	select ('2025-08')
)t
WHERE ISDATE(OrderDate) = 0