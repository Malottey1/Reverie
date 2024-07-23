<?php
header('Content-Type: application/json');
include 'db_connect.php'; // Include your database connection

// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', '1');

// Fetch the JSON data from the request body
$data = json_decode(file_get_contents('php://input'), true);

// Log the received data
file_put_contents('php://stderr', print_r($data, TRUE));

if (isset($data['user_id'])) {
    $userId = $data['user_id'];

    // Begin transaction
    $mysqli->begin_transaction();

    try {
        // Delete related records in the paymentmethods table
        $sqlDeletePaymentMethods = "DELETE FROM paymentmethods WHERE vendor_id IN (SELECT vendor_id FROM vendors WHERE user_id = ?)";
        if ($stmtDeletePaymentMethods = $mysqli->prepare($sqlDeletePaymentMethods)) {
            $stmtDeletePaymentMethods->bind_param("i", $userId);
            if (!$stmtDeletePaymentMethods->execute()) {
                throw new Exception($stmtDeletePaymentMethods->error);
            }
            $stmtDeletePaymentMethods->close();
        } else {
            throw new Exception($mysqli->error);
        }

        // Delete related records in the businessinfo table
        $sqlDeleteBusinessInfo = "DELETE FROM businessinfo WHERE vendor_id IN (SELECT vendor_id FROM vendors WHERE user_id = ?)";
        if ($stmtDeleteBusinessInfo = $mysqli->prepare($sqlDeleteBusinessInfo)) {
            $stmtDeleteBusinessInfo->bind_param("i", $userId);
            if (!$stmtDeleteBusinessInfo->execute()) {
                throw new Exception($stmtDeleteBusinessInfo->error);
            }
            $stmtDeleteBusinessInfo->close();
        } else {
            throw new Exception($mysqli->error);
        }

        // Delete related records in the products table
        $sqlDeleteProducts = "DELETE FROM products WHERE vendor_id IN (SELECT vendor_id FROM vendors WHERE user_id = ?)";
        if ($stmtDeleteProducts = $mysqli->prepare($sqlDeleteProducts)) {
            $stmtDeleteProducts->bind_param("i", $userId);
            if (!$stmtDeleteProducts->execute()) {
                throw new Exception($stmtDeleteProducts->error);
            }
            $stmtDeleteProducts->close();
        } else {
            throw new Exception($mysqli->error);
        }

        // Delete related records in the vendors table
        $sqlDeleteVendors = "DELETE FROM vendors WHERE user_id = ?";
        if ($stmtDeleteVendors = $mysqli->prepare($sqlDeleteVendors)) {
            $stmtDeleteVendors->bind_param("i", $userId);
            if (!$stmtDeleteVendors->execute()) {
                throw new Exception($stmtDeleteVendors->error);
            }
            $stmtDeleteVendors->close();
        } else {
            throw new Exception($mysqli->error);
        }

        // Delete related records in the cart table
        $sqlDeleteCart = "DELETE FROM cart WHERE user_id = ?";
        if ($stmtDeleteCart = $mysqli->prepare($sqlDeleteCart)) {
            $stmtDeleteCart->bind_param("i", $userId);
            if (!$stmtDeleteCart->execute()) {
                throw new Exception($stmtDeleteCart->error);
            }
            $stmtDeleteCart->close();
        } else {
            throw new Exception($mysqli->error);
        }

        // Delete user account
        $sqlDeleteUser = "DELETE FROM Users WHERE user_id = ?";
        if ($stmtDeleteUser = $mysqli->prepare($sqlDeleteUser)) {
            $stmtDeleteUser->bind_param("i", $userId);
            if (!$stmtDeleteUser->execute()) {
                throw new Exception($stmtDeleteUser->error);
            }
            $stmtDeleteUser->close();
        } else {
            throw new Exception($mysqli->error);
        }

        // Commit transaction
        $mysqli->commit();

        echo json_encode(['message' => 'Account deleted successfully']);
    } catch (Exception $e) {
        // Rollback transaction
        $mysqli->rollback();

        // Log the error message
        file_put_contents('php://stderr', 'Transaction failed: ' . $e->getMessage() . PHP_EOL);

        echo json_encode(['message' => 'Failed to delete account: ' . $e->getMessage()]);
    }
} else {
    // Log invalid input
    file_put_contents('php://stderr', 'Invalid input: ' . print_r($data, TRUE) . PHP_EOL);
    echo json_encode(['message' => 'Invalid input']);
}

// Close the database connection
$mysqli->close();
?>