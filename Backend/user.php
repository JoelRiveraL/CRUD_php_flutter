<?php

require 'conexion.php'; // Incluir la conexión a la base de datos
require 'vendor/autoload.php'; // Para JWT
use \Firebase\JWT\JWT;

class User
{
    private $db;
    private $secretKey = "BaPiRiYa_movilApp2509";

    public function __construct($db)
    {
        $this->db = $db;
    }

    // Método de registro de usuario
    public function register($nameU, $emailU, $passwordU)
    {
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
    public function login($emailU, $passwordU)
    {
        // Consulta para obtener los datos del usuario por nombre
        $query = "SELECT * FROM user WHERE emailU = :emailU";
        $stmt = $this->db->prepare($query);
        $stmt->bindParam(":emailU", $emailU);
        $stmt->execute();
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        // Verificar si el usuario existe y la contraseña coincide
        if ($user && password_verify($passwordU, $user['passwordU'])) {
            // Si la contraseña es correcta, generamos el token JWT
            $payload = [
                'iat' => time(),
                'exp' => time() + (60 * 5), // Expira en 5 min
                'data' => [
                    'idUser' => $user['idUser'],
                    'emailU' => $user['emailU'],
                    'nameU' => $user['nameU']
                ]
            ];
            $jwt = JWT::encode($payload, $this->secretKey, 'HS256');

            // Retorna el token
            return $jwt;
        }

        // Si no coincide, retornamos falso
        return false;
    }

    public function updateUser($id, $name, $email)
    {
        try {
            $sql = "UPDATE user SET nameU = :name, emailU = :email WHERE idUser = :id";
            $stmt = $this->db->prepare($sql);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            $stmt->bindParam(':name', $name, PDO::PARAM_STR);
            $stmt->bindParam(':email', $email, PDO::PARAM_STR);

            return $stmt->execute(); // Retorna true si se ejecuta correctamente
        } catch (Exception $e) {
            error_log("Error al actualizar usuario: " . $e->getMessage());
            return false;
        }
    }
    public function deleteUser($id)
    {
        try {
            $sql = "DELETE FROM user WHERE idUser = :id";
            $stmt = $this->db->prepare($sql);
            $stmt->bindParam(':id', $id, PDO::PARAM_INT);
            return $stmt->execute(); // Retorna true si se ejecuta correctamente
        } catch (Exception $e) {
            error_log('' . $e->getMessage());
            return false;

        }
    }

}
