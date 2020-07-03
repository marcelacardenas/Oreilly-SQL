-- Testing knowledge 
use sakila;
-- Analytic Functions -- CHAPTER 16 

select quarter(payment_date) quarter, monthname(payment_date),sum(amount) quarter_sales
from payment
where year(payment_date) = 2005
group by 1,2;

select quarter(payment_date) quarter, 
monthname(payment_date),
sum(amount) quarter_sales,
max(sum(amount)) over() max_overall_sales,
max(sum(amount)) over (partition by quarter(payment_date)) max_qrtr_sales
from payment
where year(payment_date) = 2005
group by 1,2;

select quarter(payment_date) quarter, 
monthname(payment_date),
sum(amount) monthly_Sales,
rank() over (order by sum(amount) desc) ranking
from payment
where year(payment_date) = 2005
group by 1,2
order by 1,2;

select quarter(payment_date) quarter, 
monthname(payment_date),
sum(amount) monthly_Sales,
rank() over (partition by quarter(payment_date) order by sum(amount) desc) ranking
from payment
where year(payment_date) = 2005
group by 1,2
order by 1,2;

-- row_number() "Returns a unique number for each row" IN CASE OF A TIE: with rankings arbitraily assigned 
-- rank() "Returns the same ranking" IN CASE OF A TIE : gaps* in the rankings
-- dense_rank() "Returns the same ranking" IN CASE OF A TIE: no gaps in the rankings

select customer_id, 
count(*) num_rentals,
row_number() over (order by count(*) desc) rowNumber,
rank() over (order by count(*) desc) rankRentals,
dense_rank() over (order by count(*) desc) denseRentals
from rental
group by customer_id 
order by 2 desc;

select customer_id,
monthname(rental_date) month_name,
count(*) num_rentals,
dense_rank() over (partition by monthname(rental_date) -- how to devide the result set into diff DATA WINDOWS
order by count(*) desc) ranking -- order by how the rankings should be allocated
from rental
group by customer_id , monthname(rental_date)
order by 2,3 desc; -- order by how the result data should be sorted 

-- TOP 5 CUSTOMERS FOR EACH MONTH
select customer_id, rental_month, num_rentals, ranking 
from 
(SELECT customer_id,
monthname(rental_date) rental_month,
count(*) num_rentals,
row_number() over (partition by monthname(rental_date) -- how to devide the result set into diff DATA WINDOWS
order by count(*) desc) ranking -- order by how the rankings should be allocated
from rental
group by customer_id , monthname(rental_date)
order by 2,3
) rnk_customers
where ranking <= 5
order by rental_month, num_rentals desc, ranking;

-- REPORTING FUNCTIONS
select monthname(payment_date) payment_month, amount,
sum(amount) over (partition by monthname(payment_date)) monthly_total,
sum(amount) over() grand_total
from payment
where amount >= 10
order by 1;

select sum(amount), monthname(payment_date) namemonth
from payment
where monthname(payment_date) = 'August'
group by namemonth;
                      
-- monthly total on max min or middle
select monthname(payment_date) monthname, sum(amount) total_per_month,
case SUM(amount)
when MAX(SUM(amount)) over ()then 'Highest'
WHEN MIN(SUM(amount)) over () then 'Lowest'
ELSE 'Middle'
end description
from payment 
group by 1;

-- payments for each week
select yearweek(payment_date) payment_week, sum(amount) week_total, sum(sum(amount))
over (order by yearweek(payment_date) rows unbounded preceding) rolling_sum    -- including the current row
from payment
group by yearweek(payment_date)
order by 1;

select yearweek(payment_date) payment_week, sum(amount) weektotal, avg(sum(amount)) 
over (order by yearweek(payment_date) 
rows between 1 preceding and 1 following) rolling_3wk_avg -- data window consisting current row, prior row and next row
from payment
group by yearweek(payment_date)
order by 1;

-- lag prior row / lead following row 
select yearweek(payment_date), sum(amount) week_total,
lag (sum(amount),1) over (order by yearweek(payment_date)) prev_week,
lead (sum(amount),1) over (order by yearweek(payment_date)) next_week
from payment
group by yearweek(payment_date);

-- % difference from prior week "comparing values from different rows"
select yearweek(payment_date), sum(amount) week_total,
round ((sum(amount) - lag(sum(amount),1) over (order by yearweek(payment_date))) 
/ lag(sum(amount),1) over (order by yearweek(payment_date)) * 100,1) pct_diff
from payment
group by yearweek(payment_date);
 
-- common value concatenation "group_concat" 
-- acts like an aggregate that pivots all of the last names of all actos appearing in each film into a single string 
select f.title, group_concat(a.last_name order by a.last_name separator ', ') actors 
from actor a
inner join film_actor fa on fa.actor_id = a.actor_id
inner join film f on f.film_id = fa.film_id
group by f.title
having count(*) = 3;

show tables;

create table sales_Fact (
year_no int,
month_no int,
tot_sales int);

select * from sales_Fact;

select year_no, month_no, tot_sales,
rank () over(order by tot_sales desc) ranksales
from sales_fact;

select year_no, month_no, tot_sales,
rank () over (partition by year_no order by tot_sales desc) ranksales
from sales_fact;

select year_no, month_no, tot_sales, 
lag (tot_sales) over(order by tot_sales desc) prev_month
from sales_fact
where year_no = '2020';
