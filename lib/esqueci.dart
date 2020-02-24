import 'package:auto_parts/botton_nav.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'menuDrawer.dart';

class Esqueci extends StatefulWidget {
  @override
  _EsqueciState createState() => _EsqueciState();
}

class _EsqueciState extends State<Esqueci> {

  String _resultEsqueci;
  int token = 123456789;

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

  TextEditingController _controllerEsqueciEmail = TextEditingController();


  sendEsqueci() async {

    String email;

    email = _controllerEsqueciEmail.text.trim();

    if(email.isEmpty) {

      mensagemToast("Preencha o campo Email");

    } else {

      String apiEsqueci = 'http://www.dsxweb.com/apps/autoparts/api/email/esqueciasenha.php?token=$token';

      // print(apiAcesso);

      http.Response response;

      response = await http.post(apiEsqueci, body: {'email': email});

      print(response.body);

      if (response.statusCode == 200) {

        setState(() {
          _resultEsqueci = response.body;
        });

        print('Resultado:' + _resultEsqueci.toString());

        if(_resultEsqueci.isEmpty) {

          print('Erro');
          mensagemToast('Erro ao enviar o email');


        } else {

          // OK
          mensagemToast("Verifique seu email com a senha");


          _controllerEsqueciEmail.clear();



        }



      } else {

        print('Erro 500');

      }

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Esqueci a senha'),
        backgroundColor: Color.fromARGB(255, 204, 37, 1),
      ),
      //drawer: MenuDrawer(),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/fundo3.jpg'),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter
                )
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 30),
            child: Image.asset('assets/img/logo_autoparts.png'),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 250),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(23),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Container(
                      color: Color(0xfff5f5f5),
                      child: TextFormField(
                        controller: _controllerEsqueciEmail,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'SFUIDisplay'
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            labelStyle: TextStyle(
                                fontSize: 15
                            )
                        ),
                      ),

                    ),
                  ),



                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      onPressed: (){
                        sendEsqueci();
                        //Navigator.pushNamed(context, '/pecas');
                      },//since this is only a UI app
                      child: Text('Recuperar Senha',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'SFUIDisplay',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Color.fromARGB(255, 214, 37, 1),
                      //color: Color(0xffff2d55),
                      elevation: 0,
                      minWidth: 400,
                      height: 50,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      ),

      ///bottomNavigationBar: BottomNav(),
    );
  }
}
