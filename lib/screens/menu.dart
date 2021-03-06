import 'package:controle_de_contas_mensal/provider/contas_provider.dart';
import 'package:controle_de_contas_mensal/provider/usuarios_provider.dart';
import 'package:controle_de_contas_mensal/screens/criadorconta.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatelessWidget {
  static const routeName = 'menu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (context) => CriadorConta()))),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                  child: DrawerHeader(
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                      child: Text('Controlador \n Contas'))),
              ListTile(
                leading: Text('Sair'),
                trailing: Icon(Icons.exit_to_app),
                onTap: () async {
                  await Provider.of<UsuarioProvider>(context, listen: false)
                      .logout();
                },
              )
            ],
          ),
        ),
        body: FutureBuilder(
          future:
              Provider.of<ContasProvider>(context, listen: false).getDados(),
          builder: (ctx, result) => result.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Consumer<ContasProvider>(
                  builder: (ctx, contas, _) => ListView.builder(
                    itemCount: contas.items.length,
                    itemBuilder: (ctx, index) => ListTile(
                      leading: CircleAvatar(),
                      title: Text(contas.items[index].titulo),
                      subtitle: Text(contas.items[index].descricao),
                      trailing: GestureDetector(
                          onTap: () async {
                            await Provider.of<ContasProvider>(context,
                                    listen: false)
                                .remove(contas.items[index]);
                          },
                          child: Icon(Icons.delete)),
                      onTap: () =>
                          Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (context) => CriadorConta(
                                    c: contas.items[index],
                                  ))),
                    ),
                  ),
                ),
        ));
  }
}
