<?php
header('Content-Type: application/json');
include 'db_connect.php'; // Include your database connection

// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', '1');

// Fetch the JSON data from the request body
$data = json_decode(file_get_contents('php://input'), true);

// Log the received data
file_put_contents('php://stderr', print_r($data, TRUE));

// Check if the input data is set and not null
if (isset($data['user_id'], $data['new_password'])) {
    $userId = $data['user_id'];
    $newPassword = password_hash($data['new_password'], PASSWORD_DEFAULT);

    // Prepare SQL statement
    $sql = "UPDATE Users SET password_hash = ? WHERE user_id = ?";
    if ($stmt = $mysqli->prepare($sql)) {
        $stmt->bind_param("si", $newPassword, $userId);

        // Execute the statement
        if ($stmt->execute()) {
            echo json_encode(['message' => 'Password changed successfully']);
        } else {
            // Log the error message
            file_put_contents('php://stderr', 'Error executing statement: ' . $stmt->error . PHP_EOL);
            echo json_encode(['message' => 'Failed to change password']);
        }

        $stmt->close();
    } else {
        // Log the error message
        file_put_contents('php://stderr', 'Failed to prepare the SQL statement: ' . $mysqli->error . PHP_EOL);
        echo json_encode(['message' => 'Failed to prepare the SQL statement']);
    }
} else {
    // Log invalid input
    file_put_contents('php://stderr', 'Invalid input: ' . print_r($data, TRUE) . PHP_EOL);
    echo json_encode(['message' => 'Invalid input']);
}

// Close the database connection
$mysqli->close();
?>