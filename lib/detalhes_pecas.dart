import 'package:auto_parts/themes/light_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themes/light_color.dart';
import 'package:auto_parts/utils/app_config.dart';



class Detalhes extends StatefulWidget {

  Detalhes({ Key key, @required this.idpecadetalhes}) : super(key: key);
  final String idpecadetalhes;

  @override
  _DetalhesState createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {

  String get idpecadetalhes => widget.idpecadetalhes;
  String imagem;
  String nome;
  double valor;
  String dimensoes;
  String peso;
  String garantia;

  List _itemsD = [];
  //int _quantD = 0;
  String _apiDetalhes;

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


  // CARREGA OS DADOS - DETALHES DAS PEÇAS
  Future<List> _recuperarDadosPecas() async {

    _apiDetalhes = "${Constants.baseUrlApi}apiRecupera_pecas_detalhes.php";

    print(_apiDetalhes);

    print("idpeça ${idpecadetalhes}");

    http.Response response;

    //response = await http.post(_apiDetalhes, body: {'token': Constants.token.toString()});

    response = await http.post(_apiDetalhes, body: {'token': Constants.token.toString(), 'id_peca': idpecadetalhes});

    //response = await http.get(_apiDetalhes);

    _itemsD = json.decode(response.body) as List;


    nome = _itemsD[0]['nome'];
    valor = double.parse(_itemsD[0]['valor']);

    //print(_itemsD);


    return _itemsD;

  }

  addCart(idpeca, nome, String valor) async {

    //int idpeca;

    // shared
    SharedPreferences sp = await SharedPreferences.getInstance();


    // String apiAddCart
    String apiAddCart = '${Constants.baseUrlApi}apiInsereCarrinho8.php?token=${Constants.token.toString()}';

    print(apiAddCart);

    http.Response response;

    // campos teste
    String _idusuario = sp.getString('id_usuario');
    String _email = sp.getString('email'); //'dariosalles@gmail.com';
    String _peca = nome;
    String _idpeca = _itemsD[0]['id_peca'].toString();
    //String _idpeca = idpeca.toString();
    String _quant = '1';
    String _valor = valor;

    Map<dynamic, dynamic> _corpo = {'id_usuario': _idusuario, 'email': _email, 'id_peca': _idpeca, 'peca': _peca, 'quant': _quant, 'valor': _valor };

    print('Map Corpo $_corpo');

    response = await http.post(apiAddCart, body: _corpo);

    //print(response.body);


    if (response.statusCode == 200) {

      String _resultAddCart = response.body;

      if(_resultAddCart.isEmpty) {

        print('Erro ao adicionar o produto. Tente novamente');
        mensagemToast('Erro ao adicionar o produto. Tente novamente');

      } else {

        mensagemToast('Produto adicionado com sucesso');
        // Navigator.pushNamed(context, '/carrinho');

      }

    } else {

      print('Erro 500');

    }


  }
  Widget _colorWidget(Color color, {bool isSelected = false}) {
    return CircleAvatar(
      radius: 12,
        backgroundColor: color.withAlpha(150),
      child: isSelected
      ? Icon(
        Icons.check_circle,
        color: color,
        size: 18,
      )
          : CircleAvatar(radius: 7, backgroundColor: color,)
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      onPressed: (){

        showDialog(context: context,
            builder: (context){
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),
                title: Text('Deseja adicionar ao carrinho'),
                titlePadding: EdgeInsets.all(20),
                titleTextStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.red
                ),
                content: Text(nome.toString(),
                    textAlign: TextAlign.center),
                contentPadding: EdgeInsets.all(20),
                actions: <Widget>[
                  RaisedButton(
                    child: Text("Sim"),
                    onPressed: (){
                      print('sim');
                      //addCart(this.idpecadetalhes,nome,valor.toString());
                      Navigator.pop(context);
                    },
                  ),
                  RaisedButton(
                    child: Text('Não'),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )
                ],

              );
            });
        //print('Clicado $indice');
      },
      backgroundColor: LightColor.red,
      child: Icon(Icons.shopping_cart,
      color: Theme.of(context).floatingActionButtonTheme.backgroundColor),

    );

}

  goCarrinho(){

    Navigator.pushNamed(context, '/carrinho');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          title: Text('Detalhes'),
          backgroundColor: Color.fromARGB(255, 204, 37, 1),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () async {
                goCarrinho();
                //Navigator.pushNamed(context, '/pecas');
              },
            ),
          ],
        ),
        //drawer: MenuDrawer(),
        floatingActionButton: _floatingActionButton(),
        body: SingleChildScrollView(
          child: Container(
            child: FutureBuilder(
              future: _recuperarDadosPecas(),
              builder: (context, snapshot){

                String resultado;

                switch(snapshot.connectionState) {
                  case ConnectionState.done :
                    print("done");

                    if (snapshot.hasError){

                      resultado = "Erro ao carregar os dados";
                      //print(snapshot.hasError);
                      print(snapshot.error);

                    } else {

                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(50),
                            child: Container(
                              padding: EdgeInsets.all(0),
                              child: Image.asset('assets/img/pecas/' + snapshot.data[0]['imagem'],
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(snapshot.data[0]['nome'] ?? '',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          Row(
                            children: <Widget>[

                              SizedBox(
                                width: 10,
                              ),
                              _colorWidget(LightColor.black, isSelected: true),
                              SizedBox(
                                width: 10,
                              ),

                              Text('Dados do Produto',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                  )

                              ),

                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),

                              SizedBox(width: 0),
                              Text("Dimensões",
                                style: TextStyle(
                                  fontSize: 18
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              _colorWidget(LightColor.red, isSelected: true),
                              SizedBox(
                                width: 10,
                              ),
                              Text(snapshot.data[0]['dimensoes'] ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),

                              SizedBox(width: 0),
                              Text('Peso',
                                style: TextStyle(
                                  fontSize: 18
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              _colorWidget(LightColor.red, isSelected: true),
                              SizedBox(
                                width: 10,
                              ),
                              Text(snapshot.data[0]['peso'].toString() + ' grama(s)'  ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),

                              SizedBox(width: 0),
                              Text("Garantia",
                                style: TextStyle(
                                  fontSize: 18
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              _colorWidget(LightColor.red, isSelected: true),
                              SizedBox(
                                width: 10,
                              ),
                              Text(snapshot.data[0]['garantia'] ?? '',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
//                          IconButton(
//                            icon: Icon(Icons.pin_drop),
//                            iconSize: 40,
//                            color: Colors.red,
//                            tooltip: 'Localização',
//                            onPressed: () {
//
//                            },
//                        ),
//                          MaterialButton(
//                            onPressed: (){
//                              //goMapa(snapshot.data[0]['latitude'],snapshot.data[0]['longitude']);
//                            },
//                            color: Colors.red,
//                            child: Text('Mapa de Localização',
//                              style: TextStyle(
//                                  fontSize: 20,
//                                  color: Colors.white
//                              ),
//                            ),
//                            elevation: 5,
//
//                          ),
//                          SizedBox(height: 20),
//                          MaterialButton(
//                            onPressed: (){},
//                            color: Colors.red,
//                            child: Text('Produtos',
//                              style: TextStyle(
//                                  fontSize: 20,
//                                  color: Colors.white
//                              ),
//                            ),
//                            elevation: 10,
//
//                          ),
                        ],

                      );


                    }

                    break;
                  case ConnectionState.waiting :
                  //print('waiting');

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          //backgroundColor: Colors.red,
                          strokeWidth: 5,
                        ),
                        SizedBox(height: 10),
                        Text('Carregando Dados...',
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),)
                      ],
                    );


                    break;
                  case ConnectionState.active :
                    print('active');
                    break;
                  case ConnectionState.none :
                    print('done');
                    break;
                }

                return Container(
                  child: Text('ok'),
                );





              },
            ),
          ),
        )
    );
  }
}
