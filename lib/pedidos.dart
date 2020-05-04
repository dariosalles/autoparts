import 'dart:async';
import 'dart:convert';

import 'package:auto_parts/pecas.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'menuDrawer.dart';


Future<Album> fetchAlbum() async {
  final response =
  await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
//    final r = json.decode(response.body);
//    print (r);
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

Future<PecasT> fetchPecas() async {
  final response =
  await http.post('http://www.dsxweb.com.br/apps/autoparts/api/apiRecupera_pecas_detalhes.php', body: ({ "token": "123456789", "id_peca": "5"}));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    final r = json.decode(response.body[0]);
    print (r);
    return PecasT.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}


Future<Users> fetchUsers() async {

  String url = "http://localhost:3333/users";

  final response = await http.get(url);
  //final response = await http.get('https://jsonplaceholder.typicode.com/albums');

  if (response.statusCode == 200) {

//    final r = json.decode(response.body);
//    print(r);

    return Users.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class PecasT {
  final int idPeca;
  final int idFornecedor;
  final int idCategoria;
  
  PecasT({this.idPeca, this.idFornecedor, this.idCategoria});

  factory PecasT.fromJson(Map<String, dynamic> json) {
    return PecasT(
      idPeca: json['id_peca'],
      idFornecedor: json['id_fornecedor'],
      idCategoria: json['id_categoria']
    );
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}


class Users {
  int id;
  String name;
  String password;
  String email;

  Users({this.id, this.name, this.password, this.email});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    password = json['password'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['password'] = this.password;
    data['email'] = this.email;
    return data;
  }
}

class Usuarios {
  List<Users> users;

  Usuarios({this.users});

  Usuarios.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      users = new List<Users>();
      json['users'].forEach((v) {
        users.add(new Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['users'] = this.users.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pedidos extends StatefulWidget {
  Pedidos({Key key}) : super(key: key);

  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {

  Future<Album> futureAlbum;
  Future<Users> futureUsers;
  Future<PecasT> futurePecas;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
    futureAlbum = fetchAlbum();
    futurePecas = fetchPecas();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<PecasT>(
            future: futurePecas,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.idCategoria.toString());
                //return Text(snapshot.data.email.toString());
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}