import 'package:auto_parts/themes/light_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:auto_parts/menuDrawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/title_text.dart';
import 'themes/light_color.dart';
import 'themes/theme.dart';
import 'package:intl/intl.dart';

class Detalhes extends StatefulWidget {
  @override
  _DetalhesState createState() => _DetalhesState();
}

class _DetalhesState extends State<Detalhes>
    with TickerProviderStateMixin {

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

  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();

    _recuperaIdPeca();
    //inicialDetalhes(idpecadetalhes);

  }

  _recuperaIdPeca() async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    String idpecadetalhes = sp.getString('idpeca');

    print('Detalhes - ID PECA: $idpecadetalhes');

    inicialDetalhes(idpecadetalhes);
  }




  // CARREGA OS DADOS - DETALHES DAS PEÇAS
  inicialDetalhes(id) async {
    String _idpecaRecuperado = id.toString();


    print('inicialDetalhes: $_idpecaRecuperado');

    _apiDetalhes =
    'http://www.dsxweb.com/apps/autoparts/api/apiRecupera_pecas_detalhes.php?token=$_token&id_peca=$_idpecaRecuperado';

    http.Response response;

    response = await http.get(_apiDetalhes);

    if (response.statusCode == 200) {

      setState(() {
        _itemsD = json.decode(response.body) as List;
        print(_itemsD);
        imagem = _itemsD[0]['imagem'];
        nome = _itemsD[0]['nome'];
        valor = double.parse(_itemsD[0]['valor']);
        dimensoes = _itemsD[0]['dimensoes'];
        peso = _itemsD[0]['peso'];
        garantia = _itemsD[0]['garantia'];

      });

    } else {
      print("Erro no servidor - 500");
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

  Widget _detalhesImage() {

    return AnimatedBuilder(
      builder: (context, child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: animation.value,
          child: child,
        );
      },
      animation: animation,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          TitleText(
            text: "Auto Parts",
            fontSize: 100,
            color: Colors.red,
          ),
          //Image.asset('assets/img/pecas/' + _itemsD[0]['imagem'].toString())
          Image.asset('assets/img/pecas/$imagem')
        ],
      ),
    );

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

  Widget _dimensoes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _colorWidget(LightColor.black, isSelected: true),
                SizedBox(
                  width: 10,
                ),
                Text('Dados do produto na embalagem',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
                )
              ],
            )

          ],
        ),
        SizedBox(height: 20),
        TitleText(
          text: "Dimensões",
          fontSize: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            _colorWidget(LightColor.red, isSelected: true),
          SizedBox(
            width: 15,
          ),
            //_colorWidget(LightColor.lightBlue),
          Text(dimensoes  ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
          )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        TitleText(
          text: "Peso",
          fontSize: 18,
        ),
        //SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _colorWidget(LightColor.red, isSelected: true),
            SizedBox(
              width: 15,
            ),
            //_colorWidget(LightColor.lightBlue),
            Text('$peso grama(s)' ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            )
          ],
        ),
        SizedBox(
          height: 15,
        ),
        TitleText(
          text: "Garantia",
          fontSize: 18,
        ),
        //SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _colorWidget(LightColor.red, isSelected: true),
            SizedBox(
              width: 15,
            ),
            //_colorWidget(LightColor.lightBlue),
            Text(garantia ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            )
          ],
        )
      ],
    );

  }

  Widget _detalhesWidget() {

    return DraggableScrollableSheet(
        maxChildSize: .8,
        initialChildSize: .53,
        minChildSize: .53,
        builder: (context, scrollController) {
          return Container(
            padding: AppTheme.padding.copyWith(bottom: 0),
            //padding: EdgeInsets.only(bottom: 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 5),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                          color: LightColor.iconColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TitleText(text: nome ?? '', fontSize: 25),
                        //TitleText(text: 'escapamento'.toUpperCase(), fontSize: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TitleText(
                                  text: "R\$ ",
                                  fontSize: 18,
                                  color: LightColor.red,
                                ),
                                Text(valor.toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: LightColor.red,
                                      fontWeight: FontWeight.bold
                                    ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.star,
                                    color: LightColor.red, size: 17),
                                Icon(Icons.star,
                                    color: LightColor.red, size: 17),
                                Icon(Icons.star,
                                    color: LightColor.red, size: 17),
                                Icon(Icons.star,
                                    color: LightColor.red, size: 17),
                                Icon(Icons.star,
                                    color: LightColor.red, size: 17),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                _dimensoes(),
                SizedBox(
                  height: 20,
                ),
                //_availableColor(),
                SizedBox(
                  height: 20,
                ),
                  //_description(),
                ],
              ),
            ),
          );
        },
      );

  }

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
                      //addCart(idpecadetalhes,nome,valor);
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          title: Text('Detalhes'),
          backgroundColor: Color.fromARGB(255, 204, 37, 1),
        ),
        //drawer: MenuDrawer(),
        floatingActionButton: _floatingActionButton(),
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfffbfbfb),
                  Color(0xfff7f7f7),
                ],
                begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
              )
            ),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _detalhesImage(),

                  ],
                ),
                _detalhesWidget()
              ],
            ),
          ),
        )
    );
  }
}
