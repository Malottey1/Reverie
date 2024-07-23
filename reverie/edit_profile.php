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
    // Log the received POST data
    error_log("Received POST data: " . json_encode($_POST));
    error_log("Received FILES data: " . json_encode($_FILES));

    // Check if all necessary data is provided
    if (!isset($_POST['vendor_id'], $_POST['business_description'], $_POST['business_name'], $_POST['business_registration_number'], $_POST['business_address'], $_POST['city'], $_POST['state'], $_POST['country'], $_POST['payment_method'])) {
        echo json_encode(["message" => "Missing required fields"]);
        exit();
    }

    // Extract data from the POST request
    $vendor_id = $_POST['vendor_id'];
    $business_description = $_POST['business_description'];
    $business_name = $_POST['business_name'];
    $business_registration_number = $_POST['business_registration_number'];
    $business_address = $_POST['business_address'];
    $city = $_POST['city'];
    $state = $_POST['state'];
    $country = $_POST['country'];
    $payment_method = $_POST['payment_method'];

    // Handle the profile photo upload if provided
    $profile_photo = null;
    if (isset($_FILES['profile_photo'])) {
        $target_dir = "https://reverie.newschateau.com/api/reverie/product-images/";
        $image_name = time() . '_' . basename($_FILES["profile_photo"]["name"]);
        $target_file = $target_dir . $image_name;

        // Ensure the target directory exists and has the right permissions
        if (!is_dir($target_dir)) {
            mkdir($target_dir, 0755, true);
        }

        if (move_uploaded_file($_FILES["profile_photo"]["tmp_name"], $target_file)) {
            $profile_photo = $image_name;
        } else {
            echo json_encode(["message" => "Failed to upload profile photo"]);
            exit();
        }
    }

    // Start a transaction
    $mysqli->begin_transaction();

    try {
        // Update Vendors table
        if ($profile_photo) {
            $vendorQuery = "UPDATE Vendors SET profile_photo = ?, business_description = ? WHERE vendor_id = ?";
            $vendorStmt = $mysqli->prepare($vendorQuery);
            $vendorStmt->bind_param("ssi", $profile_photo, $business_description, $vendor_id);
        } else {
            $vendorQuery = "UPDATE Vendors SET business_description = ? WHERE vendor_id = ?";
            $vendorStmt = $mysqli->prepare($vendorQuery);
            $vendorStmt->bind_param("si", $business_description, $vendor_id);
        }
        if ($vendorStmt === false) {
            throw new Exception("Failed to prepare statement: " . $mysqli->error);
        }
        $vendorStmt->execute();

        // Update BusinessInfo table
        $businessQuery = "UPDATE BusinessInfo SET business_name = ?, business_registration_number = ?, business_address = ?, city = ?, state = ?, country = ? WHERE vendor_id = ?";
        $businessStmt = $mysqli->prepare($businessQuery);
        if ($businessStmt === false) {
            throw new Exception("Failed to prepare statement: " . $mysqli->error);
        }
        $businessStmt->bind_param("ssssssi", $business_name, $business_registration_number, $business_address, $city, $state, $country, $vendor_id);
        $businessStmt->execute();

        // Prepare optional fields based on payment method
        $card_name = $payment_method == 'credit_card' ? $_POST['card_name'] : null;
        $card_number = $payment_method == 'credit_card' ? $_POST['card_number'] : null;
        $card_expiry_date = $payment_method == 'credit_card' ? $_POST['card_expiry_date'] : null;
        $card_cvv = $payment_method == 'credit_card' ? $_POST['card_cvv'] : null;
        $mobile_network = $payment_method == 'mobile_money' ? ($_POST['mobile_network'] ?? null) : null;
        $phone_number = $payment_method == 'mobile_money' ? ($_POST['phone_number'] ?? null) : null;
        $account_holder_name = $payment_method == 'bank_account' ? $_POST['account_holder_name'] : null;
        $bank_name = $payment_method == 'bank_account' ? $_POST['bank_name'] : null;
        $account_number = $payment_method == 'bank_account' ? $_POST['account_number'] : null;
        $routing_number = $payment_method == 'bank_account' ? $_POST['routing_number'] : null;

        // Update PaymentMethods table based on the payment method
        $paymentQuery = "UPDATE PaymentMethods SET payment_method = ?, card_name = ?, card_number = ?, card_expiry_date = ?, card_cvv = ?, mobile_network = ?, phone_number = ?, account_holder_name = ?, bank_name = ?, account_number = ?, routing_number = ? WHERE vendor_id = ?";
        $paymentStmt = $mysqli->prepare($paymentQuery);
        if ($paymentStmt === false) {
            throw new Exception("Failed to prepare statement: " . $mysqli->error);
        }
        $paymentStmt->bind_param("sssssssssssi", 
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
            $routing_number,
            $vendor_id
        );
        $paymentStmt->execute();

        // Commit the transaction
        $mysqli->commit();

        echo json_encode(['message' => 'Profile updated successfully']);
    } catch (Exception $e) {
        // Rollback the transaction in case of an error
        $mysqli->rollback();
        echo json_encode(['message' => 'Profile update failed', 'error' => $e->getMessage()]);
    }

    // Close the prepared statements
    $vendorStmt->close();
    $businessStmt->close();
    $paymentStmt->close();
} else {
    echo json_encode(["message" => "Invalid request method"]);
}

// Close the database connection
$mysqli->close();
?>