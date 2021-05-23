import 'package:flutter/material.dart';
import 'package:somchai_wordcamp/WordCard.dart';
import 'package:somchai_wordcamp/home.dart';

import 'database/database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Somchai_WordCamp',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Somchai words camp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Database
  final dbHelper = DatabaseHelper.instance;

  //Value
  List<Map<String, dynamic>> userData;
  List<Map<String, dynamic>> favoriteData;

  //Function
  Future<bool> readUserData() async {
    // List<Map<String, dynamic>> data = await dbHelper.queryAllRows();
    userData = await dbHelper.queryAllRows();
    print('UserData');
    print(userData);

    favoriteData = await dbHelper.queryFavorite();
    print('FavouriteData');
    print(favoriteData);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                icon: Icon(Icons.home),
                label: Text('Home'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[600],
                  padding: EdgeInsets.symmetric(
                      horizontal: 30, vertical: 10), //ตามแกน
                  shape: RoundedRectangleBorder(
                      borderRadius: (BorderRadius.circular(5.0))),
                  textStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              //-------------------------------------MemorycardButtonBelow----------------------------------------
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WordCardPage()));
                },
                icon: Icon(Icons.home),
                label: Text('MemoryCard'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.grey[600],
                  padding: EdgeInsets.symmetric(
                      horizontal: 30, vertical: 10), //ตามแกน
                  shape: RoundedRectangleBorder(
                      borderRadius: (BorderRadius.circular(5.0))),
                  textStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder(
                future: readUserData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Text(userData.toString());
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
