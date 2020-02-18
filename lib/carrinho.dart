import 'package:auto_parts/botton_nav.dart';
import 'package:flutter/material.dart';

class Carrinho extends StatefulWidget {
  @override
  _CarrinhoState createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
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
          title: Text('Carrinho'),
          backgroundColor: Color.fromARGB(255, 204, 37, 1),
        ),
        body: Container(
          child: Text('Lista do Carrinho'),
        ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
