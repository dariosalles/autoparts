import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {

    const TextStyle optionStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    return Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.assignment),
              color: Colors.red,
              iconSize: 30,
              tooltip: 'Adicionar ao Carrinho',
              onPressed: () {
                print('Recarrega a pagina Peças');
                Navigator.pushNamed(context, '/pecas');
              },
            ),
            Text('Peças ',
                style: optionStyle),
            IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Colors.red,
              iconSize: 30,
              tooltip: 'Adicionar ao Carrinho',
              onPressed: () {
                print('Recarrega a pagina Carrinho');
                Navigator.pushNamed(context, '/carrinho');
              },
            ),
            Text('Carrinho ',
                style: optionStyle),

            IconButton(
              icon: Icon(Icons.alternate_email),
              color: Colors.red,
              iconSize: 30,
              tooltip: 'Adicionar ao Carrinho',
              onPressed: () {
                print('Recarrega a pagina Contato');
                Navigator.pushNamed(context, '/contato');
              },
            ),
            Text("Contato",
                style: optionStyle),
          ],
        )
    );
  }
}
