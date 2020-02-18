import 'package:auto_parts/botton_nav.dart';
import 'package:flutter/material.dart';

class Contato extends StatefulWidget {
  @override
  _ContatoState createState() => _ContatoState();
}

class _ContatoState extends State<Contato> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        leading: new GestureDetector(
        child: new Icon(Icons.arrow_back_ios),
    onTap: () {
    Navigator.of(context).pop();
    },
    ),
    title: Text('Contato'),
    backgroundColor: Color.fromARGB(255, 204, 37, 1),
    ),
    body: Container(
    child: Text('Contato'),
    ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
