-- Creating Database:
create database WalmartData;

--Creating Table for Sales Data:
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date timestamp NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income DECIMAL(12, 4),
    rating FLOAT
);

-- Feature Engineering:

-- a) time_of_day:
SELECT
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM
    sales;

--Adding time_of_day column to the database:
alter table sales add column time_of_day varchar(20);

--Updating the time_of_day column:
update sales 
set time_of_day=(CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END);

-- b) day_name:
SELECT date, to_char(date::date, 'Day')
		AS day_name FROM sales;

--Adding name of the day to the column:
alter table sales add column day_name varchar(50);

--Updating the day_name column:
UPDATE sales SET day_name = to_char(date::date, 'Day');

-- c) month_name:
--Adding name of the month to the column:
alter table sales add column month_name varchar(50);

--Updating the month_name column:
update sales set month_name=to_char(date::date,'Month');

-----------------------------------------Generic Questions------------------------------------

-- 1) How many unique cities does the data have?
select distinct 
	city from sales;

-- 2) In which city is each branch?
select distinct 
	city,branch from sales;

----------------------------------------------Product-----------------------------------------

-- 1) How many unique product lines does the data have?
select distinct
	product_line from sales;

select distinct
	count (distinct product_line) from sales;


-- 2) What is the most commaon payment method?
select payment,
	count(payment) as payment_count
from sales
group by payment
Order by payment_count desc;

-- 3) What is most selling product line?
select product_line,
count(product_line) as most_selling_product_line
from sales
group by product_line
order by most_selling_product_line desc;

-- 4) What is the total revenue by month?
select month_name as month,
	sum(total) as total_revenue
from sales
group by month_name
order by total_revenue;

-- 5) What month had the largest COGS?
select month_name as month,
	sum(cogs) as largest_cogs
from sales
group by month_name
order by largest_cogs desc;

--6) What product line had the largest revenue?
select product_line,
	sum(total) as total_revenue
from sales 
group by product_line
order by total_revenue desc;

-- 7) Which city has the largest revenue?
select city,branch, 
	sum(total) as largest_revenue
from sales
group by city,branch
order by largest_revenue desc;

-- 8) Which product line had the largest VAT?
select product_line,
	avg(tax_pct) as largest_vat
from sales
group by product_line
order by largest_vat desc;

-- 9) Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales and "Bad" otherwise.
select avg(quantity) as avg_qnty
from sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM sales
GROUP BY product_line;


-- 10) Which brand sold more products than average product sold?
select branch, 
	sum(quantity) as qty
from sales
group by branch 
having sum(quantity)>(select avg(quantity) from sales);

-- 11) What is the most common product line by gender?
select gender,
		product_line,
	count(gender) as total_cnt
from sales 
group by gender,product_line
order by total_cnt desc;

-- 12) What is the average rating of each product line?
select avg(rating) as avg_rating,
	product_line
	from sales 
group by product_line
order by avg_rating desc;


----------------------------------------------Sales-----------------------------------------

-- 1) Number of Sales made in each time of the day per weekday:
SELECT time_of_day, COUNT(*) AS total_sales
	FROM sales
	GROUP BY time_of_day
	order by total_sales asc;

-- 2) Which of the customer types brings the most revenue?
select 
	customer_type,
	sum(total) as total_rev
from sales
group by customer_type
order by total_rev desc;

-- 3) Which City has the largest tax percent/VAT(Value Added Tax)?
select city,
avg(tax_pct) as vat
from sales
group by city
order by vat desc;

-- 4) Which customer type pays the most in VAT?
select customer_type,
avg(tax_pct) as vat
from sales
group by customer_type
order by vat desc;

----------------------------------------------Customer-----------------------------------------

-- 1) How many unique customer types does the data have?
select distinct
	customer_type from sales;
	
-- 2) How many unique payment methods does the data have?
select distinct payment
from sales;

-- 3) What is the most common customer type?
select customer_type,
count(*) as cstm_cnt
from sales
group by customer_type;

-- 4) What is the gender of most of the customer?
select gender, 
count(*) as gender_cnt
from sales
group by gender
order by gender_cnt desc;

-- 5) What is the gender distribution per branch?
select gender, 
count(*) as gender_cnt
from sales
where branch='A'
group by gender
order by gender_cnt desc;

-- 6) Which time of the day do customers give most ratings?
select time_of_day,
avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;

-- 7) Which time of the day do customers give most ratings per branch?
select time_of_day,
avg(rating) as avg_rating
from sales
where branch='A'
group by time_of_day
order by avg_rating desc;

-- 8) Which Day of the week has the best average rating?
select day_name,
avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;

-- 9) Which Day of the week has the best average rating per branch?
select day_name,
avg(rating) as avg_rating
from sales
where branch='C'
group by day_name
order by avg_rating desc;




