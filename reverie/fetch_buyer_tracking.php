<?php
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
    // Retrieve the order_id from the request body
    $input = json_decode(file_get_contents('php://input'), true);
    if (!isset($input['order_id'])) {
        throw new Exception('Order ID not provided');
    }
    $orderId = $input['order_id'];

    // Fetch tracking details from the OrderTracking table
    $stmt = $mysqli->prepare('SELECT * FROM OrderTracking WHERE order_id = ?');
    if (!$stmt) {
        throw new Exception("Prepare statement failed: " . $mysqli->error);
    }
    $stmt->bind_param('i', $orderId);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows === 0) {
        throw new Exception('No tracking details found for the given Order ID');
    }

    $trackingDetails = $result->fetch_assoc();

    // Fetch order items from the OrderDetails table
    $stmt = $mysqli->prepare('SELECT od.product_id, p.title AS name, CONCAT("https://reverie.newschateau.com/api/reverie/product-images/", p.image_path) AS imageUrl, od.price 
                              FROM OrderDetails od 
                              JOIN Products p ON od.product_id = p.product_id 
                              WHERE od.order_id = ?');
    if (!$stmt) {
        throw new Exception("Prepare statement failed: " . $mysqli->error);
    }
    $stmt->bind_param('i', $orderId);
    $stmt->execute();
    $result = $stmt->get_result();

    $items = [];
    while ($row = $result->fetch_assoc()) {
        $items[] = $row;
    }

    $trackingDetails['items'] = $items;

    // Return tracking details as JSON
    echo json_encode($trackingDetails);

} catch (Exception $e) {
    // Log the error message
    logError($e->getMessage());
    http_response_code(500);
    echo json_encode(['message' => 'Internal Server Error', 'error' => $e->getMessage()]);
}
?>