import 'dart:io';
import 'dart:math';
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
        'favorite_name': firstFavorite[i].toString()
      };
      await db.insert('favorite', data);
    }
  }

  //Method:
  //User: get Data
  Future<Map<String, dynamic>> queryUserData() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> myQueryList =
        await db.rawQuery('SELECT * FROM user WHERE user_ID = 1');

    return myQueryList[0];
  }

  //User: update Data
  Future<int> updateUserData(int id, Map<String, dynamic> row) async {
    Database db = await instance.database;

    return await db.update('user', row, where: 'user_ID = ?', whereArgs: [id]);
  }

  //User: update xp Data
  Future<Map<String, dynamic>> updateXPUserData(int gainXP) async {
    Database db = await instance.database;
    int id = 0;

    List<Map<String, dynamic>> user = await db.rawQuery('SELECT * FROM user WHERE user_ID = 1');
    Map<String, dynamic> userData = user[id];

    int newXP = userData['user_exp'].toInt() + gainXP;
    int newLevel = userData['user_level'];
    while (newXP >= levelCap(newLevel)) {
      newXP = newXP - levelCap(newLevel);
      newLevel = newLevel + 1;
    }

    Map<String, dynamic> newUserData = {
      'user_exp': newXP,
      'user_level': newLevel
    };

    int returnID = await db.update('user', newUserData, where: 'user_ID = ?', whereArgs: [id]);

    return newUserData;
    // return await db.update('user', row, where: 'user_ID = ?', whereArgs: [id]);
  }

  //User: update coin Data
  Future<bool> updateCoinUser(int gainCoin) async {
    Database db = await instance.database;
    int id = 0;

    List<Map<String, dynamic>> user = await db.rawQuery('SELECT * FROM user WHERE user_ID = 1');
    Map<String, dynamic> userData = user[id];

    int newCoin = userData['user_coin'] + gainCoin;

    Map<String, dynamic> newCoinData = {
      'user_coin': newCoin
    };
    // print(newCoinData);

    if (newCoin >= 0) {
      var returnID = await db.update('user', newCoinData, where: 'user_ID = ?', whereArgs: [id]);
      return true;
    } else {
      return false;
    }
  }

  //User: update profile Data
  Future<bool> updateProfileUser(int profile) async {
    Database db = await instance.database;
    int id = 0;

    Map<String, dynamic> newProfileData = {
      'user_profileicon': profile
    };

    var returnID = await db.update('user', newProfileData, where: 'user_ID = ?', whereArgs: [id]);
    return true;
  }

  //Get XP Range
  int levelCap(int level) {
    int power = pow(2, level-2).toInt();
    return 100 * power;
  }

  //WordCard: get Data
  Future<List<Map<String, dynamic>>> queryWordCardData() async {
    Database db = await instance.database;

    List<Map<String, dynamic>> myWordCardList =
        await db.rawQuery('SELECT * FROM wordcard');
    return myWordCardList;
  }

  //WordCard: get Data [One]
  Future<Map<String, dynamic>> queryOneWordCardData(int value) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> myWordCardData =
        await db.rawQuery('SELECT * FROM wordcard WHERE wordcard_ID = $value');
    return myWordCardData[0];
  }

  //WordCard: get Category
  Future<List<Map<String, dynamic>>> queryCategoryData(int event) async {
    Database db = await instance.database;

    String column = "favorite_group" + event.toString();

    List<Map<String, dynamic>> myCategoryList =
        await db.rawQuery('SELECT * FROM favorite_group where $column == 1');

    List<Map<String, dynamic>> mynewCategoryList = [];
    for (var i = 0; i < myCategoryList.length; i++) {
      var context = myCategoryList[i]['wordcard_ID'];
      List<Map<String, dynamic>> getInfo = await db
          .rawQuery('SELECT * FROM wordcard where wordcard_ID == $context');
      mynewCategoryList.addAll(getInfo);
    }

    return mynewCategoryList;
  }

  //WordCard: insert Data
  Future<int> wordcardInsert(
      Map<String, dynamic> row, Map<String, dynamic> favorite) async {
    Database db = await instance.database;
    int insertID = await db.insert('wordcard', row);
    String currentDate = formatDate(DateTime.now(), [d, ' ', M, '-', yyyy]);

    Map<String, dynamic> detailRow = {
      'wordcard_ID': insertID,
      'wordcard_detail_createdate': currentDate,
    };

    favorite['wordcard_ID'] = insertID;
    // print(favorite);

    int detailID = await db.insert('wordcard_detail', detailRow);
    // print(detailID);

    int favoriteID = await db.insert('favorite_group', favorite);
    // print(favoriteID);

    return insertID;
  }

  //WordCard: update Data
  Future<int> updateWordCardData(int id, Map<String, dynamic> row) async {
    Database db = await instance.database;

    return await db.update('wordcard', row, where: 'wordcard_ID = ?', whereArgs: [id]);
  }

  //WordCard: update detail
  Future<int> updateWordCardDetail(int id, int fullscore, int getscore) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> row = await db.rawQuery('SELECT * FROM wordcard_detail WHERE wordcard_ID = $id');
    Map<String, dynamic> wordRow = row[0];

    int newN = wordRow['wordcard_detail_testedall'].toInt();
    newN = newN + 1;
    int newAccuary = ((((wordRow['wordcard_detail_testedall'] * wordRow['wordcard_detail_accuary']) + (getscore / fullscore)) / newN) * 100).toInt();
    int newHighscore = (wordRow['wordcard_detail_highscore'].toInt() > getscore) ? wordRow['wordcard_detail_highscore'].toInt() : getscore;

    Map<String, dynamic> newRow = {
      'wordcard_detail_testedall': newN,
      'wordcard_detail_accuary': newAccuary,
      'wordcard_detail_highscore': newHighscore
    };
    // print(newRow);

    return await db.update('wordcard_detail', newRow, where: 'wordcard_ID = ?', whereArgs: [id]);
  }

  //WordCard: delete Data
  Future<int> deleteWordCardData(int id) async {
    Database db = await instance.database;
    int deleteid = await db.delete('wordcard', where: 'wordcard_ID = ?', whereArgs: [id]);
    int wordDelete = await db.delete('word', where: 'wordcard_ID = ?', whereArgs: [id]);
    int favoriteDelete = await db.delete('favorite_group', where: 'wordcard_ID = ?', whereArgs: [id]);
    
    return deleteid;
  }

  //Word: get word
  Future<List<Map<String, dynamic>>> queryWordList(int value) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> myWordList =
        await db.rawQuery('SELECT * FROM word WHERE wordcard_ID = $value');
    return myWordList;
  }

  //Word: insert Data
  Future<int> wordInsert(Map<String, dynamic> row, int id) async {
    Database db = await instance.database;

    int insertID = await db.insert('word', row);

    List<Map<String, dynamic>> myWordCardData =
        await db.rawQuery('SELECT * FROM wordcard WHERE wordcard_ID = $id');
    
    Map<String, dynamic> updateWordCard = {
      'wordcard_word': myWordCardData[0]['wordcard_word'] + 1
    };

    int result = await db.update('wordcard', updateWordCard, where: 'wordcard_ID = ?', whereArgs: [id]);

    return insertID;
  }

  //Word: update Data
  Future<int> updateWordData(int id, Map<String, dynamic> row) async {
    print(id);
    print(row);
    Database db = await instance.database;

    return await db.update('word', row, where: 'word_ID = ?', whereArgs: [id]);
  }

  //Word: delete Data
  Future<int> deleteWordData(int id, int wordcardID) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> myWordCardData =
        await db.rawQuery('SELECT * FROM wordcard WHERE wordcard_ID = $wordcardID');
    
    Map<String, dynamic> updateWordCard = {
      'wordcard_word': myWordCardData[0]['wordcard_word'] - 1
    };

    int result = await db.update('wordcard', updateWordCard, where: 'wordcard_ID = ?', whereArgs: [wordcardID]);

    return await db.delete('word', where: 'word_ID = ?', whereArgs: [id]);
  }
}
