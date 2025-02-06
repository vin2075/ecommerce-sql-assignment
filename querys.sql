-- Schema: E-Commerce Database

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    join_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) CHECK (price > 0)
);

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES Customers(customer_id),
    order_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE Order_Items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT CHECK (quantity >= 1)
);


-- Insert Customers
INSERT INTO Customers (name, email, join_date) VALUES
('John Doe', 'john@example.com', '2023-01-01'),
('Jane Smith', 'jane@example.com', '2023-01-02');

-- Insert Products
INSERT INTO Products (product_name, price) VALUES
('Laptop', 999.99),
('Smartphone', 499.99);

-- Insert Orders
INSERT INTO Orders (customer_id, order_date) VALUES
(1, '2023-01-01'),
(2, '2023-01-02');

-- Insert Order_Items
INSERT INTO Order_Items (order_id, product_id, quantity) VALUES
(1, 1, 1), -- John Doe ordered 1 Laptop
(1, 2, 2), -- John Doe ordered 2 Smartphones
(2, 1, 3); -- Jane Smith ordered 3 Laptops

--basic queries
-- List all customers sorted by join_date (newest first)
SELECT * FROM Customers ORDER BY join_date DESC;


-- Find all orders placed in January 2023
SELECT * FROM Orders WHERE order_date BETWEEN '2023-01-01' AND '2023-01-31';


-- Calculate total revenue from all orders
SELECT SUM(p.price * oi.quantity) AS total_revenue
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id;


--joins and relationships

-- Show all orders with customer names and order dates
SELECT o.order_id, c.name AS customer_name, o.order_date
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id;

-- List products that have never been ordered
SELECT * FROM Products
WHERE product_id NOT IN (SELECT DISTINCT product_id FROM Order_Items);

-- Find the top-spending customer
SELECT c.name, SUM(p.price * oi.quantity) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;

--data manipulation
-- Update Laptop price to 899.99
UPDATE Products SET price = 899.99 WHERE product_name = 'Laptop';

-- Delete orders placed before 2023-01-02
DELETE FROM Orders WHERE order_date < '2023-01-02';

-- Add new product "Headphones"
INSERT INTO Products (product_name, price) VALUES ('Headphones', 149.99);


--advanced challenges
-- Calculate average order value per customer
SELECT c.name, AVG(total) AS avg_order_value
FROM (
    SELECT o.customer_id, SUM(p.price * oi.quantity) AS total
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    GROUP BY o.order_id
) AS order_totals
JOIN Customers c ON order_totals.customer_id = c.customer_id
GROUP BY c.name;

-- Find products ordered more than 2 times in total
SELECT p.product_name, SUM(oi.quantity) AS total_quantity
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(oi.quantity) > 2;

-- Create an index to optimize querying orders by customer_id
CREATE INDEX idx_orders_customer ON Orders (customer_id);
