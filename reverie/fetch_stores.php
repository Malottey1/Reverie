<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

try {
    $sql = "SELECT v.vendor_id, v.profile_photo, v.business_description, b.business_name 
            FROM Vendors v 
            JOIN BusinessInfo b ON v.vendor_id = b.vendor_id";
    $result = $mysqli->query($sql);

    $stores = [];
    while ($row = $result->fetch_assoc()) {
        $stores[] = $row;
    }

    echo json_encode($stores);
} catch (Exception $e) {
    error_log("Error: " . $e->getMessage());
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>