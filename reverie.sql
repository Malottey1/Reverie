-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3308
-- Generation Time: Jul 04, 2024 at 11:30 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `Reverie`
--

-- --------------------------------------------------------

--
-- Table structure for table `BillingAddresses`
--

CREATE TABLE `BillingAddresses` (
  `billing_address_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `address` varchar(255) NOT NULL,
  `city` varchar(100) NOT NULL,
  `postal_code` varchar(20) NOT NULL,
  `state` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `BillingAddresses`
--

INSERT INTO `BillingAddresses` (`billing_address_id`, `user_id`, `name`, `address`, `city`, `postal_code`, `state`, `country`, `created_at`) VALUES
(1, 31, 'BMN', 'VGBVBNM', 'BN', 'VHJK', 'VHJK', 'VBHJ', '2024-07-04 01:32:59'),
(2, 31, 'BMN', 'VGBVBNM', 'BN', 'VHJK', 'VHJK', 'VBHJ', '2024-07-04 01:32:59');

-- --------------------------------------------------------

--
-- Table structure for table `BusinessInfo`
--

CREATE TABLE `BusinessInfo` (
  `business_info_id` int(11) NOT NULL,
  `vendor_id` int(11) NOT NULL,
  `business_name` varchar(100) NOT NULL,
  `business_registration_number` varchar(50) NOT NULL,
  `business_address` varchar(255) NOT NULL,
  `city` varchar(100) NOT NULL,
  `state` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `BusinessInfo`
--

INSERT INTO `BusinessInfo` (`business_info_id`, `vendor_id`, `business_name`, `business_registration_number`, `business_address`, `city`, `state`, `country`, `created_at`) VALUES
(10, 10, 'gfhgdh', '3456', '5678', 'gfhdhf', 'gbgnhg', 'fdggf', '2024-07-01 17:59:12'),
(11, 11, 'gsfdsd', '2345', '3323', 'gunan', 'dkhfdf', 'fdfds', '2024-07-01 18:05:59'),
(12, 12, 'Zara', '1234', 'Road Rd', 'Accra', 'Gr.Accra', 'Ghana', '2024-07-01 21:17:11'),
(13, 13, 'AXC', '1345', 'STREET RD', 'Accra', 'Accraz', 'Ghana', '2024-07-01 21:26:22'),
(14, 14, 'BOBO', 'BR234', 'Road Rd', 'Accra', 'Accra', 'Ghana', '2024-07-02 09:16:19'),
(15, 15, 'ggfdg', 'BR345', 'Road12', 'fghdf', 'gfgdfg', 'gfgfd', '2024-07-02 09:35:35'),
(16, 16, 'fdfd', 'ddff123', 'dssdsd', 'fddsd', 'fdfdf', 'ghana', '2024-07-02 09:42:09'),
(17, 17, 'gdfgf', 'fdfd21', 'ffdfd', 'fdfdsf', 'fdfsgs', 'fdfdsfs', '2024-07-02 10:12:31'),
(18, 18, 'fgdffgd', 'ds344', 'fdfdfd', 'fgdhf', 'dssfd', 'sdsdsf', '2024-07-02 12:35:21'),
(19, 19, 'fgdffgd', 'ds344', 'rofodf', 'dsdf', 'dssfd', 'sdsdsf', '2024-07-02 12:35:57'),
(20, 20, 'fgdffgd', 'ds344', 'rofodf', 'dsdf', 'dssfd', 'sdsdsf', '2024-07-02 12:39:33'),
(21, 21, 'fgdffgd', 'ds344', 'rofodf', 'dsdf', 'dssfd', 'sdsdsf', '2024-07-02 12:39:33'),
(22, 22, 'fgdffgd', 'ds344', 'rofodf', 'dsdf', 'dssfd', 'sdsdsf', '2024-07-02 12:47:25'),
(23, 23, 'fgdffgd', 'ds344', 'rofodf', 'dsdf', 'dssfd', 'sdsdsf', '2024-07-02 12:47:28'),
(24, 24, 'dfdf', 'eds43', 'ffgddf', 'gdfdsd', 'dfgdfds', 'dfgdgfd', '2024-07-02 12:48:24'),
(25, 25, 'dfdf', 'eds43', 'ffgddf', 'gdfdsd', 'dfgdfds', 'dfgdgfd', '2024-07-02 12:48:31'),
(26, 26, 'dfdf', 'eds43', 'ffgddf', 'gdfdsd', 'dfgdfds', 'dfgdgfd', '2024-07-02 12:54:53'),
(27, 27, 'dfsddsf', 'dfsfs1', 'fgdgf', 'gdfdf', 'fdgdfgdf', 'fgdfgd', '2024-07-02 12:57:31'),
(28, 28, 'Nae', 'BR234', 'FDSFDF12', 'Ghana', 'Accra', 'Ghana', '2024-07-02 13:16:12'),
(29, 29, 'Jesse inc', 'Jesse and jesse', 'Jesse\'s house', 'Jesse\'s street', 'Jesse\'s day', 'Jesse\'s country', '2024-07-02 13:53:32'),
(30, 30, 'Jesse inc', 'Jesse and jesse', 'Jesse\'s house', 'Jesse\'s street', 'Jesse\'s day', 'Jesse\'s country', '2024-07-02 13:53:50'),
(31, 31, 'Jesse inc', 'Jesse and jesse', 'Jesse\'s house', 'Jesse\'s street', 'Jesse\'s day', 'Jesse\'s country', '2024-07-02 13:54:26'),
(32, 32, 'dfsdfasdf', '1234', 'dsfdsfdf', 'fdfsdfds', 'dfsdfsdc', 'fssdsd', '2024-07-03 01:21:16');

-- --------------------------------------------------------

--
-- Table structure for table `Cart`
--

CREATE TABLE `Cart` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Cart`
--

INSERT INTO `Cart` (`cart_id`, `user_id`, `product_id`) VALUES
(9, 31, 18),
(10, 31, 20);

-- --------------------------------------------------------

--
-- Table structure for table `Categories`
--

CREATE TABLE `Categories` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Categories`
--

INSERT INTO `Categories` (`category_id`, `category_name`) VALUES
(1, 'Tops'),
(2, 'Bottoms'),
(3, 'Dresses'),
(4, 'Outerwear'),
(5, 'Accessories');

-- --------------------------------------------------------

--
-- Table structure for table `Conditions`
--

CREATE TABLE `Conditions` (
  `condition_id` int(11) NOT NULL,
  `condition_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Conditions`
--

INSERT INTO `Conditions` (`condition_id`, `condition_name`) VALUES
(1, 'New with Tags'),
(2, 'Excellent'),
(3, 'Very Good'),
(4, 'Good'),
(5, 'Fair');

-- --------------------------------------------------------

--
-- Table structure for table `Inventory`
--

CREATE TABLE `Inventory` (
  `inventory_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `OrderDetails`
--

CREATE TABLE `OrderDetails` (
  `order_detail_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Orders`
--

CREATE TABLE `Orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_status` enum('Pending','Completed','Failed') NOT NULL,
  `order_status` enum('Processing','Shipped','Delivered','Cancelled') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `OrderTracking`
--

CREATE TABLE `OrderTracking` (
  `tracking_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `status` enum('Ready','Picked Up','Delivered') NOT NULL,
  `estimated_delivery_date` date DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `PaymentMethods`
--

CREATE TABLE `PaymentMethods` (
  `payment_method_id` int(11) NOT NULL,
  `vendor_id` int(11) NOT NULL,
  `payment_method` enum('credit_card','mobile_money','bank_account') NOT NULL,
  `card_name` varchar(100) DEFAULT NULL,
  `card_number` varchar(20) DEFAULT NULL,
  `card_expiry_date` varchar(7) DEFAULT NULL,
  `card_cvv` varchar(4) DEFAULT NULL,
  `mobile_network` varchar(50) DEFAULT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `account_holder_name` varchar(100) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `account_number` varchar(20) DEFAULT NULL,
  `routing_number` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `PaymentMethods`
--

INSERT INTO `PaymentMethods` (`payment_method_id`, `vendor_id`, `payment_method`, `card_name`, `card_number`, `card_expiry_date`, `card_cvv`, `mobile_network`, `phone_number`, `account_holder_name`, `bank_name`, `account_number`, `routing_number`) VALUES
(10, 10, 'mobile_money', NULL, NULL, NULL, NULL, 'Telelvel', '0577589856', NULL, NULL, NULL, NULL),
(11, 11, 'mobile_money', NULL, NULL, NULL, NULL, 'yfdf', '0843343423', NULL, NULL, NULL, NULL),
(12, 12, 'mobile_money', NULL, NULL, NULL, NULL, 'MTN', '0244567689', NULL, NULL, NULL, NULL),
(13, 13, 'mobile_money', NULL, NULL, NULL, NULL, 'MTN', '0244568708', NULL, NULL, NULL, NULL),
(14, 14, 'mobile_money', NULL, NULL, NULL, NULL, 'Telecel', '0233894345', NULL, NULL, NULL, NULL),
(15, 15, 'mobile_money', NULL, NULL, NULL, NULL, 'gdfgf', '0344898567', NULL, NULL, NULL, NULL),
(16, 16, 'mobile_money', NULL, NULL, NULL, NULL, 'dfgdd', '0233748564', NULL, NULL, NULL, NULL),
(17, 17, 'mobile_money', NULL, NULL, NULL, NULL, 'thids', '03566859043', NULL, NULL, NULL, NULL),
(18, 18, 'mobile_money', NULL, NULL, NULL, NULL, 'Telecel', '5453455', NULL, NULL, NULL, NULL),
(19, 19, 'mobile_money', NULL, NULL, NULL, NULL, 'Telecel', '545345543535', NULL, NULL, NULL, NULL),
(20, 20, 'mobile_money', NULL, NULL, NULL, NULL, 'Telecel', '545345543535', NULL, NULL, NULL, NULL),
(21, 21, 'mobile_money', NULL, NULL, NULL, NULL, 'Telecel', '545345543535', NULL, NULL, NULL, NULL),
(22, 22, 'mobile_money', NULL, NULL, NULL, NULL, 'Telecel', '545345543535', NULL, NULL, NULL, NULL),
(23, 23, 'mobile_money', NULL, NULL, NULL, NULL, 'Telecel', '545345543535', NULL, NULL, NULL, NULL),
(24, 24, 'mobile_money', NULL, NULL, NULL, NULL, 'fdgsdfds', '0477545656', NULL, NULL, NULL, NULL),
(25, 25, 'mobile_money', NULL, NULL, NULL, NULL, 'fdgsdfds', '0477545656', NULL, NULL, NULL, NULL),
(26, 26, 'mobile_money', NULL, NULL, NULL, NULL, 'fdgsdfds', '0477545656', NULL, NULL, NULL, NULL),
(27, 27, 'mobile_money', NULL, NULL, NULL, NULL, 'gfdgdf', '0466758965', NULL, NULL, NULL, NULL),
(28, 28, 'mobile_money', NULL, NULL, NULL, NULL, 'Telecel', '0344689534', NULL, NULL, NULL, NULL),
(29, 29, 'mobile_money', NULL, NULL, NULL, NULL, 'mtn', '0244753872', NULL, NULL, NULL, NULL),
(30, 30, 'mobile_money', NULL, NULL, NULL, NULL, 'mtn', '0244753872', NULL, NULL, NULL, NULL),
(31, 31, 'mobile_money', NULL, NULL, NULL, NULL, 'mtn', '0244753872', NULL, NULL, NULL, NULL),
(32, 32, 'mobile_money', NULL, NULL, NULL, NULL, 'Telecel', '0233456543', NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `Payments`
--

CREATE TABLE `Payments` (
  `payment_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_method` enum('Credit Card','Mobile Money','Bank Transfer') NOT NULL,
  `payment_status` enum('Pending','Completed','Failed') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Products`
--

CREATE TABLE `Products` (
  `product_id` int(11) NOT NULL,
  `vendor_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `category_id` int(11) NOT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `size_id` int(11) NOT NULL,
  `color` varchar(50) NOT NULL,
  `condition_id` int(11) NOT NULL,
  `target_group_id` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `image_path` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Products`
--

INSERT INTO `Products` (`product_id`, `vendor_id`, `title`, `description`, `category_id`, `brand`, `size_id`, `color`, `condition_id`, `target_group_id`, `price`, `image_path`, `is_active`, `created_at`) VALUES
(18, 11, 'Dress', 'ffgsdf', 3, 'fsdfs', 3, 'fsdfsd', 2, 2, 20.00, '1719857210_26.jpg', 1, '2024-07-01 18:06:50'),
(19, 11, 'Dress', 'ffgsdf', 2, 'fsdfs', 3, 'fsdfsd', 2, 1, 20.00, '1719857309_22.png', 1, '2024-07-01 18:08:29'),
(20, 11, 'Dress', 'ffgsdf', 2, 'fsdfs', 1, 'fsdfsd', 2, 2, 20.00, '1719857359_20.png', 1, '2024-07-01 18:09:19'),
(21, 12, 'Dress', 'Nice dress', 3, 'H&M', 2, 'Blue', 2, 2, 30.00, '1719868688_church-tabernacle-catholic-gold-neutral-background-42825744.jpg', 1, '2024-07-01 21:18:08'),
(22, 28, 'Grahic Tee', 'Nice Tee', 1, 'Hollister', 2, 'White', 3, 1, 50.00, '1719926684_22.png', 1, '2024-07-02 13:24:44'),
(23, 29, 'angel', 'angels hand', 3, 'angels and angel', 1, 'brown angel', 5, 2, 99.00, '1719928504_6301867f-e4c9-44b2-95e4-74a82d3ddfc48652715983851209844.jpg', 1, '2024-07-02 13:55:04'),
(24, 29, 'angel', 'angels hand', 3, 'angels and angel', 1, 'brown angel', 5, 2, 99.00, '1719928529_6301867f-e4c9-44b2-95e4-74a82d3ddfc48652715983851209844.jpg', 1, '2024-07-02 13:55:29');

-- --------------------------------------------------------

--
-- Table structure for table `ShippingAddresses`
--

CREATE TABLE `ShippingAddresses` (
  `address_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `address` varchar(255) NOT NULL,
  `address_line2` varchar(255) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `postal_code` varchar(20) NOT NULL,
  `state` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ShippingAddresses`
--

INSERT INTO `ShippingAddresses` (`address_id`, `user_id`, `first_name`, `last_name`, `address`, `address_line2`, `city`, `postal_code`, `state`, `country`, `created_at`) VALUES
(1, 31, 'dfsdzgsfdgd', 'dfgdfgd', 'gdfgfdgd', 'dfgdfg', 'fdgdfg', 'fdgdfg', 'fdgfdgfd', 'gfdgfdgd', '2024-07-04 08:13:10');

-- --------------------------------------------------------

--
-- Table structure for table `Sizes`
--

CREATE TABLE `Sizes` (
  `size_id` int(11) NOT NULL,
  `size_name` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Sizes`
--

INSERT INTO `Sizes` (`size_id`, `size_name`) VALUES
(1, 'XS'),
(2, 'S'),
(3, 'M'),
(4, 'L'),
(5, 'XL'),
(6, 'XXL');

-- --------------------------------------------------------

--
-- Table structure for table `Stores`
--

CREATE TABLE `Stores` (
  `store_id` int(11) NOT NULL,
  `vendor_id` int(11) NOT NULL,
  `store_description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `TargetGroups`
--

CREATE TABLE `TargetGroups` (
  `target_group_id` int(11) NOT NULL,
  `target_group_name` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `TargetGroups`
--

INSERT INTO `TargetGroups` (`target_group_id`, `target_group_name`) VALUES
(1, 'Men'),
(2, 'Women'),
(3, 'Kids');

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

CREATE TABLE `Users` (
  `user_id` int(11) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `gender` enum('Male','Female','Other') NOT NULL,
  `birthday` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Users`
--

INSERT INTO `Users` (`user_id`, `first_name`, `last_name`, `email`, `password_hash`, `gender`, `birthday`, `created_at`) VALUES
(12, 'kofi', 'ababio', 'kofi@gmail.com', '$2y$10$wDfF55oQHTRTgDZH2JGMreFP3wHSyz0wwn6dGSsF.jdTZb/I8mwTG', 'Male', '2024-07-01', '2024-07-01 17:58:09'),
(13, 'kojo', 'gogo', 'kojo@gmail.com', '$2y$10$O2StEvamkYEI86b4Mz7VO.QXUTd9WDMtbP0RGo3ZYwieQNF/lgTSS', 'Female', '2024-07-01', '2024-07-01 18:03:56'),
(14, 'fufu', 'bannin', 'fufu@gmail.com', '$2y$10$cVk7Ev964wBYrckDBu5NGu/RQA1HokSyND1reZ9nirwJ3MJhSLb6i', 'Male', '2024-07-01', '2024-07-01 19:12:21'),
(15, 'malcolm', 'malcolm', 'abc@gmail.com', '$2y$10$4Y2vKHAVykCGNLjHP1fUxeyJ8rAXA3Si3Qf.ovEdt1pRtHzGC4nSi', 'Male', '2024-07-01', '2024-07-01 21:00:32'),
(16, 'mal', 'colm', 'mal@gmail.com', '$2y$10$7zWJx9p7OB58ZMWSVqhmaOhNZh0Rj4FpA76Lq269OOSMmiAyyU8M6', 'Male', '2024-07-01', '2024-07-01 21:09:05'),
(17, 'do', 'it', 'do@gmail.com', '$2y$10$ai.heNai0VB36HUHgA3F/.lZsBk7XMZ7xP1tZQcXBP1S/7pH54OH.', 'Male', '2024-07-01', '2024-07-01 21:25:01'),
(18, 'kiki', 'pipi', 'kiki@gmail.com', '$2y$10$RgURcHUh9B1gLKel4xb4keB5APtUUfGZqBCWwYEBBhHjRyl8njMEC', 'Male', '2024-07-01', '2024-07-01 23:15:02'),
(19, 'mimi', 'adu', 'mimi@gmail.com', '$2y$10$TT1Z3MaBPJbLWojhNF14Q.pGlItpank1xunPLWo0AkBtpHBlKkNNO', 'Male', '2024-07-01', '2024-07-01 23:47:09'),
(20, 'maurice', 'clo', 'maurice@gmail.com', '$2y$10$i7xYlV9W/6e3xQQERVKsgOlXAjsb.znIOK3RR95KwdHVBcA4MThUa', 'Female', '2024-07-02', '2024-07-02 09:14:50'),
(21, 'ju', 'bu', 'ju@gmail.com', '$2y$10$m8BUyUxFw8CWziQCytVqvOs9AzlhuZ0SXvK4gjdSDt1/3ba7fEGWW', 'Male', '2024-07-02', '2024-07-02 09:34:49'),
(22, 'ko', 'ab', 'ko@gmail.com', '$2y$10$DVmqzLQVGryBkwyKRTBAF.IbgRki/6IfWqawmROa9C9soWNADCipS', 'Male', '2024-07-02', '2024-07-02 09:41:18'),
(23, 'hu', 'koj', 'hu@gmail.com', '$2y$10$er/A6LofOJnIWbXfSfiMqek0OxmZ.q6Wx7JQg/Ym8CYMD0DYQip1G', 'Male', '2024-07-02', '2024-07-02 10:11:45'),
(24, 'abc', 'you', 'hugo@gmail.com', '$2y$10$P53na0nMGRTbDjRQpARUOulSOnQ/TQ481QeRusahu6aaNzs987yZu', 'Male', '2024-07-02', '2024-07-02 12:34:12'),
(25, 'adngf', 'adfd', 'russ@gmail.com', '$2y$10$PNkjie7TzXzRWovkuejvTucsCQc9uJBdEWkbCumA2kgvxyvdvd4vq', 'Male', '2024-07-02', '2024-07-02 12:56:47'),
(26, 'Felix', 'Hugo', 'felixx@gmail.com', '$2y$10$tCj25SqH.hdEH2XTaQmeHu7jhp/b2wvVzah86uvq7QW2/T/yZ6Blq', 'Female', '2024-07-01', '2024-07-02 13:15:13'),
(27, 'Ayeyi', 'Gyan', 'ayeyi@gmail.com', '$2y$10$eWuIUjQB/V5F39ocnHl5neOOp5/5KbRjnl6qF8u2KUMBPG0yasgmu', 'Male', '2024-07-01', '2024-07-02 13:48:17'),
(28, 'jesse', 'jefferson', 'jesse@gmail.com', '$2y$10$ikfuNwU2gmQxtoWC8v/FouCJ9phniU2GlNL.i/LrvsThjAmkegziS', 'Male', '2024-07-03', '2024-07-02 13:58:11'),
(29, 'Bubu', 'Tutu', 'bubu@gmail.com', '$2y$10$ETmg24uHYF25d5J7l6UuS.lXWe6o9kzmpq6VEUeueHJU/2qQ0ClFW', 'Male', '2003-07-02', '2024-07-02 14:17:34'),
(30, 'd', 's', 'hs@gmail.com', '$2y$10$4aaZKL9ohiSNjsUnJ9gb1uCorzgyX51A1zOE5q3o1Jv.dLXduKel6', 'Female', '2024-07-02', '2024-07-02 14:23:17'),
(31, 'frank', 'cean', 'frank@gmail.com', '$2y$10$NdVqbtNoHtNDEiH8VUS.buUK.5lk0m5eVL6CsS4eVcsMYziDPz7ha', 'Male', '2024-07-01', '2024-07-03 01:20:21');

-- --------------------------------------------------------

--
-- Table structure for table `Vendors`
--

CREATE TABLE `Vendors` (
  `vendor_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `profile_photo` varchar(255) DEFAULT NULL,
  `business_description` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Vendors`
--

INSERT INTO `Vendors` (`vendor_id`, `user_id`, `profile_photo`, `business_description`, `created_at`) VALUES
(10, 12, '1719856752_22.png', 'fdgdghfg', '2024-07-01 17:59:12'),
(11, 13, '1719857159_18.png', 'fgdfgd', '2024-07-01 18:05:59'),
(12, 15, '1719868631_gettyimages-157197704-1024x1024.jpg', 'Rug', '2024-07-01 21:17:11'),
(13, 17, '1719869182_BF613630_d11510.jpg', 'Soso', '2024-07-01 21:26:22'),
(14, 20, '1719911779_25.png', 'Giog', '2024-07-02 09:16:19'),
(15, 21, '1719912935_18.png', 'vbf', '2024-07-02 09:35:35'),
(16, 22, '1719913329_18.png', 'dfsdf', '2024-07-02 09:42:09'),
(17, 23, '1719915151_18.png', 'fdgdgdfd', '2024-07-02 10:12:31'),
(18, 24, '1719923721_18.png', 'fdgdfgdff', '2024-07-02 12:35:21'),
(19, 24, '1719923757_18.png', 'fdgdfgdff', '2024-07-02 12:35:57'),
(20, 24, '1719923973_18.png', 'fdgdfgdff', '2024-07-02 12:39:33'),
(21, 24, '1719923973_18.png', 'fdgdfgdff', '2024-07-02 12:39:33'),
(22, 24, '1719924445_18.png', 'fdgdfgdff', '2024-07-02 12:47:25'),
(23, 24, '1719924448_18.png', 'fdgdfgdff', '2024-07-02 12:47:28'),
(24, 24, '1719924504_18.png', 'abc', '2024-07-02 12:48:24'),
(25, 24, '1719924511_18.png', 'abc', '2024-07-02 12:48:31'),
(26, 24, '1719924893_18.png', 'abc', '2024-07-02 12:54:53'),
(27, 25, '1719925051_18.png', 'fddsfd', '2024-07-02 12:57:31'),
(28, 26, '1719926172_18.png', 'Store', '2024-07-02 13:16:12'),
(29, 27, '1719928412_1000000046.jpg', 'rags', '2024-07-02 13:53:32'),
(30, 27, '1719928430_1000000046.jpg', 'rags', '2024-07-02 13:53:50'),
(31, 27, '1719928466_1000000046.jpg', 'rags', '2024-07-02 13:54:26'),
(32, 31, '1719969676_18.png', 'dfdgdffs', '2024-07-03 01:21:16');

-- --------------------------------------------------------

--
-- Table structure for table `Wishlists`
--

CREATE TABLE `Wishlists` (
  `wishlist_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `BillingAddresses`
--
ALTER TABLE `BillingAddresses`
  ADD PRIMARY KEY (`billing_address_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `BusinessInfo`
--
ALTER TABLE `BusinessInfo`
  ADD PRIMARY KEY (`business_info_id`),
  ADD KEY `vendor_id` (`vendor_id`);

--
-- Indexes for table `Cart`
--
ALTER TABLE `Cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD UNIQUE KEY `unique_cart_item` (`user_id`,`product_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `Categories`
--
ALTER TABLE `Categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `Conditions`
--
ALTER TABLE `Conditions`
  ADD PRIMARY KEY (`condition_id`);

--
-- Indexes for table `Inventory`
--
ALTER TABLE `Inventory`
  ADD PRIMARY KEY (`inventory_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `OrderDetails`
--
ALTER TABLE `OrderDetails`
  ADD PRIMARY KEY (`order_detail_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `Orders`
--
ALTER TABLE `Orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `OrderTracking`
--
ALTER TABLE `OrderTracking`
  ADD PRIMARY KEY (`tracking_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `PaymentMethods`
--
ALTER TABLE `PaymentMethods`
  ADD PRIMARY KEY (`payment_method_id`),
  ADD KEY `vendor_id` (`vendor_id`);

--
-- Indexes for table `Payments`
--
ALTER TABLE `Payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `Products`
--
ALTER TABLE `Products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `vendor_id` (`vendor_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `size_id` (`size_id`),
  ADD KEY `condition_id` (`condition_id`),
  ADD KEY `target_group_id` (`target_group_id`);

--
-- Indexes for table `ShippingAddresses`
--
ALTER TABLE `ShippingAddresses`
  ADD PRIMARY KEY (`address_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `Sizes`
--
ALTER TABLE `Sizes`
  ADD PRIMARY KEY (`size_id`);

--
-- Indexes for table `Stores`
--
ALTER TABLE `Stores`
  ADD PRIMARY KEY (`store_id`),
  ADD KEY `vendor_id` (`vendor_id`);

--
-- Indexes for table `TargetGroups`
--
ALTER TABLE `TargetGroups`
  ADD PRIMARY KEY (`target_group_id`);

--
-- Indexes for table `Users`
--
ALTER TABLE `Users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `Vendors`
--
ALTER TABLE `Vendors`
  ADD PRIMARY KEY (`vendor_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `Wishlists`
--
ALTER TABLE `Wishlists`
  ADD PRIMARY KEY (`wishlist_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `BillingAddresses`
--
ALTER TABLE `BillingAddresses`
  MODIFY `billing_address_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `BusinessInfo`
--
ALTER TABLE `BusinessInfo`
  MODIFY `business_info_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `Cart`
--
ALTER TABLE `Cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `Categories`
--
ALTER TABLE `Categories`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Conditions`
--
ALTER TABLE `Conditions`
  MODIFY `condition_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `Inventory`
--
ALTER TABLE `Inventory`
  MODIFY `inventory_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `OrderDetails`
--
ALTER TABLE `OrderDetails`
  MODIFY `order_detail_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Orders`
--
ALTER TABLE `Orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `OrderTracking`
--
ALTER TABLE `OrderTracking`
  MODIFY `tracking_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `PaymentMethods`
--
ALTER TABLE `PaymentMethods`
  MODIFY `payment_method_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `Payments`
--
ALTER TABLE `Payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Products`
--
ALTER TABLE `Products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `ShippingAddresses`
--
ALTER TABLE `ShippingAddresses`
  MODIFY `address_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `Sizes`
--
ALTER TABLE `Sizes`
  MODIFY `size_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `Stores`
--
ALTER TABLE `Stores`
  MODIFY `store_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `TargetGroups`
--
ALTER TABLE `TargetGroups`
  MODIFY `target_group_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `Users`
--
ALTER TABLE `Users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `Vendors`
--
ALTER TABLE `Vendors`
  MODIFY `vendor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `Wishlists`
--
ALTER TABLE `Wishlists`
  MODIFY `wishlist_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `BillingAddresses`
--
ALTER TABLE `BillingAddresses`
  ADD CONSTRAINT `billingaddresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`);

--
-- Constraints for table `BusinessInfo`
--
ALTER TABLE `BusinessInfo`
  ADD CONSTRAINT `businessinfo_ibfk_1` FOREIGN KEY (`vendor_id`) REFERENCES `Vendors` (`vendor_id`);

--
-- Constraints for table `Cart`
--
ALTER TABLE `Cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`),
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`);

--
-- Constraints for table `Inventory`
--
ALTER TABLE `Inventory`
  ADD CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`);

--
-- Constraints for table `OrderDetails`
--
ALTER TABLE `OrderDetails`
  ADD CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `Orders` (`order_id`),
  ADD CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`);

--
-- Constraints for table `Orders`
--
ALTER TABLE `Orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`);

--
-- Constraints for table `OrderTracking`
--
ALTER TABLE `OrderTracking`
  ADD CONSTRAINT `ordertracking_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `Orders` (`order_id`);

--
-- Constraints for table `PaymentMethods`
--
ALTER TABLE `PaymentMethods`
  ADD CONSTRAINT `paymentmethods_ibfk_1` FOREIGN KEY (`vendor_id`) REFERENCES `Vendors` (`vendor_id`);

--
-- Constraints for table `Payments`
--
ALTER TABLE `Payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `Orders` (`order_id`);

--
-- Constraints for table `Products`
--
ALTER TABLE `Products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`vendor_id`) REFERENCES `Vendors` (`vendor_id`),
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `Categories` (`category_id`),
  ADD CONSTRAINT `products_ibfk_3` FOREIGN KEY (`size_id`) REFERENCES `Sizes` (`size_id`),
  ADD CONSTRAINT `products_ibfk_4` FOREIGN KEY (`condition_id`) REFERENCES `Conditions` (`condition_id`),
  ADD CONSTRAINT `products_ibfk_5` FOREIGN KEY (`target_group_id`) REFERENCES `TargetGroups` (`target_group_id`);

--
-- Constraints for table `ShippingAddresses`
--
ALTER TABLE `ShippingAddresses`
  ADD CONSTRAINT `shippingaddresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`);

--
-- Constraints for table `Stores`
--
ALTER TABLE `Stores`
  ADD CONSTRAINT `stores_ibfk_1` FOREIGN KEY (`vendor_id`) REFERENCES `Vendors` (`vendor_id`);

--
-- Constraints for table `Vendors`
--
ALTER TABLE `Vendors`
  ADD CONSTRAINT `vendors_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`);

--
-- Constraints for table `Wishlists`
--
ALTER TABLE `Wishlists`
  ADD CONSTRAINT `wishlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`),
  ADD CONSTRAINT `wishlists_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `Products` (`product_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
