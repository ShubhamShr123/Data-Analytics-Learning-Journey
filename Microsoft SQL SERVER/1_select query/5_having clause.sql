--Having clause
--filters data after aggregation
--filters end results
--can only be used after using the GROUP BY


--finding the total customers and total score for each country (having the score > 500)
select
	country,
	COUNT(id) as Total_customers,
	SUM(score) as Total_Score
from customers
group by country
having SUM(score) > 500
order by Total_Score desc

--finding the total customers and total score for each country (having the score < 860)
select
	country,
	COUNT(id) as Total_customers,
	SUM(score) as Total_Score
from customers
group by country
having SUM(score)<860
order by Total_Score desc

--finding the avg score for each country considering only the customers with a score not equal to 0
--and returning only the country with an avg score > than 430
select
	country,
	AVG(score) as AVG_Score
from customers
where score!=0
group by country
having AVG(score)>430
order by AVG_Score desc