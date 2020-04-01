import 'package:auto_parts/themes/light_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themes/light_color.dart';

//import 'package:auto_parts/pecas.dart';


class Detalhes extends StatefulWidget {
  @override
  _DetalhesState createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes> {

  String idpecadetalhes;
  String imagem;
  String nome;
  double valor;
  String dimensoes;
  String peso;
  String garantia;

  //TOKEN
  int _token = 123456789;

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

//  AnimationController controller;
//  Animation<double> animation;
// @override
//  void initState() {
//    super.initState();
//
////    controller =
////        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
////    animation = Tween<double>(begin: 0, end: 1).animate(
////        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
////    controller.forward();
//
//    //_recuperaIdPeca();
//    //inicialDetalhes(idpecadetalhes);
//
//  }

//  _recuperaIdPeca() async {
//
//    SharedPreferences sp = await SharedPreferences.getInstance();
//    String idpecadetalhes = sp.getString('idpeca');
//
//    print('Detalhes - ID PECA: $idpecadetalhes');
//
//    //inicialDetalhes(idpecadetalhes);
//  }




  // CARREGA OS DADOS - DETALHES DAS PEÇAS
  Future<List> _recuperarDadosPecas() async {

    SharedPreferences sp = await SharedPreferences.getInstance();

    idpecadetalhes = sp.getString('idpeca');

    _apiDetalhes =
    'http://www.dsxweb.com/apps/autoparts/api/apiRecupera_pecas_detalhes.php?token=$_token&id_peca=$idpecadetalhes';

    print(_apiDetalhes);

    http.Response response;

    response = await http.get(_apiDetalhes);

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
    String apiAddCart = 'http://www.dsxweb.com/apps/autoparts/api/apiInsereCarrinho8.php?token=$_token';

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
//
//  // GET TOTAL
//  getValor() {
//
//    NumberFormat formatter = NumberFormat("00.00");
//
//
//    double total = 0;
//
//    total = double.parse(_itemsD[0]['valor']);
//
//
//    //print('Total ' + total.toString());
//
//    return formatter.format(total);
//
//  }

//  Widget _detalhesImage() {
//
//    return AnimatedBuilder(
//      builder: (context, child) {
//        return AnimatedOpacity(
//          duration: Duration(milliseconds: 500),
//          opacity: animation.value,
//          child: child,
//        );
//      },
//      animation: animation,
//      child: Stack(
//        alignment: Alignment.center,
//        children: <Widget>[
//          TitleText(
//            text: "Auto Parts",
//            fontSize: 100,
//            color: Colors.red,
//          ),
//          //Image.asset('assets/img/pecas/' + _itemsD[0]['imagem'].toString())
//          Image.asset('assets/img/pecas/$imagem')
//        ],
//      ),
//    );
//
//  }
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

//  Widget _dimensoes() {
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Row(
//          children: <Widget>[
//            Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                _colorWidget(LightColor.black, isSelected: true),
//                SizedBox(
//                  width: 10,
//                ),
//                Text('Dados do produto na embalagem',
//                style: TextStyle(
//                    fontWeight: FontWeight.bold,
//                    fontSize: 20
//                ),
//                )
//              ],
//            )
//
//          ],
//        ),
//        SizedBox(height: 20),
//        TitleText(
//          text: "Dimensões",
//          fontSize: 18,
//        ),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            SizedBox(
//              height: 15,
//            ),
//            _colorWidget(LightColor.red, isSelected: true),
//          SizedBox(
//            width: 15,
//          ),
//            //_colorWidget(LightColor.lightBlue),
//          Text(dimensoes  ?? '',
//          style: TextStyle(
//            fontWeight: FontWeight.bold,
//            fontSize: 16
//          ),
//          )
//          ],
//        ),
//        SizedBox(
//          height: 15,
//        ),
//        TitleText(
//          text: "Peso",
//          fontSize: 18,
//        ),
//        //SizedBox(height: 20),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            _colorWidget(LightColor.red, isSelected: true),
//            SizedBox(
//              width: 15,
//            ),
//            //_colorWidget(LightColor.lightBlue),
//            Text('$peso grama(s)' ?? '',
//              style: TextStyle(
//                  fontWeight: FontWeight.bold,
//                  fontSize: 16
//              ),
//            )
//          ],
//        ),
//        SizedBox(
//          height: 15,
//        ),
//        TitleText(
//          text: "Garantia",
//          fontSize: 18,
//        ),
//        //SizedBox(height: 20),
//        Row(
//          mainAxisAlignment: MainAxisAlignment.start,
//          children: <Widget>[
//            _colorWidget(LightColor.red, isSelected: true),
//            SizedBox(
//              width: 15,
//            ),
//            //_colorWidget(LightColor.lightBlue),
//            Text(garantia ?? '',
//              style: TextStyle(
//                  fontWeight: FontWeight.bold,
//                  fontSize: 16
//              ),
//            )
//          ],
//        )
//      ],
//    );
//
//  }

//  Widget _detalhesWidget() {
//
//    return DraggableScrollableSheet(
//        maxChildSize: .8,
//        initialChildSize: .53,
//        minChildSize: .53,
//        builder: (context, scrollController) {
//          return Container(
//            padding: AppTheme.padding.copyWith(bottom: 0),
//            //padding: EdgeInsets.only(bottom: 0),
//            decoration: BoxDecoration(
//                borderRadius: BorderRadius.only(
//                  topLeft: Radius.circular(40),
//                  topRight: Radius.circular(40),
//                ),
//                color: Colors.white),
//            child: SingleChildScrollView(
//              controller: scrollController,
//              child: Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisSize: MainAxisSize.max,
//                children: <Widget>[
//                  SizedBox(height: 5),
//                  Container(
//                    alignment: Alignment.center,
//                    child: Container(
//                      width: 50,
//                      height: 5,
//                      decoration: BoxDecoration(
//                          color: LightColor.iconColor,
//                          borderRadius: BorderRadius.all(Radius.circular(10))),
//                    ),
//                  ),
//                  SizedBox(height: 10),
//                  Container(
//                    child: Row(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        TitleText(text: nome ?? '', fontSize: 25),
//                        //TitleText(text: 'escapamento'.toUpperCase(), fontSize: 25),
//                        Column(
//                          crossAxisAlignment: CrossAxisAlignment.end,
//                          children: <Widget>[
//                            Row(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                TitleText(
//                                  text: "R\$ ",
//                                  fontSize: 18,
//                                  color: LightColor.red,
//                                ),
//                                Text(valor.toString(),
//                                    style: TextStyle(
//                                      fontSize: 20,
//                                      color: LightColor.red,
//                                      fontWeight: FontWeight.bold
//                                    ),
//                                ),
//                              ],
//                            ),
//                            Row(
//                              children: <Widget>[
//                                Icon(Icons.star,
//                                    color: LightColor.red, size: 17),
//                                Icon(Icons.star,
//                                    color: LightColor.red, size: 17),
//                                Icon(Icons.star,
//                                    color: LightColor.red, size: 17),
//                                Icon(Icons.star,
//                                    color: LightColor.red, size: 17),
//                                Icon(Icons.star,
//                                    color: LightColor.red, size: 17),
//                              ],
//                            ),
//                          ],
//                        ),
//                      ],
//                    ),
//                  ),
//                SizedBox(
//                  height: 20,
//                ),
//                _dimensoes(),
//                SizedBox(
//                  height: 20,
//                ),
//                //_availableColor(),
//                SizedBox(
//                  height: 20,
//                ),
//                  //_description(),
//                ],
//              ),
//            ),
//          );
//        },
//      );
//
//  }

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
                      addCart(idpecadetalhes.toString(),nome,valor.toString());
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
