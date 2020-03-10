import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_parts/menuDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

        title: Text('Perfil'),
    backgroundColor: Color.fromARGB(255, 204, 37, 1),
    ),
    drawer: MenuDrawer(),
    body: Container(
      child: Text('perfil')
      )
    );
  }
}
