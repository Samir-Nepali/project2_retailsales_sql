create database project2;
use project2;

create table retail_sales( 
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(20),
age int,
category varchar(20),
quantity int,
price_per_unit float,
cogs float,
total_sale float);

select * from retail_sales;
set dateformat dmy;
bulk insert retail_sales from 'C:\Users\samir\Downloads\retail.csv'
 with ( firstrow=2,
        fieldterminator=',',
		rowterminator='\n' );

--checking null values
select transactions_id , count(*) from retail_sales group by transactions_id having count(transactions_id)>1;
select  * from retail_sales where transactions_id is null 
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or category is null
or quantity is null
or cogs is null
or total_sale is null;
 
 --deleting null values
 delete from retail_sales where  transactions_id is null 
or sale_date is null
or sale_time is null
or customer_id is null
or gender is null
or category is null
or quantity is null
or cogs is null
or total_sale is null;

--data analysis
--1. How many sales we have?
 select count(*) as  total_sale from retail_sales ;

--2. How many unique customers we have?
 select count( distinct customer_id ) as total_customer from retail_sales;

--3. How many unique category we have?
 select distinct category  from retail_sales;

--query for business analysis
--4. Write a sql query to retrieve all columns from sales made on '2022-11-05'
 select * from retail_sales where sale_date='2022-11-05';

--5. Write a sql query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022?
 select * from retail_sales where category='clothing' and  quantity >=4 and sale_date between '2022-11-01'and '2022-11-30' order by 2;

--6. Write a sql query to calculate the total sales from each category?
 select category,count(category), sum(total_sale) as total_sales from retail_sales group by category order by 2;

--7. Write a sql query to find the average age of customres who purchased items from the 'Beauty' category?
 select category, avg(age) as avg_customer from retail_sales where category='beauty' group by category;

--8. Write a sql query to find all transactions where the total sale is greater than 1000?
 select * from retail_sales where total_sale > 1000;

--9. Write a sql query to find the total number of transactions(transactions_id) made by each gender in each category?
 select category,gender ,count(transactions_id)as total_transactions from retail_sales group by category, gender order by 1;

--10. Write a sql query to calculate the average sale from each month. Find out the best selling month in each year?
 with cte as
( select year(sale_date) as year, month(sale_date) as month , avg(total_sale) as avg_sale,
 rank() over ( partition by year(sale_date) order by avg(total_sale) desc) as rank
 from retail_sales group by  year(sale_date), month(sale_date) )
 select * from cte where rank =1;

--11. Write a sql query to find the top 5 customer based on the highest totalsales?
select top 5 * from (select customer_id, sum(total_sale)as total_sales from retail_sales group by customer_id ) as t order by 2 desc;


--12. Write a Sql query to find the number of unique customers who purchased item from each category?
 select category,count(distinct customer_id ) from retail_sales group by category;

--10.Write a Sql query to create each shift and number of orders( example morning <=12, afternoon between 12 and 17, evening >17)
 with hourly_sale as
 ( select *,
 case
    when datepart(hour,sale_time)<12 then 'Morning'
	when datepart(hour,sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
end as Shift
from retail_sales)
select shift, count(*) as total_orders from hourly_sale group by Shift;
