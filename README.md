<<<<<<< HEAD

# Superstore-Dataset-portfolio-project
=======
# Superstore-Dataset-portfolio-project

---
>>>>>>> b72d8534efdcf203e6b62a83739898cc5ce1161b
Portfolio project to convert Company's Excel sheet into a Relational Database using MySQL 

---

**Table *of* Contents:**
1. Create an Entity-Relationship Model (ERM) diagram
2. Create tables using MYSQL to fetch the data from CSV file into Database
3. Import Data From an CSV file 
4. Exploratory Analysis using SQL to satisfy the business needs 
---

## Create an Entity-Relationship Model (ERM) diagram using draw.io

Apply Normalization to the Conceptual design.

Converting ERMs to physical DBs.

Identify entities what Database needs, its attributes and the relationship between all entities.

Entities have been created as shown in the graph:

 * Customer  
 * Customer segment 
 * Orders 
 * Oreders details  
 * City 
 * State  
 * Region  
 * Category  
 * Sub-category 
 * Products 
 * Manufacturer 

---

## Create tables using MYSQL to fetch the data from CSV file into Database

 > As an example:

```SQL
 CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `customer_name` varchar(100) NOT NULL,
  `customer_segment_id` int(11) NOT NULL,
  `nOrders` int(11) NOT NULL,
  `is_top_customer` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```
---
## Import Data From an CSV file as "RowData"
Importing data from CSV file using PHPmyadmin (XAMPP-MYSQL) and then start the process of cleaning data: 

* Standrdize Date Format 
* Remove Duplicates 
* Delete unused columns 
---
## Exploratory Analysis using SQL to satisfy the business needs 

* Created SQL queries to get the data from the “RowData” table to the tables you’ve created

* Created a prodedure that takes a state and year as parameters and return the most profitable City in this State this year and the annual profit for that city

* Created a prodedure that takes a state and returns what’s the most 5 profitable products in that specific state across all years.

* Created a prodedure that takes a category and year and returns what is the most popular product (Qty) in that category in a specific year 

* Created a prodedure that returns what was the most profitable month in each year

* Created a prodedure that returns all the details of the transactions with a Profit Ratio < 0%

* Created a new integer column in the customer’s table called “nOrders” and use an UPDATE statement to update the column of each customer with its number of orders

* Created a new boolean column in the customer’s table called “is_top_customer” it will set to true if the customer is one of the company's top customers (if the customer has more than or equals 10 orders) and to false if not. 

* Created a prodedure to return the total revenue generated per vendor (Manufacturer) every year in each segment For each product category as a parameter, the company wants to know what is the total profit per segments

* Created a view to show(Year, Month, Product Category, Segment, nOrders, Sales, Revenue)

* Created a trigger to increment the value of the customer’s table column “nOrders” so each time an order

* Created for this customer in the orders table the value incremented by 1

* Take a backup of the database (tables, data, views, functions)

* Create a function called “Get_Customer_Level”, it will take the CustomerID as a parameter and return its level, to calculate the level it will calculate the overall AOV(average order value) for all the orders, calculate the AOV of this customer and check if the customer AOV > overall AOV then it will return “Platinum” and if customer AOV >= 2x overall AOV it will return “Key Account”, otherwise it will return “Normal”

> As an example: created a stored procedure to get most profitable city 

```SQL
DELIMITER / / 
CREATE PROCEDURE Most_profitable_City(
  IN US_state varchar(100),
  IN year_profit varchar(10)
) 
BEGIN
SELECT
  t1.US_state,
  t1.cities,
  MAX(t1.total_profit) AS MAX_total_profit,
  SUM(t1.YEAR_DATE) AS year_profit
FROM
  (
    SELECT
      state.state_name AS US_state,
      city.city_name AS cities,
      EXTRACT(
        YEAR
        FROM
          orders.order_date
      ) AS YEAR_DATE,
      SUM(orders_details.profit) AS total_profit
    FROM
      state
      JOIN city ON city.state_id = state.state_id
      JOIN orders ON orders.order_id = city.city_id
      JOIN orders_details ON orders.order_id = orders_details.order_id
    group by
      1,
      2
    order by
      YEAR_DATE,
      SUM(orders_details.profit) DESC
  ) AS t1
WHERE
  t1.US_state = US_state
  AND t1.YEAR_DATE = year_profit
GROUP BY
  1,
  2
ORDER BY
  MAX(t1.total_profit) DESC
LIMIT
  1;
END / / 
DELIMITER;
```














