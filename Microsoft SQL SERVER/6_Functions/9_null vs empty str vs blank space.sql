--NULL VS EMPTY VS BLANKSPACES

--BLANK SPACES
--string value having 1 or more space characters

WITH Orders AS ( --this is a cte we will learn about it later in the videos)
select 1 ID, 'A' Category UNION
select 2, NULL UNION
select 3, '' UNION
select 4, ' '
)
select *,
DATALENGTH(Category) Category_len --a function that counts the length of the data (just like len function)
from Orders;

/*
NULL - (value = null, unknown, Datatype = special marker, storage = very minimal, performance = best, comparison = is null / is not null)
EMPTY STR - (vlaue = '', known empty value, Datatype = string(0), storage = occupies memory, performance = fast, comparison = '')
BLANK SPACE - (value = ' ',known, space value, Datatype = string(1 or more), storage = occupies memory, performance = slow, comparison = ' ')
*/


--HANDLING NULLS / DATA POLICIES
--set of rules that how data should be handled

--DATA POLICY 1
--only use nulls and empty strings and avoid the blank spaces
WITH Orders_2 AS ( --this is a cte we will learn about it later in the videos
    SELECT 1 AS ID, 'A' AS Category
    UNION 
    SELECT 2 AS ID, NULL
    UNION 
    SELECT 3 AS ID, ''
    UNION 
    SELECT 4 AS ID, ' '
)
SELECT *,
    DATALENGTH(Category) AS Category_len,
    DATALENGTH(TRIM(Category)) as Policy_1
FROM Orders_2;

--DATA POLICY 2
--only use nulls and avoid using empty strings the blank spaces
WITH Orders_2 AS ( --this is a cte we will learn about it later in the videos
    SELECT 1 AS ID, 'A' AS Category
    UNION 
    SELECT 2 AS ID, NULL
    UNION 
    SELECT 3 AS ID, ''
    UNION 
    SELECT 4 AS ID, ' '
)
SELECT *,
    DATALENGTH(Category) AS Category_len,
    DATALENGTH(TRIM(Category)) as Policy_1,
    NULLIF(TRIM(Category), '') as Policy_2 --replaced the empty strings with nulls
FROM Orders_2;

--DATA POLICY 3
--only use default value 'unkown' and avoid using nulls, empty strings, and blank spaces
/*
replacing empty strings and blanks with NULL during data preparation before inserting into a database
to optimize storage and performance.
*/
WITH Orders_2 AS ( --this is a cte we will learn about it later in the videos
    SELECT 1 AS ID, 'A' AS Category
    UNION 
    SELECT 2 AS ID, NULL
    UNION 
    SELECT 3 AS ID, ''
    UNION 
    SELECT 4 AS ID, ' '
)
SELECT *,
    DATALENGTH(Category) AS Category_len,
    DATALENGTH(TRIM(Category)) as Policy_1, --removing the spaces
    NULLIF(TRIM(Category), '') as Policy_2, --replaced the empty strings with nulls,
    COALESCE(nullif(trim(Category), ''), 'unknown') as Policy_3 --replaced the nulls with unknown
FROM Orders_2;


--data policy usecases
/*
replacing empty strings and blanks with NULL during data preparation before inserting into a database
to optimize storage and performance.
*/

/*NULLS SUMMARY
special markers means missing value
using nulls can optimize storage and performance

FUNCTIONS
--COALESCE / ISNULL  (to replace nulls with a value)
--nullif (to replace a value with a null)
--is null / is not null (to check if the provided data is null or not null)

USECASES
handle nulls - before data aggregation
handle nulls - before mathematical operations
handle nulls - before joining tables
handle nulls - before sorting data
find unmatched data - left anti join
data policies (nulls or default values)
*/