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
    $sql = "SELECT v.vendor_id, v.profile_photo, v.business_description, b.business_name 
            FROM Vendors v 
            JOIN BusinessInfo b ON v.vendor_id = b.vendor_id 
            WHERE v.vendor_id = ?";
    $stmt = $mysqli->prepare($sql);
    if ($stmt === false) {
        throw new Exception($mysqli->error);
    }

    $stmt->bind_param('i', $vendor_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($row = $result->fetch_assoc()) {
        echo json_encode($row);
    } else {
        echo json_encode(array("message" => "Vendor not found"));
    }
} catch (Exception $e) {
    error_log("Error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>