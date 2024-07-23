<?php
header('Content-Type: application/json');
include 'db_connect.php'; // Include your database connection script

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents("php://input"), true);
    if (!isset($input['vendor_id'])) {
        echo json_encode(["message" => "Missing vendor_id"]);
        exit();
    }
    $vendor_id = intval($input['vendor_id']); // Ensure vendor_id is an integer

    // Fetch orders associated with the vendor
    $query = "SELECT o.order_id, o.user_id, o.total_amount, o.order_status, o.created_at,
              GROUP_CONCAT(p.title) as items
              FROM Orders o
              JOIN OrderDetails od ON o.order_id = od.order_id
                               JOIN Products p ON od.product_id = p.product_id
                 WHERE p.vendor_id = ?
                 GROUP BY o.order_id";
       $stmt = $mysqli->prepare($query);
       $stmt->bind_param('i', $vendor_id);
       $stmt->execute();
       $result = $stmt->get_result();

       $orders = [];
       while ($row = $result->fetch_assoc()) {
           $orders[] = [
               'order_id' => intval($row['order_id']), // Ensure order_id is an integer
               'user_id' => intval($row['user_id']), // Ensure user_id is an integer
               'total_amount' => floatval($row['total_amount']), // Ensure total_amount is a float
               'order_status' => $row['order_status'],
               'created_at' => $row['created_at'],
               'items' => explode(',', $row['items']) // Convert items to array of strings
           ];
       }

       if ($orders) {
           echo json_encode($orders);
       } else {
           echo json_encode(["message" => "No orders found"]);
       }
   } else {
       echo json_encode(["message" => "Invalid request method"]);
   }

   $mysqli->close();
   ?>