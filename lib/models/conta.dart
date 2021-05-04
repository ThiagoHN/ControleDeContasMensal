import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class Conta with ChangeNotifier {
  int _idconta;
  double _valor;
  String _vencimento;
  String _titulo;
  String _descricao;

  Conta(this._idconta, this._valor, this._vencimento, this._titulo,
      this._descricao);

  double get valor {
    return this._valor;
  }

  int get idconta {
    return this._idconta;
  }

  String get vencimento {
    return this._vencimento;
  }

  String get titulo {
    return this._titulo;
  }

  String get descricao {
    return this._descricao;
  }

  set valor(double valor) {
    this._valor = valor;
  }

  set id(int idconta) {
    this._idconta = idconta;
  }

  set vencimento(String vencimento) {
    this._vencimento = vencimento;
  }

  set titulo(String titulo) {
    this._titulo = titulo;
  }

  set descricao(String descricao) {
    this._descricao = descricao;
  }
}
