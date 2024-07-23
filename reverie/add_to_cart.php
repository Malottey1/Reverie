<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

try {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (!isset($_POST['user_id']) || !isset($_POST['product_id'])) {
            echo json_encode(["message" => "Missing required fields"]);
            exit();
        }

        $user_id = intval($_POST['user_id']);
        $product_id = intval($_POST['product_id']);

        // Log the received user_id and product_id
        error_log("Received user_id: $user_id, product_id: $product_id");

        // Verify if the user_id exists
        $userQuery = "SELECT user_id FROM Users WHERE user_id = ?";
        $userStmt = $mysqli->prepare($userQuery);
        if (!$userStmt) {
            throw new Exception($mysqli->error);
        }
        $userStmt->bind_param("i", $user_id);
        $userStmt->execute();
        $userStmt->store_result();

        if ($userStmt->num_rows === 0) {
            echo json_encode(["message" => "Invalid user ID"]);
            exit();
        }
        $userStmt->close();

        // Verify if the product_id exists
        $productQuery = "SELECT product_id FROM Products WHERE product_id = ?";
        $productStmt = $mysqli->prepare($productQuery);
        if (!$productStmt) {
            throw new Exception($mysqli->error);
        }
        $productStmt->bind_param("i", $product_id);
        $productStmt->execute();
        $productStmt->store_result();

        if ($productStmt->num_rows === 0) {
            echo json_encode(["message" => "Invalid product ID"]);
            exit();
        }
        $productStmt->close();

        // Check if the product is already in the cart for this user
        $checkQuery = "SELECT * FROM Cart WHERE user_id = ? AND product_id = ?";
        $checkStmt = $mysqli->prepare($checkQuery);
        if (!$checkStmt) {
            throw new Exception($mysqli->error);
        }
        $checkStmt->bind_param("ii", $user_id, $product_id);
        $checkStmt->execute();
        $checkResult = $checkStmt->get_result();

        if ($checkResult->num_rows > 0) {
            echo json_encode(["message" => "Product already in cart"]);
            exit();
        }

        // Add the product to the cart
        $insertQuery = "INSERT INTO Cart (user_id, product_id) VALUES (?, ?)";
        $insertStmt = $mysqli->prepare($insertQuery);
        if (!$insertStmt) {
            throw new Exception($mysqli->error);
        }
        $insertStmt->bind_param("ii", $user_id, $product_id);
        $insertStmt->execute();

        if ($insertStmt->affected_rows > 0) {
            echo json_encode(["message" => "Product added to cart successfully"]);
        } else {
            echo json_encode(["message" => "Failed to add product to cart"]);
        }

        $insertStmt->close();
    } else {
        echo json_encode(["message" => "Invalid request method"]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>