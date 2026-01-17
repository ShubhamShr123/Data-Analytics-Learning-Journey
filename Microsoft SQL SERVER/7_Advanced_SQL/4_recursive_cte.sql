--RECURSIVE CTE
--a self refrencing query that repeatedly processes data until a specific condition is met.
/*
1. The query of the CTE will be executed for the first time
and we will get the initial data from the CTE
2. This intermediate result is not ready yet for the main query
3. This intermediate result will go to back to the CTE gonna check whether the current results is meeting specific conditions or not
4.  If not the CTE query gonna be executed second time (its result will be added to the intermediate results) and this loop continues
5. Now intermediate resuls will have more data
6. Again before we can use it from the main query it is gonna be checked if the result fulfils the condition or not
7. if the condition fulfils the loop gonna end and the result is ready to use from the main query

SYNTAX
WITH CTE_NAME As (
    SELECT... --if we just use this one query it will be executed only once
    FROM...
    WHERE...

    UNION ALL --in sql we cant have 2 sel statements like this (so we have to connect it using the union or union ALL   )

    SELECT...
    FROM CTE_NAME --here we refrenced the cte name to itself
    WHERE [BREAK CONDITION] --in order to break the loop
)
SELECT...
FROM CTE_NAME
WHERE...
OPTION (MAXRECURSION 30) --optional (limit set to iterate)

1. the first query in the with query is called ANCHOR QUERY (will only be executed once)
2. the second query in the with query is called RECURSIVE QUERY (will keep looping until certain condition is met)
3. the second query will keep repeating and add data to the intermediate results until the condition is met (or when there is no more data available to be processed)
*/

--generate a sequence of numbers from 1 to 20

WITH Series As (
--anchor query
SELECT 1 AS MyNum
UNION ALL
--recursive query
SELECT
    MyNum + 1
FROM Series
WHERE MyNum < 20
)
SELECT *
FROM Series
OPTION (MAXRECURSION 30) --this will make the query not iterate more than 30

--TASK : Show the employee hierarchy by diplaying each employee's level within the organization

WITH CTE_EMP_Hierarchy as (
    --ANCHOR QUERY
    SELECT
        EmployeeID,
        FirstName,
        ManagerID,
        1 as Level
    from Sales.Employees
    WHERE ManagerID IS NULL


)
SELECT
*
FROM CTE_EMP_HIERARCHY