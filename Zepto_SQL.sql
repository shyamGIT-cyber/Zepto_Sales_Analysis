CREATE DATABASE zepto_SQL_project;
USE zepto_SQL_project;

CREATE TABLE zepto(
sku_id INT AUTO_INCREMENT PRIMARY KEY,
category VARCHAR(150),
name VARCHAR(150) NOT NULL,
mrp DECIMAL(8,2),
discount_percent DECIMAL(5,2),
available_quantity INT,
discounted_selling_price DECIMAL(8,2),
weight_in_gms INT,
out_of_stock BOOLEAN,
quantity INT
)


-- Data exploration 

-- Count rows
SELECT COUNT(*) FROM zepto_v2;

-- Sample data 
SELECT * FROM zepto_v2
LIMIT 10;

-- Null values
SELECT * FROM zepto_v2
WHERE name IS NULL
OR 
sku_id IS NULL
OR 
category IS NULL
OR 
mrp IS NULL
OR
discount_price IS NULL
OR 
available_quantity IS NULL
OR
discounted_selling_price IS NULL
OR
weight_in_gms IS NULL
OR
out_of_stock IS NULL
OR
quantity IS NULL;

-- Different product category
SELECT DISTINCT category FROM zepto_v2
ORDER BY category;

-- Product in_stock vs out_of_stock
SELECT out_of_stock, COUNT(sku_id) FROM zepto_v2
GROUP BY out_of_stock;

-- Product names present multiple time 
SELECT name, COUNT(*) AS product_name_count FROM zepto_v2
GROUP BY name
HAVING product_name_count > 1
ORDER BY product_name_count DESC ;

-- Data cleaning 

-- Product where price = 0
SELECT * FROM zepto_v2 
WHERE mrp = 0 OR discounted_selling_price = 0;

DELETE FROM zepto WHERE mrp = 0;

-- Convert paise to rupees
UPDATE zepto_v2
SET mrp = mrp/100.0,
discounted_selling_price = discounted_selling_price/100.0;

SELECT mrp, discounted_selling_price FROM zepto_v2;


-- Q1. Find the top 10 best-value products based on the discount percentage.
SELECT DISTINCT name, mrp, discount_percent FROM zepto_v2 
ORDER BY discount_percent DESC
LIMIT 10;

-- Q2.What are the Products with High MRP but Out of Stock
SELECT DISTINCT name , mrp, out_of_stock FROM zepto_v2 
WHERE out_of_stock = 'TRUE'
ORDER BY mrp DESC;

-- Q3.Calculate Estimated Revenue for each category
SELECT category, SUM(discounted_selling_price*available_quantity) AS total_revenue FROM zepto_v2
GROUP BY category
ORDER BY total_revenue;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name , mrp, discount_percent FROM zepto_v2
WHERE mrp > 500 AND discount_percent < 10
ORDER BY mrp DESC, discount_percent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category, AVG(discount_percent) average_discount FROM zepto_v2
GROUP BY category 
ORDER BY average_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
SELECT DISTINCT name,
	 discounted_selling_price,
	 weight_in_gms,
	 (discounted_selling_price/weight_in_gms) AS price_per_gram 
 FROM zepto_v2
WHERE weight_in_gms >= 100
ORDER BY price_per_gram;

-- Q7.Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name , weight_in_gms,
CASE 
	WHEN weight_in_gms < 1000 THEN 'Low'
    WHEN weight_in_gms < 5000 THEN 'Medium'
    ELSE 'Bulk'
    END AS 'weight_category'
FROM zepto_v2;


-- Q8.What is the Total Inventory Weight Per Category 
SELECT category, SUM(available_quantity*weight_in_gms) AS total_quantity_gms FROM zepto_v2
GROUP BY category
ORDER BY total_quantity_gms;



