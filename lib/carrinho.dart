import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auto_parts/menuDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Carrinho extends StatefulWidget {
  @override
  _CarrinhoState createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {

  NumberFormat formatter = NumberFormat("00.00");

//  initState() {
//
//    //getTotal();
//
//  }

  String email;

  //TOKEN
  int _token = 123456789;
  int quant = 0;
  List _itemsC = [];
  String _apiC;
  //double total;
  String totalg;

  // MENSAGENS AMIGAVEIS
  mensagemToast(String msg) {

    return Fluttertoast.showToast(

        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 3,
        backgroundColor: Color.fromARGB(255, 214, 37, 1),
        textColor: Colors.white,
        fontSize: 16.0
    );


  }

  Future<List> _recuperarCarrinho() async {

    // shared
    SharedPreferences sp = await SharedPreferences.getInstance();
    email = sp.getString('email');

    //print(email);

    _apiC = 'http://www.dsxweb.com/apps/autoparts/api/apiRecupera_carrinho.php?token=$_token';

    //print(_apiC);

    http.Response response;

    response = await http.post(_apiC, body: {'email': email});


    _itemsC = json.decode(response.body) as List;

    //NumberFormat formatter = NumberFormat("00.00");
    double total = 0;
    for(int i=0;i<_itemsC.length;i++) {
      total += double.parse(_itemsC[i]['valor']);
      //print('Total ' + total.toString());
    }

    //setState(() {
      totalg = total.toString();
    //});

      //print(totalg);

    //getTotal();

    return _itemsC;

  }


  getTotal() {

    //NumberFormat formatter = NumberFormat("00.00");
    double total = 0;
    for(int i=0;i<_itemsC.length;i++) {
      total += double.parse(_itemsC[i]['valor']);
    }

      //setState(() {
        totalg = total.toString();
      //});
      return totalg;
      //print('Total: ' + totalg);

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

    //print(response.body);


    if (response.statusCode == 200) {
      String _resultaumentaQtde = response.body;


      print('Resultado: $_resultaumentaQtde');


      if (_resultaumentaQtde.isEmpty) {
        print('Erro ao aumentar a quantidade do produto. Tente novamente');
        mensagemToast('Erro ao aumentar a quantidade do produto. Tente novamente');
      } else {

        //getTotal();

        print('Quantidade aumentada com sucesso');
        mensagemToast('Quantidade aumentada com sucesso');
        Navigator.pushNamed(context, '/carrinho');

      }
    } else {
      print('Erro 500');
    }



  }

  // DIMINUI QUANTIDADE DO PRODUTO
  diminuiQtde(idcarrinho,valor,qtde) async {

    // String apiAddCart
    String apidiminuiQtde = 'http://www.dsxweb.com/apps/autoparts/api/apiDiminui_qtde.php?token=$_token';

    String _idcarrinho = idcarrinho.toString();
    String _valor = valor.toString();
    String _qtde = qtde.toString();

    http.Response response;

    Map<dynamic, dynamic> _corpo = {
      'id_carrinho': _idcarrinho,
      'valor': _valor,
      'qtde': _qtde
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
        //getTotal();

        if(_resultdiminuiQtde=='qtdeminima') {

          print('Quantidade mínima já atingida');
          mensagemToast('Quantidade mínima já atingida');

        } else {

          print('Quantidade diminuida com sucesso');
          mensagemToast('Quantidade diminuida com sucesso');
          Navigator.pushNamed(context, '/carrinho');

        }

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

                  child: FutureBuilder(
                    future: _recuperarCarrinho(),
                    builder: (context, snapshot){

                      String resultado;

                      switch(snapshot.connectionState) {

                        //DONE
                        case ConnectionState.done :
                          //print("done");

                          if (snapshot.hasError){

                            resultado = "Erro ao carregar os dados";
                            //print(snapshot.hasError);
                            //print(snapshot.error);

                          } else {

                            if(snapshot.data.length==0) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      IconButton(
                                        icon: Icon(Icons.remove_shopping_cart),
                                        color: Colors.green,
                                        iconSize: 25,
                                        tooltip: 'Carrinho Free',

                                      ),
                                      Text("Carrinho vazio",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          color: Colors.red
                                        ),
                                      ),
                                    ],
                                  );
                              }

                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, indice){

                                  return ListTile(

                                    onTap: (){

                                    },
                                    title: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[

                                        Row(
                                          children: <Widget>[

                                            Text(snapshot.data[indice]['peca'].toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold
                                              ),)
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            CircleAvatar(
                                              backgroundImage: AssetImage('assets/img/pecas/'+snapshot.data[indice]['imagem'].toString()),
                                              radius: 50,
                                            ),

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
                                                    valorp = double.parse(snapshot.data[indice]['valor']);
                                                    quantp = double.parse(snapshot.data[indice]['quant']);
                                                    double valorpeca = valorp / quantp;
                                                    print(valorpeca);

                                                    aumentaQtde(snapshot.data[indice]['id_carrinho'].toString(),valorpeca);
                                                  },
                                                ),

                                                Text('x ' + snapshot.data[indice]['quant'].toString(),
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
                                                    valorp = double.parse(snapshot.data[indice]['valor']);
                                                    quantp = double.parse(snapshot.data[indice]['quant']);
                                                    double valorpeca = valorp / quantp;
                                                    print(valorpeca);

                                                    diminuiQtde(snapshot.data[indice]['id_carrinho'].toString(),valorpeca,quantp);
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
                                                        content: Text(snapshot.data[indice]['peca'].toString(),
                                                            textAlign: TextAlign.center),
                                                        contentPadding: EdgeInsets.all(20),
                                                        actions: <Widget>[
                                                          RaisedButton(
                                                            child: Text("Sim"),
                                                            onPressed: (){
                                                              print('sim');
                                                              removeCart(snapshot.data[indice]['id_peca']);
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
                                            Text('= R\$ ' + snapshot.data[indice]['valor'])
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.black26,
                                          height: 20,
                                          thickness: 2,
                                        ),

                                      ],
                                    ),

                                  );

                                });

                          }
                          break;

                      //WAITING
                        case ConnectionState.waiting :

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
                              Text('Carregando Carrinho...',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                ),)
                            ],
                          );
                          break;

                      //ACTIVE
                        case ConnectionState.active :
                        //print('conexao active');
                          break;
                      //NONE
                          case ConnectionState.none :
                          print('conexao none');
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

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 10, top: 10),
                      child: Row(
                        children: <Widget>[
                          Text("Total:" + getTotal(),
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                  height: 50,
                    minWidth: 400,
                  onPressed: (){
                    //getAcesso();
                    Navigator.pushNamed(context, '/finaliza');
                  },//since this is only a UI app
                  child: Text('Finalizar Pagamento',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'SFUIDisplay',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Color.fromARGB(255, 204, 37, 1),
                  //color: Color(0xffff2d55),
                  elevation: 0,

                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                ),
              ],
            )
        ),
      //bottomNavigationBar: BottomNav(),
    );
  }
}