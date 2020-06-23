-- Testing knowledge 
use sakila;
-- JOINS Revisited -- CHAPTER 10 
select one.num + two.num
from
(
select 1 num 
union all
select 2 num
union all
select 3 num 
union all
select 4 num
union all
select 5 num 
union all
select 6 num
union all
select 7 num 
union all
select 8 num
union all
select 9 num 
union all
select 10 num) one
cross join
(select 0 num 
union all
select 10 num 
union all
select 20 num
union all
select 30 num 
union all
select 40 num
union all
select 50 num 
union all
select 60 num
union all
select 70 num 
union all
select 80 num
union all
select 90 num ) two;

-- Conditional Logic -- CHAPTER 11 

select Name, 
( CASE 
when category.name in ('Children','Family','Sports','Animation','Action')
then 'All ages'
when category.name = 'Horror' 
then 'Adults'
when category.name in ('Music','Games')
then 'Teens'
else 'Other'
END) as Classification
FROM category;

select c.first_name, c.last_name, 
case when active = 0 then 0
else (select count(*) from rental r
where r.customer_id = c.customer_id)
end num_rentals
from customer c;          

select monthname(rental_date),count(*) num_rentals
from rental
where rental_date between '2005-05-01' and '2005-08-01'
group by monthname(rental_date);

select 
SUM(case when monthname(rental_date) = 'May' THEN 1 ELSE 0 END) May,
SUM(case when monthname(rental_date) = 'June' THEN 1 ELSE 0 END) June,
SUM(case when monthname(rental_date) = 'July' THEN 1  ELSE 0 END) July
from rental
where rental_date between '2005-05-01' and '2005-08-01';

select name, case 
WHEN language.name in ('English','Italian','French','German')
THEN 'latin'
WHEN language.name in ('Japanese','Mandarin')
THEN 'utf8'
ELSE 'Unknown'
END character_set
from language;

select rating, count(*)
from film
group by rating;

select
sum(case when rating = 'PG' then 1 else 0 end  ) PG,
sum(case when rating = 'G' then 1 else 0 end ) G,
sum(case when rating = 'NC-17' then 1 else 0 end ) NC17,
sum(case when rating = 'PG-13' then 1 else 0 end ) PG13,
sum(case when rating = 'R' then 1 else 0 end )  R
from film;
