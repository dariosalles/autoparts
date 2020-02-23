import 'package:auto_parts/cadastro.dart';
import 'package:auto_parts/pecas.dart';
import 'package:auto_parts/contato.dart';
import 'package:auto_parts/carrinho.dart';

import 'package:auto_parts/screen_login.dart';
import 'package:flutter/material.dart';

import 'fornecedores.dart';



void main() {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Auto Parts',
    initialRoute: "/",
    routes: {
      '/': (context) => Inicial(),
      '/pecas': (context) => Pecas(),
      '/contato': (context) => Contato(),
      '/carrinho': (context) => Carrinho(),
      '/cadastro': (context) => Cadastro(),
      '/fornecedores': (context) => Fornecedores()

    },
  ));
}

// PAGE INICIAL
class Inicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        appBar: AppBar(
//          title: Text('Auto Parts'),
//          backgroundColor: Color.fromARGB(255, 214, 37, 1),
//        ),
        body: SignInOne()
    );
  }
}



class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //CONTROLLER - Email/Senha - RECUPERA O QUE FOI DIGITADO
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/img/fundo.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.srgbToLinearGamma(

          )
        ),
      ),
      padding: EdgeInsets.all(36),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Image.asset('assets/img/logo_autoparts.png'),

          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: "Digite seu email",
                labelStyle: TextStyle(
                    color: Colors.white
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gapPadding: 4.00
                )
              //contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0)
            ),
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              //decorationColor: Colors.black
            ),
            controller: _controllerEmail,
          ),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: Colors.white
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gapPadding: 4.00
                )
              //contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0)
            ),
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              //decorationColor: Colors.black
            ),
            controller: _controllerSenha,
          ),
          RaisedButton(
            child: Text('Acessar'),
            color: Color.fromARGB(255, 204, 51, 0),
            textColor: Colors.white,
            onPressed: (){
              Navigator.pushNamed(context, '/pecas');
              },
          )

        ],
      ),

    );
  }
}


