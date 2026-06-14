

/*=========================================================
PROBLEM  3 — PRODUCT CATEGORY PERFORMANCE ANALYSIS
(SIMPLIFIED VERSION)
===============
Objective:
Identify top-performing product categories
based on revenue.

Business Question:
Which product categories generate
the highest revenue?

Tables Used:
orders
order_items
products

Revenue Logic:
Revenue = SUM(price)

Filter:
Only delivered orders
=========================================================*/


SELECT

    p.product_category_name
    AS product_category,

    ROUND(
        SUM(oi.price),
        2
    ) AS total_revenue,

    COUNT(*)
    AS total_items_sold

FROM order_items oi

INNER JOIN orders o
ON oi.order_id = o.order_id

INNER JOIN products p
ON oi.product_id = p.product_id

WHERE o.order_status = 'delivered'

GROUP BY p.product_category_name

ORDER BY total_revenue DESC

LIMIT 10;








/*=========================================================
PROBLEM 2.2 — SALES CONTRIBUTION BY CATEGORY
=========================================================

Business Question:
Which product categories contribute the most
to total business revenue?

Objective:
Calculate percentage contribution of each
category to overall revenue.

Business Importance:
Helps identify:
1. High-value categories
2. Revenue-driving segments
3. Marketing focus areas
4. Inventory priorities

Tables Used:
orders
order_items
products

Revenue Logic:
SUM(price)

Filter:
Only delivered orders
=========================================================*/


SELECT

    p.product_category_name
    AS product_category,

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

INNER JOIN products p
ON oi.product_id = p.product_id

WHERE o.order_status = 'delivered'

GROUP BY p.product_category_name

ORDER BY total_revenue DESC

LIMIT 10;

/*=========================================================
PROBLEM 2.3 — PRODUCT DEMAND PATTERNS
=========================================================

Business Question:
Which product categories are most in demand?

Objective:
Identify categories with the highest
purchase frequency.

Business Importance:
Helps understand:
1. Customer buying behavior
2. Popular categories
3. Inventory planning
4. Product demand trends

Tables Used:
orders
order_items
products

Demand Logic:
COUNT(order_item_id)

Filter:
Only delivered orders
=========================================================*/


SELECT

    p.product_category_name
    AS product_category,

    COUNT(oi.order_item_id)
    AS total_items_sold

FROM order_items oi

INNER JOIN orders o
ON oi.order_id = o.order_id

INNER JOIN products p
ON oi.product_id = p.product_id

WHERE o.order_status = 'delivered'

GROUP BY p.product_category_name

ORDER BY total_items_sold DESC

LIMIT 10;




/*=========================================================
PROBLEM 2.4 — REVENUE-DRIVING BUSINESS SEGMENTS
=========================================================

Business Question:
Which product categories generate both
high revenue and high demand?

Objective:
Compare category revenue and demand
together.

Business Importance:
Helps identify:
1. Strong business segments
2. High-performing categories
3. Inventory priorities
4. Marketing investment areas

Tables Used:
orders
order_items
products

Metrics Used:
SUM(price) → revenue
COUNT(order_item_id) → demand

Filter:
Only delivered orders
=========================================================*/


SELECT

    p.product_category_name
    AS product_category,

    ROUND(
        SUM(oi.price),
        2
    ) AS total_revenue,

    COUNT(oi.order_item_id)
    AS total_items_sold

FROM order_items oi

INNER JOIN orders o
ON oi.order_id = o.order_id

INNER JOIN products p
ON oi.product_id = p.product_id

WHERE o.order_status = 'delivered'

GROUP BY p.product_category_name

ORDER BY total_revenue DESC,
         total_items_sold DESC

LIMIT 10;














