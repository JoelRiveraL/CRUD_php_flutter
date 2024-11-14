<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "urbanizationtreasurysystem";

$conn = new mysqli($servername, $username, $password, $dbname, 3306);

if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}
else
{
    echo "Conexión exitosa";
}