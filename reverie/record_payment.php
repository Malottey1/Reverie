<?php
include 'db_connect.php';

header('Content-Type: application/json');

$data = json_decode(file_get_contents('php://input'), true);

$orderId = $data['order_id'];
$amount = $data['amount'];

$sql = "INSERT INTO Payments (order_id, amount) VALUES (?, ?)";
$stmt = $mysqli->prepare($sql);
$stmt->bind_param('id', $orderId, $amount);

if ($stmt->execute()) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['error' => $mysqli->error]);
}

$stmt->close();
$mysqli->close();
?>