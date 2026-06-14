/*=========================================================
PROBLEM 4.1 — DELIVERY DELAY ANALYSIS
=========================================================

Business Question:
How long does delivery actually take?

Objective:
Calculate average delivery time.

Business Importance:
Helps understand:
1. Logistics performance
2. Delivery efficiency
3. Customer experience
4. Operational delays

Tables Used:
orders

Metric:
Delivery days

Formula:
delivery_date - purchase_date

Filter:
Only delivered orders
=========================================================*/


SELECT

    ROUND(
        AVG(
            DATEDIFF(
                order_delivered_customer_date,
			order_purchase_timestamp
            )
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_status = 'delivered';


/*=========================================================
PROBLEM 4.2 — ON-TIME VS LATE DELIVERIES
=========================================================

Business Question:
How many deliveries are on time
versus delayed?

Objective:
Compare actual delivery date
with estimated delivery date.

Business Importance:
Helps understand:
1. Customer trust
2. Delivery performance
3. Logistics efficiency
4. Service reliability

Tables Used:
orders

Logic:
actual_delivery <= estimated_delivery
→ On Time

actual_delivery > estimated_delivery
→ Late Delivery

Filter:
Only delivered orders
=========================================================*/


SELECT
    CASE
        WHEN order_delivered_customer_date
        <= order_estimated_delivery_date
        THEN 'On Time Delivery'
        ELSE 'Late Delivery'
    END AS delivery_status,
    COUNT(*) AS total_orders
FROM orders
WHERE order_status = 'delivered'
GROUP BY delivery_status;



/*=========================================================
PROBLEM 4.3 — DELIVERY IMPACT ON CUSTOMER REVIEWS
=========================================================

Business Question:
Do late deliveries affect
customer satisfaction?

Objective:
Compare average review score
between on-time and late deliveries.

Business Importance:
Helps understand:
1. Customer trust
2. Customer satisfaction
3. Delivery quality impact
4. Service improvement areas

Tables Used:
orders
reviews

Metric:
Average review score

Logic:
actual_delivery <= estimated_delivery
→ On Time

actual_delivery > estimated_delivery
→ Late Delivery

Filter:
Only delivered orders
=========================================================*/


SELECT
    CASE
        WHEN o.order_delivered_customer_date
        <= o.order_estimated_delivery_date
        THEN 'On Time Delivery'
        ELSE 'Late Delivery'
    END AS delivery_status,
    ROUND(
        AVG(r.review_score),
        2
    ) AS average_review_score,
    COUNT(*) AS total_reviews
FROM orders o
INNER JOIN reviews r
ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY delivery_status;



/*=========================================================
PROBLEM 4.4 — MOST DELAY-PRONE STATES
=========================================================

Business Question:
Which states experience the most
late deliveries?

Objective:
Identify states with highest
delivery delays.

Business Importance:
Helps understand:
1. Logistics issues
2. Regional delivery challenges
3. Customer trust risk
4. Operational improvements

Tables Used:
orders
customers

Logic:
actual_delivery > estimated_delivery
→ Late Delivery

Filter:
Only delivered orders
=========================================================*/


SELECT
    c.customer_state,
    COUNT(*) AS delayed_orders
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer_date
>
o.order_estimated_delivery_date
GROUP BY c.customer_state
ORDER BY delayed_orders DESC
LIMIT 10;