--date time PART EXTRACTION

--(DAY, MONTH, YEAR)

--DAY(date) (returns the day from the date)
--MONTH(date) (returns the month from the date)
--YEAR(date) (returns the year from the date)
--select the year,month, day of creation from the order creation time in separate cols in one table
select
	o.OrderID,
	o.CreationTime,
	YEAR(o.CreationTime) as Year_of_creation,
	MONTH(o.CreationTime) as Month_of_creation,
	DAY(o.CreationTime) as Day_of_creation,
	o.OrderDate
from Sales.Orders as o


--DATEPART(part, date)
--inside the sql (dates also have the week and quarter but not visible(we can extract those using this func))
--we can write full part name also like HOUR and write its abbrevation too like HH and same applies to (year, month, day, hour, minute, second)
--returns a specific part of a data as a number (int)
--extra datepart arguments (Millisecond, Microsecond, nanosecond, isoweek)

--return the year, month, day, hour, minute, second using their abbrevations with function DATEPART
select
	o.OrderID,
	o.CreationTime,
	DATEPART(YY,o.CreationTime) as Year_of_creation,
	DATEPART(MM,o.CreationTime) as Month_of_creation,
	DATEPART(DD,o.CreationTime) as Day_of_creation,
	DATEPART(HH,o.CreationTime) as Hour_of_creation,
	DATEPART(MM,o.CreationTime) as Min_of_creation,
	DATEPART(SS,o.CreationTime) as Sec_of_creation,
	o.OrderDate
from Sales.Orders as o

----return the year, month, day, hour, minute, second using function DATEPART
select 
	o.OrderID,
	o.CreationTime,
	DATEPART(YEAR,o.CreationTime) as Year_of_creation,
	DATEPART(MONTH,o.CreationTime) as Month_of_creation,
	DATEPART(DAY,o.CreationTime) as Day_of_creation,
	DATEPART(HOUR,o.CreationTime) as Hour_of_creation,
	DATEPART(MINUTE,o.CreationTime) as Min_of_creation,
	DATEPART(SECOND,o.CreationTime) as Sec_of_creation,
	o.OrderDate
from Sales.Orders as o

--return the quarter, weekday, week using datepart function
select
	OrderID,
	DATEPART(QUARTER,CreationTime) as Quarter_of_creation,
	DATEPART(WEEK,CreationTime) as Week_of_creation,
	DATEPART(WEEKDAY,CreationTime) as Weekday_of_creation
from Sales.Orders


--DATENAME(part, date)
--returns the name of the month or weekday from the date
--returns string in the result

--return the month name, week name of the creation of order
select
	OrderID,
	DATENAME(mm,CreationTime) as Month_of_creation,
	DATENAME(weekday,CreationTime) as WeekDay_of_creation
from Sales.Orders


--DATETRUNC(part, date)
--truncates the date to the specific part (keeps the specified part and reset remaining datetime)
/*
like 2025-08-20 18:55:45
now when I apply datetrunc to the above date
DEFAULT RESET VALUE FOR TIME is 00
DEFAULT RESET VALUE FOR DATE is 01
1. DATETRUNC(year, 2025-08-20 18:55:45) output - 2025-01-01 00:00:00 
2. DATETRUNC(month, 2025-08-20 18:55:45) output - 2025-08-01 00:00:00
3. DATETRUNC(day, 2025-08-20 18:55:45) output - 2025-08-20 00:00:00
4. DATETRUNC(hour, 2025-08-20 18:55:45) output - 2025-08-20 18:00:00
5. DATETRUNC(minute, 2025-08-20 18:55:45) output - 2025-08-20 18:55:00
*/

select
	OrderID,
	DATETRUNC(YEAR,CreationTime) as year_dt,
	DATETRUNC(MONTH,CreationTime) as Month_dt,
	DATETRUNC(DAY,CreationTime) as Day_dt,
	DATETRUNC(HOUR,CreationTime) as Hour_dt,
	DATETRUNC(MINUTE,CreationTime) as Min_dt
from Sales.Orders

--actual use of DATETRUNC in data analysis
--grouping of dates while doing analysis
/*
in the creation time they cant be grouped because
every order is not done on the same time all are different time day and month

(so let suppose if I want to group by the reults on month of creation)
we can use the datetrunc like below
*/
select
	DATETRUNC(MONTH, CreationTime) as Creation,
	COUNT(OrderID) as total_orders
from Sales.Orders
group by DATETRUNC(MONTH, CreationTime)


--EOMONTH(DATE)
--returns the last day of the month
--it will only effect the day of the date (it will change the day to the end day of the month)
--if the day is already on the end day of the month it will remain the same

--return the end day of the month of creation of date
select
	OrderID,
	DATETRUNC(DAY, CreationTime) as Creation_Date,
	EOMONTH(CreationTime) as EOMonth
from Sales.Orders
--return the starting day of the month of creation date
select
	OrderID,
	DATETRUNC(month, CreationTime) as Start_of_month
from Sales.Orders

