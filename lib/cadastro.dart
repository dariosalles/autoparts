import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {

  String _resultCad;
  int _token = 123456789;

  //CONTROLLER - CADASTRO - RECUPERA O QUE FOI DIGITADO
  TextEditingController _controllerNome = TextEditingController();
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

  _setCadastro() async {

    String nome = _controllerNome.text.trim();
    String email = _controllerEmail.text.trim();
    String senha = _controllerSenha.text.trim();

    if(nome.isEmpty || email.isEmpty || senha.isEmpty) {

      mensagemToast("Campo Nome, E-mail ou/e Senha em branco");

    } else {


      String _apiCadastro = 'http://www.dsxweb.com/apps/autoparts/api/apiCadastra_usuario.php?token=$_token';

      print(_apiCadastro);

      http.Response response;

      response = await http.post(_apiCadastro, body: {'nome': nome, 'email': email, 'senha': senha });

      print(response.body);


      if (response.statusCode == 200) {

        setState(() {
          _resultCad = response.body;
        });

        print('Resultado: $_resultCad');


        if(_resultCad=='Erro') {

          print('Erro no Cadastro');
          mensagemToast('Erro Cadastro');


        } else {

          print('Cadastro feito com sucesso');


          showDialog(context: context,
              builder: (context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  title: Text('Cadastrado com sucesso'),
                  titlePadding: EdgeInsets.all(20),
                  titleTextStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.red
                  ),
                  content: Text('Verifique seu email para ativar o cadastro. Feito isso, estará pronto para acesso.',
                      textAlign: TextAlign.center),
                  contentPadding: EdgeInsets.all(20),
                  actions: <Widget>[
                    RaisedButton(
                      child: Text("OK"),
                      onPressed: (){
                        print('sim');
                        Navigator.pushNamed(context, '/');
                      },
                    ),
                  ],

                );
              });
          //print('Clicado $indice');
          //Navigator.pushNamed(context, '/');

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
          title: Text('Cadastro'),
          backgroundColor: Color.fromARGB(255, 214, 37, 1),
        ),
        body: Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/img/fundo4.jpg'),
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
                      controller: _controllerNome,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'SFUIDisplay'
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nome',
                          prefixIcon: Icon(Icons.person),
                          labelStyle: TextStyle(
                              fontSize: 15
                          )
                      ),
                    ),

                  ),
                ),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextFormField(
                    controller: _controllerEmail,
                    maxLength: 30,
                    obscureText: false,
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
                Container(
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
                      _setCadastro();
                      //Navigator.pushNamed(context, '/pecas');
                    },//since this is only a UI app
                    child: Text('Cadastrar',
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
        ));

  }

}
