/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

SELECT 
STAFF.FIRST_NAME AS MANAGER_FIRST_NAME,
STAFF.LAST_NAME AS LAST_NAME,
ADDRESS.ADDRESS AS ADDRESS,
ADDRESS.DISTRICT AS  DISTRICT,
CITY.CITY AS CITY,
COUNTRY.COUNTRY AS COUNTRY 
FROM 
STORE 
INNER JOIN STAFF ON STAFF.STAFF_ID=STORE.MANAGER_STAFF_ID
INNER JOIN ADDRESS ON ADDRESS.ADDRESS_ID=STAFF.ADDRESS_ID
INNER JOIN CITY ON ADDRESS.CITY_ID=CITY.CITY_ID
INNER JOIN COUNTRY ON COUNTRY.COUNTRY_ID=CITY.COUNTRY_ID;



/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

SELECT 
A.INVENTORY_ID AS INVENTORY_ID,
A.STORE_ID AS STORE_ID,
B.TITLE AS NAME_OF_FILM,
B.RATING AS FILMS_RATING ,
B.RENTAL_RATE,
B.REPLACEMENT_COST
FROM 
INVENTORY  A 
LEFT JOIN FILM B 
ON A.FILM_ID=B.FILM_ID;

/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/

SELECT 
COUNT(A.INVENTORY_ID) AS COUNT_OF_INVENTORY_ITEMS,
A.STORE_ID AS STORE_ID,
B.RATING AS FILMS_RATING 
FROM 
INVENTORY  A 
LEFT JOIN FILM B 
ON A.FILM_ID=B.FILM_ID
GROUP BY A.STORE_ID, B.RATING
ORDER BY STORE_ID; 











/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 


SELECT 
INV.STORE_ID,
COUNT(INV.INVENTORY_ID) AS FILMS,
CTG.NAME,
AVG(FLM.REPLACEMENT_COST),
SUM(FLM.REPLACEMENT_COST)
FROM 
INVENTORY INV 
LEFT JOIN 
FILM FLM  ON FLM.FILM_ID=INV.FILM_ID
LEFT JOIN FILM_CATEGORY FLM_CTG
ON FLM.FILM_ID=FLM_CTG.FILM_ID
LEFT JOIN CATEGORY CTG
ON CTG.CATEGORY_ID=FLM_CTG.CATEGORY_ID

GROUP BY 1,3
ORDER  BY SUM(FLM.REPLACEMENT_COST) DESC;






/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

SELECT 
CUST.FIRST_NAME,
CUST.LAST_NAME,
CUST.STORE_ID,
CUST.ACTIVE,
ADDR.ADDRESS,
CITY.CITY,
COUNTRY.COUNTRY
FROM 
	CUSTOMER CUST
LEFT JOIN ADDRESS ADDR ON CUST.ADDRESS_ID=ADDR.ADDRESS_ID
LEFT JOIN CITY CITY ON ADDR.CITY_ID=CITY.CITY_ID
LEFT JOIN COUNTRY COUNTRY ON COUNTRY.COUNTRY_ID=CITY.COUNTRY_ID;



    




/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

SELECT 
CUST.FIRST_NAME,
CUST.LAST_NAME,
COUNT(RENTAL.RENTAL_ID) TOTAL_LIFE_TIME_RENTALS,
SUM(PYMT.AMOUNT) AS TOTAL_PAYMENTS 
FROM 
CUSTOMER CUST
LEFT JOIN RENTAL RENTAL  ON RENTAL.CUSTOMER_ID=CUST.CUSTOMER_ID 
LEFT JOIN PAYMENT PYMT ON PYMT.RENTAL_ID=RENTAL.RENTAL_ID
GROUP BY 1,2
ORDER BY 4 DESC;

    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/


SELECT 
'INVESTOR' AS TYPE,
FIRST_NAME,
LAST_NAME,
COMPANY_NAME
FROM 
INVESTOR
UNION 
SELECT  
'ADVISOR' AS TYPE ,
FIRST_NAME,
LAST_NAME,
NULL
FROM ADVISOR;




/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

SELECT
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END AS number_of_awards, 
    AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film
	
FROM actor_award
	

GROUP BY 
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END