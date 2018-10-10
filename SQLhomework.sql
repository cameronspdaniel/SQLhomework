USE sakila;
#1a
SELECT first_name, last_name
FROM actor;
#1b
SELECT UPPER(CONCAT(first_name, ' ', last_name)) AS 'Actor Name' 
FROM actor;

#2a
SELECT actor_id, first_name, last_name 
FROM actor WHERE first_name = 'Joe';  
#2b
SELECT * 
FROM actor 
WHERE last_name LIKE '%GEN%';
#2c
SELECT * 
FROM actor WHERE last_name LIKE '%LI%' 
ORDER BY last_name, first_name;
#2d
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan' , 'Bangladesh', 'China');

#3a
ALTER TABLE actor 
ADD COLUMN description BLOB;
#3b
ALTER TABLE actor 
DROP COLUMN description;

#4a
SELECT DISTINCT last_name, COUNT(last_name) AS 'Shared Lastname Count'
FROM actor
GROUP BY last_name;
#4b
SELECT DISTINCT last_name, COUNT(last_name) AS 'Shared Lastname Count'
FROM actor
GROUP BY last_name 
HAVING Shared_Lastname_Count >= 2 ;
#4c
UPDATE actor 
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';
SELECT * FROM actor
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

#5a(From: Google)
SHOW CREATE TABLE address;
CREATE TABLE IF NOT EXISTS
 `address` (
 `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
 `address` varchar(50) NOT NULL,
 `address2` varchar(50) DEFAULT NULL,
 `district` varchar(20) NOT NULL,
 `city_id` smallint(5) unsigned NOT NULL,
 `postal_code` varchar(10) DEFAULT NULL,
 `phone` varchar(20) NOT NULL,
 `location` geometry NOT NULL,
 `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 PRIMARY KEY (`address_id`),
 KEY `idx_fk_city_id` (`city_id`),
 SPATIAL KEY `idx_location` (`location`),
 CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

#6a
SELECT s.first_name, s.last_name, a.address, c.city, ctr.country
FROM staff s
INNER JOIN address a 
ON s.address_id = a.address_id 
INNER JOIN city c
ON a.city_id = c.city_id
INNER JOIN country ctr 
ON c.country_id = ctr.country_id;
#6b
SELECT s.first_name, s.last_name, SUM(p.amount) AS 'Payment Received'
FROM staff s
INNER JOIN payment p
ON s.staff_id = p.staff_id
WHERE p.payment_date LIKE '2005-08%'
GROUP BY p.staff_id;
#6c
SELECT title, COUNT(actor_id) AS 'Number of Actors'
FROM film f
INNER JOIN film_actor fa 
ON f.film_id = fa.film_id
GROUP BY title;
#6d
SELECT title, COUNT(inventory_id) AS 'Copies Count'
FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
WHERE title LIKE 'Hunchback Impossible';
#6e
SELECT first_name, last_name, SUM(amount) AS 'Total Amount Paid'
FROM customer c
INNER JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY last_name ASC;

#7a
SELECT title 
FROM film
WHERE language_id IN
(
	SELECT language_id 
	FROM language
	WHERE name = "English"
    AND ((title LIKE "K%") OR (title LIKE "Q%"))
);
#7b
SELECT first_name, last_name
FROM actor a
WHERE actor_id IN
(SELECT actor_id FROM film_actor
 WHERE film_id IN 
	(SELECT film_id FROM film
	 WHERE title = 'Alone Trip')
);
#7c
SELECT c.first_name, c.last_name, c.email
FROM customer c
INNER JOIN customer_list cl
ON c.customer_id = cl.ID
WHERE cl.country = 'Canada';
#7d
SELECT title
FROM film
WHERE film_id IN
(SELECT film_id
 FROM film_category
 WHERE category_id IN
	(SELECT category_id
	 FROM category
	 WHERe name = 'Family')
);
#7e (From: Google )
SELECT f.title, COUNT(*) AS 'Rented_Count'
FROM film f, inventory i, rental r
WHERE f.film_id = i.film_id AND r.inventory_id = i.inventory_id
GROUP BY i.film_id
ORDER BY COUNT(*) DESC, f.title ASC;
#7f
SELECT s.store_id, SUM(amount) AS revenue
FROM store s
INNER JOIN staff sf
ON s.store_id = sf.store_id
INNER JOIN payment p
ON p.staff_id = sf.staff_id
GROUP BY s.store_id;
#7g
SELECT s.store_id, c.city, ctr.country
FROM store s
INNER JOIN address a
ON s.address_id = a.address_id
INNER JOIN city c
ON a.city_id = c.city_id
INNER JOIN country ctr
ON c.country_id = ctr.country_id;
#7h (From Google)
SELECT name, SUM(p.amount) AS gross_revenue
FROM category c
INNER JOIN film_category fc 
ON fc.category_id = c.category_id
INNER JOIN inventory i 
ON i.film_id = fc.film_id
INNER JOIN rental r 
ON r.inventory_id = i.inventory_id
RIGHT JOIN payment p 
ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY gross_revenue DESC LIMIT 5;

#8a (From Google)
DROP VIEW IF EXISTS top_five_genres;
CREATE VIEW top_five_genres AS

SELECT name, SUM(p.amount) AS gross_revenue
FROM category c
INNER JOIN film_category fc ON fc.category_id = c.category_id
INNER JOIN inventory i ON i.film_id = fc.film_id
INNER JOIN rental r ON r.inventory_id = i.inventory_id
RIGHT JOIN payment p ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY gross_revenue DESC LIMIT 5;
#8b
SELECT * 
FROM top_five_genres;
#8c
DROP VIEW top_five_genres