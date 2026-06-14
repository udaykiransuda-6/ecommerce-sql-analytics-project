/*=========================================================
PROBLEM 5.1 — REPEAT VS ONE-TIME CUSTOMERS
=========================================================

Business Question:
Are customers returning or buying only once?

Objective:
Identify repeat customers
vs one-time customers.

Business Importance:
Helps understand:
1. Customer loyalty
2. Retention rate
3. Customer engagement
4. Repeat purchase behavior

Tables Used:
orders

Metric:
Number of orders per customer
=========================================================*/

SELECT
    customer_type,
    COUNT(*) AS total_customers
FROM (
    SELECT
        customer_id,
        CASE
            WHEN COUNT(order_id) = 1
            THEN 'One-Time Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM orders
    GROUP BY customer_id
) customer_summary
GROUP BY customer_type;


/*=========================================================
PROBLEM 5.2 — CUSTOMER PURCHASE FREQUENCY
=========================================================

Business Question:
How frequently do customers place orders?

Objective:
Analyze customer order frequency.

Business Importance:
Helps understand:
1. Customer engagement
2. Purchase behavior
3. Customer activity level
4. Repeat buying trends

Tables Used:
orders

Metric:
Number of orders per customer
=========================================================*/


SELECT
    order_count,
    COUNT(*) AS total_customers
FROM (
    SELECT
        customer_id,
        COUNT(order_id)
        AS order_count
    FROM orders
    GROUP BY customer_id
) customer_orders
GROUP BY order_count
ORDER BY order_count;






/*=========================================================
PROBLEM 5.3 — HIGH-VALUE CUSTOMERS
=========================================================

Business Question:
Which customers generate
the highest revenue?

Objective:
Identify top-spending customers.

Business Importance:
Helps identify:
1. High-value customers
2. Premium customer segments
3. Customer retention targets
4. Revenue-driving customers

Tables Used:
orders
payments

Revenue Logic:
SUM(payment_value)

Filter:
Only delivered orders
=========================================================*/


SELECT
    o.customer_id,
    ROUND(
        SUM(p.payment_value),
        2
    ) AS total_spent,
    COUNT(o.order_id)
    AS total_orders
FROM orders o
INNER JOIN payments p
ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY o.customer_id
ORDER BY total_spent DESC
LIMIT 10;


/*=========================================================
PROBLEM 5.4 — CUSTOMER PAYMENT PREFERENCES
=========================================================

Business Question:
Which payment methods are
most preferred by customers?

Objective:
Analyze payment method usage.

Business Importance:
Helps understand:
1. Customer payment behavior
2. Popular payment methods
3. Checkout optimization
4. Payment strategy

Tables Used:
payments

Metric:
Payment method frequency
=========================================================*/


SELECT
    payment_type,
    COUNT(*) AS total_transactions,
    ROUND(
        SUM(payment_value),
        2
    ) AS total_payment_value
FROM payments
GROUP BY payment_type
ORDER BY total_transactions DESC;