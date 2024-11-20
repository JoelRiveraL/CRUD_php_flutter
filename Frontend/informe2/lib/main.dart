import 'package:flutter/material.dart';
import 'package:informe2/crud.dart';
import 'registrar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para convertir los datos JSON
import 'package:jwt_decoder/jwt_decoder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inicio de Sesión',
      debugShowCheckedModeBanner: false,
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  @override
  __MyHomePageState createState() => __MyHomePageState();
}

class __MyHomePageState extends State<_MyHomePage> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();

// URL de tu backend
  final String apiUrl =
      "http://localhost/CRUD_php_flutter/Backend/login.php";
// Función para realizar la petición de login
  Future<void> login() async {
    try {
      // Notifica que el proceso de login está en curso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Iniciando sesión...')),
      );

      // Crea un mapa con los datos que vas a enviar
      Map<String, String> body = {
        'emailU': email.text,
        'passwordU': password.text,
      };

      print('Enviando datos: $body');

      // Realiza la petición POST
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Indica que estás enviando JSON
        },
        body: jsonEncode(body), // Convierte el cuerpo a JSON
      );

      print('Código de respuesta: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');

      // Verifica si la respuesta fue exitosa
      if (response.statusCode == 200) {
        // Parsear JSON
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          // Login exitoso
          String token = responseData['token'];
          // Decodifica el token JWT
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

          print('Token JWT: $token');

          // Redirige a otra pantalla
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Crud(decodedToken)),
          );
        } else {
          // Muestra el mensaje de error desde el servidor
          String errorMessage = responseData['message'] ?? 'Error desconocido';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login fallido: $errorMessage')),
          );
        }
      } else {
        // Error en la conexión
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en la conexión con el servidor')),
        );
      }
    } catch (error) {
      // Manejo de errores
      print('Error en el login: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al intentar iniciar sesión')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.only(
          top: 50,
          left: 30,
          right: 30,
          bottom: 50,
        ),
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 140,
                child: Image.asset('assets/Logo_ESPE.png'),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: email,
                decoration: InputDecoration(hintText: "Usuario"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(hintText: "Contraseña"),
              ),
              Container(
                margin: EdgeInsets.only(top: 60),
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)),
                child: TextButton(
                  onPressed: () {
                    login();
                  },
                  child: Text(
                    "Iniciar Sesión",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Registrar()),
                  );
                },
                child: Text(
                  "¿No tiene cuenta? REGÍSTRESE",
                  style: TextStyle(color: Colors.lightBlue, fontSize: 15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
