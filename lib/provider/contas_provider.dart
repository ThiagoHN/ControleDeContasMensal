import 'package:controle_de_contas_mensal/helpers/sql.dart';
import 'package:controle_de_contas_mensal/models/conta.dart';
import 'package:flutter/widgets.dart';

class ContasProvider with ChangeNotifier {
  List<Conta> _items = [];
  final nomeTabela = 'contas';

  int idUsuario;

  ContasProvider();
  ContasProvider.logado(this.idUsuario);

  List<Conta> get items {
    return [..._items];
  }

  Future<void> getDados() async {
    final dados = await BancoDados.leituraPorChave(
        nomeTabela, 'idUsuario', idUsuario.toString());
    if (dados.length == 0) {
      return;
    }

    _items = dados
        .map((e) => Conta(
            e['id'], e['valor'], e['vencimento'], e['titulo'], e['descricao']))
        .toList();
    notifyListeners();
  }

  Future<bool> add(
      double valor, String vencimento, String titulo, String descricao) async {
    int id = await BancoDados.inserir(nomeTabela, {
      'valor': valor,
      'idUsuario': idUsuario,
      'vencimento': vencimento,
      'titulo': titulo,
      'descricao': descricao
    });
    Conta novaConta = Conta(id, valor, vencimento, titulo, descricao);
    _items.add(novaConta);
    notifyListeners();
  }

  void remove(Conta contaSelecionada) async {
    _items.remove(contaSelecionada);
    await BancoDados.deletar(nomeTabela, contaSelecionada.idconta);
    notifyListeners();
  }

  Future<bool> update(Conta contaSelecionada) async {
    final contaIndex = _items
        .indexWhere((element) => element.idconta == contaSelecionada.idconta);
    if (contaIndex == -1) return false;
    _items[contaIndex] = contaSelecionada;
    await BancoDados.atualizar(nomeTabela, {
      'valor': contaSelecionada.valor,
      'vencimento': contaSelecionada.vencimento,
      'titulo': contaSelecionada.titulo,
      'descricao': contaSelecionada.descricao
    });
    notifyListeners();
  }
}
