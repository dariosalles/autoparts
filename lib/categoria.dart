import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'menuDrawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_parts/include_categorias.dart';

class Categoria extends StatefulWidget {
  @override
  _CategoriaState createState() => _CategoriaState();
}

class _CategoriaState extends State<Categoria>  {

  //TOKEN
  int _token = 123456789;

  List _itemsCat = [];

  String urlcat;

  String id_categoria;

  //CONTROLLER - BUSCA - RECUPERA O QUE FOI DIGITADO
  TextEditingController _controllerBuscaCategoria = TextEditingController();

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


  Future<List> _recuperarCategoria() async {

    //RECUPERA O IDCATEGORIA
    SharedPreferences sp = await SharedPreferences.getInstance();
    String id_categoria = sp.getString('id_categoria');

    var _buscaCategoria = _controllerBuscaCategoria.text.trim();
    //print(_buscaCategoria);

    if(_buscaCategoria.isEmpty) {

      //setState(() {
        urlcat = "http://www.dsxweb.com/apps/autoparts/api/apiRecupera_categoria.php?token=$_token&id_categoria=$id_categoria";

      //});

      print(urlcat);

    } else {

        //setState(() {
          urlcat = 'http://www.dsxweb.com/apps/autoparts/api/apiRecupera_categoria.php?token=$_token&id_categoria=$id_categoria&busca=$_buscaCategoria';
        //});

        //print(urlcat);
    }

    //print(urlcat);


    http.Response response = await http.get(urlcat);

    _itemsCat = json.decode(response.body) as List;

    return _itemsCat;

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

          title: Text('Categoria'),
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
            padding: EdgeInsets.all(0),
            child: Column(
              children: <Widget>[
                Categorias(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
//                    Container(
//                      width: 250,
//                      child:
//                      TextField(
//                        cursorWidth: 2,
//                        keyboardType: TextInputType.text,
//                        maxLength: 30,
//                        decoration: InputDecoration(
//                            labelText: "Buscar peça na categoria",
//
//                            border: OutlineInputBorder(
//                                borderRadius: BorderRadius.all(Radius.circular(10)),
//                                gapPadding: 4.00
//                            )
//                        ),
//                        style: TextStyle(
//                          fontSize: 20,
//                          color: Colors.black,
//                        ),
//                        controller: _controllerBuscaCategoria,
//                      ),
//                    ),
//                    SizedBox(width: 15,),
//                    Container(
//                      width: 100,
//                      child:
//                      RaisedButton(
//                        child: Text('Buscar'),
//                        color: Colors.red,
//                        textColor: Colors.white,
//                        onPressed: (){
//
//                          _recuperarCategoria();
//                        },
//                      ),
//
//                    ),
                  ],
                ),

                Expanded(
                  child: FutureBuilder(
                    future: _recuperarCategoria(),
                    builder: (context, snapshot){

                      String resultado;

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
                                      goDetalhes(snapshot.data[indice]['id_peca']
                                          .toString());
                                    },
                                    title: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(snapshot.data[indice]['nome'].toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            CircleAvatar(
                                              backgroundImage: AssetImage('assets/img/pecas/' + snapshot.data[indice]['imagem'].toString(),
                                              ),
                                              radius: 50,

                                            ),
                                            Column(
                                              children: <Widget>[
                                                Text(snapshot.data[indice]['marca'].toString(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                                Text(snapshot.data[indice]['modelo'].toString()),
                                                Text('R\$ ' + snapshot.data[indice]['valor'].toString(),
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
                                                        content: Text(_itemsCat[indice]['nome'].toString(),
                                                            textAlign: TextAlign.center),
                                                        contentPadding: EdgeInsets.all(20),
                                                        actions: <Widget>[
                                                          RaisedButton(
                                                            child: Text("Sim"),
                                                            onPressed: (){
                                                              print('sim');
                                                              addCart(_itemsCat[indice]['id_peca'],_itemsCat[indice]['nome'],_itemsCat[indice]['valor']);
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
                              SizedBox(height: 10),
                              Text('Carregando Categoria...',
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
    //bottomNavigationBar: BottomNav());
  }
}