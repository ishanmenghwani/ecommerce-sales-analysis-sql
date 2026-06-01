CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city          VARCHAR(50),
    segment       VARCHAR(30),
    signup_date   DATE
);

CREATE TABLE products (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(100),
    category     VARCHAR(50),
    price        DECIMAL(10, 2)
);

CREATE TABLE orders (
    order_id    INT PRIMARY KEY,
    customer_id INT,
    product_id  INT,
    quantity    INT,
    order_date  DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES products(product_id)
);


INSERT INTO customers VALUES
(1,  'Rahul Sharma',  'Mumbai',    'Premium', '2022-03-10'),
(2,  'Priya Patel',   'Delhi',     'Regular', '2022-05-22'),
(3,  'Amit Joshi',    'Bengaluru', 'Premium', '2022-01-15'),
(4,  'Sneha Iyer',    'Chennai',   'Budget',  '2022-08-01'),
(5,  'Vikram Singh',  'Hyderabad', 'Regular', '2022-09-14'),
(6,  'Neha Gupta',    'Pune',      'Premium', '2023-01-05'),
(7,  'Ravi Nair',     'Kochi',     'Budget',  '2023-02-18'),
(8,  'Ananya Das',    'Kolkata',   'Regular', '2023-03-22'),
(9,  'Karan Mehta',   'Mumbai',    'Premium', '2023-04-11'),
(10, 'Divya Reddy',   'Bengaluru', 'Regular', '2023-05-30');

INSERT INTO products VALUES
(1,  'Wireless Headphones', 'Electronics', 2999.00),
(2,  'Running Shoes',       'Footwear',    3499.00),
(3,  'Yoga Mat',            'Sports',       799.00),
(4,  'Laptop Stand',        'Electronics', 1299.00),
(5,  'Backpack',            'Accessories', 1599.00),
(6,  'Smartwatch',          'Electronics', 8999.00),
(7,  'Protein Powder',      'Health',      2499.00),
(8,  'Sunglasses',          'Accessories', 1199.00),
(9,  'Resistance Bands',    'Sports',       499.00),
(10, 'Bluetooth Speaker',   'Electronics', 3299.00);

INSERT INTO orders VALUES
(1,  1,  1,  2, '2023-01-15'),
(2,  2,  3,  3, '2023-01-22'),
(3,  3,  6,  1, '2023-02-05'),
(4,  4,  9,  5, '2023-02-14'),
(5,  5,  2,  1, '2023-02-28'),
(6,  1,  5,  2, '2023-03-10'),
(7,  6,  10, 1, '2023-03-18'),
(8,  3,  4,  3, '2023-04-02'),
(9,  7,  7,  2, '2023-04-20'),
(10, 2,  8,  1, '2023-05-05'),
(11, 8,  1,  1, '2023-05-19'),
(12, 9,  6,  2, '2023-06-01'),
(13, 10, 2,  1, '2023-06-15'),
(14, 5,  5,  3, '2023-06-28'),
(15, 1,  7,  1, '2023-07-10'),
(16, 4,  10, 2, '2023-07-22'),
(17, 6,  3,  4, '2023-08-05'),
(18, 9,  4,  2, '2023-08-19'),
(19, 3,  8,  3, '2023-09-01'),
(20, 7,  9,  6, '2023-09-15');


-- Revenue by category
SELECT
    p.category,
    COUNT(o.order_id)                    AS total_orders,
    SUM(o.quantity * p.price)            AS total_revenue,
    ROUND(AVG(o.quantity * p.price), 2)  AS avg_order_value
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;


-- Top 5 customers by spend
SELECT
    c.customer_name,
    c.city,
    c.segment,
    COUNT(o.order_id)          AS total_orders,
    SUM(o.quantity * p.price)  AS total_spent
FROM customers c
LEFT JOIN orders o  ON c.customer_id = o.customer_id
LEFT JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name, c.city, c.segment
ORDER BY total_spent DESC
LIMIT 5;


-- Customer spending tier segmentation
SELECT
    c.customer_name,
    c.segment,
    SUM(o.quantity * p.price) AS total_spent,
    CASE
        WHEN SUM(o.quantity * p.price) >= 15000 THEN 'High Value'
        WHEN SUM(o.quantity * p.price) >= 5000  THEN 'Mid Value'
        ELSE 'Low Value'
    END AS spending_tier
FROM customers c
JOIN orders o   ON c.customer_id = o.customer_id
JOIN products p ON o.product_id  = p.product_id
GROUP BY c.customer_id, c.customer_name, c.segment
ORDER BY total_spent DESC;


-- Monthly revenue trend
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    COUNT(o.order_id)                  AS num_orders,
    SUM(o.quantity * p.price)          AS monthly_revenue
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month ASC;


-- Products with no orders
SELECT
    product_id,
    product_name,
    category,
    price
FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id FROM orders
);


-- Revenue share by category
WITH category_revenue AS (
    SELECT
        p.category,
        SUM(o.quantity * p.price) AS revenue
    FROM orders o
    JOIN products p ON o.product_id = p.product_id
    GROUP BY p.category
),
total AS (
    SELECT SUM(revenue) AS grand_total FROM category_revenue
)
SELECT
    cr.category,
    cr.revenue,
    ROUND(cr.revenue / t.grand_total * 100, 1) AS revenue_share_pct
FROM category_revenue cr
CROSS JOIN total t
ORDER BY cr.revenue DESC;
