<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['user_id']) || !isset($data['first_name']) || !isset($data['last_name']) || !isset($data['address']) || !isset($data['address_line2']) || !isset($data['city']) || !isset($data['postal_code']) || !isset($data['state']) || !isset($data['country'])) {
    echo json_encode(array("message" => "Required fields are missing"));
    exit();
}

$user_id = $data['user_id'];
$first_name = $data['first_name'];
$last_name = $data['last_name'];
$address = $data['address'];
$address_line2 = $data['address_line2'];
$city = $data['city'];
$postal_code = $data['postal_code'];
$state = $data['state'];
$country = $data['country'];

error_log("Received User ID: $user_id");
error_log("Received Data: " . print_r($data, true));

if ($mysqli->connect_error) {
    error_log("Database connection failed: " . $mysqli->connect_error);
    echo json_encode(array("message" => "Database connection failed"));
    exit();
}

try {
    $current_sql = "SELECT * FROM ShippingAddresses WHERE user_id = ?";
    $current_stmt = $mysqli->prepare($current_sql);
    $current_stmt->bind_param("i", $user_id);
    $current_stmt->execute();
    $current_result = $current_stmt->get_result();
    $current_data = $current_result->fetch_assoc();
    
    if (!$current_data) {
        error_log("No existing data for user_id: $user_id. Inserting new data.");
        $insert_sql = "INSERT INTO ShippingAddresses (user_id, first_name, last_name, address, address_line2, city, postal_code, state, country) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        $insert_stmt = $mysqli->prepare($insert_sql);
        $insert_stmt->bind_param("issssssss", $user_id, $first_name, $last_name, $address, $address_line2, $city, $postal_code, $state, $country);
        $insert_stmt->execute();

        if ($insert_stmt->affected_rows > 0) {
            error_log("Shipping address added successfully for user_id: $user_id");
            echo json_encode(array("message" => "Shipping address added successfully"));
        } else {
            error_log("Failed to add shipping address for user_id: $user_id");
            echo json_encode(array("message" => "Failed to add shipping address"));
        }
    } else {
        error_log("Existing data found for user_id: $user_id. Updating data.");
        $sql = "UPDATE ShippingAddresses SET first_name = ?, last_name = ?, address = ?, address_line2 = ?, city = ?, postal_code = ?, state = ?, country = ? WHERE user_id = ?";
        $stmt = $mysqli->prepare($sql);
        $stmt->bind_param("ssssssssi", $first_name, $last_name, $address, $address_line2, $city, $postal_code, $state, $country, $user_id);
        $stmt->execute();

        if ($stmt->affected_rows > 0) {
            error_log("Shipping address updated successfully for user_id: $user_id");
            echo json_encode(array("message" => "Shipping address updated successfully"));
        } else {
            error_log("No changes made to the shipping address for user_id: $user_id");
            echo json_encode(array("message" => "No changes made"));
        }
    }
} catch (Exception $e) {
    error_log("Internal server error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>