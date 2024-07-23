<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['user_id']) || !isset($data['first_name']) || !isset($data['last_name']) || !isset($data['email'])) {
    echo json_encode(array("message" => "Required fields are missing"));
    exit();
}

$user_id = $data['user_id'];
$first_name = $data['first_name'];
$last_name = $data['last_name'];
$email = $data['email'];

try {
    $sql = "UPDATE Users SET first_name = ?, last_name = ?, email = ? WHERE user_id = ?";
    $stmt = $mysqli->prepare($sql);
    $stmt->bind_param("sssi", $first_name, $last_name, $email, $user_id);
    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        echo json_encode(array("message" => "User information updated successfully"));
    } else {
        echo json_encode(array("message" => "No changes made"));
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>



  