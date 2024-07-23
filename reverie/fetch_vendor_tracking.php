<?php
header('Content-Type: application/json');
include 'db_connect.php';

// Enable error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Set a valid error log file path
ini_set('error_log', '/path/to/your/log/file.log'); // Update the path as needed

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents("php://input"), true);

    if (!isset($input['order_id'])) {
        error_log("Missing order_id");
        echo json_encode(["message" => "Missing order_id"]);
        exit();
    }

    $order_id = $input['order_id'];

    // Fetch order details along with tracking status
    $orderQuery = "
        SELECT o.order_id, o.user_id, o.total_amount, o.order_status, o.created_at, 
               u.first_name, u.last_name, u.email, 
               ot.status, ot.estimated_delivery_date
        FROM Orders o
        JOIN Users u ON o.user_id = u.user_id
        JOIN OrderTracking ot ON o.order_id = ot.order_id
        WHERE o.order_id = ?";
        
    $stmt = $mysqli->prepare($orderQuery);
    if ($stmt === false) {
        error_log("Failed to prepare statement: " . $mysqli->error);
        echo json_encode(["message" => "Failed to prepare statement"]);
        exit();
    }

    $stmt->bind_param('i', $order_id);
    if ($stmt->execute()) {
        $result = $stmt->get_result();
        if ($result->num_rows > 0) {
            $orderDetails = $result->fetch_assoc();

            // Fetch item details
            $itemQuery = "
                SELECT p.title AS name, p.description, p.price, CONCAT('https://reverie.newschateau.com/api/reverie/product-images/', p.image_path) AS imageUrl
                FROM OrderDetails od
                JOIN Products p ON od.product_id = p.product_id
                WHERE od.order_id = ?";
            
            $itemStmt = $mysqli->prepare($itemQuery);
            if ($itemStmt === false) {
                error_log("Failed to prepare item statement: " . $mysqli->error);
                echo json_encode(["message" => "Failed to prepare item statement"]);
                exit();
            }

            $itemStmt->bind_param('i', $order_id);
            if ($itemStmt->execute()) {
                $itemResult = $itemStmt->get_result();
                $items = [];
                while ($itemRow = $itemResult->fetch_assoc()) {
                    $items[] = $itemRow;
                }
                $orderDetails['items'] = $items;
            } else {
                error_log("Failed to execute item statement: " . $itemStmt->error);
                echo json_encode(["message" => "Failed to fetch items"]);
                exit();
            }
            $itemStmt->close();

            echo json_encode($orderDetails);
        } else {
            echo json_encode(["message" => "Order not found"]);
        }
    } else {
        error_log("Failed to execute statement: " . $stmt->error);
        echo json_encode(["message" => "Failed to fetch order details"]);
    }
    $stmt->close();
} else {
    error_log("Invalid request method");
    echo json_encode(["message" => "Invalid request method"]);
}

$mysqli->close();
?>