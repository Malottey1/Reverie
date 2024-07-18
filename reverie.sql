

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



CREATE TABLE `Cart` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Cart`
--

INSERT INTO `Cart` (`cart_id`, `user_id`, `product_id`) VALUES
(14, 33, 18);

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


-- --------------------------------------------------------

--
-- Table structure for table `OrderDetails`
--

CREATE TABLE `OrderDetails` (
  `order_detail_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
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
  `order_status` enum('Processing','Shipped','Delivered','Cancelled') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `OrderTracking`
--

CREATE TABLE `OrderTracking` (
  `tracking_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) NOT NULL,
  `status` enum('Ready','Picked Up','Delivered') NOT NULL,
  `estimated_delivery_date` date DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `Payments`
--

CREATE TABLE `Payments` (
  `payment_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
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
(24, 29, 'angel', 'angels hand', 3, 'angels and angel', 1, 'brown angel', 5, 2, 99.00, '1719928529_6301867f-e4c9-44b2-95e4-74a82d3ddfc48652715983851209844.jpg', 1, '2024-07-02 13:55:29'),
(32, 34, 'Shirt', 'Nice Shirt', 1, 'Gucci', 3, 'Yellow', 2, 1, 50.00, '1720101789_8d474ec7-61c0-4887-a00c-41f8c163ac434306783355756363128.jpg', 1, '2024-07-04 14:03:09'),
(33, 34, 'Shirt', 'Nice Shirt', 1, 'Gucci', 3, 'Yellow', 2, 3, 50.00, '1720101792_8d474ec7-61c0-4887-a00c-41f8c163ac434306783355756363128.jpg', 1, '2024-07-04 14:03:12'),
(34, 34, 'Shirt', 'Nice Shirt', 1, 'Gucci', 3, 'Yellow', 2, 3, 50.00, '1720101792_8d474ec7-61c0-4887-a00c-41f8c163ac434306783355756363128.jpg', 1, '2024-07-04 14:03:12'),
(35, 32, 'Test Product', 'Test payment ', 1, 'Russ', 2, 'Blue', 2, 1, 0.10, '1720668003_gettyimages-157197704-1024x1024.jpg', 1, '2024-07-11 03:20:03');

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
  MODIFY `business_info_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `Cart`
--
ALTER TABLE `Cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

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
-- AUTO_INCREMENT for table `Payments`
--
ALTER TABLE `Payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `Products`
--
ALTER TABLE `Products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

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
-- AUTO_INCREMENT for table `TargetGroups`
--
ALTER TABLE `TargetGroups`
  MODIFY `target_group_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `Users`
--
ALTER TABLE `Users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `Vendors`
--
ALTER TABLE `Vendors`
  MODIFY `vendor_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

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
