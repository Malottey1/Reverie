<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

$data = json_decode(file_get_contents("php://input"));

$order_id = $data->order_id;
$estimated_delivery_date = $data->estimated_delivery_date;

try {
    $sql = "INSERT INTO OrderTracking (order_id, status, estimated_delivery_date) VALUES (?, 'Ready', ?)";
    $stmt = $mysqli->prepare($sql);
    $stmt->bind_param("is", $order_id, $estimated_delivery_date);
    $stmt->execute();

    echo json_encode(array("message" => "Tracking created successfully"));
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>