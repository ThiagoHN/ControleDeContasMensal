import 'package:flutter/widgets.dart';

class Usuario with ChangeNotifier {
  String _nome;
  String _email;
  String _senha;
  int _id;

  Usuario(this._nome, this._email, this._senha, this._id);

  String get nome {
    return this._nome;
  }

  String get emal {
    return this._email;
  }

  String get senha {
    return this._senha;
  }

  int get id {
    return this._id;
  }

  set nome(String nome) {
    this._nome = nome;
  }

  set email(String email) {
    this._email = email;
  }

  set senha(String senha) {
    this._senha = senha;
  }

  set id(int idusuario) {
    this._id = idusuario;
  }
}
