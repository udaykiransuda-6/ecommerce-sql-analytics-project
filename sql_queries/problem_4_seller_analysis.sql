/*=========================================================
PROBLEM 3.1 — TOP-PERFORMING SELLERS
=========================================================

Business Question:
Which sellers generate the highest revenue?

Objective:
Identify top-performing sellers
based on revenue.

Business Importance:
Helps identify:
1. High-performing sellers
2. Business-driving partners
3. Seller contribution
4. Seller reward opportunities

Tables Used:
orders
order_items

Revenue Logic:
SUM(price)

Filter:
Only delivered orders
=========================================================*/


SELECT

    oi.seller_id,

    ROUND(
        SUM(oi.price),
        2
    ) AS total_revenue,

    COUNT(oi.order_item_id)
    AS total_items_sold

FROM order_items oi

INNER JOIN orders o
ON oi.order_id = o.order_id

WHERE o.order_status = 'delivered'

GROUP BY oi.seller_id

ORDER BY total_revenue DESC

LIMIT 10;






/*=========================================================
PROBLEM 3.2 — SELLER REVENUE CONTRIBUTION
=========================================================

Business Question:
Which sellers contribute the most
to total business revenue?

Objective:
Calculate percentage contribution
of each seller to overall revenue.

Business Importance:
Helps identify:
1. Key business sellers
2. Revenue concentration risk
3. Seller dependency
4. Strategic partnerships

Tables Used:
orders
order_items

Revenue Logic:
SUM(price)

Filter:
Only delivered orders
=========================================================*/


SELECT
    oi.seller_id,
ROUND(
        SUM(oi.price),
        2
    ) AS total_revenue,
    ROUND(

        (
            SUM(oi.price)
            /

            (
                SELECT
                    SUM(oi2.price)
                FROM order_items oi2
                INNER JOIN orders o2
                ON oi2.order_id = o2.order_id
                WHERE o2.order_status =
			'delivered'
            )

        ) * 100,

        2

    ) AS revenue_contribution_percentage
FROM order_items oi
INNER JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
ORDER BY total_revenue DESC
LIMIT 10;










/*=========================================================
PROBLEM 3.3 — SELLER RELIABILITY
=========================================================

Business Question:
Which sellers are most reliable in
successful order completion?

Objective:
Measure seller reliability based on
successful delivered orders.

Business Importance:
Helps identify:
1. Reliable sellers
2. Delivery consistency
3. Seller trustworthiness
4. Strong business partners

Tables Used:
orders
order_items

Metric:
Delivered orders count

Filter:
Only delivered orders
=========================================================*/


SELECT
    oi.seller_id,
    COUNT(o.order_id)
    AS successful_orders,
    ROUND(
        SUM(oi.price),
        2
    ) AS total_revenue
FROM order_items oi
INNER JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
ORDER BY successful_orders DESC
LIMIT 10;


/*=========================================================
PROBLEM 3.4 — BUSINESS DEPENDENCE ON SELLERS
=========================================================

Business Question:
Is the business highly dependent
on a few sellers?

Objective:
Identify top sellers contributing
the highest revenue share.

Business Importance:
Helps identify:
1. Revenue concentration risk
2. Seller dependency
3. Business sustainability
4. Partnership strategy

Tables Used:
orders
order_items

Revenue Logic:
SUM(price)

Filter:
Only delivered orders
=========================================================*/


SELECT
    oi.seller_id,
    ROUND(
        SUM(oi.price),
        2
    ) AS total_revenue,
    ROUND(
        (
		SUM(oi.price)/
            (
                SELECT
                    SUM(oi2.price)
                FROM order_items oi2
                INNER JOIN orders o2
                ON oi2.order_id = o2.order_id
                WHERE o2.order_status =
			'delivered'
            )
        ) * 100,
        2
    ) AS business_dependency_percentage
FROM order_items oi
INNER JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY oi.seller_id
ORDER BY business_dependency_percentage DESC
LIMIT 10;




