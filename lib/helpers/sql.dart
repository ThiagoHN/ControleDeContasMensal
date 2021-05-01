import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class BancoDados {
  static Future<Database> get database async {
    final dbpath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbpath, 'BancoDados.db'),
        onCreate: (db, version) async {
      await db.execute('CREATE TABLE usuarios (' +
          'id INTEGER PRIMARY KEY' +
          'nome TEXT,' +
          'email TEXT,' +
          'senha TEXT)');

      await db.execute('CREATE TABLE contas(' +
          'id INTEGER PRIMARY KEY,' +
          'idUsuario INTEGER,' +
          'valor REAL,' +
          'vencimento TEXT,' +
          'titulo TEXT,' +
          'descricao TEXT)');
    }, version: 1);
  }

  static Future<int> inserir(
      String tabelaSelecionada, Map<String, Object> dados) async {
    final sqldb = await BancoDados.database;
    return await sqldb.insert(tabelaSelecionada, dados,
        conflictAlgorithm: ConflictAlgorithm.abort);
  }

  static Future<int> atualizar(
      String tabelaSelecionada, Map<String, Object> dados) async {
    final sqldb = await BancoDados.database;
    return await sqldb.update(tabelaSelecionada, dados);
  }

  static Future<List<Map<String, Object>>> leitura(
      String tabelaSelecionada) async {
    final sqldb = await BancoDados.database;
    return await sqldb.query(tabelaSelecionada);
  }

  static Future<int> deletar(String tabelaSelecionada, int id) async {
    final sqldb = await BancoDados.database;
    return await sqldb
        .delete(tabelaSelecionada, where: 'id=?', whereArgs: [id]);
  }

  static Future<List<Map<String, Object>>> leituraPorChave(
      String tabelaSelecionada, String argumento, String chave) async {
    final sqldb = await BancoDados.database;
    return await sqldb
        .query(tabelaSelecionada, where: '$argumento=?', whereArgs: [chave]);
  }
}
