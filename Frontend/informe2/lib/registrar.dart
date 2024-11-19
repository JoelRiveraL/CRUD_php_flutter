import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para convertir los datos JSON

class Registrar extends StatefulWidget {
  @override
  _RegistrarState createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> registerUser(String name, String email, String password) async {
    final String apiUrl =
        "http://localhost/CRUD_php_flutter/Backend/register.php";

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registrando usuario...')),
      );

      Map<String, dynamic> body = {
        'nameU': name,
        'emailU': email,
        'passwordU': password,
      };
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      print("Código de respuesta: ${response.statusCode}");
      print("Respuesta del servidor: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          print("Registro exitoso: ${responseData['message']}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registro exitoso')),
          );
        } else {
          print("Error en el registro: ${responseData['message']}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error en el registro')),
          );
        }
      } else {
        print("Error en la conexión con el servidor");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error en la conexión con el servidor')),
        );
      }
    } catch (e) {
      print("Error en el registro: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en el registro')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("Registrarse"),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 50),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: Image.asset('assets/Logo_ESPE.png'),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  hintText: "Nombre",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 40),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () {
                    // Lógica para registrar al usuario
                    // Puedes llamar aquí a la función que envíe los datos al backend en PHP
                    registerUser(
                      nombreController.text,
                      emailController.text,
                      passwordController.text,
                    );
                    // Redireccionar a la pantalla principal después del registro
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Crear Usuario",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
