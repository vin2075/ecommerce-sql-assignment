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
