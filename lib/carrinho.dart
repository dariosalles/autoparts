import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_parts/menuDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Carrinho extends StatefulWidget {
  @override
  _CarrinhoState createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {

  String email;


  initState() {

    _inicialCarrinho();


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

  List _itemsC = [];
  int _quantC = 0;
  String _apiC;

  // CARREGA AS PEÇAS INICIAIS
  _inicialCarrinho() async {

    // shared
    SharedPreferences sp = await SharedPreferences.getInstance();

    email = sp.getString('email');

    print(email);

    _apiC = 'http://www.dsxweb.com/apps/autoparts/api/apiRecupera_carrinho.php?token=$_token';

    print(_apiC);

    http.Response response;

    response = await http.post(_apiC, body: {'email': email});
    //response = await http.get(_apiC);

    print(response.body);

    if(response.statusCode==200) {

      setState(() {
        _itemsC = json.decode(response.body) as List;
        //print(_items);
      });

      setState(() {
        _quantC = _itemsC.length;
        //print(quant);
      });

      //print(_items);

    } else {

      print("Erro no servidor - 500");
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          title: Text('Carrinho'),
          backgroundColor: Color.fromARGB(255, 204, 37, 1),
        ),
        drawer: MenuDrawer(),
        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Text("Resumo do seu pedido",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),



                Expanded(

                  child: ListView.builder(
                      itemCount: _quantC,
                      itemBuilder: (context, indice){

                        return ListTile(
                            onTap: (){

                            },
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: AssetImage('assets/img/pecas/'+_itemsC[indice]['imagem'].toString()),
                                      radius: 50,
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Text(_itemsC[indice]['peca'].toString()),
                                        Text(_itemsC[indice]['valor'].toString()),
                                        Text('Quant: ' + _itemsC[indice]['quant'].toString()),
                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      color: Colors.red,
                                      iconSize: 40,
                                      tooltip: 'Excluir do Carrinho',
                                      onPressed: () {
                                        showDialog(context: context,
                                            builder: (context){
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                                                ),
                                                title: Text('Deseja excluir do carrinho'),
                                                titlePadding: EdgeInsets.all(20),
                                                titleTextStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red
                                                ),
                                                content: Text(_itemsC[indice]['peca'].toString(),
                                                    textAlign: TextAlign.center),
                                                contentPadding: EdgeInsets.all(20),
                                                actions: <Widget>[
                                                  RaisedButton(
                                                    child: Text("Sim"),
                                                    onPressed: (){
                                                      print('sim');
                                                      //removeCart(_itemsC[indice]['id_peca']);
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
        ),
      //bottomNavigationBar: BottomNav(),
    );
  }
}
