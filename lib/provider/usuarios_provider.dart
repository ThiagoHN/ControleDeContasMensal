import 'dart:async';
import 'package:controle_de_contas_mensal/helpers/sql.dart';
import 'package:controle_de_contas_mensal/models/usuario.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UsuarioProvider with ChangeNotifier {
  Usuario usuarioLogado;
  Timer timerAutenticacao;
  DateTime expirationToken;
  final nomeTabela = 'usuarios';

  bool get estaLogado {
    return usuarioLogado != null;
  }

  int get id {
    if (usuarioLogado == null) return -1;
    return usuarioLogado.id;
  }

  Usuario get usuarioSelecionado {
    return usuarioLogado;
  }

  Future<bool> logar(String email, String senha) async {
    final leitura =
        await BancoDados.leituraPorChave(nomeTabela, 'email', email);
    if (leitura.isEmpty) return false;
    if (leitura[0]['senha'].toString().compareTo(senha) != 0) return false;

    usuarioLogado = Usuario(
        leitura[0]['nome'].toString(),
        leitura[0]['email'].toString(),
        leitura[0]['senha'].toString(),
        int.parse(leitura[0]['id'].toString()));

    expirationToken = DateTime.now().add(Duration(hours: 3));
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    final userData = json.encode({
      'userid': usuarioLogado.id,
      'expiredToken': expirationToken.toIso8601String()
    });

    pref.setString('userData', userData);

    return true;
  }

  Future<bool> registrar(String nome, String email, String senha) async {
    final leitura =
        await BancoDados.leituraPorChave(nomeTabela, 'email', email);
    if (leitura.isNotEmpty) return false;

    int id = await BancoDados.inserir(
        nomeTabela, {'nome': nome, 'email': email, 'senha': senha});

    usuarioLogado = Usuario(
      nome,
      email,
      senha,
      id,
    );

    expirationToken = DateTime.now().add(Duration(hours: 3));
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    final userData = json.encode({
      'userid': usuarioLogado.id,
      'expiredToken': expirationToken.toIso8601String()
    });

    pref.setString('userData', userData);

    return true;
  }

  Future<bool> loginAutomatico() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('userData')) return false;
    final userData =
        json.decode(pref.getString('userData')) as Map<String, Object>;
    final expiredDate = DateTime.parse(userData['expiredToken']);
    if (expiredDate.isBefore(DateTime.now())) return false;
    final leitura = await BancoDados.leituraPorChave(
        nomeTabela, 'id', userData['userid'].toString());

    usuarioLogado = Usuario(
        leitura[0]['nome'].toString(),
        leitura[0]['email'].toString(),
        leitura[0]['senha'].toString(),
        int.parse(leitura[0]['id'].toString()));

    expirationToken = expiredDate;
    notifyListeners();

    return true;
  }

  Future<bool> logout() async {
    usuarioLogado = null;
    if (timerAutenticacao != null) {
      timerAutenticacao.cancel();
      timerAutenticacao = null;
    }
    expirationToken = null;
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  Future<bool> logoutAutomico() async {
    if (timerAutenticacao != null) {
      timerAutenticacao.cancel();
    }
    final tempoExpirar = expirationToken.difference(DateTime.now()).inSeconds;
    timerAutenticacao = Timer(Duration(seconds: tempoExpirar), logout);
  }
}
