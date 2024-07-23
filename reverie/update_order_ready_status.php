<?php
header('Content-Type: application/json');
include 'db_connect.php';

// Enable error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Set a valid error log file path
ini_set('error_log', '/path/to/your/log/file.log'); // Update the path as needed

// Buffer output to prevent accidental output
ob_start();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents("php://input"), true);

    if (!isset($input['order_id']) || !isset($input['status'])) {
        error_log("Missing order_id or status");
        echo json_encode(["message" => "Missing order_id or status"]);
        ob_end_flush(); // Flush the output buffer
        exit();
    }

    $order_id = $input['order_id'];
    $status = $input['status'];

    // Update order status
    $updateQuery = "UPDATE Orders SET order_status = ? WHERE order_id = ?";
    $stmt = $mysqli->prepare($updateQuery);
    if ($stmt === false) {
        error_log("Failed to prepare statement: " . $mysqli->error);
        echo json_encode(["message" => "Failed to prepare statement"]);
        ob_end_flush(); // Flush the output buffer
        exit();
    }

    $stmt->bind_param('si', $status, $order_id);
    if ($stmt->execute()) {
        echo json_encode(["message" => "Order status updated successfully"]);
    } else {
        error_log("Failed to execute statement: " . $stmt->error);
        echo json_encode(["message" => "Failed to update order status"]);
    }
    $stmt->close();
} else {
    error_log("Invalid request method");
    echo json_encode(["message" => "Invalid request method"]);
}

$mysqli->close();
ob_end_flush(); // Flush the output buffer
?>