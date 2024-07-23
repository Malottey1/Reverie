<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['vendor_id'])) {
    echo json_encode(array("message" => "Vendor ID parameter is missing"));
    exit();
}

$vendor_id = $data['vendor_id'];

try {
    $sql = "SELECT * FROM Products WHERE vendor_id = ?";
    $stmt = $mysqli->prepare($sql);
    if ($stmt === false) {
        throw new Exception($mysqli->error);
    }

    $stmt->bind_param('i', $vendor_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $products = [];
    while ($row = $result->fetch_assoc()) {
        $products[] = $row;
    }

    echo json_encode($products);
} catch (Exception $e) {
    error_log("Error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>