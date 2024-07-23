<?php
require 'db_connect.php';

$order_id = $_GET['order_id'];

$query = "SELECT * FROM OrderTracking WHERE order_id = ?";
$stmt = $mysqli->prepare($query);
$stmt->bind_param("i", $order_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $order_status = $result->fetch_assoc();
    echo json_encode(["success" => true, "data" => $order_status]);
} else {
    echo json_encode(["success" => false, "message" => "Order not found"]);
}

$stmt->close();
$mysqli->close();
?>