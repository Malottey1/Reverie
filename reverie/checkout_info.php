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
    $sql = "SELECT 
                u.first_name,
                u.last_name,
                u.email,
                sa.first_name AS shipping_first_name,
                sa.last_name AS shipping_last_name,
                sa.address AS shipping_address,
                sa.city AS shipping_city,
                sa.state AS shipping_state,
                sa.country AS shipping_country,
                sa.postal_code AS shipping_postal_code,
                ba.name AS billing_name,
                ba.address AS billing_address,
                ba.city AS billing_city,
                ba.state AS billing_state,
                ba.country AS billing_country,
                ba.postal_code AS billing_postal_code
            FROM Users u
            LEFT JOIN ShippingAddresses sa ON u.user_id = sa.user_id
            LEFT JOIN BillingAddresses ba ON u.user_id = ba.user_id
            WHERE u.user_id = ?";

    $stmt = $mysqli->prepare($sql);
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $checkout_info = $result->fetch_assoc();
        
        // Fetch order details
        $sql_order_details = "SELECT 
                                od.product_id, 
                                p.title, 
                                p.image_path, 
                                od.price
                              FROM OrderDetails od
                              JOIN Products p ON od.product_id = p.product_id
                              WHERE od.order_id = (
                                  SELECT order_id FROM Orders WHERE user_id = ? ORDER BY created_at DESC LIMIT 1
                              )";
        $stmt_order_details = $mysqli->prepare($sql_order_details);
        $stmt_order_details->bind_param("i", $user_id);
        $stmt_order_details->execute();
        $result_order_details = $stmt_order_details->get_result();

        $order_details = [];
        while ($row = $result_order_details->fetch_assoc()) {
            $order_details[] = $row;
        }

        $checkout_info['order_details'] = $order_details;

        echo json_encode($checkout_info);
    } else {
        echo json_encode(array("message" => "No checkout information found for the user"));
    }

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(array("message" => "Internal server error", "error" => $e->getMessage()));
}

$mysqli->close();
?>