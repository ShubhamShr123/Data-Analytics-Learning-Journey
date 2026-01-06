--IN SQL WE HAVE 5 DIFFERENT TECHNIQUES TO REDUCTE AND OPTIMIZE THE COMPLEXITY OF SQL QUERIES
--THESE ARE
--SUBQUERY, CTE(COMMON TABLE EXPRESSION), VIEW, TMP, CTAS(Create Table As Select)

--Question arises - Why do we need those techniques
--SQL DATA PROJECTS (REAL WORLD SCENARIOS)

/*
Normally in projects we have a database and person responsible for the database structure (dba (data base administrator))
In simple scenario we are having a user who is writing queries to retieve the data from the database and after writing the query the user will be getting the results 

BUT IN THE REAL PROJECT THINGS GET VERY COMPLICATED
Let suppose we have
1. Financial Analyst : (that is writing huge block of sql queries which is very complex)
2. Risk Manager : (is also writing complex and huge block of sql queries)
3. and for different departments and different projects for different task we will be having lot of analysts that are writing many complex queries

All of those will be having direct access to the database and they are executing complex sql queries in order to generate report or something

We wil also be having DATA ENGINEER
who will be :
1. building data warehouse
2. extract the data
3. writing extract queries
4. after extraction writing different scripts for transformation (in order to manipulate, filter, cleanup, aggregate your data)
5. 3rd script to collect the results of the transformation and load it in another database called data warehouse

DATA WAREHOUSE : A special database that collects and integrates data from different sources to enable analytics and support decision making.

In the end of this chain we will be having a DATA ANALYST 
Who wil be :
1. writing queries to analyse the data in the data warehouse

Or we might have a different query to prepare the data before insert it into a tool like power bi in order to generate reports and visualization

SO WE CALL THIS A DATA WAREHOUSE SYSTEM / BUSINESS INTELLIGENCE SYSTEM

Now we also have DATA SCIENTIST having direct access to database
Who will be :
1. writing different queries to extract the data
2. manipulating the data that are needed in order to develop a model and doing machine learning and AI

The results of the data analyst gonna be used in another query in order to prepare the results for power bi or exporting the results as and excel list

So we have a lot of people having different roles that want to access the database and do analysis on top of it
because everyone wants to answer the questions based on the data

IN THIS WE WILL FIND MANY CHALLENGES AND PROBLEMS:
1. Redundancy (because if we compare all queries used by everyone we will find we are having same logic repeating over and over)
2. Performance Issues
3. Complexity
4. Hard to Maintain
5. Database stress
6. Security

SOLUTIONS
1. Subqueries
2. CTE
3. Views
4. Temporary Tables
5. CTAS (Create Table As Select)
*/

--SIMPLIFIED DATA ARCHITECTURE
/*
DATABASE ENGINE : Brain of the databse handling multiple operations such as storing, retireving and managing the data within the database.

In the database we have a very important component that is the storage
Two types of storage in a db are :
1. DiskStorage : Long Term memory where the data is stored permanently even if we turn off the system (I can store lot of data, but its slow to read and write)
2. Cache : Short Term memory where data is stored temporarily (Extremely fast to read and write, but can hold only smaller amount of data (for short term only))

DISK STORAGE
is having 3 types
1. USER : Main content of the db. This is where the actual data that users care about is stored
2. TEMP STORAGE : It is a temprory space used by the database for short term tasks, like processing queries and sorting the data. Once these tasks are done, the storage is cleared. 
3. CATALOG : DB's internal storage for its own information. A blueprint that keeps track of everything about the database itself, not the user data (it holds the metadata information about the DB [METADATA : Data about Data])

METADATA LOOKS LIKE THIS:
Let suppose we have a customer table its metdata will look like this:
Table Name | Column Name | Data Type | Size | Constraints
Customer   | CustomerID  | INT       | 4    | PRIMARY KEY
Customer   | FirstName   | VARCHAR   | 50   | NOT NULL
Customer   | LastName    | VARCHAR   | 50   | NOT NULL
Customer   | Email       | VARCHAR   | 100  | UNIQUE

since we are working on our database we have full acess to everything inside the sql server but in real projects if we are just a user or developer we will not have the access to the system databases (only for db administrators)

SO THESE ARE ALL THE COMPONENTS OF THE DATABASE ARCHITECTURE
*/

/*
We can find system catalog / metadata in the information schema of the database
INFORMATION SCHEMA : A system defined schema with built-in views that provide information about all the database objects such as tables, columns, data types, and constraints.
*/
--LIKE
SELECT
*
FROM INFORMATION_SCHEMA.COLUMNS;
--AND THIS
SELECT
DISTINCT TABLE_NAME
FROM INFORMATION_SCHEMA.COLUMNS;