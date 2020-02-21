import 'package:auto_parts/botton_nav.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class Contato extends StatefulWidget {
  @override
  _ContatoState createState() => _ContatoState();
}

class _ContatoState extends State<Contato> {

  String _resultContato;
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

  TextEditingController _controllerContatoNome = TextEditingController();
  TextEditingController _controllerContatoEmail = TextEditingController();
  TextEditingController _controllerContatoAssunto = TextEditingController();
  TextEditingController _controllerContatoMsg = TextEditingController();

  sendContato() async {

    String nome;
    String email;
    String assunto;
    String msg;

    nome = _controllerContatoNome.text.trim();
    email = _controllerContatoEmail.text.trim();
    assunto = _controllerContatoAssunto.text.trim();
    msg = _controllerContatoMsg.text.trim();

    if(nome.isEmpty || email.isEmpty || assunto.isEmpty || msg.isEmpty) {

      mensagemToast("Preencha todos os campos");

    } else {

      String apiContato = 'http://www.dsxweb.com/apps/autoparts/api/api_contato.php?token=$token';

      // print(apiAcesso);

      http.Response response;

     response = await http.post(apiContato, body: {'nome': nome, 'email': email, 'assunto': assunto, 'msg': msg});

      print(response.body);

      if (response.statusCode == 200) {

        setState(() {
          _resultContato = response.body;
        });

        print('Resultado:' + _resultContato.toString());

        if(_resultContato.isEmpty) {

          print('Erro');
          mensagemToast('Erro ao enviar o email');


        } else {

        // OK
          mensagemToast("Mensagem enviada com sucesso");


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
          leading: new GestureDetector(
          child: new Icon(Icons.arrow_back_ios),
          onTap: () {
          Navigator.of(context).pop();
    },
    ),
          title: Text('Contato'),
        backgroundColor: Color.fromARGB(255, 204, 37, 1),
    ),
        body: Padding(
          padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Text('Entre com seus dados para falar conosco',
                style: TextStyle(
                    fontSize: 20,

                    fontStyle: FontStyle.italic
                ),
            ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _controllerContatoNome,
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

            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _controllerContatoEmail,
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
            
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _controllerContatoAssunto,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'SFUIDisplay'
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Assunto',
                    prefixIcon: Icon(Icons.subject),
                    labelStyle: TextStyle(
                        fontSize: 15
                    )
                ),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                maxLines: 5,
                controller: _controllerContatoMsg,
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'SFUIDisplay'
                ),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mensagem',
                    prefixIcon: Icon(Icons.message),
                    labelStyle: TextStyle(
                      fontSize: 15,

                    )
                ),
              ),
            ),
            Padding(
             padding: EdgeInsets.all(10),
             child: MaterialButton(

               onPressed: () async {
                 sendContato();
                 //Navigator.pushNamed(context, '/pecas');
               },//since this is only a UI app
               child: Text('Enviar',
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
            )
          ],
          ),
        ),

        bottomNavigationBar: BottomNav(),
    );
  }
}
