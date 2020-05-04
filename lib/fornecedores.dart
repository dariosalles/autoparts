import 'dart:ui';

import 'package:auto_parts/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detalhes_fornecedores.dart';
import 'menuDrawer.dart';

class Fornecedores extends StatefulWidget {
  @override
  _FornecedoresState createState() => _FornecedoresState();
}

class _FornecedoresState extends State<Fornecedores> {

  String email;

  // MENSAGENS AMIGAVEIS
  mensagemToast(String msg) {

    return Fluttertoast.showToast(

        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: Color.fromARGB(255, 214, 37, 1),
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  //CONTROLLER - BUSCA - RECUPERA O QUE FOI DIGITADO
  TextEditingController _controllerBuscaF = TextEditingController();

  List _itemsF = [];
  int _quantF = 0;
  String _apiF;

  // CARREGA OS FORNECEDORES INICIAIS
  Future<List> _recuperarFornecedores() async {

    String urlF;

    var _busca = _controllerBuscaF.text.trim();


    if(_busca.isEmpty) {
      setState(() {
        urlF = "${Constants.baseUrlApi}apiRecupera_fornecedores.php";
      });

    } else {
      setState(() {
        urlF = '${Constants.baseUrlApi}apiRecupera_fornecedores.php?busca=$_busca';
      });

    }

    http.Response response = await http.post(urlF, body: ({"token": Constants.token.toString()}));

    _itemsF = json.decode(response.body) as List;

    return _itemsF;

  }

  goDetalhesFornecedores(idfornecedor) async{

    String idf = idfornecedor.toString();

    // passando pra outra tela utilizando parametros
    Navigator.push(
        context,
        MaterialPageRoute(
          //fullscreenDialog: true,
          builder: (context) => DetalhesFornecedores(idfdetalhes: idf),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          title: Text('Fornecedores'),
          backgroundColor: Color.fromARGB(255, 204, 37, 1),
        ),
        drawer: MenuDrawer(),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 250,
                      child:
                      TextField(
                        cursorWidth: 2,
                        keyboardType: TextInputType.text,
                        maxLength: 30,
                        decoration: InputDecoration(
                            labelText: "Buscar fornecedor",

                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                gapPadding: 4.00
                            )
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        controller: _controllerBuscaF,
                      ),
                    ),
                    SizedBox(width: 15,),
                    Container(
                      width: 100,
                      child:
                      RaisedButton(
                        child: Text('Buscar'),
                        color: Colors.red,
                        textColor: Colors.white,
                        onPressed: (){
                          //_buscaPecas();
                          _recuperarFornecedores();
                        },
                      ),
                    )

                  ],
                ),
                Expanded(
                  child: FutureBuilder(
                    future: _recuperarFornecedores(),
                    builder: (context, snapshot){

                      String resultado;
                      bool _loading = false;

                      switch(snapshot.connectionState) {
                        case ConnectionState.done :
                        //print('conexao none');
                          if (snapshot.hasError){

                            resultado = "Erro ao carregar os dados";
                            //print(snapshot.hasError);
                            print(snapshot.error);

                          } else {

                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, indice) {

                                  return ListTile(
                                    onTap: () {
                                      goDetalhesFornecedores(snapshot.data[indice]['id_fornecedor']
                                          .toString());
                                    },
                                    title: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                             Image.asset('assets/img/fornecedores/' + snapshot.data[indice]['imagem'].toString(),
                                              width: 120,
                                               height: 120,
                                            ),
                                            Text(snapshot.data[indice]['fornecedor'].toString(),
                                                  style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            )
                                          ],
                                        ),

                                        Divider(
                                          color: Colors.black12,
                                          height: 20,
                                          thickness: 2,
                                        )

                                      ],
                                    ),

                                  );
                                });

                          }
                          break;
                        case ConnectionState.waiting :

                        //runLoading();

                        //_loading ?
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                //backgroundColor: Colors.red,
                                strokeWidth: 5,
                              ),
                              SizedBox(height: 10,),
                              Text('Carregando Fornecedores...',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),)
                            ],
                          );


                          //  : SizedBox(width: 0, height: 0,);

                          //resultado = 'Carregando...';

                          break;

                        case ConnectionState.active :
                        //print('conexao active');
                          break;
                        case ConnectionState.none :
                        //print('conexao none');
                          break;
                      }
                      return Center(
                        child: Text(resultado,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),),
                      );
                    },
                  ),
                )
              ],
            )
        ));
  }
}
