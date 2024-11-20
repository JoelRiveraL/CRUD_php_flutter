<?php
require 'conexion.php'; // Incluir la conexión a la base de datos
require 'user.php';     // Incluir la clase User

// Configuración de cabeceras
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Decodificar los datos enviados en el cuerpo de la solicitud
    $data = json_decode(file_get_contents("php://input"), true);

    if (isset($data['idUser']) && isset($data['nameU']) && isset($data['emailU'])) {
        $id = $data['idUser'];
        $name = $data['nameU'];
        $email = $data['emailU'];

        $user = new User($db);

        // Intentar actualizar el usuario
        if ($user->updateUser($id, $name, $email)) {
            echo json_encode([
                "status" => "success",
                "message" => "Usuario actualizado con éxito"
            ]);
        } else {
            echo json_encode([
                "status" => "error",
                "message" => "No se pudo actualizar el usuario"
            ]);
        }
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Faltan parámetros"
        ]);
    }
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Método no permitido"
    ]);
}