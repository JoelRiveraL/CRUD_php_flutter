<?php
// Datos de configuración
$host = 'localhost'; 
$dbname = 'system';
$username = 'root';
$password = '';

try {
    // Crear una instancia de PDO para la conexión a MySQL
    $db = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);

    // Configurar PDO para lanzar excepciones en caso de error
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    //echo "Conexión exitosa"; // Mensaje para confirmar conexión en pruebas (luego puede eliminarse)
} catch (PDOException $e) {
    // Captura el error en caso de falla de conexión
    echo "Error de conexión: " . $e->getMessage();
    exit(); // Finaliza el script en caso de error
}
?>