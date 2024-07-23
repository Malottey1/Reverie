<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

try {
    $sql = "SELECT p.product_id, p.title, p.description, p.price, p.image_path, p.brand, c.category_name, s.size_name, con.condition_name, t.target_group_name 
            FROM Products p
            JOIN Categories c ON p.category_id = c.category_id
            JOIN Sizes s ON p.size_id = s.size_id
            JOIN Conditions con ON p.condition_id = con.condition_id
            JOIN TargetGroups t ON p.target_group_id = t.target_group_id
            WHERE p.is_active = 1";

    $result = $mysqli->query($sql);

    if (!$result) {
        throw new Exception($mysqli->error);
    }

    $products = array();

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $products[] = array(
                'product_id' => $row['product_id'],
                'title' => $row['title'],
                'description' => $row['description'],
                'price' => $row['price'],
                'image_url' => 'https://reverie.newschateau.com/api/reverie/product-images/' . $row['image_path'],
                'brand' => $row['brand'],
                'category_name' => $row['category_name'],
                'size_name' => $row['size_name'],
                'condition_name' => $row['condition_name'],
                'target_group_name' => $row['target_group_name']
            );
        }
        echo json_encode($products);
    } else {
        echo json_encode(array("message" => "No products found"));
    }

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>