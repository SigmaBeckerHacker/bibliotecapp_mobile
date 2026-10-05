import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();


  static const int _version = 2;
  static const String _dbName = 'livros_db.db';

  Future<Database> _initDatabase() async {
    String documentsDir = await getDatabasesPath();
    String path = join(documentsDir, _dbName);
    return openDatabase(
      path,
      version: _version,
      onCreate: _createDb,
      onUpgrade: _onUpgrade, 
    );
  }


  Future _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE livros (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        autor TEXT NOT NULL,
        genero TEXT NOT NULL,
        foi_lido INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE usuarios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        senha TEXT NOT NULL
      )
    ''');
  }


  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE usuarios (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          email TEXT NOT NULL,
          senha TEXT NOT NULL
        )
      ''');
    }
  }
}