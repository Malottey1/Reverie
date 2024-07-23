<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

$data = json_decode(file_get_contents("php://input"));

$order_id = $data->order_id;
$product_id = $data->product_id;
$price = $data->price;

try {
    $sql = "INSERT INTO OrderDetails (order_id, product_id, price) VALUES (?, ?, ?)";
    $stmt = $mysqli->prepare($sql);
    $stmt->bind_param("iid", $order_id, $product_id, $price);
    $stmt->execute();

    echo json_encode(array("message" => "Order detail created successfully"));
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>