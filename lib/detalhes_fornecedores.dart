import 'package:auto_parts/themes/light_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/title_text.dart';
import 'themes/light_color.dart';

class DetalhesFornecedores extends StatefulWidget {
  @override
  _DetalhesFornecedoresState createState() => _DetalhesFornecedoresState();
}

class _DetalhesFornecedoresState extends State<DetalhesFornecedores>
    with TickerProviderStateMixin {

  String id_fornecedor;
  String fornecedor;
  String endereco;
  String bairro;
  String cidade;
  String estado;
  int cep;
  double latitude;
  double longitude;
  int telefone;
  String descricao;
  String imagem;
  String site;
//TOKEN
  int _token = 123456789;

  List _itemsDF = [];
  //int _quantD = 0;
  String _apiDetalhesF;

//  AnimationController controller;
//  Animation<double> animation;

//  @override
//  void initState() {
//    super.initState();
////
////    controller =
////        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
////    animation = Tween<double>(begin: 0, end: 1).animate(
////        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
////    controller.forward();
//
//    //_recuperaIdFornecedor();
//
//
//  }

//  _recuperaIdFornecedor() async {
//
//
//    //return idforndetalhes;
//
//    //inicialDetalhesF(idforndetalhes);
//  }

  // CARREGA OS DADOS - DETALHES DO FORNECEDOR
  Future<List> _recuperarDadosFornecedores() async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    String idforndetalhes = sp.getString('idfornecedor');

    //print('Detalhes - ID Fornecedor: $idforndetalhes');

    _apiDetalhesF =
    'http://www.dsxweb.com/apps/autoparts/api/apiRecupera_fornecedor_detalhes.php?token=$_token&id_fornecedor=$idforndetalhes';

    //print(_apiDetalhesF);

    http.Response response;

    response = await http.get(_apiDetalhesF);

    _itemsDF = json.decode(response.body) as List;
    //print(_itemsDF);

      fornecedor = _itemsDF[0]['fornecedor'];


//    endereco = _itemsDF[0]['endereco'];
//    bairro = _itemsDF[0]['bairro'];
//    cidade = _itemsDF[0]['cidade'];
//    estado = _itemsDF[0]['estado'];
//    cep = _itemsDF[0]['cep'];
//    latitude = _itemsDF[0]['latitude'];
//    longitude = _itemsDF[0]['longitude'];
//    telefone = _itemsDF[0]['telefone'];
//    descricao = _itemsDF[0]['descricao'];

      imagem = _itemsDF[0]['imagem'];
      print(imagem);


//    site = _itemsDF[0]['site'];

    return _itemsDF;


  }

  goMapa(double latitude, double longitude) async {

    //guarda email
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setDouble('latitude', latitude);
    sp.setDouble('longitude', longitude);

    Navigator.pushNamed(context, '/fornecedormapa');
  }

//  Widget _detalhesFImage() {
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
//            color: Colors.transparent,
//          ),
//          //Image.asset('assets/img/pecas/' + _itemsD[0]['imagem'].toString())
//          Image.asset('assets/img/fornecedores/$imagem')
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

//  Widget _dadosFornecedores() {
//
//    return FutureBuilder(
//        future: _recuperarDadosFornecedores(),
//        builder: (context, snapshot) {
//
//          String resultado;
//
//          switch(snapshot.connectionState) {
//            case ConnectionState.done :
//
//              if (snapshot.hasError){
//
//                resultado = "Erro ao carregar os dados";
//                //print(snapshot.hasError);
//                print(snapshot.error);
//
//              } else {
//
//                return Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  children: <Widget>[
//                    Row(
//                      children: <Widget>[
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: <Widget>[
//                            _colorWidget(LightColor.black, isSelected: true),
//                            SizedBox(
//                              width: 10,
//                            ),
//                            Text('Dados do Fornecedor',
//                              style: TextStyle(
//                                  fontWeight: FontWeight.bold,
//                                  fontSize: 20
//                              ),
//                            )
//                          ],
//                        )
//
//                      ],
//                    ),
//                    SizedBox(height: 20),
//                    TitleText(
//                      text: "Endereço",
//                      fontSize: 18,
//                    ),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        SizedBox(
//                          height: 15,
//                        ),
//                        _colorWidget(LightColor.red, isSelected: true),
//                        SizedBox(
//                          width: 15,
//                        ),
//                        //_colorWidget(LightColor.lightBlue),
//                        Text(snapshot.data[0]['endereco'] ?? '',
//                          style: TextStyle(
//                              fontWeight: FontWeight.bold,
//                              fontSize: 16
//                          ),
//                        )
//                      ],
//                    ),
//                    Text(snapshot.data[0]['bairro'] ?? '',
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 16
//                      ),
//                    ),
//                    SizedBox(
//                      height: 15,
//                    ),
//                    TitleText(
//                      text: "Cidade",
//                      fontSize: 18,
//                    ),
//                    //SizedBox(height: 20),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        _colorWidget(LightColor.red, isSelected: true),
//                        SizedBox(
//                          width: 15,
//                        ),
//                        //_colorWidget(LightColor.lightBlue),
//                        Text(snapshot.data[0]['cidade'] + '-' + snapshot.data[0]['estado'] ?? '',
//                          style: TextStyle(
//                              fontWeight: FontWeight.bold,
//                              fontSize: 16
//                          ),
//                        ),
//                        SizedBox(
//                          width: 25,
//                        ),
//                        IconButton(
//                          icon: Icon(Icons.pin_drop),
//                          iconSize: 40,
//                          color: Colors.red,
//                          tooltip: 'Localização',
//                          onPressed: () {
//
//                          },
//                        ),
//                        RaisedButton(
//                          onPressed: (){
//                            goMapa(snapshot.data[0]['latitude'],snapshot.data[0]['longitude']);
//                          },
//                          hoverColor: Colors.red,
//                          color: Colors.white,
//                          child: Text('Localização'),
//                        )
//
//                      ],
//                    ),
//                    SizedBox(
//                      height: 15,
//                    ),
//                    TitleText(
//                      text: "Telefone",
//                      fontSize: 18,
//                    ),
//                    //SizedBox(height: 20),
//                    Row(
//                      mainAxisAlignment: MainAxisAlignment.start,
//                      children: <Widget>[
//                        _colorWidget(LightColor.red, isSelected: true),
//                        SizedBox(
//                          width: 15,
//                        ),
//                        //_colorWidget(LightColor.lightBlue),
//                        Text(snapshot.data[0]['telefone'].toString() ?? '',
//                          style: TextStyle(
//                              fontWeight: FontWeight.bold,
//                              fontSize: 16
//                          ),
//                        )
//                      ],
//                    )
//                  ],
//                );
//
//
//              }
//              break;
//            case ConnectionState.waiting :
//
//             return Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                   CircularProgressIndicator(
//                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
//                      //backgroundColor: Colors.red,
//                      strokeWidth: 5,
//            ),
//                SizedBox(height: 10,),
//                Text('Carregando Dados...',
//                  style: TextStyle(
//                      color: Colors.red,
//                      fontWeight: FontWeight.bold,
//                      fontSize: 20
//                ),
//                )
//          ],
//          );
//
//          break;
//
//          case ConnectionState.active :
//          //print('conexao active');
//          break;
//          case ConnectionState.none :
//          //print('conexao none');
//          break;
//        }
//
//
//        });
//
//
//
//  }

//  Widget _detalhesFWidget() {
//
//    return DraggableScrollableSheet(
//      maxChildSize: .8,
//      initialChildSize: .53,
//      minChildSize: .53,
//      builder: (context, scrollController) {
//        return Container(
//          padding: AppTheme.padding.copyWith(bottom: 0),
//          //padding: EdgeInsets.only(bottom: 0),
//          decoration: BoxDecoration(
//              borderRadius: BorderRadius.only(
//                topLeft: Radius.circular(40),
//                topRight: Radius.circular(40),
//              ),
//              color: Colors.white),
//          child: SingleChildScrollView(
//            controller: scrollController,
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              mainAxisSize: MainAxisSize.max,
//              children: <Widget>[
//                SizedBox(height: 5),
//                Container(
//                  alignment: Alignment.center,
//                  child: Container(
//                    width: 50,
//                    height: 5,
//                    decoration: BoxDecoration(
//                        color: LightColor.iconColor,
//                        borderRadius: BorderRadius.all(Radius.circular(10))),
//                  ),
//                ),
//                SizedBox(height: 10),
//                Container(
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: <Widget>[
//                      TitleText(text: fornecedor ?? '', fontSize: 25),
//                      //TitleText(text: 'escapamento'.toUpperCase(), fontSize: 25),
//                      Column(
//                        crossAxisAlignment: CrossAxisAlignment.end,
//                        children: <Widget>[
//                          Row(
//                            crossAxisAlignment: CrossAxisAlignment.center,
//                            children: <Widget>[
////                              TitleText(
////                                text: "R\$ ",
////                                fontSize: 18,
////                                color: LightColor.red,
////                              ),
////                              Text(valor.toString(),
////                                style: TextStyle(
////                                    fontSize: 20,
////                                    color: LightColor.red,
////                                    fontWeight: FontWeight.bold
////                                ),
////                              ),
//                            ],
//                          ),
//                          Row(
//                            children: <Widget>[
//                              Icon(Icons.star,
//                                  color: LightColor.red, size: 17),
//                              Icon(Icons.star,
//                                  color: LightColor.red, size: 17),
//                              Icon(Icons.star,
//                                  color: LightColor.red, size: 17),
//                              Icon(Icons.star,
//                                  color: LightColor.red, size: 17),
//                              Icon(Icons.star,
//                                  color: LightColor.red, size: 17),
//                            ],
//                          ),
//                        ],
//                      ),
//                    ],
//                  ),
//                ),
//                SizedBox(
//                  height: 20,
//                ),
//
//                //_dadosFornecedores(),
//                SizedBox(
//                  height: 20,
//                ),
//                //_availableColor(),
//                SizedBox(
//                  height: 20,
//                ),
//                //_description(),
//              ],
//            ),
//          ),
//        );
//      },
//    );
//
//  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          title: Text('Detalhes'),
          backgroundColor: Color.fromARGB(255, 204, 37, 1),
        ),
        //drawer: MenuDrawer(),
        //floatingActionButton: _floatingActionButton(),
        body: SingleChildScrollView(
          child: Container(
            child: FutureBuilder(
              future: _recuperarDadosFornecedores(),
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
                              child: Image.asset('assets/img/fornecedores/' + snapshot.data[0]['imagem'],
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(snapshot.data[0]['fornecedor'],
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

                              Text('Dados do Fornecedor',
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
                              TitleText(
                                text: "Endereço",
                                fontSize: 18,
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
                              Text(snapshot.data[0]['endereco'] ?? '',
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
                              TitleText(
                                text: "Cidade",
                                fontSize: 18,
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
                              Text(snapshot.data[0]['cidade'] + ' - ' + snapshot.data[0]['estado']  ?? '',
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
                              TitleText(
                                text: "Telefone",
                                fontSize: 18,
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
                              Text(snapshot.data[0]['telefone'].toString() ?? '',
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
                          MaterialButton(
                            onPressed: (){
                              goMapa(snapshot.data[0]['latitude'],snapshot.data[0]['longitude']);
                            },
                            color: Colors.red,
                            child: Text('Mapa de Localização',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white
                              ),
                            ),
                            elevation: 5,

                          ),
                          SizedBox(height: 20),
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
                      //mainAxisAlignment: MainAxisAlignment.end,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                              //backgroundColor: Colors.red,
                              strokeWidth: 5,
                            ),
                            SizedBox(height: 20),
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

