import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'categoria.dart';

class Categorias extends StatefulWidget {
  @override
  _CategoriasState createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 204, 37, 1), // I played with different colors code for get transparency of color but Alway display White.
        ),
        margin: EdgeInsets.only(top: 0, bottom: 20),
        height: 160,
        child: ListView(

          // This next line does the trick.
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: 140.0,
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: (){

                        getCategoria(3);

                        //print('botao apertado');
                      },
                      padding: EdgeInsets.all(0.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        backgroundImage: AssetImage('assets/img/categorias/cat_acessorios.png',
                        ),
                        radius: 40,
                      ),
                    ),
                    Text('Acessórios',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: 140.0,
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: (){
                        getCategoria(5);
                      },
                      padding: EdgeInsets.all(0.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        backgroundImage: AssetImage('assets/img/categorias/cat_amortecedor.png',
                        ),
                        radius: 40,
                      ),
                    ),
                    Text('Amortecedores',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: 140.0,
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: (){
                        print('botao apertado');
                      },
                      padding: EdgeInsets.all(0.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        backgroundImage: AssetImage('assets/img/categorias/cat_combustivel.png',
                        ),
                        radius: 40,
                      ),
                    ),
                    Text('Alimentação',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                    Text('Combustível',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: 140.0,
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: (){
                        print('botao apertado');
                      },
                      padding: EdgeInsets.all(0.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        backgroundImage: AssetImage('assets/img/categorias/cat_eletrico.png',
                        ),
                        radius: 40,
                      ),
                    ),
                    Text('Elétrico',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: 140.0,
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: (){
                        print('botao apertado');
                      },
                      padding: EdgeInsets.all(0.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        backgroundImage: AssetImage('assets/img/categorias/cat_freios.png',
                        ),
                        radius: 40,
                      ),
                    ),
                    Text('Freios',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: 140.0,
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: (){
                        print('botao apertado');
                      },
                      padding: EdgeInsets.all(0.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        backgroundImage: AssetImage('assets/img/categorias/cat_ignicao.png',
                        ),
                        radius: 40,

                      ),
                      //Image.asset('assets/img/categorias/cat_amortecedor.png')
                    ),
                    Text('Ignição',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: 140.0,
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: (){
                        print('botao apertado');
                      },
                      padding: EdgeInsets.all(0.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        backgroundImage: AssetImage('assets/img/categorias/cat_iluminacao.png',
                        ),
                        radius: 40,

                      ),
                      //Image.asset('assets/img/categorias/cat_amortecedor.png')
                    ),
                    Text('Iluminação',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: 140.0,
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: (){
                        print('botao apertado');
                      },
                      padding: EdgeInsets.all(0.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        backgroundImage: AssetImage('assets/img/categorias/cat_retrovisores.png',
                        ),
                        radius: 40,
                      ),
                    ),
                    Text('Retrovisores',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                  ],
                )
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                width: 140.0,
                child: Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: (){
                        print('botao apertado');
                      },
                      padding: EdgeInsets.all(0.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        backgroundImage: AssetImage('assets/img/categorias/cat_vidros.png',
                        ),
                        radius: 40,
                      ),
                    ),
                    Text('Vidros',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    )
                  ],
                )
            ),
          ],
        )
    );
  }

  void getCategoria(idcategoria) async{

    String idc = idcategoria.toString();

    // passando pra outra tela utilizando parametros
    Navigator.push(
        context,
        MaterialPageRoute(
          //fullscreenDialog: true,
          builder: (context) => Categoria(idcategoria: idc),
        ));

    // STORAGE - IDCATEGORIA - SET
//    SharedPreferences sp = await SharedPreferences.getInstance();
//    sp.setString('id_categoria', idcategoria.toString());
//
//    // redireciona
//    Navigator.pushNamed(context, '/categoria');

  }
}