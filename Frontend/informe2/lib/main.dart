import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
        ),
        margin: EdgeInsets.only(top: 50,left: 30, right: 30, bottom: 50,),
        padding: EdgeInsets.only(left: 20, right: 20,),
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
                height: 40,
              ),

              TextField(
                controller: email,
                decoration: InputDecoration(
                    hintText: "Usuario"
                ),
              ),
              SizedBox(height: 50,),
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Contraseña"
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 70),
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                  onPressed: (){},
                  child: Text("Iniciar Sesión", style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
              ),
              SizedBox(height: 20,),
              Text("¿No tiene cuenta? REGÍSTRESE", style: TextStyle(color: Colors.lightBlue, fontSize: 15)),

            ],
          ),
        ),

      ),
    );
  }
}