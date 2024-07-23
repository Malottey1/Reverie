<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include 'db_connect.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['product_id'])) {
    echo json_encode(array("message" => "Missing parameters for deleting product"));
    exit();
}

$product_id = $data['product_id'];

try {
    $stmt = $mysqli->prepare("DELETE FROM Products WHERE product_id = ?");
    $stmt->bind_param("i", $product_id);

    if ($stmt->execute()) {
        echo json_encode(array("message" => "Product deleted successfully"));
    } else {
        echo json_encode(array("message" => "Failed to delete product"));
    }
    $stmt->close();
} catch (Exception $e) {
    error_log("Error: " . $e->getMessage());
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>