import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:date_format/date_format.dart';

class DatabaseHelper {
  static final databaseName = 'somchaiWordCampDB.db';
  static final databaseVersion = 2;

  //Build Singleton Class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  //Assign to DatabaseName
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  //Method: Build Database
  _initDatabase() async {
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
      CREATE TABLE favorite_group (favorite_group_ID INTEGER PRIMARY KEY AUTOINCREMENT, wordcard_ID INTEGER NOT NULL, favorite_group1 INTEGER DEFAULT 0, favorite_group2 INTEGER DEFAULT 0, favorite_group3 INTEGER DEFAULT 0, favorite_group4 INTEGER DEFAULT 0, favorite_group5 INTEGER DEFAULT 0);
    ''');

    //Build Data
    Map<String, dynamic> firstUser = {
      'user_name': 'Somchai',
    };
    List<String> firstFavorite = ['FAV1', 'FAV2', 'FAV3', 'FAV4', 'FAV5'];

    await db.insert('user', firstUser);
    for (var i = 0; i < firstFavorite.length; i++) {
      Map<String, dynamic> data = {
        'favorite_name' : firstFavorite[i].toString()
      };
      await db.insert('favorite', data);
    }
  }

  //Method:
  //User: get Data
  Future<Map<String, dynamic>> queryUserData() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> myQueryList =
        await db.rawQuery('SELECT * FROM user');
    return myQueryList[0];
  }
  
  //User: update Data
  Future<int> updateUserData(int id, Map<String, dynamic> row) async {
    Database db = await instance.database;
    
    return await db.update('user', row, where: 'user_ID = ?', whereArgs: [id]);
  }

  //WordCard: get Data
  Future<List<Map<String, dynamic>>> queryWordCardData() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> myWordCardList =
        await db.rawQuery('SELECT * FROM wordcard');
    return myWordCardList;
  }
  
  //WordCard: insert Data
  Future<int> wordcardInsert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int insertID = await db.insert('wordcard', row);
    String currentDate = formatDate(DateTime.now(),
      [d, ' ', M, '-', yyyy]);

    Map<String, dynamic> detailRow = {
      'wordcard_ID': insertID,
      'wordcard_detail_createdate': currentDate,
    };

    int detailID = await db.insert('wordcard_detail', detailRow);
    print(detailID);

    return insertID;
  }

  
  // Future<int> queryRowCount() async {
  //   Database db = await instance.database;
  //   return Sqflite.firstIntValue(
  //       await db.rawQuery('SELECT COUNT(*) from $table'));
  // }

  Future<List<Map<String, dynamic>>> queryFavorite() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> myQueryList =
        await db.rawQuery('SELECT * FROM favorite');
    return myQueryList;
  }

  
  // Future<int> deleteRow(int id) async {
  //   Database db = await instance.database;
  //   return await db.delete(table, where: '$columnID = ?', whereArgs: [id]);
  // }
}
