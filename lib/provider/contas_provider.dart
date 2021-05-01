import 'package:controle_de_contas_mensal/models/conta.dart';
import 'package:flutter/widgets.dart';

class ContasProvider with ChangeNotifier {
  List<Conta> _items = [
    Conta(69.24, '234123', '2304', 'Mamaco tá loko',
        'Tenho que pagar o zoologico KKK'),
    Conta(69.24, '234123', '2304', 'Guara no Drift',
        'Tenho que pagar o zoologico KKK')
  ];

  int idUsuario;

  ContasProvider();
  ContasProvider.logado(this.idUsuario);

  List<Conta> get items {
    return [..._items];
  }

  bool add(double valor, String vencimento, String titulo, String descricao) {
    Conta novaConta = Conta(
        valor, DateTime.now().toIso8601String(), vencimento, titulo, descricao);
    _items.add(novaConta);
    notifyListeners();
  }

  bool remove(Conta contaSelecionada) {}
}
