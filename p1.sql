create table retail_sales(
             transactions_id int primary key,
			 sale_date date,
			 sale_time time,
			 customer_id int,
			 gender varchar(15),
			 age int,
			 category varchar(15),
			 quantiy int,
			 price_per_unit float,
			 cogs float,
			 total_sale float
);
select count(*) from retail_sales;

select * from retail_sales
Delete from retail_sales
where 
   transactions_id is null
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or age is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null

--1. write a query to retrieve all columns for sales made on '2022-11-05'
select * from retail_sales
where sale_date = '2022-11-05';

--2.Write a query to retrieve all the transactions where the category is 'clothing' 
--and the quantity sold is more than 10 in the month of nov-2022
select * from retail_sales
where 
quantiy >=4 and 
to_char(sale_date, 'yyyy-mm')= '2022-11'
and
category='Clothing';

--3. Write a query to calculate the total sale for each category sale_date between '2022-01-01' and '2022-01-30'
select category, sum(total_sale) from retail_sales
group by category;

--4.Write a query to find the average age of customers who purchased items from the 'Beauty' category
select avg(age) from retail_sales
where category = 'Beauty';

--5.Write a query to find all transactions where the total-sale is greater than 1000
select * from retail_sales
where total_sale > 1000;

--6.Write a query to find the total number of transactions made by each gender in each category
select count(transactions_id),gender,category from retail_sales
group by gender, category;

--7. calculate the average sale for each month. find out best selling month in the each year
select year,month, avg_sale 
from 
(
select 
   EXTRACT(YEAR from sale_date) as year,
   EXTRACT(MONTH from sale_date) as month,
   avg (total_sale) as avg_sale,
   rank() over (partition by extract(YEAR from sale_date)order by avg(total_sale)desc) as rank
   from retail_sales
   group by 1,2
) as t1
where rank =1;

--8. find top 5 customers based on the highest total sales
select distinct(customer_id),sum(total_sale)as total_sales from retail_sales
group by customer_id 
order by total_sales desc
limit 5;

--9. find the numebr of unique customers who purchased items fom each category
select category,count(distinct(customer_id)) as customers from retail_sales
group by category;

--10. create each shift and number of orders( example morning <=12, afternoon between 12 & 17, evening >17)
with hourly_sales
as
(
select *, 
    case 
	    when EXTRACT (Hour from sale_time)< 12 then 'Morning'
	    when EXTRACT (Hour from sale_time)between 12 and 17 then 'Afternoon'
        else 'evening'
    end as shift
from retail_sales
)
select shift, count(*) as total_orders
from hourly_sales
group by shift;
	
    

