select job_industry_category, count (*) as count_clients
from customer
group by job_industry_category
order by count_clients desc; 

select date_trunc('month', transaction_date)::date as transaction_month,
c.job_industry_category, sum(t.list_price) as total_sales
from transaction t
join customer c on t.customer_id = c.customer_id 
group by transaction_month, c.job_industry_category
order by transaction_month, c.job_industry_category;

select count(*) as total_orders, t.brand, t.order_status, c.job_industry_category, t.online_order
from transaction t
join customer c on t.customer_id = c.customer_id
where order_status = 'Approved' and c.job_industry_category = 'IT' and t.online_order = 'True'
group by t.brand, t.order_status, c.job_industry_category, t.online_order
order by total_orders desc;

select
	c.customer_id, 
	sum(t.list_price) as total_spent, 
	max(t.list_price) as max_spent, 
	min(t.list_price) as min_spent,
	count(t.transaction_id) as total_transactions  
from transaction t
join customer c on t.customer_id = c.customer_id
group by c.customer_id 
order by total_spent desc, total_transactions desc;

select c.customer_id,
       SUM(t.list_price) OVER (PARTITION BY c.customer_id) AS total_spent,
       MAX(t.list_price) OVER (PARTITION BY c.customer_id) AS max_transaction,
       MIN(t.list_price) OVER (PARTITION BY c.customer_id) AS min_transaction,
       COUNT(t.transaction_id) OVER (PARTITION BY c.customer_id) AS total_transactions
from transaction t
join customer  c on t.customer_id = c.customer_id
order by total_spent DESC, total_transactions DESC;

with customer_total as (
	select c.customer_id, c.first_name, c.last_name, sum(t.list_price) as total_spent
	from transaction t
	join customer  c on t.customer_id = c.customer_id 
	group by c.customer_id, c.first_name, c.last_name 
)
select first_name, last_name, total_spent 
from customer_total 
where total_spent = (select min(total_spent) from customer_total); 

with customer_total as (
	select c.customer_id, c.first_name, c.last_name, sum(t.list_price) as total_spent
	from transaction t
	join customer  c on t.customer_id = c.customer_id 
	group by c.customer_id, c.first_name, c.last_name 
)
select first_name, last_name, total_spent 
from customer_total 
where total_spent = (select max(total_spent) from customer_total);

select customer_id, transaction_id, transaction_date, list_price 
from (
	select t.customer_id, t.transaction_id, t.transaction_date, t.list_price,
		row_number() over(PARTITION BY t.customer_id ORDER BY t.transaction_date ASC) as row_number 
	from transaction t
) subquery 
where row_number = 1;

with transaction_intervals as (
    select 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.job_title,
        t.transaction_id,
        t.transaction_date,
        LAG(t.transaction_date) OVER (PARTITION BY c.customer_id ORDER BY t.transaction_date) AS prev_transaction_date,
        (t.transaction_date - LAG(t.transaction_date) OVER (PARTITION BY c.customer_id ORDER BY t.transaction_date)) AS transaction_gap
    from transaction t
    join customer c on t.customer_id = c.customer_id
)
select first_name, last_name, job_title, transaction_gap
from transaction_intervals
where transaction_gap = (SELECT MAX(transaction_gap) FROM transaction_intervals);

