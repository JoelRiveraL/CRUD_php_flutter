<?php

require 'conexion.php'; // Incluir la conexión a la base de datos

class User {
    private $db;

    // Constructor que recibe la conexión a la base de datos
    public function __construct($db) {
        $this->db = $db;
    }

    // Método de registro de usuario
    public function register($nameU, $surnameU, $passwordU) {
        // Cifrar la contraseña usando password_hash en lugar de passwordU_hash
        $hashedPasswordU = password_hash($passwordU, PASSWORD_BCRYPT);

        // Sentencia SQL para insertar los datos
        $query = "INSERT INTO user (nameU, surnameU, passwordU) VALUES (:nameU, :surnameU, :passwordU)";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(":nameU", $nameU);
        $stmt->bindParam(":surnameU", $surnameU);
        $stmt->bindParam(":passwordU", $hashedPasswordU);

        // Ejecutar y devolver el resultado
        return $stmt->execute();
    }

    // Método de inicio de sesión
    public function login($nameU, $passwordU) {
        // Consulta SQL para obtener el usuario por nombre
        $query = "SELECT * FROM user WHERE nameU = :nameU";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(":nameU", $nameU);
        $stmt->execute();

        // Verificar si se encuentra el usuario
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        // Si el usuario existe y la contraseña coincide, retornar los datos del usuario
        if ($user && password_verify($passwordU, $user['passwordU'])) {
            return $user;
        }
        // Si no coincide, devolver falso
        return false;
    }
}
