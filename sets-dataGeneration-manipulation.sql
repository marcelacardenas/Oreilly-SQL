-- Testing knowledge 
use sakila;

-- Working with sets -- CHAPTER 6
select a.first_name, a.last_name
from actor a 
where a.last_name like 'L%'
UNION
select c.first_name, c.last_name 
from customer c
where c.last_name like 'L%'
order by last_name;

-- Data Generation, Manipulation and Conversion -- CHAPTER 7
SELECT name, name LIKE '%y' ends_in_y
FROM category;

SELECT name, name REGEXP'y$' ends_in_y
FROM category;

select substring('Please find the substring in this string',17,9);

select -25.76823, sign(-25.76823), abs(-25.76823), round(-25.76823,2);

select rental_date, extract(month from return_date) as month
from rental;
           
-- Grouping and Aggregates --CHAPTER 8 
-- Interact with some higher level of granularity than what is stored in the database
-- Finding trends in the data 

select customer_id, count(*) as count
from rental
group by customer_id
having count >= 40
order by 2 desc;

select customer_id, max(amount) as max, min(amount) as min, avg(amount) as average, sum(amount) as total, count(*) as totalpayments 
from payment
group by customer_id
order by total desc;

select fa.actor_id, f.rating,count(*)
from film_actor fa
inner join film f on f.film_id = fa.film_id
group by fa.actor_id,f.rating
order by 1,2;

select extract(year from rental_date) year, count(*) how_many
from rental
group by year;

select fa.actor_id, f.rating,count(*)
from film_actor fa
inner join film f on f.film_id = fa.film_id 
group by fa.actor_id,f.rating WITH ROLLUP
order by 1,2;

select customer_id, count(*) as numberofpayments, sum(amount) as totalpaid
from payment
group by customer_id
having count(*) > 40;
