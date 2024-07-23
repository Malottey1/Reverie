<?php
require 'db_connect.php'; // Database connection

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents("php://input"), true);
    $vendor_id = $input['vendor_id'];

    // Log the vendor ID for debugging
    error_log('Vendor ID received: ' . $vendor_id);

    if (!$vendor_id) {
        echo json_encode(['error' => 'vendor_id not provided']);
        error_log('vendor_id not provided');
        exit();
    }

    $query = "SELECT o.order_id, o.user_id, o.total_amount, o.order_status, o.created_at, ot.status AS tracking_status, p.title
              FROM Orders o
              JOIN OrderTracking ot ON o.order_id = ot.order_id
              JOIN OrderDetails od ON o.order_id = od.order_id
              JOIN Products p ON od.product_id = p.product_id
              WHERE p.vendor_id = ? AND ot.status = 'Delivered'";

    $stmt = $mysqli->prepare($query);
    if (!$stmt) {
        error_log('Prepare failed: ' . $mysqli->error);
        echo json_encode(['error' => 'Prepare failed']);
        exit();
    }

    $stmt->bind_param("i", $vendor_id);
    if (!$stmt->execute()) {
        error_log('Execute failed: ' . $stmt->error);
        echo json_encode(['error' => 'Execute failed']);
        exit();
    }

    $result = $stmt->get_result();
    if (!$result) {
        error_log('Get result failed: ' . $stmt->error);
        echo json_encode(['error' => 'Get result failed']);
        exit();
    }

    $response = [];
    while ($row = $result->fetch_assoc()) {
        $response[] = $row;
    }

    $stmt->close();
    $mysqli->close();

    echo json_encode($response); // Ensure we return an array
    error_log('Fetched Delivered Orders: ' . json_encode($response)); // Log the response
} else {
    echo json_encode(['error' => 'Invalid request method']);
    error_log('Invalid request method');
}
?>