<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['user_id']) || !isset($data['name']) || !isset($data['address']) || !isset($data['city']) || !isset($data['postal_code']) || !isset($data['state']) || !isset($data['country'])) {
    echo json_encode(array("message" => "Required fields are missing"));
    exit();
}

$user_id = $data['user_id'];
$name = $data['name'];
$address = $data['address'];
$city = $data['city'];
$postal_code = $data['postal_code'];
$state = $data['state'];
$country = $data['country'];

error_log("Received User ID: $user_id"); // Debugging line
error_log("Received Data: " . print_r($data, true)); // Debugging line

// Fetch the current data for comparison
$current_sql = "SELECT * FROM BillingAddresses WHERE user_id = ?";
$current_stmt = $mysqli->prepare($current_sql);
$current_stmt->bind_param("i", $user_id);
$current_stmt->execute();
$current_result = $current_stmt->get_result();
$current_data = $current_result->fetch_assoc();

try {
    if (!$current_data) {
        // If no existing data, perform an insert
        $insert_sql = "INSERT INTO BillingAddresses (user_id, name, address, city, postal_code, state, country) VALUES (?, ?, ?, ?, ?, ?, ?)";
        $insert_stmt = $mysqli->prepare($insert_sql);
        $insert_stmt->bind_param("issssss", $user_id, $name, $address, $city, $postal_code, $state, $country);
        $insert_stmt->execute();

        if ($insert_stmt->affected_rows > 0) {
            echo json_encode(array("message" => "Billing address added successfully"));
        } else {
            echo json_encode(array("message" => "Failed to add billing address"));
        }
    } else {
        // If existing data, perform an update
        $sql = "UPDATE BillingAddresses SET name = ?, address = ?, city = ?, postal_code = ?, state = ?, country = ? WHERE user_id = ?";
        $stmt = $mysqli->prepare($sql);
        $stmt->bind_param("ssssssi", $name, $address, $city, $postal_code, $state, $country, $user_id);
        $stmt->execute();

        if ($stmt->affected_rows > 0) {
            echo json_encode(array("message" => "Billing address updated successfully"));
        } else {
            echo json_encode(array("message" => "No changes made"));
        }
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>