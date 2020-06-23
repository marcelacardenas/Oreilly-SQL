-- Testing knowledge 
use sakila;
-- Indexes and Constraints -- CHAPTER 13

ALTER TABLE rental 
ADD constraint fk_customer_id FOREIGN KEY (customer_id) 
REFERENCES customer (customer_id) ON DELETE RESTRICT;

CREATE INDEX idx_payment01
on payment (payment_date, amount);

EXPLAIN select * from payment;

-- VIEWS -- CHAPTER 14

create view film_ctgry_actor as
select title, name as category_name, first_name, last_name
from category c
inner join film_category fc on c.category_id = fc.category_id
inner join film f on f.film_id = fc.film_id
inner join film_actor fa on f.film_id = fa.film_id
inner join actor a on a.actor_id = fa.actor_id
where last_name = 'FAWCETT';
 

select title,category_name, first_name, last_name
from film_ctgry_actor;


create view ctry_payments3
as 
select c.country,
(select sum(p.amount)
from city ct 
inner join address ad on ad.city_id = ct.city_id
inner join customer c on c.address_id = ad.address_id
inner join payment p on c.customer_id = p.customer_id
where ct.country_id = c.country_id) tot_payments
from country c;

select country,tot_payments from ctry_payments3 ;

-- METADATA -- CHAPTER 15

SELECT distinct table_name,index_name
from information_schema.statistics
where table_schema = 'sakila';
