import 'package:bibliotecapp_mobile/database/database_helper.dart';

class UserDao {
  UserDao._privateConstructor();
  static final UserDao instance = UserDao._privateConstructor();

  Future<bool> emailExiste(String email) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<int> cadastrarUsuario(String email, String senhaHash) async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('usuarios', {
      'email': email,
      'senha': senhaHash,
    });
  }

  Future<bool> validarLogin(String email, String senhaHash) async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'usuarios',
      where: 'email = ? AND senha = ?',
      whereArgs: [email, senhaHash],
    );
    return result.isNotEmpty;
  }
}