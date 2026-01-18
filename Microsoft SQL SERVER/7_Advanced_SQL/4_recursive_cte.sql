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
    UNION ALL
    --RECURSIVE QUERY
    SELECT 
        e.EmployeeID,
        e.FirstName,
        e.ManagerID,
        Level + 1
    FROM Sales.Employees as e
    INNER JOIN CTE_EMP_Hierarchy as ceh
    on e.ManagerID = ceh.EmployeeID
)
SELECT
*
FROM CTE_EMP_HIERARCHY
/*
1. Anchor query - Ran only once (which will select the top level employee not having any manager)
2. Recursive query - works by searching if a manager id is equal to which employee id(
    a. first it will check the 1st row which is frank having no manager id so the recursive query will not find any match and will skip it.
    b. the it will move to the next row (which is kevin) having Frank as manager id so it will find a match and add kevin to the intermediate results with level 2
    c. then it will move to the next row (which is mary) having frank as manager id so it will find a match and add mary to the intermediate results with level 2
    d. now next iteration will be started (as now there are no more employees having the frank as their manager id) so the next level will be 3
    e. from the next line onwards it will keep searching for employees having either kevin or mary as their manager id and will keep adding them to the intermediate results with level 3
    f. (as the sql stops searching for the employees having the ManagerID as (2(kevin), 3(mary)) now the 2rd iteration will end and 3rd iteration will start which will search if there are any employees having the managerid as (4 Michael), (5 Carol))this will continue until there are no more employees left to process (ie no more matches found)
)
*/

/*
SUMMARY

CTE is a temprory named result set that can be used multiple times within a QUERY
ADVANTAGES OF CTE:
1. Readability - makes complex queries easier to read and understand by breaking them into smaller, manageable parts.
2. Modularity - allows you to define a CTE once and reference it multiple times within the same query, promoting code reuse.
3. Reusability - CTEs can be reused within the same query, reducing redundancy and improving maintainability.
4. Organization - helps organize complex queries by separating different logical parts into distinct sections.
5. Recursion - supports recursive queries, enabling you to work with hierarchical or self-referential data structures.

1. Result of CTE is like Tables which cant be used from multiple queries outside the main query where it is defined
2. TIP : Dont create more than 5 cte in a single query as it may impact performance negatively and readability
*/