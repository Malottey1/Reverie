<?php
header('Content-Type: application/json');

include 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);

    if (!isset($input['vendor_id'])) {
        echo json_encode(['success' => false, 'message' => 'Vendor ID is required']);
        exit();
    }

    $vendor_id = $input['vendor_id'];

    // Start a transaction
    $mysqli->begin_transaction();

    try {
        // Delete from PaymentMethods table
        $paymentQuery = "DELETE FROM PaymentMethods WHERE vendor_id = ?";
        $paymentStmt = $mysqli->prepare($paymentQuery);
        $paymentStmt->bind_param("i", $vendor_id);
        $paymentStmt->execute();
        $paymentStmt->close();

        // Delete from BusinessInfo table
        $businessQuery = "DELETE FROM BusinessInfo WHERE vendor_id = ?";
        $businessStmt = $mysqli->prepare($businessQuery);
        $businessStmt->bind_param("i", $vendor_id);
        $businessStmt->execute();
        $businessStmt->close();

        // Delete from Vendors table
        $vendorQuery = "DELETE FROM Vendors WHERE vendor_id = ?"; // Updated column name
        $vendorStmt = $mysqli->prepare($vendorQuery);
        $vendorStmt->bind_param("i", $vendor_id);
        $vendorStmt->execute();
        $vendorStmt->close();

        // Commit the transaction
        $mysqli->commit();

        echo json_encode(['success' => true, 'message' => 'Vendor deleted successfully']);
    } catch (Exception $e) {
        // Rollback the transaction in case of an error
        $mysqli->rollback();
        echo json_encode(['success' => false, 'message' => 'Failed to delete vendor: ' . $e->getMessage()]);
    }

    $mysqli->close();
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
}
?>