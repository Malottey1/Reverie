<?php
header('Content-Type: application/json');

include 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!isset($_POST['user_id'])) {
        echo json_encode(["message" => "Missing required fields"]);
        exit();
    }

    $user_id = $_POST['user_id'];

    $query = "SELECT vendor_id FROM Vendors WHERE user_id = ?";
    $stmt = $mysqli->prepare($query);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $stmt->bind_result($vendor_id);
    $stmt->fetch();

    if ($vendor_id) {
        echo json_encode(["is_vendor" => true, "vendor_id" => $vendor_id]);
    } else {
        echo json_encode(["is_vendor" => false]);
    }

    $stmt->close();
} else {
    echo json_encode(["message" => "Invalid request method"]);
}

$mysqli->close();
?>