/*=========================================================
AUDIT 1 — MISSING VALUES CHECK
=========================================================

Objective:
Check missing values in important
delivery and approval columns.

Business Problem:
Missing values can affect:
1. Delivery analysis
2. Customer trust analysis
3. Operational insights

Expected Result:
Low missing values
=========================================================*/


SELECT

    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN order_approved_at IS NULL
            THEN 1
            ELSE 0
        END
    ) AS missing_approval,

    SUM(
        CASE
            WHEN order_delivered_carrier_date IS NULL
            THEN 1
            ELSE 0
        END
    ) AS missing_carrier_delivery,

    SUM(
        CASE
            WHEN order_delivered_customer_date IS NULL
            THEN 1
            ELSE 0
        END
    ) AS missing_customer_delivery

FROM orders;
    
  /*   AUDIT 2 — DUPLICATE RECORD CHECK  
Objective:
Check whether important business identifiers
contain duplicate records.

Business Problem:
Duplicate records can lead to:
1. Incorrect revenue calculation
2. Inflated customer count
3. Wrong seller performance
4. Misleading business insights

SQL Techniques Used:
GROUP BY
COUNT(*)
HAVING

Expected Result:
Empty Set

Meaning:
No duplicate records exist.*/
 
   -- duplicate check fot customers
   SELECT
      customer_id,
      COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;
 
 -- duplicate check for products
  SELECT
      product_id,
      COUNT(*) AS duplicate_count
FROM products
GROUP BY  product_id
HAVING COUNT(*)  > 1;
  
  -- Duplicate check for sellers
  SELECT
       seller_id,
       COUNT(*) AS duplicate_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1 ;

   
   
    SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
    
    
    /*=========================================================
AUDIT 3 — TIMESTAMP VALIDATION
=========================================================

Objective:
Validate whether order timeline follows
logical business sequence.

Business Problem:
Incorrect timestamps can lead to:
1. Wrong delivery analysis
2. Incorrect logistics insights
3. Misleading customer trust evaluation

Timeline Rules:
1. Approval date >= Purchase date
2. Carrier shipment >= Approval date
3. Customer delivery >= Carrier shipment

SQL Technique Used:
WHERE clause

Reason:
We are filtering invalid row-level records,
not aggregated results.

Expected Result:
0 invalid records

Meaning:
Business timeline is logically valid.
=========================================================*/


-- Check invalid approval timeline
 SELECT
   COUNT(*) AS invalid_approval_dates
FROM orders
WHERE order_approved_at < order_purchase_timestamp ;

-- check invalid carrier shipment timeline 
SELECT
  COUNT(*) AS invalid_carrier_dates
FROM orders
WHERE order_delivered_carrier_date < order_approved_at ;

 -- check invalid customer delivery timeline
 SELECT
	COUNT(*) AS invalid_customer_delivery_dates
FROM orders
WHERE order_delivered_customer_date < order_delivered_carrier_date ;



/*=========================================================
AUDIT 4 — ORDER STATUS DISTRIBUTION
=========================================================

Objective:
Analyze the distribution of order statuses
to understand business operational health.

Business Problem:
Order status affects:
1. Revenue analysis
2. Delivery performance
3. Customer satisfaction
4. Logistics efficiency

Reason:
Cancelled or unavailable orders should be
handled carefully in business analysis.

SQL Techniques Used:
GROUP BY
COUNT(*)
ORDER BY

Expected Insight:
Most orders should ideally be delivered.
=========================================================*/
 SELECT
  order_status,
  COUNT(*) AS total_orders
  FROM orders
  GROUP BY order_status
  ORDER BY total_orders DESC ;
    
    
    /*=========================================================
AUDIT 5 — DELIVERY COMPLETENESS ANALYSIS
=========================================================

Objective:
Analyze how many orders were successfully
delivered versus incomplete deliveries.

Business Problem:
Not every order reaches the customer.
Incomplete deliveries can impact:
1. Customer trust
2. Business revenue
3. Delivery performance
4. Customer satisfaction

SQL Techniques Used:
CASE WHEN
GROUP BY
COUNT(*)

Reason:
CASE WHEN helps categorize deliveries
into understandable business groups.

Expected Insight:
Most orders should ideally be completed.
=========================================================*/

SELECT
    CASE
        WHEN order_delivered_customer_date IS NULL
        THEN 'Incomplete Delivery'

        ELSE 'Completed Delivery'
    END AS delivery_status,

    COUNT(*) AS total_orders

FROM orders

GROUP BY delivery_status
ORDER BY total_orders DESC;
    