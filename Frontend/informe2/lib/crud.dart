import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';

class Crud extends StatefulWidget {
  final Map<String, dynamic> decodedToken; // Define el token como una propiedad

  const Crud(this.decodedToken, {super.key});

  @override
  State<Crud> createState() => _CrudState();
}

class _CrudState extends State<Crud> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Usuarios"),
        backgroundColor: Colors.white60,
      ),
      backgroundColor: Colors.deepPurple.shade100,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bienvenido, ${widget.decodedToken['data']['nameU']}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Correo: ${widget.decodedToken['data']['emailU']}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            // Aquí puedes agregar más funcionalidades como editar el usuario
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditUserScreen(userData: widget.decodedToken['data']),
                  ),
                );
              },
              child: const Text("Editar Usuario"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeleteUserScreen(
                        userId:
                            int.parse(widget.decodedToken['data']['idUser'])),
                  ),
                );
              },
              child: const Text("Eliminar Usuario"),
            ),
          ],
        ),
      ),
    );
  }
}

class DeleteUserScreen extends StatefulWidget {
  final int userId;

  const DeleteUserScreen({super.key, required this.userId});

  @override
  State<DeleteUserScreen> createState() => _DeleteUserScreenState();
}

class _DeleteUserScreenState extends State<DeleteUserScreen> {
  Future<void> deleteUser() async {
    final String apiUrl =
        "http://localhost/CRUD_php_flutter/Backend/User_Deleter.php";
    Map<String, dynamic> body = {
      'idUser': widget.userId,
    };

    try {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Usuario eliminado con éxito")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${responseData['message']}")),
          );
        }
      } else {
        print("Error en la conexión con el servidor");
      }
    } catch (e) {
      print("Error al eliminar el usuario: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Eliminar Usuario")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("¿Estás seguro de que deseas eliminar tu cuenta?"),
            ElevatedButton(
                onPressed: () {
                  deleteUser();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                child: Text("Eliminar Cuenta")),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancelar"),
            ), // Botón para cancelar
          ],
        ),
      ),
    );
  }
}

class EditUserScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditUserScreen({super.key, required this.userData});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData['nameU']);
    emailController = TextEditingController(text: widget.userData['emailU']);
  }

  Future<void> updateUser() async {
    final String apiUrl =
        "http://localhost/CRUD_php_flutter/Backend/User_Updater.php";
    Map<String, dynamic> body = {
      'idUser': widget.userData['idUser'],
      'nameU': nameController.text,
      'emailU': emailController.text,
    };

    try {
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Usuario actualizado con éxito")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${responseData['message']}")),
          );
        }
      } else {
        print("Error en la conexión con el servidor");
      }
    } catch (e) {
      print("Error al actualizar el usuario: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Editar Usuario")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nombre")),
            TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Correo")),
            ElevatedButton(
                onPressed: () {
                  updateUser();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                child: Text("Guardar Cambios")),
          ],
        ),
      ),
    );
  }
}
