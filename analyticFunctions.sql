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
