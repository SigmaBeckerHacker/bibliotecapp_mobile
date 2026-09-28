import 'package:bibliotecapp_mobile/database/database_helper.dart';
import 'package:bibliotecapp_mobile/models/livro.dart';
import 'package:sqflite/sqflite.dart';

class LivroDao {
  LivroDao._();
  static final LivroDao instance = LivroDao._();

  Future<List<Livro>> getLivros() async {
    Database db = await DatabaseHelper.instance.database;
    var livros = await db.query('livros', orderBy: 'id DESC');
    List<Livro> livroList = livros.isNotEmpty
        ? livros.map((item) => Livro.fromMap(item)).toList()
        : [];
    return livroList;
  }

  Future<int> add(Livro novoLivro) async {
    Database db = await DatabaseHelper.instance.database;
    return await db.insert('livros', novoLivro.toMap());
  }

  Future<int> remove(Livro livro) async{
    Database db = await DatabaseHelper.instance.database;
    return await db.delete('livros', where: 'id = ?', whereArgs: [livro.id]);
  }

  Future<int> update(Livro livro) async {
    Database db = await DatabaseHelper.instance.database;
    return await db
      .update('livros', livro.toMap(), where: 'id = ?', whereArgs: [livro.id]);
  }
}