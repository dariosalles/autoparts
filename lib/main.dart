import 'package:auto_parts/cadastro.dart';
import 'package:auto_parts/detalhes_fornecedores.dart';
import 'package:auto_parts/detalhes_pecas.dart';
import 'package:auto_parts/pecas.dart';
import 'package:auto_parts/contato.dart';
import 'package:auto_parts/carrinho.dart';
import 'package:auto_parts/perfil.dart';

import 'package:auto_parts/screen_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'categoria.dart';
import 'esqueci.dart';
import 'fornecedores.dart';
import 'fornecedores_mapa.dart';
import 'package:auto_parts/pedidos.dart';

void main() {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Auto Parts',
    initialRoute: "/",
    routes: {
      '/': (context) => Splash(),
      '/inicial': (context) => Inicial(),
      '/perfil': (context) => Perfil(),
      '/pecas': (context) => Pecas(),
      '/detalhes': (context) => Detalhes(),
      '/detalhesfornecedor': (context) => DetalhesFornecedores(),
      '/fornecedormapa': (context) => FornecedorMapa(),
      '/contato': (context) => Contato(),
      '/carrinho': (context) => Carrinho(),
      '/cadastro': (context) => Cadastro(),
      '/fornecedores': (context) => Fornecedores(),
      '/esqueci': (context) => Esqueci(),
      '/pedidos': (context) => Pedidos(),
      '/categoria': (context) => Categoria(),

    },
  ));
}

// SPLASH
class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    Future.delayed(Duration(seconds: 4)).then((_){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Inicial()));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        color: Color.fromARGB(255, 214, 37, 1),
        child: Center(
          child: Container(
            width: 150,
            height: 150,
            child: Image.asset("assets/img/icon.png"),
          ),
        )
    );
  }
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


