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
    public function login($emailU, $passwordU) {
        // Consulta para obtener los datos del usuario por nombre
        $query = "SELECT * FROM users WHERE emailU = :emailU";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(":nameU", $emailU);
        $stmt->execute();
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        // Verificar si el usuario existe y la contraseña coincide
        if ($user && password_verify($passwordU, $user['passwordU'])) {
            // Si la contraseña es correcta, generamos el token JWT
            $payload = [
                'iat' => time(),
                'exp' => time() + (60 * 60), // Expira en 1 hora
                'data' => [
                    'idUser' => $user['idUser'],
                    'emailU' => $user['emailU']
                ]
            ];
            $jwt = JWT::encode($payload, $this->secretKey, 'HS256');

            // Retorna el token
            return $jwt;
        }

        // Si no coincide, retornamos falso
        return false;
    }
}
