import 'package:controle_de_contas_mensal/models/conta.dart';
import 'package:controle_de_contas_mensal/provider/contas_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CriadorConta extends StatefulWidget {
  final Conta c;

  CriadorConta({this.c});

  @override
  _CriadorConta createState() => _CriadorConta();
}

class _CriadorConta extends State<CriadorConta> {
  final GlobalKey<FormState> globalKey = GlobalKey();

  double valor = 0.0;
  String titulo = '';
  String descricao = '';
  DateTime vencimento;
  bool atualizar;

  void initState() {
    super.initState();
    if (widget.c != null) {
      valor = widget.c.valor;
      titulo = widget.c.titulo;
      descricao = widget.c.descricao;
      vencimento = DateTime.parse(widget.c.vencimento);
      atualizar = true;
    }
  }

  selecionaData() {
    DateTime hoje = DateTime.now().add(Duration (days: 1));
    showDatePicker(context: context, initialDate: hoje, firstDate: hoje, lastDate: DateTime (hoje.year + 1)).then((value) => setState((){
      vencimento = value;
    }));
  }

  criarConta() async {
    if (!globalKey.currentState.validate())
      return false;
    globalKey.currentState.save();

    if (atualizar)
      await Provider.of<ContasProvider>(context,listen: false).add(valor, vencimento.toIso8601String(), titulo, descricao);
    else {
      widget.c.valor = valor;
      widget.c.titulo = titulo;
      widget.c.descricao = descricao;
      widget.c.vencimento = vencimento.toIso8601String();

      await Provider.of<ContasProvider>(context,listen: false).update(widget.c);

    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Racha Conta Menu'),
      ),
      body: Form(
          key: globalKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: titulo,
                    decoration: InputDecoration(
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.name,
                    maxLength: 20,
                    onSaved: (value) {
                      titulo = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) 
                        return 'O campo está vazio! Favor escrever algo!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    initialValue: descricao,
                    decoration: InputDecoration(
                        border: OutlineInputBorder()),
                    keyboardType: TextInputType.name,
                    maxLines: 2,
                    onSaved: (value) {
                      descricao = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) 
                        return 'O campo está vazio! Favor escrever algo!';
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    initialValue: valor.toStringAsFixed(2),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'R\$'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      valor = double.parse(value);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Valor da conta inválido, digite o valor novamente!';
                      } else if (double.tryParse(value) == null)
                        return 'Valor da conta deve ser númerico';
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      vencimento == null ? Text('Nenhuma data foi selecionada') : Text(DateFormat('dd/MM/yyyy').format(vencimento)),
                      ElevatedButton(onPressed: selecionaData, child: Text('Escolha uma data')),                  
                    ]
                  ),



                  ElevatedButton(
                      onPressed: criarConta,
                      child: Text('Calcular'))
                ],
              ),
            ),
          )),
    );
  }
  }