--VALUE WINDOW FUNCTIONS
--these functions are used to access value from another row
/*
Lets suppose we have a table:
Month | Sales
jan   | 100
feb   | 200
mar   | 300
apr   | 400
may   | 500
jun   | 600
jul   | 700

if we are on the current row (let suppose on april row)
WE CAN USE
1. LAG() fucntion to access value from previous row (means mar row )
2. LEAD() function to access value from next row (means may row)
3. first_value() function to access value from first row (means jan row)
4. last_value() function to access value from last row (means jul row)

RULES
1. LAG(expr, OFFSET, default) [Expression : All data type, OFFSET : Number of rows forward or backward from current row default = 1, Default : Returns a default value if next or prev row is not available (default = null), Partition Clause : Optional, Order Clause : Required, Frame Clause : Not Allowed]
2. LEAD(expr, OFFSET, default) [Expression : All data type, OFFSET : Number of rows forward or backward from current row default = 1, Default : Returns a default value if next or prev row is not available (default = null), Partition Clause : Optional, Order Clause : Required, Frame Clause : Not Allowed]
3. first_value(expr) [Expression : All data type, Partition Clause : Optional, Order Clause : Required, Frame Clause : Optional]
4. last_value(expr) [Expression : All data type, Partition Clause : Optional, Order Clause : Required, Frame Clause : Should be used]

(so that we can compare the sales of different months)
ORDER BY is mandatory to use
*/

--VALUE WINDOW FUNCTIONS
--MIN / MAX

--LEAD() Access the value from the next row within a window
--LAG() Access the value from the previous row within a window
