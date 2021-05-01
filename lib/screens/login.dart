import 'package:controle_de_contas_mensal/provider/usuarios_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'menu.dart';

class Login extends StatefulWidget {
  static const routeName = 'Tela_principal';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> globalKey = GlobalKey();
  var formmap = {'nome':'','email':'','senha':'','confirmarsenha':''};

  bool esta_logando = false;
  bool carregando = false;

  _logar() async {
    if (globalKey.currentState.validate()){
      globalKey.currentState.save();
      bool resultado = false;
      setState(() {
        carregando = true;
      });

      if(esta_logando)
        resultado = await Provider.of<UsuarioProvider>(context, listen: false).logar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.purple[700],
                Colors.indigo[500],
              ],
            )),
          ),
          Center(
            child: Card(
              elevation: 4,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Text(
                        'Edu Duca',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (esta_logando)
                        TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(), labelText: 'Nome'),
                          onSaved: (value) {
                            // preco_total = double.parse(value);
                          },
                        ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Email'),
                        onSaved: (value) {
                          // email = double.parse(value);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Campo obrigatório, por favor insira seu email!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Senha'),
                        onSaved: (value) {
                          // senha = double.parse(value);
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return 'Campo obrigatório, por favor insira sua senha!';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      if (esta_logando)
                        TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Confirmar senha'),
                          onSaved: (value) {
                            // preco_total = double.parse(value);
                          },
                        ),
                      const SizedBox(height: 20),
                      Container(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: _logar,
                            child: Text('Acessar')),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () => setState(() {
                                  esta_logando = !esta_logando;
                                }),
                            child: Text('Registrar')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
