/*=========================================================
PROBLEM 1 — REVENUE TREND ANALYSIS
=========================================================

Business Problem:
Understand how business revenue changes
over time.

Business Question:
Is the e-commerce business growing,
declining, or showing seasonal trends?

Objective:
Calculate month-wise revenue using
successful order payments.

Tables Used:
1. orders
2. payments

Reason:
orders table contains purchase timestamps.
payments table contains actual revenue.

Join Used:
INNER JOIN

Reason:
Only valid matching transactions should be
included for accurate revenue analysis.

Revenue Logic:
Revenue = SUM(payment_value)

Time Granularity:
Monthly

Reason:
Monthly analysis provides clearer business
insights than daily fluctuations.

Date Used:
order_purchase_timestamp

Reason:
Revenue belongs to the month when the
customer places the order, not delivery month.

SQL Concepts Used:
INNER JOIN
SUM()
GROUP BY
DATE_FORMAT()
ORDER BY

Expected Insight:
Identify revenue growth, decline,
or seasonal business trends.
=========================================================*/


SELECT

    -- Extract year and month from purchase timestamp
    DATE_FORMAT(
        o.order_purchase_timestamp,
        '%Y-%m'
    ) AS order_month,

    -- Calculate total monthly revenue
    ROUND(
        SUM(p.payment_value),
        2
    ) AS total_revenue

FROM orders o

-- Join payments table to get revenue amount
INNER JOIN payments p
ON o.order_id = p.order_id

-- Only successful delivered orders
WHERE o.order_status = 'delivered'

-- Group revenue month-wise
GROUP BY order_month

-- Show timeline from oldest to newest
ORDER BY order_month;




/*=========================================================
PROBLEM 1 UPGRADE — TOP REVENUE MONTH
=========================================================

Objective:
Identify the highest revenue month.

Business Importance:
Helps understand peak sales period,
seasonality, and campaign effectiveness.
=========================================================*/

SELECT
    DATE_FORMAT(
        o.order_purchase_timestamp,
        '%Y-%m'
    ) AS order_month,

    ROUND(
        SUM(p.payment_value),
        2
    ) AS total_revenue

FROM orders o

INNER JOIN payments p
ON o.order_id = p.order_id

WHERE o.order_status = 'delivered'

GROUP BY order_month

ORDER BY total_revenue DESC

LIMIT 1;




/*=========================================================
PROBLEM 1 UPGRADE — LOWEST REVENUE MONTH
=========================================================

Objective:
Identify the lowest revenue month.

Business Importance:
Helps identify weak business periods
and operational issues.
=========================================================*/

SELECT
    DATE_FORMAT(
        o.order_purchase_timestamp,
        '%Y-%m'
    ) AS order_month,

    ROUND(
        SUM(p.payment_value),
        2
    ) AS total_revenue

FROM orders o

INNER JOIN payments p
ON o.order_id = p.order_id

WHERE o.order_status = 'delivered'

GROUP BY order_month

ORDER BY total_revenue ASC

LIMIT 1;



SQL Concept:
CTE
LAG()
Window Function
=========================================================*/

WITH monthly_revenue AS (

    SELECT

        DATE_FORMAT(
            o.order_purchase_timestamp,
            '%Y-%m'
        ) AS order_month,

        ROUND(
            SUM(p.payment_value),
            2
        ) AS total_revenue

    FROM orders o

    INNER JOIN payments p
    ON o.order_id = p.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY order_month
)

SELECT

    order_month,

    total_revenue,

    LAG(total_revenue)
    OVER (
        ORDER BY order_month
    ) AS previous_month_revenue,

    ROUND(

        (
            (
                total_revenue
                -
                LAG(total_revenue)
                OVER (
                    ORDER BY order_month
                )
            )

            /

            LAG(total_revenue)
            OVER (
                ORDER BY order_month
            )
        ) * 100,

        2

    ) AS growth_percentage

FROM monthly_revenue;