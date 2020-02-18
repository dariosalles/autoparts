import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'menuDrawer.dart';

// PAGE PEÇAS
class Pecas extends StatefulWidget {
  @override
  _PecasState createState() => _PecasState();
}

class _PecasState extends State<Pecas> {


  initState() {

    _inicialPecas();

  }

  //TOKEN
  int _token = 123456789;

  //CONTROLLER - BUSCA - RECUPERA O QUE FOI DIGITADO
  TextEditingController _controllerBusca = TextEditingController();

  List _items = [];
  int _quant = 0;
  String _api;

  // CARREGA AS PEÇAS INICIAIS
  _inicialPecas() async {

    _api = 'http://www.dsxweb.com/apps/autoparts/api/apiRecupera_pecas22.php?token=$_token';

    http.Response response;

    response = await http.get(_api);

    if(response.statusCode==200) {

      setState(() {
        _items = json.decode(response.body) as List;
        //print(_items);
      });

      setState(() {
        _quant = _items.length;
        //print(quant);
      });

    } else {

      print("Erro no servidor - 500");
    }

  }

  // BUSCA PEÇAS
  _buscaPecas() async {

    var _busca = _controllerBusca.text.trim();
    print(_busca);

    String _api = 'http://www.dsxweb.com/apps/autoparts/api/apiRecupera_pecas22.php?token=$_token&busca=$_busca';

    print(_api);

    http.Response response;

    response = await http.get(_api);

    setState(() {
      _items = json.decode(response.body) as List;
    });

    setState(() {
      _quant = _items.length;
    });

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text('Peças'),
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
                    labelText: "Buscar peça",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        gapPadding: 4.00
                    )
                ),
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
                controller: _controllerBusca,
              ),
              RaisedButton(
                child: Text('Buscar'),
                color: Colors.red,
                textColor: Colors.white,
                onPressed: (){
                  _buscaPecas();
                },
              ),

              Expanded(
                child: ListView.builder(
                    itemCount: _quant,
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
                                  Image.asset('assets/img/pecas/' + _items[indice]['imagem'].toString(),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(_items[indice]['nome'].toString()),
                                      Text(_items[indice]['modelo'].toString()),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_circle),
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
                                          content: Text(_items[indice]['nome'].toString(),
                                          textAlign: TextAlign.center),
                                          contentPadding: EdgeInsets.all(20),
                                          actions: <Widget>[
                                            RaisedButton(
                                              child: Text("Sim"),
                                              onPressed: (){
                                                print('sim');
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
      //bottomNavigationBar: BottomNav());
  }
}