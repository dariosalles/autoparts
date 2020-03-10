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

  //TOKEN
  int _token = 123456789;

  List _itemsC = [];
  int _quantC = 0;
  String _apiC;


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

  // CARREGA AS PEÇAS INICIAIS
  _inicialCarrinho() async {

    // shared
    SharedPreferences sp = await SharedPreferences.getInstance();

    email = sp.getString('email');

    //print(email);

    _apiC = 'http://www.dsxweb.com/apps/autoparts/api/apiRecupera_carrinho.php?token=$_token';

    //print(_apiC);

    http.Response response;

    response = await http.post(_apiC, body: {'email': email});
    //response = await http.get(_apiC);

    //print(response.body);

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

  // AUMENTA QUANTIDADE DO PRODUTO
  aumentaQtde(idcarrinho,valor) async {

    // String apiAddCart
    String apiaumentaQtde = 'http://www.dsxweb.com/apps/autoparts/api/apiAumenta_qtde.php?token=$_token';

    String _idcarrinho = idcarrinho.toString();
    String _valor = valor.toString();

    http.Response response;

    Map<dynamic, dynamic> _corpo = {
      'id_carrinho': _idcarrinho,
      'valor': _valor
    };


    response = await http.post(apiaumentaQtde, body: _corpo);

    print(response.body);


    if (response.statusCode == 200) {
      String _resultaumentaQtde = response.body;


      print('Resultado: $_resultaumentaQtde');


      if (_resultaumentaQtde.isEmpty) {
        print('Erro ao aumentar a quantidade do produto. Tente novamente');
        mensagemToast('Erro ao aumentar a quantidade do produto. Tente novamente');
      } else {
        print('Quantidade aumentada com sucesso');
        mensagemToast('Quantidade aumentada com sucesso');
        Navigator.pushNamed(context, '/carrinho');

      }
    } else {
      print('Erro 500');
    }



  }

  // DIMINUI QUANTIDADE DO PRODUTO
  diminuiQtde(idcarrinho,valor) async {

    // String apiAddCart
    String apidiminuiQtde = 'http://www.dsxweb.com/apps/autoparts/api/apiDiminui_qtde.php?token=$_token';

    String _idcarrinho = idcarrinho.toString();
    String _valor = valor.toString();

    http.Response response;

    Map<dynamic, dynamic> _corpo = {
      'id_carrinho': _idcarrinho,
      'valor': _valor
    };


    response = await http.post(apidiminuiQtde, body: _corpo);

    print(response.body);


    if (response.statusCode == 200) {
      String _resultdiminuiQtde = response.body;


      print('Resultado: $_resultdiminuiQtde');


      if (_resultdiminuiQtde.isEmpty) {
        print('Erro ao diminuir a quantidade do produto. Tente novamente');
        mensagemToast('Erro ao diminuir a quantidade do produto. Tente novamente');
      } else {
        print('Quantidade diminuida com sucesso');
        mensagemToast('Quantidade diminuida com sucesso');
        Navigator.pushNamed(context, '/carrinho');

      }
    } else {
      print('Erro 500');
    }



  }

  //REMOVE A PEÇA DO CARRINHO
  removeCart(idpeca) async {
    // shared
    SharedPreferences sp = await SharedPreferences.getInstance();


    // String apiAddCart
    String apiremoveCart = 'http://www.dsxweb.com/apps/autoparts/api/apiRemove_carrinho.php?token=$_token';

    print(apiremoveCart);

    http.Response response;

    // campos teste
    String _idusuario = sp.getString('id_usuario');
    String _email = sp.getString('email'); //'dariosalles@gmail.com';
    String _idpeca = idpeca.toString();


    Map<dynamic, dynamic> _corpo = {
      'id_usuario': _idusuario,
      'email': _email,
      'id_peca': _idpeca
    };

    print('Map Corpo $_corpo');

    response = await http.post(apiremoveCart, body: _corpo);

    //print(response.body);


    if (response.statusCode == 200) {
      String _resultremoveCart = response.body;


      print('Resultado: $_resultremoveCart');


      if (_resultremoveCart.isEmpty) {
        print('Erro ao excluir o produto. Tente novamente');
        mensagemToast('Erro ao excluir o produto. Tente novamente');
      } else {
        //print('Produto adicionado com sucesso');
        mensagemToast('Produto excluido com sucesso');
        Navigator.pushNamed(context, '/carrinho');

      }
    } else {
      print('Erro 500');
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
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text("Resumo do seu pedido",
                    style: TextStyle(
                      fontSize: 25,
                    ),
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
                                  children: <Widget>[

                                    Text(_itemsC[indice]['peca'].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: AssetImage('assets/img/pecas/'+_itemsC[indice]['imagem'].toString()),
                                      radius: 50,
                                    ),
//                                    Column(
//                                      children: <Widget>[
//                                        Text(_itemsC[indice]['peca'].toString()),
//                                        Text(_itemsC[indice]['valor'].toString()),
//                                        //Text('Quant: ' + _itemsC[indice]['quant'].toString()),
//                                      ],
//                                    ),
//                                    Column(
//                                      children: <Widget>[
//                                        Text('x ' + _itemsC[indice]['quant'].toString(),
//                                        style: TextStyle(
//                                          fontWeight: FontWeight.bold
//                                        ),
//                                        ),
//                                      ],
//                                    ),
                                    Column(
                                      children: <Widget>[

                                        IconButton(
                                          icon: Icon(Icons.add_circle),
                                          color: Colors.green,
                                          iconSize: 25,
                                          tooltip: 'Excluir do Carrinho',
                                          onPressed: () {
                                           print('Clicado +');

                                           double valorp;
                                           double quantp;
                                           valorp = double.parse(_itemsC[indice]['valor']);
                                           quantp = double.parse(_itemsC[indice]['quant']);
                                           double valorpeca = valorp / quantp;
                                           print(valorpeca);

                                           aumentaQtde(_itemsC[indice]['id_carrinho'].toString(),valorpeca);
                                          },
                                        ),

                                        Text('x ' + _itemsC[indice]['quant'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.remove_circle),
                                          color: Colors.lightBlue,
                                          iconSize: 25,
                                          tooltip: 'Excluir do Carrinho',
                                          onPressed: () {
                                            print('Clicado -');

                                            double valorp;
                                            double quantp;
                                            valorp = double.parse(_itemsC[indice]['valor']);
                                            quantp = double.parse(_itemsC[indice]['quant']);
                                            double valorpeca = valorp / quantp;
                                            print(valorpeca);

                                            diminuiQtde(_itemsC[indice]['id_carrinho'].toString(),valorpeca);
                                          },
                                        ),

                                      ],
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                      iconSize: 30,
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
                                                      removeCart(_itemsC[indice]['id_peca']);
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text('= RS ' +_itemsC[indice]['valor'])
                                  ],
                                ),
                              Divider(
                                color: Colors.black26,
                                height: 20,
                                thickness: 2,
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