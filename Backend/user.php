<?php

require 'conexion.php'; // Incluir la conexión a la base de datos
require 'vendor/autoload.php'; // Para JWT
use \Firebase\JWT\JWT;

class User {
    private $db;
    private $secretKey = "BaPiRiYa_movilApp2509"; 

    public function __construct($db) {
        $this->db = $db;
    }

    // Método de registro de usuario
    public function register($nameU, $emailU, $passwordU) {
        // Cifrar la contraseña usando password_hash en lugar de passwordU_hash
        $hashedPasswordU = password_hash($passwordU, PASSWORD_BCRYPT);

        // Sentencia SQL para insertar los datos
        $query = "INSERT INTO user (nameU, emailU, passwordU) VALUES (:nameU, :emailU, :passwordU)";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(":nameU", $nameU);
        $stmt->bindParam(":emailU", $emailU);
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
