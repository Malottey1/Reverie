<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

if (!isset($_GET['user_id'])) {
    echo json_encode(array("message" => "User ID is required"));
    exit();
}

$user_id = $_GET['user_id'];

try {
    $sql = "SELECT c.cart_id, c.product_id, p.title, p.image_path, p.price, s.size_name 
            FROM Cart c
            JOIN Products p ON c.product_id = p.product_id
            JOIN Sizes s ON p.size_id = s.size_id
            WHERE c.user_id = ?";

    $stmt = $mysqli->prepare($sql);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $cart_items = array();

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $cart_items[] = array(
                'cart_id' => $row['cart_id'],
                'product_id' => $row['product_id'],
                'title' => $row['title'],
                'image_url' => 'https://reverie.newschateau.com/api/reverie/product-images/' . $row['image_path'],
                'price' => $row['price'],
                'size_name' => $row['size_name']
            );
        }
    }

    echo json_encode($cart_items);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>