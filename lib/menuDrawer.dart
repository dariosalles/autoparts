import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {

  String email;
  String nome;

  initState() {

    getEmail();

  }



  getEmail() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    setState(() {
      email = sp.getString('email');
      nome = sp.getString('nome');
    });

    //print('Email depois $email');
  }

  _logout() async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    bool rememberMe = sp.getBool('lembrarme');
    print('Logout $rememberMe');

    if(rememberMe == true) {
      setState(() {
        sp.setBool('lembrarme', false);
        rememberMe = false;
      });
    }
    print('Logout $rememberMe');
    print('Sair Logout');


    Navigator.pushNamed(context, '/inicial');

  }

  @override
  Widget build(BuildContext context) {

    const TextStyle optionStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            padding: EdgeInsets.all(0),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 214, 37, 1),
              ),
              accountName: Text(nome ?? ''),
              accountEmail: Text(email ?? ''),
              currentAccountPicture: CircleAvatar(
                child: Text('AP',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold

                ),),
                backgroundColor: Colors.white,

              ),
          ),
            decoration: BoxDecoration(
              color: Color.fromARGB(0, 204, 37, 1),
            ),
          ),
          ListTile(
            title: Column(

              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                    icon: Icon(Icons.assignment),
                    color: Colors.red,
                    iconSize: 30,
                    tooltip: 'Lista de Peças',
                    onPressed: () {
                      print('Recarrega a pagina Peças');
                      Navigator.pushNamed(context, '/pecas');
                    },
                  ),
                    Text("Peças",
                      style: optionStyle)
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.card_membership),
                      color: Colors.red,
                      iconSize: 30,
                      tooltip: 'Fornecedores',
                      onPressed: () {
                        print('Recarrega a pagina Fornecedores');
                        Navigator.pushNamed(context, '/fornecedores');
                      },
                    ),
                    Text("Fornecedores",
                        style: optionStyle)
                  ],
                ),
                Row(
                  children: <Widget>[
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
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.alternate_email),
                      color: Colors.red,
                      iconSize: 30,
                      tooltip: 'Contato',
                      onPressed: () {
                        print('Recarrega a pagina Contato');
                        Navigator.pushNamed(context, '/contato');
                      },
                    ),
                    Text("Contato",
                        style: optionStyle),
                  ],
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      color: Colors.red,
                      iconSize: 30,
                      tooltip: 'Sair',
                      onPressed: () async{
                        _logout();
                      },
                    ),
                    Text("Sair (Logout)",
                        style: optionStyle),
                  ],
                ),

              ],
            )
          )
        ],

      ),
    );


  }

}
