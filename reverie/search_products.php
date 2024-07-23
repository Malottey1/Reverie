<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'db_connect.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['query'])) {
    echo json_encode(array("message" => "Query parameter is missing"));
    exit();
}

$query = $data['query'];

error_log("Search query: $query"); // Debugging line

try {
    $queryWords = explode(' ', $query);
    $conditions = [];
    $params = [];
    foreach ($queryWords as $word) {
        $conditions[] = "(LOWER(p.title) LIKE LOWER(?) OR LOWER(p.description) LIKE LOWER(?) OR LOWER(c.category_name) LIKE LOWER(?) OR LOWER(t.target_group_name) LIKE LOWER(?) OR LOWER(p.brand) LIKE LOWER(?))";
        $params[] = "%" . $word . "%";
        $params[] = "%" . $word . "%";
        $params[] = "%" . $word . "%";
        $params[] = "%" . $word . "%";
        $params[] = "%" . $word . "%";
    }

    $sql = "SELECT p.*, c.category_name, t.target_group_name 
            FROM Products p 
            LEFT JOIN Categories c ON p.category_id = c.category_id 
            LEFT JOIN TargetGroups t ON p.target_group_id = t.target_group_id 
            WHERE " . implode(" OR ", $conditions);

    $stmt = $mysqli->prepare($sql);
    if ($stmt === false) {
        throw new Exception($mysqli->error);
    }

    $paramTypes = str_repeat('s', count($params));
    $stmt->bind_param($paramTypes, ...$params);
    $stmt->execute();
    $result = $stmt->get_result();

    $products = [];
    while ($row = $result->fetch_assoc()) {
        $products[] = $row;
    }

    echo json_encode($products);
} catch (Exception $e) {
    error_log("Error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>