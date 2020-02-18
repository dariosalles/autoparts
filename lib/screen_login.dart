import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class SignInOne extends StatefulWidget {
  @override
  _SignInOneState createState() => _SignInOneState();
}

class _SignInOneState extends State<SignInOne> {

  List _result = [];
  int token = 123456789;


  //CONTROLLER - BUSCA - RECUPERA O QUE FOI DIGITADO
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

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

  getAcesso() async {
    String email = _controllerEmail.text.trim();
    String senha = _controllerSenha.text.trim();
    String nome = 'Dario';

    //print(email);
    //print(senha);

    //VERIFICA OS CAMPOS DIGITADOS
    if(email.isEmpty || senha.isEmpty) {

      mensagemToast("Campo e-mail ou/e senha em branco");

    } else {

      // String apiAcesso_get = 'http://www.dsxweb.com/apps/autoparts/api/usuario.php?token=$token' + '&email=' + email + '&senha=' + senha;
      String apiAcesso = 'http://www.dsxweb.com/apps/autoparts/api/apiRecupera_usuario.php?token=$token';

      print(apiAcesso);

      http.Response response;

      //response = await http.get(apiAcesso);

      response = await http.post(apiAcesso, body: {'email': email, 'senha': senha });

//    var headers = response.headers;
//
      print(response.body);


      if (response.statusCode == 200) {

        setState(() {
          _result = json.decode(response.body) as List;
        });

        // print('Resultado: $_result');


        if(_result.isEmpty) {

          print('acesso não permitido');
          mensagemToast('Acesso não permitido');


        } else {

          setState(() {
            nome = 'Dario';
          });

          setState(() {
            email = _controllerEmail.text;
          });

          print('acesso permitido');
          Navigator.pushNamed(context, '/pecas');

        }



      } else {

        print('Erro 500');

      }


    }


  }

    @override
    Widget build(BuildContext context) {
      return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/fundo5.jpg'),
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
            margin: EdgeInsets.only(top: 270),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(23),
              child: ListView(
                children: <Widget>[
                  Text('Acessar AutoParts Delivery',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                  ),),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Container(
                      color: Color(0xfff5f5f5),
                      child: TextFormField(
                        controller: _controllerEmail,
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
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    color: Color(0xfff5f5f5),
                    child: TextFormField(
                      controller: _controllerSenha,
                      maxLength: 8,
                      obscureText: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFUIDisplay'
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Senha',
                          prefixIcon: Icon(Icons.lock_outline),
                          labelStyle: TextStyle(
                              fontSize: 15
                          )
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      onPressed: (){
                        getAcesso();
                        //Navigator.pushNamed(context, '/pecas');
                      },//since this is only a UI app
                      child: Text('Acessar',
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
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text('Esqueceu a senha?',
                        style: TextStyle(
                            fontFamily: 'SFUIDisplay',
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: MaterialButton(
                      onPressed: (){
                        //getAcesso();
                        Navigator.pushNamed(context, '/cadastro');
                      },//since this is only a UI app
                      child: Text('Cadastrar',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'SFUIDisplay',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      color: Colors.deepOrange,
                      //color: Color(0xffff2d55),
                      elevation: 0,
                      minWidth: 400,
                      height: 50,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),

                  )
                ],
              ),
            ),
          )
        ],
      );
    }
}