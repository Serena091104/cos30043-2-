<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

header("Access-Control-Allow-Origin: https://serena091104.github.io");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json"); // Ensure JSON output

$method = $_SERVER['REQUEST_METHOD'];
$request = isset($_SERVER['PATH_INFO']) ? explode('/', trim($_SERVER['PATH_INFO'], '/')) : [];
$input = json_decode(file_get_contents('php://input'), true);

$conn = new mysqli("sql100.infinityfree.com", "if0_39837779", "BxvuQ4NiRmfL", "if0_39837779_s104480538_db");

if (!$conn) {
    die(json_encode(["error" => "Connection failed: " . mysqli_connect_error()]));
}

mysqli_set_charset($conn, 'utf8');

$table = "products";

// Safely extract field and key
$fld = isset($request[0]) ? preg_replace('/[^a-z0-9_]+/i', '', array_shift($request)) : '';
$key = isset($request[0]) ? array_shift($request) : '';

// Prepare data for SQL
$columns = [];
$values = [];
$set = '';

if (isset($input) && is_array($input)) {
    $columns = preg_replace('/[^a-z0-9_]+/i', '', array_keys($input));
    $values = array_map(function ($value) use ($conn) {
        if ($value === null) return null;
        return mysqli_real_escape_string($conn, (string)$value);
    }, array_values($input));

    for ($i = 0; $i < count($columns); $i++) {
        $set .= ($i > 0 ? ',' : '') . '`' . $columns[$i] . '`=';
        $set .= ($values[$i] === null ? 'NULL' : '"' . $values[$i] . '"');
    }
}

// Build SQL
switch ($method) {
    case 'GET':
        $sql = "SELECT * FROM `$table`" . ($key ? " WHERE `$fld`='$key'" : '');
        break;
    case 'PUT':
        if (isset($input['id'])) {
            $id = intval($input['id']);
            $sql = "UPDATE `$table` SET $set WHERE id = $id";
        } else {
            die(json_encode(["error" => "ID not provided for update."]));
        }
        break;
    case 'POST':
        $sql = "INSERT INTO `$table` SET $set";
        break;
    case 'DELETE':
        if (isset($input['id'])) {
            $id = intval($input['id']);
            $sql = "DELETE FROM `$table` WHERE id = $id";
        } else {
            die(json_encode(["error" => "ID not provided for deletion."]));
        }
        break;
    default:
        die(json_encode(["error" => "Invalid request method."]));
}

// Execute SQL
$result = mysqli_query($conn, $sql);
if ($result) {
    if ($method == 'GET') {
        echo '[';
        for ($i = 0; $i < mysqli_num_rows($result); $i++) {
            echo ($i > 0 ? ',' : '') . json_encode(mysqli_fetch_object($result));
        }
        echo ']';
    } elseif ($method == 'POST') {
        echo json_encode(["inserted_id" => mysqli_insert_id($conn)]);
    } else {
        echo json_encode(["affected_rows" => mysqli_affected_rows($conn)]);
    }
} else {
    error_log("SQL Error: " . mysqli_error($conn));
    die(json_encode(["error" => "SQL Error: " . mysqli_error($conn)]));
}

mysqli_close($conn);
?>