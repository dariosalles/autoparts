import 'package:auto_parts/fornecedores_mapa.dart';
import 'package:auto_parts/themes/light_color.dart';
import 'package:auto_parts/utils/app_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/title_text.dart';
import 'themes/light_color.dart';

class DetalhesFornecedores extends StatefulWidget {

  DetalhesFornecedores({ Key key, @required this.idfdetalhes}) : super(key: key);
  final String idfdetalhes;

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

  List _itemsDF = [];
  String _apiDetalhesF;

  // CARREGA OS DADOS - DETALHES DO FORNECEDOR
  Future<List> _recuperarDadosFornecedores() async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    String idforndetalhes = sp.getString('idfornecedor');

    //print('Detalhes - ID Fornecedor: $idforndetalhes');

    _apiDetalhesF = '${Constants.baseUrlApi}apiRecupera_fornecedor_detalhes.php';

    //print(_apiDetalhesF);

    http.Response response;

    response = await http.post(_apiDetalhesF, body: ({"token": Constants.token.toString(), "id_fornecedor": idforndetalhes}));

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

    String lat = latitude.toString();
    String long = longitude.toString();

    // passando pra outra tela utilizando parametros
    Navigator.push(
        context,
        MaterialPageRoute(
          //fullscreenDialog: true,
          builder: (context) => FornecedorMapa(lat: lat, long: long ),
        ));

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

