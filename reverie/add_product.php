<?php
header('Content-Type: application/json');

// Enable error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Include the database connection file
include 'db_connect.php';

// Set a valid error log file path
ini_set('error_log', '/var/log/php/error.log');  // Update with your actual log file path

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Check if all necessary data is provided
    if (!isset($_POST['user_id'], $_POST['title'], $_POST['description'], $_POST['category_id'], $_POST['size_id'], $_POST['color'], $_POST['condition_id'], $_POST['target_group_id'], $_POST['price']) || !isset($_FILES['image'])) {
        echo json_encode(["message" => "Missing required fields"]);
        exit();
    }

    // Extract data from the POST request
    $user_id = $_POST['user_id'];
    $title = $_POST['title'];
    $description = $_POST['description'];
    $category_id = $_POST['category_id'];
    $brand = isset($_POST['brand']) ? $_POST['brand'] : null;
    $size_id = $_POST['size_id'];
    $color = $_POST['color'];
    $condition_id = $_POST['condition_id'];
    $target_group_id = $_POST['target_group_id'];
    $price = $_POST['price'];

    // Handle the image upload
    $target_dir = "/home/u505497111/domains/reverie.newschateau.com/public_html/api/reverie/product-images/";
    $image_name = time() . '_' . basename($_FILES["image"]["name"]);
    $target_file = $target_dir . $image_name;

    // Ensure the target directory exists and has the right permissions
    if (!is_dir($target_dir)) {
        mkdir($target_dir, 0755, true);
    }

    if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
        // Start a transaction
        $mysqli->begin_transaction();

        try {
            // Fetch vendor_id from Vendors table based on user_id
            $vendorQuery = "SELECT vendor_id FROM Vendors WHERE user_id = ?";
            $vendorStmt = $mysqli->prepare($vendorQuery);
            if ($vendorStmt === false) {
                throw new Exception("Failed to prepare statement: " . $mysqli->error);
            }
            $vendorStmt->bind_param("i", $user_id);
            $vendorStmt->execute();
            $vendorStmt->bind_result($vendor_id);
            $vendorStmt->fetch();
            $vendorStmt->close();

            if (!$vendor_id) {
                throw new Exception("Vendor ID not found for the given user ID");
            }

            // Prepare and bind the product insertion statement
            $productStmt = $mysqli->prepare("INSERT INTO Products (vendor_id, title, description, category_id, brand, size_id, color, condition_id, target_group_id, price, image_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            if ($productStmt === false) {
                throw new Exception("Failed to prepare statement: " . $mysqli->error);
            }
            $productStmt->bind_param("issisissids", $vendor_id, $title, $description, $category_id, $brand, $size_id, $color, $condition_id, $target_group_id, $price, $image_name);

            // Execute the product insertion statement
            if ($productStmt->execute()) {
                // Commit the transaction
                $mysqli->commit();
                echo json_encode(["message" => "Product added successfully"]);
            } else {
                throw new Exception("Failed to add product: " . $productStmt->error);
            }
            $productStmt->close();
        } catch (Exception $e) {
            // Rollback the transaction in case of an error
            $mysqli->rollback();
            echo json_encode(["message" => "Failed to add product", "error" => $e->getMessage()]);
        }
    } else {
        echo json_encode(["message" => "Failed to upload image"]);
    }
} else {
    echo json_encode(["message" => "Invalid request method"]);
}

// Close the database connection
$mysqli->close();
?>