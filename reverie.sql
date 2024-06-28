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
-- Create the Vendors table
CREATE TABLE Vendors (
    vendor_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    profile_photo VARCHAR(255),
    business_description TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create the BusinessInfo table
CREATE TABLE BusinessInfo (
    business_info_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id INT NOT NULL,
    business_name VARCHAR(100) NOT NULL,
    business_registration_number VARCHAR(50) NOT NULL,
    business_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);

-- Create the PaymentMethods table
CREATE TABLE PaymentMethods (
    payment_method_id INT AUTO_INCREMENT PRIMARY KEY,
    vendor_id INT NOT NULL,
    payment_method ENUM('credit_card', 'mobile_money', 'bank_account') NOT NULL,
    card_name VARCHAR(100),
    card_number VARCHAR(20),
    card_expiry_date VARCHAR(7),
    card_cvv VARCHAR(4),
    mobile_network VARCHAR(50),
    phone_number VARCHAR(20),
    account_holder_name VARCHAR(100),
    bank_name VARCHAR(100),
    account_number VARCHAR(20),
    routing_number VARCHAR(20),
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id)
);