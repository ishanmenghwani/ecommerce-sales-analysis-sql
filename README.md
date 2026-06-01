Ecommerce Sales Analysis
About the Project:
This project analyses transactional data from a mock e-commerce store with 10 customers, 10 products, and 20 orders across 9 months. The goal was to answer key business questions around revenue performance, customer behaviour, and product demand using structured SQL queries. Insights include category-level revenue breakdown, customer spending tiers, monthly sales trends, and identification of non-performing products.

Database Schema:
customers — customer profile and acquisition segment
products — product catalogue with category and pricing
orders — transactional fact table linking customers to products

Queries:
#Analysis
1) Revenue, order volume, and average order value by product category
2) Top 5 customers ranked by total spend
3) Customer segmentation into High / Mid / Low value tiers using CASE
4) Monthly revenue trend across the 9-month period
5) Products with zero orders identified using a NOT IN subquery
6) Revenue share (%) by category using CTEs and CROSS JOIN

How to Run:
Open DB Fiddle and select MySQL 8.0
Paste the schema and INSERT statements into the left panel
Paste individual SELECT queries into the right panel
Click Run
