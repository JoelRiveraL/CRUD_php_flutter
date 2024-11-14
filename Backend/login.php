<?php
require 'User.php'; // Incluir la clase de usuario
require 'conexion.php'; // Incluir la conexión

// Obtener los datos del usuario desde el formulario o el cuerpo de la solicitud
$emailU = "Ya";
$passwordU = "Leo123";

// Crear una instancia de la clase User y pasarle la conexión
$user = new User($db);

// Intentar iniciar sesión
$jwt = $user->login($emailU, $passwordU);

if ($jwt) {
    // Respuesta en JSON con el token JWT
    echo json_encode([
        'status' => 'success',
        'message' => 'Inicio de sesión exitoso',
        'token' => $jwt
    ]);
} else {
    // Respuesta en caso de fallo de autenticación
    echo json_encode([
        'status' => 'error',
        'message' => 'Nombre de usuario o contraseña incorrectos'
    ]);
}
?>
