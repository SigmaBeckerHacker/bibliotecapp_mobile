import 'package:bibliotecapp_mobile/database/database_helper.dart';
import 'package:bibliotecapp_mobile/models/autor.dart';
import 'package:sqflite/sqflite.dart';

class AutorDao {
  AutorDao._();
  static final AutorDao instance = AutorDao._();

  Future<List<Autor>> getAutores() async {
    Database db = await DatabaseHelper.instance.database;
    var autores = await db.query('autores', orderBy: 'id DESC');
    List<Autor> autorList = autores.isNotEmpty
        ? autores.map((item) => Autor.fromMap(item)).toList()
        : [];
    return autorList;
  }

  Future<int> add(Autor novoAutor) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.insert('autores', novoAutor.toMap());
  }

  Future<int> remove(Autor autor) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.delete('autores', where: 'id = ?', whereArgs: [autor.id]);
  }

  Future<int> update(Autor autor) async {
    Database db = await DatabaseHelper.instance.database;
    return await db
        .update('autores', autor.toMap(), where: 'id = ?', whereArgs: [autor.id]);
  }
}