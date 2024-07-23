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
    if (!isset($_POST['user_id'], $_POST['business_description'], $_POST['business_name'], $_POST['business_registration_number'], $_POST['business_address'], $_POST['city'], $_POST['state'], $_POST['country'], $_POST['payment_method']) || !isset($_FILES['profile_photo'])) {
        echo json_encode(["message" => "Missing required fields"]);
        exit();
    }

    // Extract data from the POST request
    $user_id = $_POST['user_id'];
    $business_description = $_POST['business_description'];
    $business_name = $_POST['business_name'];
    $business_registration_number = $_POST['business_registration_number'];
    $business_address = $_POST['business_address'];
    $city = $_POST['city'];
    $state = $_POST['state'];
    $country = $_POST['country'];
    $payment_method = $_POST['payment_method'];

    // Handle the profile photo upload
    $target_dir = "/home/u505497111/domains/reverie.newschateau.com/public_html/api/reverie/profile-photos/"; // Make sure this path is correct and writable
    $image_name = time() . '_' . basename($_FILES["profile_photo"]["name"]);
    $target_file = $target_dir . $image_name;

    // Log the target directory and file
    error_log("Target directory: " . $target_dir);
    error_log("Target file: " . $target_file);

    // Ensure the target directory is writable
    if (!is_writable($target_dir)) {
        error_log("Directory not writable: " . $target_dir);
        echo json_encode(["message" => "Target directory is not writable"]);
        exit();
    }

    // Try to move the uploaded file
    if (move_uploaded_file($_FILES["profile_photo"]["tmp_name"], $target_file)) {
        // Start a transaction
        $mysqli->begin_transaction();

        try {
            // Insert into Vendors table
            $vendorQuery = "INSERT INTO Vendors (user_id, profile_photo, business_description) VALUES (?, ?, ?)";
            $vendorStmt = $mysqli->prepare($vendorQuery);
            if ($vendorStmt === false) {
                throw new Exception("Failed to prepare statement: " . $mysqli->error);
            }
            $vendorStmt->bind_param("iss", $user_id, $image_name, $business_description);
            $vendorStmt->execute();
            $vendor_id = $mysqli->insert_id; // Get the inserted vendor ID

            // Insert into BusinessInfo table
            $businessQuery = "INSERT INTO BusinessInfo (vendor_id, business_name, business_registration_number, business_address, city, state, country) VALUES (?, ?, ?, ?, ?, ?, ?)";
            $businessStmt = $mysqli->prepare($businessQuery);
            if ($businessStmt === false) {
                throw new Exception("Failed to prepare statement: " . $mysqli->error);
            }
            $businessStmt->bind_param("issssss", $vendor_id, $business_name, $business_registration_number, $business_address, $city, $state, $country);
            $businessStmt->execute();

            // Prepare optional fields based on payment method
            $card_name = $payment_method == 'credit_card' ? $_POST['card_name'] : null;
            $card_number = $payment_method == 'credit_card' ? $_POST['card_number'] : null;
            $card_expiry_date = $payment_method == 'credit_card' ? $_POST['card_expiry_date'] : null;
            $card_cvv = $payment_method == 'credit_card' ? $_POST['card_cvv'] : null;
            $mobile_network = $payment_method == 'mobile_money' ? $_POST['mobile_network'] : null;
            $phone_number = $payment_method == 'mobile_money' ? $_POST['phone_number'] : null;
            $account_holder_name = $payment_method == 'bank_account' ? $_POST['account_holder_name'] : null;
            $bank_name = $payment_method == 'bank_account' ? $_POST['bank_name'] : null;
            $account_number = $payment_method == 'bank_account' ? $_POST['account_number'] : null;
            $routing_number = $payment_method == 'bank_account' ? $_POST['routing_number'] : null;

            // Insert into PaymentMethods table based on the payment method
            $paymentQuery = "INSERT INTO PaymentMethods (vendor_id, payment_method, card_name, card_number, card_expiry_date, card_cvv, mobile_network, phone_number, account_holder_name, bank_name, account_number, routing_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            $paymentStmt = $mysqli->prepare($paymentQuery);
            if ($paymentStmt === false) {
                throw new Exception("Failed to prepare statement: " . $mysqli->error);
            }
            $paymentStmt->bind_param("isssssssssss", 
                $vendor_id, 
                $payment_method,
                $card_name,
                $card_number,
                $card_expiry_date,
                $card_cvv,
                $mobile_network,
                $phone_number,
                $account_holder_name,
                $bank_name,
                $account_number,
                $routing_number
            );
            $paymentStmt->execute();

            // Commit the transaction
            $mysqli->commit();
            
            echo json_encode(['message' => 'Registration successful', 'vendor_id' => $vendor_id]); // Include vendor_id in the response
        } catch (Exception $e) {
            // Rollback the transaction in case of an error
            $mysqli->rollback();
            echo json_encode(['message' => 'Registration failed', 'error' => $e->getMessage()]);
        }

        // Close the prepared statements
        $vendorStmt->close();
        $businessStmt->close();
        $paymentStmt->close();
    } else {
        error_log("Failed to upload file: " . $_FILES["profile_photo"]["error"]);
        echo json_encode(["message" => "Failed to upload profile photo", "error" => $_FILES["profile_photo"]["error"]]);
    }
} else {
    echo json_encode(["message" => "Invalid request method"]);
}

// Close the database connection
$mysqli->close();
?>