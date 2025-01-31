select * from bike;

1)
select category, count(1) as number_of_bikes 
from bike
group by category
having count(1) > 2;



2)
select * from membership;
select * from customer;

select c.name, count(m.id) as membership_count 
from membership m
right join customer c on c.id=m.customer_id
group by c.name
order by count(1) desc;


3)
select id, category
, price_per_hour as old_price_per_hour
, case when category8 = 'electric' then round(price_per_hour - (price_per_hour*0.1) ,2)
	   when category = 'mountain bike' then round(price_per_hour - (price_per_hour*0.2) ,2)
       else round(price_per_hour - (price_per_hour*0.5) ,2)
  end as new_price_per_hour
, price_per_day as old_price_per_day
, case when category = 'electric' then round(price_per_day - (price_per_day*0.2) ,2)
	   when category = 'mountain bike' then round(price_per_day - (price_per_day*0.5) ,2)
       else round(price_per_day - (price_per_day*0.5) ,2)
  end as new_price_per_day
from bike;


4)
select category
, count(case when status ='available' then 1 end) as available_bikes_count
, count(case when status ='rented' then 1 end) as rented_bikes_count
from bike
group by category;


5)
SOL1 using Group by and Union all: 
select extract(year from start_timestamp) as year
, extract(month from start_timestamp) as month
, sum(total_paid) as revenue
from rental
group by extract(year from start_timestamp), extract(month from start_timestamp)
union all
select extract(year from start_timestamp) as year
, null as month, sum(total_paid) as revenue
from rental
group by extract(year from start_timestamp)
union all
select null as year, null as month, sum(total_paid) as revenue
from rental
order by year, month;

SOL2 using Grouping Sets: 
select extract(year from start_timestamp) as year
, extract(month from start_timestamp) as month
, sum(total_paid) as revenue
from rental
group by grouping sets ( (year, month), (year), () )
order by year, month;
 
SOL3 using ROLLUP: 
select extract(year from start_timestamp) as year
, extract(month from start_timestamp) as month
, sum(total_paid) as revenue
from rental
group by rollup(year, month)
order by year, month;


6)
select extract(year from start_date) as year
, extract(month from start_date) as month
, mt.name as membership_type_name
, sum(total_paid) as total_revenue
from membership m
join membership_type mt on m.membership_type_id = mt.id
group by year, month, mt.name
order by year, month, mt.name


7) 
select mt.name as membership_type_name
, extract(month from start_date) as month
, sum(total_paid) as total_revenue
from membership m
join membership_type mt on m.membership_type_id = mt.id
where extract(year from start_date) = 2023
group by CUBE(membership_type_name, month)
order by membership_type_name, month;


8)
with cte as 
    (select customer_id, count(1)
    , case when count(1) > 10 then 'more than 10' 
           when count(1) between 5 and 10 then 'between 5 and 10'
           else 'fewer than 5'
      end as category
    from rental
    GROUP by customer_id)
select category as rental_count_category
, count(*) as customer_count
from cte 
group by category
order by customer_count;












