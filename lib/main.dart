import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app_webservice_flutter/Entidades/usuarios.dart';
import 'package:http/http.dart' as http;

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Usuarios> _usuario = List<Usuarios>();
  List<Usuarios> _mostrarUsuario = List<Usuarios>();

  Future<List<Usuarios>> fetchUsers() async {
    var url = 'https://jsonfy.com/users';
    var response = await http.get(url);

    var usuario = List<Usuarios>();

    if (response.statusCode == 200) {
      var usuarioJson = json.decode(response.body);
      for (var usuarioJson in usuarioJson) {
        usuario.add(Usuarios.fromJson(usuarioJson));
      }
    }
    return usuario;
  }

  @override
  void initState() {
    fetchUsers().then((value) {
      setState(() {
        _usuario.addAll(value);
        _mostrarUsuario = _usuario;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('WEBSERVICE LISTA DE USUARIOS'),
          backgroundColor: Colors.black,
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return index == 0 ? _busqueda() : _listaUsuarios(index - 1);
          },
          itemCount: _mostrarUsuario.length + 1,
        ));
  }

  _busqueda() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        decoration:
            InputDecoration(
              hintText: 'INGRESA EL NOMBRE A BUSCAR...'
              ),
              onChanged: (texto){
                texto = texto.toLowerCase();
                setState(() {
                  _mostrarUsuario = _usuario.where((nombre){
                    var usuarioNombre = nombre.name.toLowerCase();
                    return usuarioNombre.contains(texto);
                  }).toList();
                });
              },
      ),
    );
  }

  _listaUsuarios(index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            top: 24.0, bottom: 24.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              _mostrarUsuario[index].name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _mostrarUsuario[index].email,
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            Text(
              'Edad: ' + _mostrarUsuario[index].age,
              style: TextStyle(fontSize: 16, color: Colors.red[500]),
            ),
          ],
        ),
      ),
    );
  }
}
