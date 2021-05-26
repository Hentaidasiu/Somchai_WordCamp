import 'package:flutter/material.dart';
import 'package:somchai_wordcamp/bottomsheet/AddNewWord.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//Page
import 'test.dart';
import 'bottomsheet/testOption.dart';

//Database
import 'database/database.dart';

class WordCardDetailPage extends StatefulWidget {
  final int wordCardID;

  WordCardDetailPage({Key key, this.wordCardID}) : super(key: key);

  @override
  WordCardDetailPageState createState() => WordCardDetailPageState(wordCardID);
}

class WordCardDetailPageState extends State<WordCardDetailPage> {
  //Constructer
  WordCardDetailPageState(this.wordCardID);

  //Database
  final dbHelper = DatabaseHelper.instance;

  //Value
  Map<String, dynamic> wordcardInfo = {};
  List<Map<String, dynamic>> wordList = [];
  int wordCardID;
  String wordCardName = 'Name';

  //Function
  Future<void> getWordCardData() async {
    wordcardInfo = await dbHelper.queryOneWordCardData(wordCardID);

    wordCardName = wordcardInfo['wordcard_name'];
  }

  Future<bool> getWordList() async {
    wordList = await dbHelper.queryWordList(wordCardID);

    return true;
  }

  Future<bool> deleteWordData(int value) async {
    int id = await dbHelper.deleteWordData(value, wordCardID);
    print(id);

    return true;
  }

  @override
  void initState() {
    getWordCardData();
    getWordList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$wordCardName',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Container(
        color: Colors.grey[400],
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  //padding: EdgeInsets.fromLTRB(left, top, right, bottom),
                  child: Text(
                    "Words",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Container(
                  child: Text(
                    "Meaning",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey[600],
              thickness: 3,
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[50],
              child: Column(children: [
                FutureBuilder(
                  future: getWordList(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Text('$wordList'),
                      );
                      // return ListView.builder(
                      //   itemCount: wordList.length,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return here;
                      //   },
                      // );
                    } else {
                      return Center(
                        child: Text('No Word Found'),
                      );
                    }
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey[600],
        selectedItemColor: Colors.red[300],
        backgroundColor: Colors.grey[400],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership_rounded),
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye_outlined),
            label: 'View statistic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play_rounded),
            label: 'Test',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Add word',
          ),
        ],
        onTap: (int index) async {
          if (index == 0) {
            // await Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => WordCardPage()),
            // );
          } else if (index == 1) {
            // await Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => WordTestPage(wordCardID: wordCardID, wordList: wordList, randomQuestion: true)),
            // );
            if (wordList.length < 5) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Require at least 5 word to use Test feature.'),
              ));
            } else {
              await showCupertinoModalBottomSheet(
                duration: Duration(milliseconds: 250), //popup speed
                context: context,
                builder: (context) =>
                    TestOptionPage(wordCardID: wordCardID, wordList: wordList),
              );
            }
          } else if (index == 2) {
            // await Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ProfileInfoPage()),
            // );
          } else if (index == 3) {
            // await Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => AddNewWordPage()),
            // );
            await showCupertinoModalBottomSheet(
              duration: Duration(milliseconds: 250), //popup speed
              context: context,
              builder: (context) => AddNewWordPage(wordCardID: wordCardID),
            );
          }
          setState(() {
            getWordList();
          });
        },
      ),
    );
  }
}
