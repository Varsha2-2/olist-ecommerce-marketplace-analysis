-- KPI 1: Weekday Vs Weekend Payment Statistics
SELECT 
    CASE 
        WHEN WEEKDAY(o.order_purchase_timestamp) IN (5, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS purchase_day_type,
    p.payment_type,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_payment_value,
    ROUND(AVG(p.payment_value), 2) AS avg_payment_value
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY purchase_day_type, p.payment_type
ORDER BY purchase_day_type, total_payment_value DESC;

-- KPI 2: High-Satisfaction Credit Card Orders
SELECT 
    COUNT(DISTINCT o.order_id) AS perfect_credit_orders
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE r.review_score = 5 
  AND p.payment_type = 'credit_card';

-- KPI 3: Average Delivery Days for the "Pet Shop" Category
SELECT 
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 1) AS avg_delivery_days_pet_shop
FROM olist_orders_dataset o
JOIN olist_order_items_dataset i ON o.order_id = i.order_id
JOIN olist_products_dataset p ON i.product_id = p.product_id
WHERE p.product_category_name = 'pet_shop'
  AND o.order_status = 'delivered';

-- KPI 4: Financial Metrics for São Paulo City Customers
SELECT 
    c.customer_city,
    ROUND(AVG(i.price), 2) AS avg_item_price,
    ROUND(AVG(p.payment_value), 2) AS avg_customer_payment
FROM olist_orders_dataset o
JOIN olist_order_customer_dataset c ON o.customer_id = c.customer_id
JOIN olist_order_items_dataset i ON o.order_id = i.order_id
JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
WHERE c.customer_city = 'sao paulo'
GROUP BY c.customer_city;

-- KPI 5: Shipping Days Timeline Vs. Customer Review Scores
SELECT 
    r.review_score,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(DATEDIFF(o.order_delivered_customer_date, o.order_purchase_timestamp)), 1) AS avg_shipping_days
FROM olist_orders_dataset o
JOIN olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY r.review_score
ORDER BY r.review_score DESC;
