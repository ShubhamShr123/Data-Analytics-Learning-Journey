--DATEFORMAT
--the default date and time format is (yyyy-MM-dd HH:mm:ss)
--the sql server follows INTERNATIONAL STD(ISO 8601) year-month-day


--FORMATTING
--is the changing of the format which is set by default (changing how the data looks like)
/*
DATE FORMATTING: - 
2025-08-20
MM/dd/yy = 08/20/25
MMM yyyy = Aug 2025

DATE CONVERT: - (have to provide style number istead of format)
CONVERT 6 = 20 Aug 2025
CONVERT 112 = 20250820

NUMBER STYLING / FORMATTING
1234567.89
FORMAT N = 1,234,567.89 (value will be separated with comma)
FORMAT C = $ 1,234,567.89
FORMAT P = % 123456789.00
*/


--CASTING
--changing the datatype from one to another
--can chaneg the datatype with (cast(), convert())

/*
Like if we have a str '123' we can change it to integer
if we have a date 2025-08-20 we can change it to string
if we have a str '2025-08-20' we can change it to date
*/


--FORMAT(value, format [,culture])
--the third parameter is optional it works by (showing the value in the style of specific country or region) (default culture is en-US)

--formats a date or time value
--for example - FORMAT(OrderDate,'dd/MM/yyyy')

select
	OrderID,
	CreationTime,
	FORMAT(CreationTime,'dd-MM-yyyy') as European_Format,
	FORMAT(CreationTime,'MM-dd-yyyy') as US_Format,
	FORMAT(CreationTime,'dd') as dd,
	FORMAT(CreationTime,'ddd') as ddd,
	FORMAT(CreationTime,'dddd') as dddd,
	FORMAT(CreationTime,'MM') as MM,
	FORMAT(CreationTime,'MMM') as MMM,
	FORMAT(CreationTime,'MMMM') as MMMM
from Sales.Orders

--show creation time using the following format (Day Wed Jan Q1 2025 12:34:56 PM)
--below the datepart can't be used as it returns an int value
--the sql will not be able to cast it to string and it will give an error
--as all the elements are string it will be good to use DATENAME func instead of DATEQUARTER
select
	OrderID,
	CreationTime,
	'Day ' + FORMAT(CreationTime, 'ddd MMM') + ' Q' + DATENAME(QUARTER,CreationTime) +' '+ 
	FORMAT(CreationTime, 'yyyy HH:mm:ss tt') as Custom_Format
from Sales.Orders


--FORMATTING USE CASES
--DATE AGGREGATIONS
/*the date should be formatted before doing aggregations*/

--show all the orders with their month and year of orders
select
	FORMAT(OrderDate, 'MMM yy') as OrderDate,
	Count(OrderId) as total_orders
from Sales.Orders
Group by FORMAT(OrderDate, 'MMM yy')

--DATA STANDARDIZATION
--FORMAT() - ALL FORMATS (DATE FORMAT SPECIFIERS)
SELECT 
    'D' AS FormatType, 
    FORMAT(GETDATE(), 'D') AS FormattedValue,
    'Full date pattern' AS Description
UNION ALL
SELECT 
    'd', 
    FORMAT(GETDATE(), 'd'), 
    'Short date pattern'
UNION ALL
SELECT 
    'dd', 
    FORMAT(GETDATE(), 'dd'), 
    'Day of month with leading zero'
UNION ALL
SELECT 
    'ddd', 
    FORMAT(GETDATE(), 'ddd'), 
    'Abbreviated name of day'
UNION ALL
SELECT 
    'dddd', 
    FORMAT(GETDATE(), 'dddd'), 
    'Full name of day'
UNION ALL
SELECT 
    'M', 
    FORMAT(GETDATE(), 'M'), 
    'Month without leading zero'
UNION ALL
SELECT 
    'MM', 
    FORMAT(GETDATE(), 'MM'), 
    'Month with leading zero'
UNION ALL
SELECT 
    'MMM', 
    FORMAT(GETDATE(), 'MMM'), 
    'Abbreviated name of month'
UNION ALL
SELECT 
    'MMMM', 
    FORMAT(GETDATE(), 'MMMM'), 
    'Full name of month'
UNION ALL
SELECT 
    'yy', 
    FORMAT(GETDATE(), 'yy'), 
    'Two-digit year'
UNION ALL
SELECT 
    'yyyy', 
    FORMAT(GETDATE(), 'yyyy'), 
    'Four-digit year'
UNION ALL
SELECT 
    'hh', 
    FORMAT(GETDATE(), 'hh'), 
    'Hour in 12-hour clock with leading zero'
UNION ALL
SELECT 
    'HH', 
    FORMAT(GETDATE(), 'HH'), 
    'Hour in 24-hour clock with leading zero'
UNION ALL
SELECT 
    'm', 
    FORMAT(GETDATE(), 'm'), 
    'Minutes without leading zero'
UNION ALL
SELECT 
    'mm', 
    FORMAT(GETDATE(), 'mm'), 
    'Minutes with leading zero'
UNION ALL
SELECT 
    's', 
    FORMAT(GETDATE(), 's'), 
    'Seconds without leading zero'
UNION ALL
SELECT 
    'ss', 
    FORMAT(GETDATE(), 'ss'), 
    'Seconds with leading zero'
UNION ALL
SELECT 
    'f', 
    FORMAT(GETDATE(), 'f'), 
    'Tenths of a second'
UNION ALL
SELECT 
    'ff', 
    FORMAT(GETDATE(), 'ff'), 
    'Hundredths of a second'
UNION ALL
SELECT 
    'fff', 
    FORMAT(GETDATE(), 'fff'), 
    'Milliseconds'
UNION ALL
SELECT 
    'T', 
    FORMAT(GETDATE(), 'T'), 
    'Full AM/PM designator'
UNION ALL
SELECT 
    't', 
    FORMAT(GETDATE(), 't'), 
    'Single character AM/PM designator'
UNION ALL
SELECT 
    'tt', 
    FORMAT(GETDATE(), 'tt'), 
    'Two character AM/PM designator';

--NUMBER FORMAT SPECIFIERS ALL
SELECT 'N' AS FormatType, FORMAT(1234.56, 'N') AS FormattedValue
UNION ALL
SELECT 'P' AS FormatType, FORMAT(1234.56, 'P') AS FormattedValue
UNION ALL
SELECT 'C' AS FormatType, FORMAT(1234.56, 'C') AS FormattedValue
UNION ALL
SELECT 'E' AS FormatType, FORMAT(1234.56, 'E') AS FormattedValue
UNION ALL
SELECT 'F' AS FormatType, FORMAT(1234.56, 'F') AS FormattedValue
UNION ALL
SELECT 'N0' AS FormatType, FORMAT(1234.56, 'N0') AS FormattedValue
UNION ALL
SELECT 'N1' AS FormatType, FORMAT(1234.56, 'N1') AS FormattedValue
UNION ALL
SELECT 'N2' AS FormatType, FORMAT(1234.56, 'N2') AS FormattedValue
UNION ALL
SELECT 'N_de-DE' AS FormatType, FORMAT(1234.56, 'N', 'de-DE') AS FormattedValue
UNION ALL
SELECT 'N_en-US' AS FormatType, FORMAT(1234.56, 'N', 'en-US') AS FormattedValue;


--CONVERT(datatype ,value [,stylel]) 
--it can do both casting and formatting
--helps in casting a datatype to another datatype

--give some examples of converting one datatype to another
select
    CONVERT(int, '123')[String to int CONVERT],
    CONVERT(date, '2025-12-30')[String to Date CONVERT],
    CONVERT(date, CreationTime)[Datetime to date CONVERT],
    CONVERT(varchar, CreationTime, 32)[us std style : 32],
    CONVERT(varchar, CreationTime, 34)[eu std style : 34]
from Sales.Orders

--CONVERT ALL STYLES (CULTURE CODES)
SELECT 
    'en-US' AS CultureCode,
    FORMAT(1234567.89, 'N', 'en-US') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'en-US') AS FormattedDate
UNION ALL
SELECT 
    'en-GB' AS CultureCode,
    FORMAT(1234567.89, 'N', 'en-GB') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'en-GB') AS FormattedDate
UNION ALL
SELECT 
    'fr-FR' AS CultureCode,
    FORMAT(1234567.89, 'N', 'fr-FR') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'fr-FR') AS FormattedDate
UNION ALL
SELECT 
    'de-DE' AS CultureCode,
    FORMAT(1234567.89, 'N', 'de-DE') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'de-DE') AS FormattedDate
UNION ALL
SELECT 
    'es-ES' AS CultureCode,
    FORMAT(1234567.89, 'N', 'es-ES') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'es-ES') AS FormattedDate
UNION ALL
SELECT 
    'zh-CN' AS CultureCode,
    FORMAT(1234567.89, 'N', 'zh-CN') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'zh-CN') AS FormattedDate
UNION ALL
SELECT 
    'ja-JP' AS CultureCode,
    FORMAT(1234567.89, 'N', 'ja-JP') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'ja-JP') AS FormattedDate
UNION ALL
SELECT 
    'ko-KR' AS CultureCode,
    FORMAT(1234567.89, 'N', 'ko-KR') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'ko-KR') AS FormattedDate
UNION ALL
SELECT 
    'pt-BR' AS CultureCode,
    FORMAT(1234567.89, 'N', 'pt-BR') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'pt-BR') AS FormattedDate
UNION ALL
SELECT 
    'it-IT' AS CultureCode,
    FORMAT(1234567.89, 'N', 'it-IT') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'it-IT') AS FormattedDate
UNION ALL
SELECT 
    'nl-NL' AS CultureCode,
    FORMAT(1234567.89, 'N', 'nl-NL') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'nl-NL') AS FormattedDate
UNION ALL
SELECT 
    'ru-RU' AS CultureCode,
    FORMAT(1234567.89, 'N', 'ru-RU') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'ru-RU') AS FormattedDate
UNION ALL
SELECT 
    'ar-SA' AS CultureCode,
    FORMAT(1234567.89, 'N', 'ar-SA') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'ar-SA') AS FormattedDate
UNION ALL
SELECT 
    'el-GR' AS CultureCode,
    FORMAT(1234567.89, 'N', 'el-GR') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'el-GR') AS FormattedDate
UNION ALL
SELECT 
    'tr-TR' AS CultureCode,
    FORMAT(1234567.89, 'N', 'tr-TR') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'tr-TR') AS FormattedDate
UNION ALL
SELECT 
    'he-IL' AS CultureCode,
    FORMAT(1234567.89, 'N', 'he-IL') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'he-IL') AS FormattedDate
UNION ALL
SELECT 
    'hi-IN' AS CultureCode,
    FORMAT(1234567.89, 'N', 'hi-IN') AS FormattedNumber,
    FORMAT(GETDATE(), 'D', 'hi-IN') AS FormattedDate;

--CAST(value as datatype)
--converts a value to a specified data type.
select
    CAST('123' as int) [str to int],
    CAST(123 as varchar) [int to varchar],
    CAST('2025-05-20' as date) [str to date],
    CAST('2025-05-20' as datetime) [date to datetime],
    CAST(CreationTime as date) [datetime to date]
from Sales.Orders


/*
CAST - any type to any type, no formatting
CONVERT - any type to any type, formats only date and time
FORMAT - any type to only str, format date, time and numbers
*/