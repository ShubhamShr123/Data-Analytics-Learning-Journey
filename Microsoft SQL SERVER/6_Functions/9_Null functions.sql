--COALESCE, ISNULL, NULLIF, IS(NOT)NULL

--Null
--means nothing! Unknown! not equal to anything!
--its not zero! its not empty a string! is not a blank space!

/*
IF WE HAVE A NULL AND WANT TO REPLACE IT TO A VALUE
FUNCTIONS AVAILABLE FOR THAT -> IS NULL, COALESCE

IF WE HAVE A VALUE AND WANT TO REPLACE IT TO NULL
FUNCTIONS AVAILABLE FOR THAT -> NULLIFF

IF WE WANT TO CHECK IF THE DATA IS NULL OR NOT
FUNCTIONS AVAILABLE FOR THAT -> IS NULL, IS NOT NULL
*/

--NULL FUNCTIONS

--ISNULL(value, replacement_value)
--limited to 2 values
--replaces null with a specified value
--for ex - ISNULL(Shipping_Add, 'unknown') --if any of the shipping address will be null it will be replaced by unkown
--(Shipping_Add, Billing_add) --if the billing add also have null it will replace the shipping add value to null

--COALESCE(value1, value 2, value 3....)
--can have unlimited values
--returns the first non null value from a list
--coalesce can work the same as isnull as it can also replace values
--coalesce(shipping_add, Billing_Add)
--BUT THE SPECIAL THING IS THAT WHAT IF THE REFRENCED TABLE value is also null at the time of replacement
--we can fill a static value or any other value we want
--COALESCE(Shipping_add, Billing_add, 'N/A')
--first it will check billing_add if billing_add is null then it will fillin the static value specified to Shipping_Add

