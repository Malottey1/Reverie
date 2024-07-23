<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

try {
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (!isset($_POST['product_id'])) {
            echo json_encode(["message" => "Missing required fields"]);
            exit();
        }

        $product_id = intval($_POST['product_id']);

        // Log the received product_id
        error_log("Received product_id: $product_id");

        // Fetch the category_id of the provided product_id
        $categoryQuery = "SELECT category_id FROM Products WHERE product_id = ?";
        $categoryStmt = $mysqli->prepare($categoryQuery);
        if (!$categoryStmt) {
            throw new Exception($mysqli->error);
        }
        $categoryStmt->bind_param("i", $product_id);
        $categoryStmt->execute();
        $categoryStmt->bind_result($category_id);
        $categoryStmt->fetch();
        $categoryStmt->close();

        if (!$category_id) {
            echo json_encode(["message" => "Invalid product ID"]);
            exit();
        }

        // Fetch recommended products from the same category
        $recommendQuery = "SELECT product_id, title, description, price, image_path FROM Products WHERE category_id = ? AND product_id != ? AND is_active = 1 LIMIT 2";
        $recommendStmt = $mysqli->prepare($recommendQuery);
        if (!$recommendStmt) {
            throw new Exception($mysqli->error);
        }
        $recommendStmt->bind_param("ii", $category_id, $product_id);
        $recommendStmt->execute();
        $result = $recommendStmt->get_result();

        $recommendedProducts = [];
        while ($row = $result->fetch_assoc()) {
            $recommendedProducts[] = array(
                'product_id' => intval($row['product_id']), // Ensure this is an integer
                'title' => $row['title'],
                'description' => $row['description'],
                'price' => floatval($row['price']), // Ensure this is a float
                'image_url' => 'https://reverie.newschateau.com/api/reverie/product-images/' . $row['image_path']
            );
        }

        echo json_encode($recommendedProducts);

        $recommendStmt->close();
    } else {
        echo json_encode(["message" => "Invalid request method"]);
    }
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>