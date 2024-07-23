<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['product_id'], $data['title'], $data['price'])) {
    echo json_encode(array("message" => "Required parameters are missing"));
    exit();
}

$product_id = $data['product_id'];
$title = $data['title'];
$price = $data['price'];
$is_active = isset($data['is_active']) ? $data['is_active'] : 1;

try {
    $sql = "UPDATE Products SET title = ?, price = ?, is_active = ? WHERE product_id = ?";
    $stmt = $mysqli->prepare($sql);
    if ($stmt === false) {
        throw new Exception($mysqli->error);
    }

    $stmt->bind_param('sdii', $title, $price, $is_active, $product_id);
    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        echo json_encode(array("message" => "Product updated successfully"));
    } else {
        echo json_encode(array("message" => "No changes made or invalid product ID"));
    }
} catch (Exception $e) {
    error_log("Error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>