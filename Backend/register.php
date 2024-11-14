<?php
require 'conexion.php'; // Incluir la conexión a la base de datos
require 'User.php';     // Incluir la clase User

// Crear una instancia de la clase User, pasándole la conexión a la base de datos
$user = new User($db);

// Ejemplo de registro de un nuevo usuario
$nameU = "Juan";
$surnameU = "Perez";
$passwordU = "mi_contraseña_segura";

// Registrar el usuario
if ($user->register($nameU, $surnameU, $passwordU)) {
    echo "Usuario registrado con éxito.";
} else {
    echo "Error al registrar el usuario.";
}
?>