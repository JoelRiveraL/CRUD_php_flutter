<?php
require 'conexion.php'; // Incluir la conexión a la base de datos
require 'user.php';     // Incluir la clase User

header('Content-Type: application/json'); // Asegura que el servidor responde en JSON
header("Access-Control-Allow-Origin: *"); // Permitir cualquier origen (ajustar para producción)
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Verifica si el método de la solicitud es POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Decodifica el cuerpo de la solicitud como JSON
    $data = json_decode(file_get_contents("php://input"), true);

    // Comprueba si los parámetros esperados están presentes
    if (isset($data['nameU']) && isset($data['emailU']) && isset($data['passwordU'])) {
        $nameU = $data['nameU'];
        $emailU = $data['emailU'];
        $passwordU = $data['passwordU'];

        // Crear una instancia de User
        $user = new User($db);

        // Registrar al usuario
        if ($user->register($nameU, $emailU, $passwordU)) {
            // Respuesta exitosa
            echo json_encode([
                "status" => "success",
                "message" => "Usuario registrado con éxito."
            ]);
        } else {
            // Respuesta con error al registrar
            echo json_encode([
                "status" => "error",
                "message" => "Error al registrar el usuario. Es posible que el correo ya esté registrado."
            ]);
        }
    } else {
        // Respuesta con error de parámetros faltantes
        echo json_encode([
            "status" => "error",
            "message" => "Faltan parámetros (nameU, emailU, passwordU)."
        ]);
    }
} else {
    // Respuesta con error de método no permitido
    echo json_encode([
        "status" => "error",
        "message" => "Método no permitido"
    ]);
}
?>
