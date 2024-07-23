<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Database connection
include 'db_connect.php';

// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

header('Content-Type: application/json');

// Function to log errors
function logError($message) {
    file_put_contents('error_log.txt', date('Y-m-d H:i:s') . " - " . $message . "\n", FILE_APPEND);
}

try {
    // Retrieve the order_id and status from the request body
    $input = json_decode(file_get_contents('php://input'), true);
    if (!isset($input['order_id']) || !isset($input['status'])) {
        throw new Exception('Order ID or status not provided');
    }
    $orderId = $input['order_id'];
    $status = $input['status'];

    // Log received input
    logError("Received input - Order ID: $orderId, Status: $status");

    // Update tracking status in the OrderTracking table
    $stmt = $mysqli->prepare('UPDATE OrderTracking SET status = ? WHERE order_id = ?');
    if (!$stmt) {
        throw new Exception("Prepare statement failed: " . $mysqli->error);
    }
    $stmt->bind_param('si', $status, $orderId);
    $stmt->execute();

    if ($stmt->affected_rows === 0) {
        throw new Exception('No tracking details found for the given Order ID');
    }

    // Log successful update
    logError("Order status updated successfully for Order ID: $orderId");

    // Return success response
    echo json_encode(['message' => 'Order status updated successfully']);

} catch (Exception $e) {
    // Log the error message
    logError($e->getMessage());
    http_response_code(500);
    echo json_encode(['message' => 'Internal Server Error', 'error' => $e->getMessage()]);
}

$mysqli->close();
?>