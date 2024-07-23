<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

// Get the raw POST data
$data = json_decode(file_get_contents("php://input"), true);

// Check if required fields are present
if (!isset($data['user_id']) || !isset($data['total_amount']) || !isset($data['order_status'])) {
    echo json_encode(array("message" => "Invalid input"));
    exit();
}

$user_id = $data['user_id'];
$total_amount = $data['total_amount'];
$order_status = $data['order_status'];

try {
    // Insert order into Orders table
    $sql = "INSERT INTO Orders (user_id, total_amount, order_status) VALUES (?, ?, ?)";
    $stmt = $mysqli->prepare($sql);
    $stmt->bind_param("ids", $user_id, $total_amount, $order_status);
    if ($stmt->execute()) {
        $order_id = $stmt->insert_id;
        echo json_encode(array("order_id" => $order_id));
    } else {
        echo json_encode(array("message" => "Failed to create order"));
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>