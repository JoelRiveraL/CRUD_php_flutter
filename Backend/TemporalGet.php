<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

include 'conexion.php';

$sql = $conn->query("SELECT * FROM mitabla");
$res = array();
while ($row = $sql->fetch_assoc()) {
    $res[] = $row;  // Acumulando cada fila en el arreglo $res
}
echo json_encode($res);  // Devolver todo el arreglo como JSON
?>
