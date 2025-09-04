<?php


ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

session_start();
header("Access-Control-Allow-Origin: https://serena091104.github.io");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
//$conn = new mysqli("feenix-mariadb.swin.edu.au", "s104480538", "091104", "s104480538_db");
$conn = new mysqli("sql100.infinityfree.com", "if0_39837779", "BxvuQ4NiRmfL", "if0_39837779_s104480538_db");

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Connection failed: ' . $conn->connect_error]));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_SESSION['user_id']) && isset($_POST['product_id']) && isset($_POST['comment'])) {
        $userId = $_SESSION['user_id'];
        $productId = intval($_POST['product_id']);
        $comment = $conn->real_escape_string(trim($_POST['comment']));

        $stmt = $conn->prepare("INSERT INTO comments (product_id, user_id, comment) VALUES (?, ?, ?)");
        $stmt->bind_param("iis", $productId, $userId, $comment);

        if ($stmt->execute()) {
            echo json_encode(['status' => 'success', 'message' => 'Comment added successfully']);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to add comment']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Unauthorized']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}

$conn->close();
?>
