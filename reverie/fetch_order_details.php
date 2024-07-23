<?php
header('Content-Type: application/json');
include 'db_connect.php'; // Include your database connection script

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents("php://input"), true);
    if (!isset($input['order_id'])) {
        echo json_encode(["message" => "Missing order_id"]);
        exit();
    }
    $order_id = $input['order_id'];

    // Fetch order details
    $orderQuery = "SELECT o.order_id, o.user_id, o.total_amount, o.order_status, o.created_at, u.first_name, u.last_name, u.email 
                   FROM Orders o
                   JOIN Users u ON o.user_id = u.user_id
                   WHERE o.order_id = ?";
    $stmt = $mysqli->prepare($orderQuery);
    $stmt->bind_param('i', $order_id);
    $stmt->execute();
    $orderResult = $stmt->get_result();

    if ($orderResult->num_rows > 0) {
        $orderDetails = $orderResult->fetch_assoc();

        // Fetch order items
        $itemsQuery = "SELECT p.title as name, p.description, p.price, CONCAT('https://reverie.newschateau.com/api/reverie/product-images/', p.image_path) as imageUrl 
                       FROM OrderDetails od
                       JOIN Products p ON od.product_id = p.product_id
                       WHERE od.order_id = ?";
        $stmt = $mysqli->prepare($itemsQuery);
        $stmt->bind_param('i', $order_id);
        $stmt->execute();
        $itemsResult = $stmt->get_result();

        $items = [];
        while ($item = $itemsResult->fetch_assoc()) {
            $items[] = $item;
        }

        $orderDetails['items'] = $items;

        // Fetch delivery address
        $addressQuery = "SELECT address, city, state, country FROM ShippingAddresses WHERE user_id = ?";
        $stmt = $mysqli->prepare($addressQuery);
        $stmt->bind_param('i', $orderDetails['user_id']);
        $stmt->execute();
        $addressResult = $stmt->get_result();

        if ($addressResult->num_rows > 0) {
            $address = $addressResult->fetch_assoc();
            $orderDetails['deliveryAddress'] = $address['address'] . ', ' . $address['city'] . ', ' . $address['state'] . ', ' . $address['country'];
        } else {
            $orderDetails['deliveryAddress'] = 'Address not found';
        }

        // Calculate additional details
        $orderDetails['transactionDate'] = $orderDetails['created_at'];
        $orderDetails['subtotal'] = $orderDetails['total_amount'] - 5; // Assuming delivery and taxes sum up to 5
        $orderDetails['delivery'] = 3; // Assuming fixed delivery fee
        $orderDetails['taxes'] = 2; // Assuming fixed tax amount
        $orderDetails['commission'] = 1; // Assuming fixed commission amount
        $orderDetails['total'] = $orderDetails['total_amount'];

        echo json_encode($orderDetails);
    } else {
        echo json_encode(["message" => "Order not found"]);
    }
} else {
    echo json_encode(["message" => "Invalid request method"]);
}

$mysqli->close();
?>