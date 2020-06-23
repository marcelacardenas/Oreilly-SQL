-- Testing knowledge 
use sakila;
-- Grouping and Aggregates --CHAPTER 8 
-- Interact with some higher level of granularity than what is stored in the database -- Finding trends in the data 

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

-- Subqueries -- CHAPTER 9

select city_id,city
from city
where country_id <>  (select country_id from country where country ='India');

select city_id,city
from city
where country_id NOT IN (select country_id from country where country in ('Canada','Mexico'));

Select customer_id, first_name, last_name
from customer
where customer_id NOT IN (select customer_id from payment where amount=0);

select customer_id, count(*)
from rental 
group by customer_id
having count(*) > all
(select count(*) from rental r inner join customer c on r.customer_id = c.customer_id
inner join address a on c.address_id = a.address_id
inner join city ct on ct.city_id = a.city_id
inner join country co on co.country_id = ct.country_id 
where co.country in ('United States','Mexico','Canada')
group by r.customer_id);

select customer_id, sum(amount) as total
from payment
group by customer_id
having total > any
(select sum(amount) 
from payment p 
inner join customer c on c.customer_id = p.customer_id
inner join address a on c.address_id = a.address_id
inner join city ct on ct.city_id = a.city_id
inner join country co on co.country_id = ct.country_id 
where co.country in ('Bolivia','Paraguay','Chile')
group by co.country);

select datediff (now(), r.rental_date) as days_since_last_rental
from rental r;

select actor_id, film_id
from film_actor
where (actor_id, film_id) IN 
(SELECT a.actor_id, f.film_id
from actor a
cross join film f 
where a.last_name ='Monroe' and f.rating= 'PG');


select title, f.film_id
from film_category fc
inner join category c on  c.category_id = fc.category_id
inner join film f on  f.film_id = fc.film_id
where name = 'Action';

-- noncorrelated subquery
select title
from film 
where film_id in
(select fc.film_id
from film_category fc
inner join category c on  c.category_id = fc.category_id
where name = 'Action');

-- correlated subquery
select f.title
from film f
where EXISTS 
(select 1 
from film_category fc
inner join category c on  c.category_id = fc.category_id
where name = 'Action' and f.film_id = fc.film_id);

select count(*) counts, actor_id
from film_actor
group by actor_id
order by counts desc;
 
select actr.actor_id, grps.level
from
(select actor_id, count(*) num_roles
from film_actor
group by actor_id ) actr
inner join
( select 'holywood Star' level, 30 min_roles, 9999 max_roles
union all
select 'Prolific Actor' level, 20 min_roles, 29 max_roles
union all
select 'Newcomer' level , 1 min_roles, 19 max_roles) grps
on actr.num_roles BETWEEN grps.min_roles and grps.max_roles;