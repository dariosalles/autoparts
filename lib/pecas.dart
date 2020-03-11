import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'menuDrawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

// PAGE PEÇAS
class Pecas extends StatefulWidget {
  @override
  _PecasState createState() => _PecasState();
}

class _PecasState extends State<Pecas>  {

  String email;

  //TOKEN
  int _token = 123456789;

  //CONTROLLER - BUSCA - RECUPERA O QUE FOI DIGITADO
  TextEditingController _controllerBusca = TextEditingController();

  List _items = [];
  int _quant = 0;
  String _api;

  initState() {

    _inicialPecas();

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

      //print(_items);

    } else {

      print("Erro no servidor - 500");
    }

  }

  // BUSCA PEÇAS
  _buscaPecas() async {

    var _busca = _controllerBusca.text.trim();
    print(_busca);

    String _api = 'http://www.dsxweb.com/apps/autoparts/api/apiRecupera_pecas22.php?token=$_token&busca=$_busca';

    //print(_api);

    http.Response response;

    response = await http.get(_api);

    setState(() {
      _items = json.decode(response.body) as List;
    });

    setState(() {
      _quant = _items.length;
    });

  }

  // ADICIONA PRODUTO NO CARRINHO
  addCart(idpeca, nome, valor) async {

    //int idpeca;

    // shared
    SharedPreferences sp = await SharedPreferences.getInstance();


    // String apiAddCart
    String apiAddCart = 'http://www.dsxweb.com/apps/autoparts/api/apiInsereCarrinho8.php?token=$_token';

    //print(apiAddCart);

    http.Response response;

    // campos teste
    String _idusuario = sp.getString('id_usuario');
    String _email = sp.getString('email'); //'dariosalles@gmail.com';
    String _peca = nome;
    String _idpeca = idpeca.toString();
    String _quant = '1';
    String _valor = valor;

    Map<dynamic, dynamic> _corpo = {'id_usuario': _idusuario, 'email': _email, 'id_peca': _idpeca, 'peca': _peca, 'quant': _quant, 'valor': _valor };

    print('Map Corpo $_corpo');

    response = await http.post(apiAddCart, body: _corpo);

    //print(response.body);


    if (response.statusCode == 200) {


      String _resultAddCart = response.body;


      // print('Resultado: $_result');


      if(_resultAddCart.isEmpty) {

        print('Erro ao adicionar o produto. Tente novamente');
        mensagemToast('Erro ao adicionar o produto. Tente novamente');


      } else {

       //print('Produto adicionado com sucesso');
       mensagemToast('Produto adicionado com sucesso');
       // Navigator.pushNamed(context, '/carrinho');

      }



    } else {

      print('Erro 500');

    }



  }

  goCarrinho(){

    Navigator.pushNamed(context, '/carrinho');
  }

  goDetalhes(idpeca) async{

    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString('idpeca', idpeca);

    idpeca = sp.getString('idpeca');

    print('ID PECA: $idpeca');

    Navigator.pushNamed(context, '/detalhes');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text('Peças'),
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
                            goDetalhes(_items[indice]['id_peca'].toString());
                        },
                          title: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[

                                  Text(_items[indice]['nome'].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),)
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  CircleAvatar(
                                   backgroundImage: AssetImage('assets/img/pecas/' + _items[indice]['imagem'].toString(),
                                    ),
                                    radius: 50,

                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(_items[indice]['marca'].toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),
                                      ),
                                      Text(_items[indice]['modelo'].toString()),
                                      Text('R\$ ' + _items[indice]['valor'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 20
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_circle),
                                    color: Colors.green,
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
                                                addCart(_items[indice]['id_peca'],_items[indice]['nome'],_items[indice]['valor']);
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

                              Divider(
                                color: Colors.black12,
                                height: 20,
                                thickness: 2,
                              )
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