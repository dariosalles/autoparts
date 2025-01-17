import 'package:auto_parts/pecas.dart';
import 'package:auto_parts/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInOne extends StatefulWidget {
  @override
  _SignInOneState createState() => _SignInOneState();
}

class _SignInOneState extends State<SignInOne> {

  bool rememberMe = false;

  initState() {

    _verificarLembrarMe();


  }

  //VERIFICA SE JÁ EXISTE UM LOGIN
  _verificarLembrarMe() async {

    SharedPreferences sp = await SharedPreferences.getInstance();
    bool rememberMe = sp.getBool('lembrarme');
    print(rememberMe);
    if(rememberMe==true) {

      Navigator.pushNamed(context, '/pecas');
    }
  }


  List _result = [];

  bool _obscureText = true;

  void _toggle() {

    setState(() {
      _obscureText = !_obscureText;
    });

  }

  void _onRememberMeChanged(bool newValue) => setState(() {
    rememberMe = newValue;
  });


  //CONTROLLER - BUSCA - RECUPERA O QUE FOI DIGITADO
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();


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

//  Future<Map> _getAcessoF() async {
//
//    String email;
//    String senha;
//    String nome;
//
//    email = _controllerEmail.text.trim();
//    senha = _controllerSenha.text.trim();
//    nome = 'Dario';
//
//    String apiAcesso = 'https://blockchain.info/ticker';
//
//    //String apiAcesso = 'http://www.dsxweb.com/apps/autoparts/api/apiRecupera_usuario.php?token=$token';
//
//    http.Response response = await http.post(apiAcesso, body: {'email': email, 'senha': senha});
//
//    print(json.decode(response.body));
//
//    return json.decode(response.body); // converte String para <Map>
//
//    return retorno();
//  }

  getSenha(){
    Navigator.pushNamed(context, '/esqueci');
  }

//  retorno() {
//
//    FutureBuilder<Map>(
//      future: _getAcessoF(),
//      builder: (context, snapshot){
//
//        String resultado;
//        switch (snapshot.connectionState) {
//          case ConnectionState.none :
//            print('none');
//            break;
//          case ConnectionState.waiting :
//            print('waiting');
//            resultado = 'Carregando...';
//            break;
//          case ConnectionState.active :
//            print('active');
//            break;
//          case ConnectionState.done :
//            print('done');
//            if(snapshot.error) {
//              resultado = 'Erro ao carregar os dados';
//            } else {
//              //String email = snapshot.data['email'];
//              //String nome = snapshot.data['nome'];
//              double valor = snapshot.data["BRL"]["buy"];
//              resultado = valor.toString();
//            }
//            break;
//        }
//        return Center(
//          child: Text(resultado)
//        );
//      },
//    );
//  }

  getAcesso() async {

    String email;
    String senha;
    String nome;
    String id_usuario;

    email = _controllerEmail.text.trim();
    senha = _controllerSenha.text.trim();

    //print(email);
    //print(senha);

    //VERIFICA OS CAMPOS DIGITADOS
    if(email.isEmpty || senha.isEmpty) {

      mensagemToast("Campo e-mail ou/e senha em branco");

    } else {

      // String apiAcesso_get = 'http://www.dsxweb.com/apps/autoparts/api/usuario.php?token=$token' + '&email=' + email + '&senha=' + senha;
      String apiAcesso = '${Constants.baseUrlApi}apiRecupera_usuario.php';

      print(apiAcesso);

      http.Response response;

      response = await http.post(apiAcesso, body: {'email': email, 'senha': senha, 'token': Constants.token.toString()});

      if (response.statusCode == 200) {

        setState(() {
          _result = json.decode(response.body) as List;
        });


        if(_result.isEmpty) {

          print('acesso não permitido');
          mensagemToast('Acesso não permitido');


        } else {


          setState(() {
            email = _result[0]['email'];
            nome = _result[0]['nome'];
            id_usuario = _result[0]['id_usuario'].toString();

          });

          print('acesso permitido');

              //guarda email
              SharedPreferences sp = await SharedPreferences.getInstance();
              sp.setString('nome', nome);
              sp.setString('email', email);
              sp.setString('id_usuario', id_usuario);
              if(rememberMe){
                sp.setBool('lembrarme', rememberMe);
              }

              // NAVEGA SEM DEIXAR BOTAO VOLTAR
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext) => Pecas()));

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
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          obscureText: _obscureText,
                          controller: _controllerSenha,
                          maxLength: 8,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'SFUIDisplay'
                          ),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Senha',
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: (){
                                  _toggle();
                                },
                                icon: Icon(
                                  _obscureText ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.black,
                                ),
                              ),
                              labelStyle: TextStyle(
                                  fontSize: 15
                              )
                          ),
                        ),
                      ],
                    )
                  ),
                  CheckboxListTile(
                    title: Text("Lembrar me?"),
                    value: rememberMe,
                    onChanged: _onRememberMeChanged,
                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: MaterialButton(
                      onPressed: () async {
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: <Widget>[
                        MaterialButton(
                          onPressed: (){
                            getSenha();
                            //Navigator.pushNamed(context, '/pecas');
                          },//since this is only a UI app
                          child: Text('Esqueceu a senha?',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'SFUIDisplay',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          color: Colors.blue,
                          //color: Color(0xffff2d55),
                          elevation: 0,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                        MaterialButton(
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

                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                        ),
                      ],

                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      );
    }
}