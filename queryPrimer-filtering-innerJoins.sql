-- Testing knowledge 
use sakila;

-- Query Primer  - CHAPTER 3 
select actor_id, first_name, last_name 
from actor
order by 3,2;

select actor_id, first_name, last_name 
from actor
where last_name IN ('WILLIAMS', 'DAVIS');

select distinct customer_id
from rental
where date(rental_date) = '2005-07-05'
order by customer_id;

select email, return_date
from customer c 
	inner join rental r on c.customer_id = r.customer_id
where date(rental_date) = '2005-06-14'
order by return_date desc;

-- Filtering -- CHAPTER 4
select payment_id
from payment
where customer_id <> 5 and (amount > 8 or date(payment_date) = '2005-08-23');

create view ex5 as (
select payment_id, customer_id, amount, date(payment_date) as date
from payment
where payment_id between 101 and 120);

select payment_id
from ex5
where customer_id = 5 and not (amount > 6 or date = '2005-06-19');

select * from payment
where amount in ('1.98','7.98','9.98');

SELECT first_name, last_name FROM customer
where last_name LIKE '_A%W%';

-- Querying Multiple Tables -- CHAPTER 5
select c.first_name, a.address
from customer c  join address a
on c.address_id = a.address_id;

select c.first_name, last_name, a.address, ct.city 
from customer c 
inner join  address a on c.address_id = a.address_id
inner join city ct on a.city_id = ct.city_id
where a.district = 'California';

select f.title, a.first_name
from film f
inner join film_actor fa on f.film_id = fa.film_id
inner join actor a on fa.actor_id = a.actor_id
where a.first_name = 'JOHN';

select a.address, ad.address
from address a
inner join address ad on a.city_id = ad.city_id
where ad.address <> a.address ;
