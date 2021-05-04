import 'package:controle_de_contas_mensal/provider/contas_provider.dart';
import 'package:controle_de_contas_mensal/provider/usuarios_provider.dart';
import 'package:controle_de_contas_mensal/screens/login.dart';
import 'package:controle_de_contas_mensal/screens/menu.dart';
import 'package:controle_de_contas_mensal/screens/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UsuarioProvider()),
        ChangeNotifierProxyProvider<UsuarioProvider, ContasProvider>(
            create: (ctx) => ContasProvider(),
            update: (ctx, usuarios, contas) =>
                ContasProvider.logado(usuarios.id)),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<UsuarioProvider>(
            builder: (ctx, usuarios, _) => usuarios.estaLogado
                ? Menu()
                : FutureBuilder(
                    future: usuarios.loginAutomatico(),
                    builder: (ctx, resultado) =>
                        resultado.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : Login())),
        routes: {
          Login.routeName: (ctx) => Login(),
          Menu.routeName: (ctx) => Menu(),
        },
      ),
    );
  }
}
