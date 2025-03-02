create table customer (
	customer_id int4,
	first_name varchar(50),
	last_name varchar(50),
	gender varchar(30),
	dob varchar(50),
	job_title varchar(50),
	job_industry_category varchar(50),
	wealth_segment varchar(50),
	deceased_indicator varchar(50),
	owns_car varchar(30),
	address varchar(50),
	postcode varchar(30),
	state varchar(30),
	country varchar(30),
	property_valuation int4
);


create table transaction (
	transaction_id int4,
	product_id int4,
	customer_id int4,
	transaction_date varchar(30),
	online_order varchar(30),
	order_status varchar(30),
	brand varchar(30),
	product_line varchar(30),
	product_class varchar(30),
	product_size varchar(30),
	list_price float4,
	standard_cost float4
);

alter table customer 
add constraint pk_customer primary key (customer_id);

alter table transaction
add constraint fk_transaction_customer foreign key (customer_id) references customer(customer_id); 

\copy customer 
from '/Users/daria/Documents/MPTI/Семестр 2/SQL/homework2/customer.csv'
delimiter ';'
csv header
null '';

\copy transaction 
from '/Users/daria/Documents/MPTI/Семестр 2/SQL/homework2/transaction.csv'
delimiter ';'
csv header
null '';

alter table transaction 
alter column transaction_date type date 
using TO_DATE(transaction_date, 'DD.MM.YYYY');


select distinct brand 
from transaction 
where standard_cost > 1500 ;

select distinct transaction_id 
from transaction 
where order_status = 'Approved' 
and transaction_date between '2017-04-01' and '2017-04-09';

select distinct job_title 
from customer 
where (job_industry_category = 'IT' or job_industry_category = 'Financial Services') and job_title ilike 'Senior%';

select distinct t.brand
from transaction t 
join customer c on t.customer_id = c.customer_id 
where c.job_industry_category = 'Financial Services'
and t.brand is not null;

select distinct customer_id 
from transaction 
where online_order = 'True' 
and brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
order by customer_id asc 
limit 10;

select distinct c.customer_id
from customer c
left join transaction t on c.customer_id = t.customer_id 
where t.customer_id is null;

select c.customer_id, c.first_name, c.last_name, t.transaction_id, t.standard_cost
from customer c
join transaction t on c.customer_id = t.customer_id 
where c.job_industry_category = 'IT'
and t.standard_cost = (select max(standard_cost) from transaction);

select c.customer_id, c.first_name, c.last_name, t.transaction_date, t.order_status  
from customer c
join transaction t on c.customer_id = t.customer_id 
where c.job_industry_category in ('IT', 'Health')
and t.order_status = 'Approved'
and t.transaction_date between '2017-07-07' and '2017-07-17';
