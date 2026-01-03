--STRING FUNCTIONS

/*
MANIPULATION - CONCAT, UPPER, LOWER, TRIM, REPLACE
CALCULATION - LEN
STRING EXTRACTION - LEFT, RIGHT, SUBSTRING
*/

--MANIPULATION

--concat
--combines multiple strings into one
--concatenate first name and country into one column
select
	c.FirstName,
	c.Country,
	CONCAT(c.FirstName, '-',c.Country) as name_country
from Sales.Customers as c

--UPPER / LOWER
--convert all characters of a str to upper or lowercase
--convert the customers firstname to lowercase and upper case
select
	c.FirstName,
	LOWER(c.FirstName) as Firstname_lower,
	UPPER(c.FirstName) as Firstname_upper
from Sales.Customers as c

--TRIM
--removes the leading and trailing empty whitespaces
--find the customers whose firstname contains leading or trailing spaces
select
	c.FirstName
from Sales.Customers as c
where c.FirstName != TRIM(c.FirstName)
--same question with different way
select
	FirstName,
	LEN(FirstName) as Name_len,
	LEN(TRIM(FirstName)) as Name_len_trimmed,
	LEN(FirstName) - LEN(TRIM(FirstName)) as Spaces
from Sales.Customers
where LEN(FirstName) != LEN(TRIM(FirstName))

--REPLACE
--replaces specific character with a new character

--remove the - from the number
select
	'123-456-7890' as phone,
REPLACE('123-456-7890', '-', '') as clean_phone

--replace the - from the number to '/'
select
	'123-456-7890' as phone,
REPLACE('123-456-7890', '-', '/') as clean_phone

--replace the file ext (.txt) to (.docx)
select
	'report.txt' as old_filename,
REPLACE('report.txt', '.txt', '.csv')


--CALCULATION - LEN
--LEN
--counts the number of characters / digits / dates anything and return it in the form of integer

--count the no of characters in the name
select
	FirstName as Name,
	LEN(FirstName) as Name_Length
from Sales.Customers

--count the no of digits in date
--this will count the no of characters even the dashes
select
	'2025-08-30' as Date,
	LEN('2025-08-30') as Date_Length


--STRING EXTRACTION - LEFT, RIGHT, SUBSTRING

--LEFT / RIGHT
--extracts specific no of characters from the start or from the end respectively

--extract the first 3 char of each customer's firstname
select
	FirstName as Name,
	left(firstName, 3) as short_name
from Sales.Customers

--extract the last 3 char of each customer's last name
select
	LastName,
	RIGHT(LastName, 3) as short_surname
from Sales.Customers
--where LEN(LastName) != 0 can be added if we dont want the data not having lastnames

--extract 2 characters after the 2nd char of each customer's firstname
select
	FirstName,
	SUBSTRING(FirstName,2, 2)
from Sales.Customers
--extract all the characters after the 2nd char of each customer's firstname
--here we have use len because after 2 characters the len will be more than the len of the remaining characters
--this will help us to get all the characters after the 2nd char
--entering length more than the characters left will return all the characters and will not give an error
select
	FirstName,
	SUBSTRING(FirstName,2, LEN(FirstName))
from Sales.Customers
--extract all the characters after the 2nd char of each customer's firstname without whitespaces
select
	FirstName,
	SUBSTRING(TRIM(FirstName), 2, LEN(FirstName)) as sub_name
from Sales.Customers