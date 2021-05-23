import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final databaseName = 'somchaiWordCampDB.db';
  static final databaseVersion = 2;

  static final table = 'my_weight_tb';
  static final columnID = 'id';
  static final columnWeight = 'weight';
  static final columnRecordDate = 'recorded_date';

  //Build Singleton Class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  //Assign to DatabaseName
  static Database _database;
  Future<Database> get database async {
    // print(_database.getVersion());
    // int currentDBVersion = await _database.getVersion();
    // print('Database');
    // print(_database);
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  //Method: Build Database
  _initDatabase() async {
    // print('Create New');

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);

    return await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
    );
  }

  //Method: Build Table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (user_ID INTEGER PRIMARY KEY AUTOINCREMENT, user_name TEXT NOT NULL, user_level INTEGER DEFAULT 1, user_exp INTEGER DEFAULT 0, user_coin INTEGER DEFAULT 0, user_profileicon INTEGER DEFAULT 1);
    ''');
    await db.execute('''
      CREATE TABLE wordcard (wordcard_ID INTEGER PRIMARY KEY AUTOINCREMENT, wordcard_name TEXT NOT NULL, wordcard_topic TEXT NOT NULL, wordcard_word INTEGER DEFAULT 0)
    ''');
    await db.execute('''
      CREATE TABLE wordcard_detail (wordcard_detail_ID INTEGER PRIMARY KEY AUTOINCREMENT, wordcard_ID INTEGER NOT NULL, wordcard_detail_createdate TEXT NOT NULL, wordcard_detail_testedall INTEGER DEFAULT 0, wordcard_detail_tested10 INTEGER DEFAULT 0, wordcard_detail_tested30 INTEGER DEFAULT 0, wordcard_detail_accuary INTEGER DEFAULT 0, wordcard_detail_highscore INTEGER DEFAULT 0);
    ''');
    await db.execute('''
      CREATE TABLE word (word_ID INTEGER PRIMARY KEY AUTOINCREMENT, wordcard_ID INTEGER NOT NULL, word_word TEXT NOT NULL, word_pronunce TEXT, word_meaning TEXT NOT NULL);
    ''');
    await db.execute('''
      CREATE TABLE favorite (favorite_ID INTEGER PRIMARY KEY AUTOINCREMENT, favorite_name TEXT NOT NULL);
    ''');
    await db.execute('''
      CREATE TABLE favorite_group (favorite_group_ID INTEGER PRIMARY KEY AUTOINCREMENT, favorite_ID INTEGER NOT NULL, wordcard_ID INTEGER NOT NULL);
    ''');

    Map<String, dynamic> firstUser = {
      'user_name': 'Somchai',
    };

    List<String> firstFavorite = ['FAV1', 'FAV2', 'FAV3', 'FAV4', 'FAV5'];

    await db.insert('user', firstUser);

    for (var i = 0; i < firstFavorite.length; i++) {
      Map<String, dynamic> data = {
        'favorite_name' : firstFavorite[i].toString()
      };
      print(data);
      await db.insert('favorite', data);
    }
  }

  //Method: Data Editted
  //I: Add Data and return record ID.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('user', row);
  }

  //II: Data row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) from $table'));
  }

  //III: Get Data.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> myQueryList =
        await db.rawQuery('SELECT * FROM user');
    return myQueryList;
  }

  Future<List<Map<String, dynamic>>> queryFavorite() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> myQueryList =
        await db.rawQuery('SELECT * FROM favorite');
    return myQueryList;
  }

  //IV: Drop Data row. And return deleted row.
  Future<int> deleteRow(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnID = ?', whereArgs: [id]);
  }
}
