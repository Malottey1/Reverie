<?php
$host = 'localhost';
$user = 'u505497111_root1';
$password = 'Naakey057@'; // Update with your MySQL password
$database = 'u505497111_reverie';

// Create a new mysqli object with database connection parameters
$mysqli = new mysqli($host, $user, $password, $database);

// Check for a connection error and handle it
if ($mysqli->connect_error) {
    die("Connection failed: " . $mysqli->connect_error);
}
?>