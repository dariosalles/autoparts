import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'menuDrawer.dart';

class Fornecedores extends StatefulWidget {
  @override
  _FornecedoresState createState() => _FornecedoresState();
}

class _FornecedoresState extends State<Fornecedores> {

  String email;

  initState() {

    _inicialFornecedores();


  }

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

  //TOKEN
  int _token = 123456789;

  //CONTROLLER - BUSCA - RECUPERA O QUE FOI DIGITADO
  TextEditingController _controllerBuscaF = TextEditingController();

  List _itemsF = [];
  int _quantF = 0;
  String _apiF;

  // CARREGA OS FORNECEDORES INICIAIS
  _inicialFornecedores() async {

    _apiF = 'http://www.dsxweb.com/apps/autoparts/api/apiRecupera_fornecedores.php?token=$_token';

    http.Response response;

    response = await http.get(_apiF);

    if(response.statusCode==200) {

      setState(() {
        _itemsF = json.decode(response.body) as List;
        //print(_items);
      });

      setState(() {
        _quantF = _itemsF.length;
        //print(quant);
      });

    } else {

      print("Erro no servidor - 500");
    }

  }

  // BUSCA PEÇAS
  _buscaFornecedores() async {

    var _buscaF = _controllerBuscaF.text.trim();
    print(_buscaF);

    String _apiF = 'http://www.dsxweb.com/apps/autoparts/api/apiRecupera_fornecedores.php?token=$_token&busca=$_buscaF';

    print(_apiF);

    http.Response response;

    response = await http.get(_apiF);

    setState(() {
      _itemsF = json.decode(response.body) as List;
    });

    setState(() {
      _quantF = _itemsF.length;
    });

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
                TextField(
                  cursorWidth: 2,
                  keyboardType: TextInputType.text,
                  maxLength: 30,
                  decoration: InputDecoration(
                      labelText: "Buscar Fornecedores",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          gapPadding: 4.00
                      )
                  ),
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                  controller: _controllerBuscaF,
                ),
                RaisedButton(
                  child: Text('Buscar'),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: (){
                    _buscaFornecedores();
                  },
                ),

                Expanded(
                  child: ListView.builder(
                      itemCount: _quantF,
                      itemBuilder: (context, indice){

                        return ListTile(
                            onTap: (){

                            },
                            title: Column(
                              children: <Widget>[
                                //Text("titulo"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Image.asset('assets/img/fornecedores/' + _itemsF[indice]['imagem'].toString(),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(_itemsF[indice]['fornecedor'].toString()),
                                        Text(_itemsF[indice]['descricao'].toString()),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.arrow_forward_ios),
                                      color: Colors.red,
                                      iconSize: 40,
                                      tooltip: 'Adicionar ao Carrinho',
                                      onPressed: () {
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
                                                content: Text(_itemsF[indice]['nome'].toString(),
                                                    textAlign: TextAlign.center),
                                                contentPadding: EdgeInsets.all(20),
                                                actions: <Widget>[
                                                  RaisedButton(
                                                    child: Text("Sim"),
                                                    onPressed: (){
                                                      print('sim');
                                                      (){};
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
                                    ),

                                  ],
                                ),
                              ],
                            )
                        );

                      }),
                )
              ],
            )
        ));
  }
}