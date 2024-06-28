DROP DATABASE IF EXISTS Reverie;

-- Create the database
CREATE DATABASE Reverie;

USE Reverie;

-- User table to store both customers and vendors
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    birthday DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vendor registration table
CREATE TABLE Vendors (
    vendor_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    business_name VARCHAR(100) NOT NULL,
    business_registration_number VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Product table
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    size VARCHAR(10),
    preferences TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

-- Orders table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_status ENUM('pending', 'confirmed', 'shipped', 'delivered', 'completed') DEFAULT 'pending',
    total_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Users(user_id)
);

-- Order details table
CREATE TABLE OrderDetails (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Cart table
CREATE TABLE Cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Delivery information table
CREATE TABLE DeliveryInformation (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    delivery_status ENUM('pending', 'shipped', 'delivered') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Payment details table
CREATE TABLE PaymentDetails (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method ENUM('credit_card', 'paypal', 'bank_account') NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    payment_amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Notifications table for order and delivery status
CREATE TABLE Notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Insert initial data
INSERT INTO Users (first_name, last_name, email, password_hash, gender, birthday) VALUES 
('Malcolm', 'Clottey', 'clatteymolcolm4@gmail.com', 'your_password_hash', 'Male', '2003-03-09');

INSERT INTO Vendors (user_id, business_name, business_registration_number) VALUES 
(1, 'Bershka', 'BR123456789');

INSERT INTO Products (vendor_id, name, description, price, size, preferences) VALUES 
(1, 'A-line Mini Dress', 'A beautiful mini dress', 24.99, 'M', 'Cotton'),
(1, 'Fitted T-shirt', 'A comfortable fitted T-shirt', 6.99, 'L', 'Polyester'),
(1, 'Draped One-shoulder Top', 'A stylish one-shoulder top', 19.99, 'S', 'Silk'),
(1, 'Regular Fit Cotton Shorts', 'Comfortable cotton shorts', 4.99, 'M', 'Cotton');

INSERT INTO Orders (customer_id, order_status, total_price) VALUES 
(1, 'pending', 56.99),
(1, 'shipped', 74.50),
(1, 'delivered', 120.00);

INSERT INTO OrderDetails (order_id, product_id, quantity, price) VALUES 
(1, 1, 1, 24.99),
(1, 2, 1, 6.99),
(1, 3, 1, 19.99),
(1, 4, 1, 4.99),
(2, 2, 1, 74.50);

INSERT INTO Cart (customer_id, product_id, quantity) VALUES 
(1, 1, 2),
(1, 2, 1);

INSERT INTO DeliveryInformation (order_id, address, city, state, zip_code, country, phone_number, delivery_status) VALUES 
(1, '9516 Fall Haven Rd', 'Fredericksburg', 'Virginia', '22407-9264', 'USA', '+13014589407', 'pending'),
(2, '9516 Fall Haven Rd', 'Fredericksburg', 'Virginia', '22407-9264', 'USA', '+13014589407', 'shipped');

INSERT INTO PaymentDetails (order_id, payment_method, payment_status, payment_amount, payment_date) VALUES 
(1, 'credit_card', 'completed', 56.99, CURRENT_TIMESTAMP),
(2, 'paypal', 'completed', 74.50, CURRENT_TIMESTAMP);

INSERT INTO Notifications (user_id, message, is_read) VALUES 
(1, 'Your order #12345 has been shipped', FALSE),
(1, 'Your order #12346 has been delivered', FALSE);