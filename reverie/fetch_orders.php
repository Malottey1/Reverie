<?php
header('Content-Type: application/json');

// Enable error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Include the database connection file
include 'db_connect.php';

// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Retrieve user ID from POST request
    $input = json_decode(file_get_contents("php://input"), true);
    if (!isset($input['user_id'])) {
        echo json_encode(["message" => "Missing user_id"]);
        exit();
    }
    $user_id = $input['user_id'];

    // SQL query to fetch orders and related product details
    $query = "
        SELECT 
            Orders.order_id, Orders.order_status, Orders.created_at AS order_date,
            Products.title, Products.image_path, Products.price
        FROM Orders
        JOIN OrderDetails ON Orders.order_id = OrderDetails.order_id
        JOIN Products ON OrderDetails.product_id = Products.product_id
        WHERE Orders.user_id = ?
    ";
    
    // Prepare and execute the SQL statement
    if ($stmt = $mysqli->prepare($query)) {
        $stmt->bind_param('i', $user_id);
        $stmt->execute();
        $result = $stmt->get_result();

        // Initialize an array to store the fetched orders
        $orders = [];
        while ($row = $result->fetch_assoc()) {
            $order_id = $row['order_id'];
            if (!isset($orders[$order_id])) {
                $orders[$order_id] = [
                    'id' => $order_id,
                    'status' => $row['order_status'],
                    'date' => $row['order_date'],
                    'products' => []
                ];
            }
            $orders[$order_id]['products'][] = [
                'title' => $row['title'],
                'image' => 'https://reverie.newschateau.com/api/reverie/product-images/' . basename($row['image_path']),
                'price' => $row['price']
            ];
        }

        // Convert the orders array to a JSON response
        echo json_encode(array_values($orders));
    } else {
        // Log the error
        error_log("Failed to prepare statement: " . $mysqli->error);
        echo json_encode(["message" => "Database error", "error" => $mysqli->error]);
    }
} else {
    echo json_encode(["message" => "Invalid request method"]);
}

// Close the database connection
$mysqli->close();
?>