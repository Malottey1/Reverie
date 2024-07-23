<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $cart_id = isset($_POST['cart_id']) ? intval($_POST['cart_id']) : 0;

    if ($cart_id > 0) {
        $sql = "DELETE FROM Cart WHERE cart_id = ?";
        
        if ($stmt = $mysqli->prepare($sql)) {
            $stmt->bind_param("i", $cart_id);
            
            if ($stmt->execute()) {
                echo json_encode(array("message" => "Cart item removed successfully"));
            } else {
                http_response_code(500);
                echo json_encode(array("message" => "Internal server error", "error" => $stmt->error));
            }
            
            $stmt->close();
        } else {
            http_response_code(500);
            echo json_encode(array("message" => "Internal server error", "error" => $mysqli->error));
        }
    } else {
        http_response_code(400);
        echo json_encode(array("message" => "Invalid cart ID"));
    }

    $mysqli->close();
} else {
    http_response_code(405);
    echo json_encode(array("message" => "Method not allowed"));
}
?>