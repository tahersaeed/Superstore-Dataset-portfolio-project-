

                         /*      >>>>>>>> project's requirments solved using MySQL to satisfy all business needs <<<<<<<<<<*/

/* 1 - Create a Procedure that takes a state and year as parameters and finds the most profitable City in this State this year and the annual profit for that city*/
DELIMITER / / CREATE PROCEDURE Most_profitable_City(
  IN US_state varchar(100),
  IN year_profit varchar(10)
) BEGIN
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
END / / DELIMITER;


/* 2 - Create a Procedure that takes a state and finds what’s the most 5 profitable products in a specific state across all years.*/
DELIMITER / / CREATE PROCEDURE most_5_profitable_products(IN state_name varchar(100)) BEGIN
SELECT
  state.state_name,
  products.product_name,
  EXTRACT(
    YEAR
    from
      orders.order_date
  ) AS year_date,
  SUM(orders_details.profit) OVER (
    PARTITION BY EXTRACT(
      YEAR
      from
        orders.order_date
    )
  ) AS total_profit
FROM
  state
  JOIN city ON state.state_id = city.state_id
  JOIN orders ON orders.city_id = city.city_id
  JOIN orders_details ON orders.order_id = orders_details.order_id
  JOIN products ON products.product_id = orders_details.product_id
WHERE
  state.state_name = state_name
GROUP BY
  2
ORDER BY
  SUM(orders_details.profit) DESC;
END / / DELIMITER;


/* 3 - Create a procedure that returns what was the most profitable month in each year
      */
DELIMITER / / CREATE procedure most_profitable_month () BEGIN
SELECT
  SUM(orders_details.profit) AS total_profit,
  EXTRACT(
    year
    from
      orders.order_date
  )
) AS year_date,
monthname(orders.order_date) AS month_name
FROM
  orders_details
  JOIN orders ON orders_details.order_id = orders.order_id
GROUP BY
  2
ORDER BY
  SUM(orders_details.profit) DESC;
END / / DELIMITER;


/* 4 - Create a procedure that returns all the details of the transactions with a Profit Ratio < 0% */
DELIMITER / / CREATE PROCEDURE profit_percent() BEGIN
SELECT
  products.product_name,
  products.product_id,
  orders.order_date,
  orders_details.profit,
  orders_details.sales,
  CONCAT(
    ROUND(
      (orders_details.profit) / (orders_details.sales) * 100
    ),
    " ",
    "%"
  ) AS profit_percent
FROM
  orders
  JOIN orders_details ON orders.order_id = orders_details.order_id
  JOIN products ON orders_details.order_detail_id = products.product_id
WHERE
  profit < 0
ORDER BY
  3 DESC;
END / / DELIMITER;


/* 5 - Create a new integer column in the customer’s table called “nOrders” and use an UPDATE statement to update the column of each customer with its number of orders*/
UPDATE
  customers
  JOIN (
    SELECT
      customers.customer_id as cus_id,
      customers.customer_name,
      count(orders.key_order_id) AS nOrders
    FROM
      orders
      JOIN customers ON orders.customer_id = customers.customer_id
    GROUP BY
      1
  ) t3 ON customers.customer_id = t3.cus_id
SET
  customers.nOrders = t3.nOrders
  
  
  /* 6 - Create a procedure that takes a category and year and returns what is the most popular product (Qty) in that category in a specific year */
  DELIMITER / / CREATE PROCEDURE total_qty(
    IN year_date varchar(10),
    out product_name varchar(100)
  ) BEGIN
SELECT
  products.product_name,
  category.category_name,
  EXTRACT(
    YEAR
    from
      orders.order_date
  ) AS year_date,
  SUM(orders_details.quantity) AS total_qty
FROM
  category
  JOIN subcategory ON subcategory.category_id = category.category_id
  JOIN products ON products.subcategory_id = subcategory.subcategory_id
  JOIN orders_details ON orders_details.product_id = products.product_id
  JOIN orders ON orders.order_id = orders_details.order_id
WHERE
  year_date = EXTRACT(
    YEAR
    from
      orders.order_date
  )
GROUP BY
  2
ORDER BY
  3;
END / / DELIMITER;


/*7 - Create a new boolean column in the customer’s table called “is_top_customer” it will set to true if the customer is one of the company's top customers (if the customer has more than or equals 10 orders) and to false if not.*/
ALTER TABLE
  customers
ADD
  cloumn is_top_customer TINYINT(1) NOT NUL DELIMITER / / CREATE FUNCTION is_top_customer(nOrders int) returns TINYINT DETERMINISTIC BEGIN DECLARE is_top_customer TINYINT(1);
IF nOrders >= 10 THEN
SET
  is_top_customer = 1;
ELSEIF nOrders < 10 THEN
SET
  is_top_customer = 0;
END IF;
RETURN (is_top_customer);
END / / DELIMITER;
SELECT
  customers.customer_id,
  customers.customer_name,
  IF(is_top_customer(nOrders), 'TRUE', 'FALSE') AS top_customer
FROM
  customers
ORDER BY
  customers.customer_name;
  
  
  /*8 - Create a function to return the total revenue generated per vendor (Manufacturer) every year in each segment*/
  DELIMITER / / CREATE PROCEDURE total_revenue() BEGIN
SELECT
  SUM(orders_details.sales) AS total_revenue,
  manufacturer.manufacturer_name,
  EXTRACT(
    YEAR
    from
      orders.order_date
  ) AS year_date,
  customer_segment.customer_segment_name
FROM
  orders_details
  JOIN orders ON orders_details.order_id = orders.order_id
  JOIN products ON products.product_id = orders_details.product_id
  JOIN manufacturer ON manufacturer.manufacturer_id = products.manufacturer_id
  JOIN customers ON customers.customer_id = orders.customer_id
  JOIN customer_segment ON customer_segment.customer_segment_id = customers.customer_segment_id
GROUP BY
  2
ORDER BY
  3 DESC
END / / DELIMITER;


/* 9- Create a trigger to increment the value of the customer’s table column “nOrders” so each time an order created for this customer in the orders table the value incremented by 1*/
DROP TRIGGER inc_nOrders;
DELIMITER / / CREATE TRIGGER inc_nOrders
AFTER
INSERT
  ON orders FOR EACH row BEGIN
update
  customers
SET
  customers.nOrders = customers.nOrders + 1
WHERE
  new.order_id = customer_id;
END / / DELIMITER;


/* 10 - Create a view to show(Year, Month, Product Category, Segment, nOrders, Sales, Revenue)*/
CREATE VIEW `show_tab` AS
SELECT
  customers.customer_id AS customer_id,
  EXTRACT(
    YEAR
    FROM
      orders.order_date
  ) AS year_date,
  MONTHNAME(orders.order_date) AS month_name,
  category.category_name AS category_name,
  customer_segment.customer_segment_name AS customer_segment_name,
  customers.nOrders AS nOrders,
  SUM(orders_details.sales) AS total_sales
FROM
  orders
  JOIN orders_details ON orders.order_id = orders_details.order_id
  JOIN customers ON customers.customer_id = orders.customer_id
  JOIN customer_segment ON customers.customer_segment_id = customer_segment.customer_segment_id
  JOIN products ON orders_details.product_id = products.product_id
  JOIN subcategory ON subcategory.subcategory_id = products.subcategory_id
  JOIN category ON category.category_id = subcategory.category_id
GROUP BY
  customers.customer_id
ORDER BY
  customers.customer_id
 
  /*11 - Create a procedure called “Get_Customer_Level”, it will take the CustomerID as a parameter and return its level, to calculate the level it will calculate the overall AOV(average order value) for all the orders, calculate the AOV of this customer and check if the customer AOV > overall AOV then it will return “Platinum” and if customer AOV >= 2x overall AOV it will return “Key Account”, otherwise it will return “Normal”*/
UPDATE
  customers
  JOIN (
    SELECT
      customers.customer_id as cus_id,
      customers.customer_name,
      SUM(orders_details.sales) / count(customers.nOrders) AS AOV
    FROM
      orders
      JOIN customers ON orders.customer_id = customers.customer_id
      JOIN orders_details ON orders.order_id = orders_details.order_id
    GROUP BY
      1
    ORDER BY
      1
  ) t3 ON customers.customer_id = t3.cus_id
SET
  customers.AOV = t3.AOV;

DROP PROCEDURE IF EXISTS customerLevel;
DELIMITER //
CREATE PROCEDURE customerLevel(
  IN customer_id int,
  out customer_level varchar(20)
) BEGIN
DECLARE AOV int;
DECLARE overall_AOV int;  
SELECT customer_info.id,customer_info.AOV_c,customer_info.overall_AOV
FROM 
  (SELECT customers.customer_id AS id,
   customers.AOV,
    customers.overall_AOV
  FROM customers
    JOIN orders ON customers.customer_id = orders.order_id
    JOIN orders_details ON orders.order_id = orders_details.order_id
    group by 1
    order by 1
   ) AS  customer_info 
   where customer_id = customer_info.id 
group by 1
order by 1;

	IF AOV  >  overall_AOV
	THEN SET customer_level = 'Platinum';
	ELSEIF AOV  >= (2 * overall_AOV)
	THEN SET customer_level = 'Key Account';
	ELSE SET customer_level = 'Normal';
  END IF;
END//
DELIMITER ;

call customerLevel(216,@customer_level);
SELECT @customer_level;






