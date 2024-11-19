<?php

require 'user.php'; // Incluir la clase de usuario
require 'conexion.php'; // Incluir la conexión

header('Content-Type: application/json'); // Asegura que el servidor responde con JSON
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Verifica el método de la solicitud
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Lee los datos enviados en el cuerpo de la solicitud
    $data = json_decode(file_get_contents("php://input"), true);

    // Comprueba si los parámetros esperados están presentes
    if (isset($data['emailU']) && isset($data['passwordU'])) {
        $emailU = $data['emailU'];
        $passwordU = $data['passwordU'];

        // Lógica de autenticación
        $user = new User($db);
        $token = $user->login($emailU, $passwordU);

        if ($token) {
            // Respuesta exitosa con el token
            echo json_encode([
                "status" => "success",
                "message" => "Inicio de sesión exitoso",
                "token" => $token
            ]);
        } else {
            // Respuesta con error de credenciales
            echo json_encode([
                "status" => "error",
                "message" => "Credenciales inválidas"
            ]);
        }
    } else {
        // Respuesta con error de parámetros faltantes
        echo json_encode([
            "status" => "error",
            "message" => "Faltan parámetros"
        ]);
    }
} else {
    // Respuesta con error de método no permitido
    echo json_encode([
        "status" => "error",
        "message" => "Método no permitido"
    ]);
}
