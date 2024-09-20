
--Data Analysis Process

--1. What are the top 3 products based on total revenue for each product?
select prd.name, prd.id, sum(ods.revenue)
from products as prd
join orders as ods on prd.id = ods.product_id
group by prd.name, prd.id
order by sum(ods.revenue) desc
limit 3;


--2. What are the top 3 months of the year based on total revenue for each month?
select extract(month from order_date) as months, sum(revenue) as r
from orders
group by months
order by r desc
limit 3;


--3. What are the top 3 states that ordered the most of the top 3 products from question 1? 
-- (First two queries are preliminary and helped me solve the question via the last query.)
select product_id
from orders
group by product_id
order by sum(revenue) desc 
limit 3;

select *
from products
where id in(7,4,5);

--Solution query below.
select s.name as state
from states as s
join customers as c on s.id = c.state_id
join orders as o on c.id = o.customer_id
where o.product_id in(7,4,5)
group by state
order by sum(o.quantity) desc
limit 3;


--4. Show which age group generated the most revenue from the top 3 states in question 3.
-- (First query is preliminary and helped me solve the question via the last query.)
select c.id, c.name, c.age,
CASE
	when c.age <= 30 then 'Young'
	when c.age between 31 and 50 then 'Middle Age'
	when c.age > 50 then 'Elder'
END as age_group
from customers as c

-- Solution query below.
select 
CASE
	when c.age <= 30 then 'Young'
	when c.age between 31 and 50 then 'Middle Age'
	when c.age > 50 then 'Elder'
END as age_group,
sum(o.revenue) as rev
from customers as c
join orders as o on c.id = o.customer_id
where c.state_id in
	(
	select s.id as state
	from states as s
	join customers as c on s.id = c.state_id
	join orders as o on c.id = o.customer_id
	where o.product_id in(7,4,5)
	group by state
	order by sum(o.quantity) desc
	limit 3
)
group by age_group
order by rev desc;
