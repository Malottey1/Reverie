<?php
header('Content-Type: application/json');
include 'db_connect.php'; // Include your database connection

// Fetch the JSON data from the request body
$data = json_decode(file_get_contents('php://input'), true);

// Check if the input data is set and not null
if (isset($data['email'], $data['password'])) {
    $email = $data['email'];
    $password = $data['password'];

    // Prepare SQL statement
    $sql = "SELECT user_id, password_hash FROM Users WHERE email = ?";
    if ($stmt = $mysqli->prepare($sql)) {
        $stmt->bind_param("s", $email);

        // Execute the statement
        if ($stmt->execute()) {
            $result = $stmt->get_result();
            if ($result->num_rows > 0) {
                $user = $result->fetch_assoc();
                // Verify the password
                if (password_verify($password, $user['password_hash'])) {
                    echo json_encode(['message' => 'Login successful', 'user_id' => $user['user_id']]);
                } else {
                    echo json_encode(['message' => 'Invalid credentials']);
                }
            } else {
                echo json_encode(['message' => 'User not found']);
            }
            $stmt->close();
        } else {
            echo json_encode(['message' => 'Failed to execute SQL statement']);
        }
    } else {
        echo json_encode(['message' => 'Failed to prepare the SQL statement']);
    }
} else {
    echo json_encode(['message' => 'Invalid input']);
}

// Close the database connection
$mysqli->close();
?>