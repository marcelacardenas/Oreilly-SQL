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


