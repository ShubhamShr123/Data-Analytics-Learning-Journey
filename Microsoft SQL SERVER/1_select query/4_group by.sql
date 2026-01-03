--group by
--grouping on same country
select
	country,
	sum(score) as totalscore
from customers
group by country
order by country desc
/*GROUP BY RULE
all columns in the SELECT must be either aggregated or included in the GROUP BY*/

--finding the total score and total number of customers for each country
select
	country,
	COUNT(id) as total_customers,
	SUM(score) as Total_Score
from customers
group by country
order by Total_Score desc