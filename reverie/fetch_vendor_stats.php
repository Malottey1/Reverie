<?php
header('Content-Type: application/json');
include 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents("php://input"), true);
    if (!isset($input['vendor_id'])) {
        echo json_encode(["message" => "Missing vendor_id"]);
        exit();
    }
    $vendor_id = $input['vendor_id'];

    $stats = [
        'earnings' => 0,
        'total_orders' => 0,
        'active_listings' => 0,
        'new_orders' => 0,
    ];

    // Earnings this month
    $result = $mysqli->query("SELECT SUM(od.price) as earnings 
                              FROM Orders o 
                              JOIN OrderDetails od ON o.order_id = od.order_id
                              JOIN Products p ON od.product_id = p.product_id
                              WHERE p.vendor_id = $vendor_id 
                              AND MONTH(o.created_at) = MONTH(CURRENT_DATE()) 
                              AND YEAR(o.created_at) = YEAR(CURRENT_DATE())");
    if ($result) {
        $stats['earnings'] = $result->fetch_assoc()['earnings'] ?? 0;
    } else {
        error_log("Earnings query failed: " . $mysqli->error);
    }

    // Total Orders
    $result = $mysqli->query("SELECT COUNT(DISTINCT o.order_id) as total_orders 
                              FROM Orders o 
                              JOIN OrderDetails od ON o.order_id = od.order_id
                              JOIN Products p ON od.product_id = p.product_id
                              WHERE p.vendor_id = $vendor_id");
    if ($result) {
        $stats['total_orders'] = $result->fetch_assoc()['total_orders'] ?? 0;
    } else {
        error_log("Total orders query failed: " . $mysqli->error);
    }

    // Active Listings
    $result = $mysqli->query("SELECT COUNT(*) as active_listings 
                              FROM Products 
                              WHERE vendor_id = $vendor_id AND is_active = 1");
    if ($result) {
        $stats['active_listings'] = $result->fetch_assoc()['active_listings'] ?? 0;
    } else {
        error_log("Active listings query failed: " . $mysqli->error);
    }

    // New Orders this month
    $result = $mysqli->query("SELECT COUNT(DISTINCT o.order_id) as new_orders 
                              FROM Orders o 
                              JOIN OrderDetails od ON o.order_id = od.order_id
                              JOIN Products p ON od.product_id = p.product_id
                              WHERE p.vendor_id = $vendor_id 
                              AND MONTH(o.created_at) = MONTH(CURRENT_DATE()) 
                              AND YEAR(o.created_at) = YEAR(CURRENT_DATE())");
    if ($result) {
        $stats['new_orders'] = $result->fetch_assoc()['new_orders'] ?? 0;
    } else {
        error_log("New orders query failed: " . $mysqli->error);
    }

    echo json_encode($stats);
} else {
    echo json_encode(["message" => "Invalid request method"]);
}

$mysqli->close();
?>