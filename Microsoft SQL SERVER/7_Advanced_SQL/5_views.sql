--view is not like a query that we can use in sql but it is an object which we can find in a database

/*
WE HAVE HIERARCHY STRUCTURE IN A DATABASE

SQL SERVER > DATABASE > Multiple SCHEMAS > TABLE/VIEW/PROCEDURE/INDEX/FUNCTION

1. Database server - stores, manages, and provides access to databases for users or applications.
2. Database - Collection of information that is stored in a structured way (can be multiple databases in a server)
3. Schema - logical layer that groups related objects together (can be multiple schemas in a database)
4. Table - a place where data is stored and organized in rows and columns (can have multiple columns, keys etc etc)
5. View - virtual table that shows data without storing it physically (can have multiple columns(for each column we have a name and datatype)).

NOW IN ORDERD TO MANAGE THIS STRUCUTURE WE HAVE DIFFERENT SQL COMMANDS CALLED DDL COMMANDS (DATA DEFINITION LANGUAGE)
    CREATE
    ALTER
    DROP

DATABASE 3 LEVE ARCHITECTURE
abstraction lowest to highest from physical to logical to view
abstraction means hiding the complex implementation details and showing only the essential features of the object.
    ^
    |
    |3rd LEVEL - EXTERNAL LEVEL (VIEW)
    |2ND LEVEL - CONCEPTUAL LEVEL / LOGICAL LEVEL (TABLE)
    |1ST LEVEL - INTERNAL LEVEL / PHYSICAL LEVEL (STORAGE)
    |
    ^ 
    1. PHYSICAL LEVEL - It is the lowest level of the database where the actual data is stored in the physical storage (bascially there will be datafiles, partitions, logs, catalogues, blocks, caches) and usually who has access to this level are the database administrators.
    2. LOGICAL LEVEL - Less complicated than the physical layer, at this level we have to deal on how to organize our data, and normally we have here an application developers, data engineers who design the database structure, views, procedures, tables, relationships, constraints, indexes etc etc.
    3. VIEW LEVEL - Its the highest level of abstraction in the db, it is what the end users and applications can access and see. For example we have have 1 view for the business analysts (so we prepare and customize view that are suitable only for them), another set of views for data visualizations (like powerbi, tableau etc), another view for end users, another view for specific purpose or use cases etc.

WHAT IS A VIEW?
a virtual table based on the result set of an sql query, without storing the data in the database (physically).
view are stored or presisted SQL queries in the database.

t
*/