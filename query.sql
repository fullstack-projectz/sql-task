-- Create the ecommerce database
CREATE DATABASE ecommerce;
-- Use the ecommerce database
USE ecommerce;
-- Create the customers table
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    address TEXT NOT NULL
);
-- Create the orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);
-- Create the products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT NOT NULL
);
-- Insert data into customers
INSERT INTO customers (name, email, address)
VALUES ('Dinesh', 'dinesh@gmail.com', '123 some Street'),
    ('Saran', 'Saran@gmail.com', '456 lake street'),
    ('diya', 'diya@gmail.com', '789 Oak Avenue');
-- Insert data into products
INSERT INTO products (name, price, description)
VALUES ('Product A', 20.00, 'Description for Product A'),
    ('Product B', 35.00, 'Description for Product B'),
    ('Product C', 50.00, 'Description for Product C');
-- Insert data into orders
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES (1, CURDATE(), 70.00),
    (2, CURDATE() - INTERVAL 20 DAY, 35.00),
    (3, CURDATE() - INTERVAL 40 DAY, 50.00);
-- 1. Retrieve all customers who have placed an order in the last 30 days.
-- Retrieve customers who placed orders in the past 30 days
SELECT DISTINCT c.name,
    c.email
FROM customers c
    JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY;
-- 2. Get the total amount of all orders placed by each customer.
-- Calculate the total order amount for each customer
SELECT c.name,
    SUM(o.total_amount) AS total_spent
FROM customers c
    JOIN orders o ON c.id = o.customer_id
GROUP BY c.name;
--3. Update the price of Product C to 45.00.
-- Update the price of a specific product
UPDATE products
SET price = 45.00
WHERE name = 'Product C';
--4. Add a new column discount to the products table.
-- Add a discount column to store product-specific discounts
ALTER TABLE products
ADD COLUMN discount DECIMAL(5, 2) DEFAULT 0.00;
--5. Retrieve the top 3 products with the highest price.
-- Get the 3 most expensive products
SELECT name,
    price
FROM products
ORDER BY price DESC
LIMIT 3;
--6. Get the names of customers who have ordered Product A.
-- Retrieve customer names who ordered 'Product A'
SELECT DISTINCT c.name
FROM customers c
    JOIN orders o ON c.id = o.customer_id
    JOIN order_items oi ON o.id = oi.order_id
    JOIN products p ON oi.product_id = p.id
WHERE p.name = 'Product A';
--7. Join the orders and customers tables to retrieve the customer's name and order date for each order.
-- Get customer names and their corresponding order dates
SELECT c.name,
    o.order_date
FROM customers c
    JOIN orders o ON c.id = o.customer_id;
--8. Retrieve the orders with a total amount greater than 150.00.
-- Fetch orders where the total amount exceeds 150
SELECT id,
    customer_id,
    total_amount
FROM orders
WHERE total_amount > 150.00;
--9. Normalize the database by creating a separate table for order items.
-- Create the order_items table to store individual products in each order
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);
--10. Retrieve the average total of all orders.
-- Calculate the average total value of all orders
SELECT AVG(total_amount) AS average_order_total
FROM orders;