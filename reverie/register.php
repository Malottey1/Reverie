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
if (isset($data['first_name'], $data['last_name'], $data['email'], $data['password'], $data['gender'], $data['birthday'])) {
    $firstName = $data['first_name'];
    $lastName = $data['last_name'];
    $email = $data['email'];
    $password = password_hash($data['password'], PASSWORD_DEFAULT);
    $gender = $data['gender'];
    $birthday = $data['birthday'];

    // Prepare SQL statement
    $sql = "INSERT INTO Users (first_name, last_name, email, password_hash, gender, birthday) VALUES (?, ?, ?, ?, ?, ?)";
    if ($stmt = $mysqli->prepare($sql)) {
        $stmt->bind_param("ssssss", $firstName, $lastName, $email, $password, $gender, $birthday);

        // Execute the statement
        if ($stmt->execute()) {
            echo json_encode(['message' => 'Registration successful']);
        } else {
            // Log the error message
            file_put_contents('php://stderr', 'Error executing statement: ' . $stmt->error . PHP_EOL);
            echo json_encode(['message' => 'Registration failed']);
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