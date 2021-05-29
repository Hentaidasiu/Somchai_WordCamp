import 'package:flutter/material.dart';
import 'package:somchai_wordcamp/bottomsheet/AddNewWord.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:popup_menu/popup_menu.dart';
//Page
import 'test.dart';
import 'bottomsheet/testOption.dart';
import 'bottomsheet/editword.dart';
//Database
import 'database/database.dart';

class WordCardDetailPage extends StatefulWidget {
  final int wordCardID;
  final String wordCardName;

  WordCardDetailPage({Key key, this.wordCardID, this.wordCardName})
      : super(key: key);

  @override
  WordCardDetailPageState createState() =>
      WordCardDetailPageState(wordCardID, wordCardName);
}

class WordCardDetailPageState extends State<WordCardDetailPage> {
  //Constructer
  WordCardDetailPageState(this.wordCardID, this.wordCardName){
    bottomNavSet();
  }

  //Database
  final dbHelper = DatabaseHelper.instance;

  //Value
  Map<String, dynamic> userData = {};
  Map<String, dynamic> wordcardInfo = {};
  List<Map<String, dynamic>> wordList = [];
  int wordCardID;
  String username = 'Username';
  String wordCardName;
  int MenuSelect;
  int usercoin = 0;
  int userlevel = 0;
  //Function
  Future<void> getWordCardData() async {
    wordcardInfo = await dbHelper.queryOneWordCardData(wordCardID);

    wordCardName = wordcardInfo['wordcard_name'];
  }

  Future<void> getUserData() async {
    userData = await dbHelper.queryUserData();

    setState(() {
      username = userData['user_name'];
      usercoin = userData['user_coin'];
      userlevel = userData['user_level'];
    });
  }

    List<BottomNavigationBarItem> bottomNavBarItems;

  bottomNavSet() {
    bottomNavBarItems = [
         BottomNavigationBarItem(
          title: Container(
            padding: const EdgeInsets.only(left: 4),
            child: Row(children: [
              Text('LV${userlevel.toString()} ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: 'Kanit-Light')),
         
              Text(username.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: 'Kanit-Light')),
            ]),
          ),
          icon: Container(
            padding: const EdgeInsets.only(left: 2),
            child: Row(children: [
              Icon(Icons.money),
              Container(
                margin: const EdgeInsets.only(left: 2),
                child: Text(usercoin.toString()),
              ),
            ]),
          )),
      BottomNavigationBarItem(
          icon: Icon(Icons.add, color: Colors.white),
          title: Text("ADD", style: TextStyle(color: Colors.white,fontFamily: 'Kanit-Light'))),
      BottomNavigationBarItem(
          icon: Icon(Icons.add),
          title: Text("ADD",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: 'Kanit-Light'))),
      BottomNavigationBarItem(
          icon: Icon(Icons.message),
          title: Text("GAME",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: 'Kanit-Light'))),
      BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text("PROFILE",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,fontFamily: 'Kanit-Light'))),
    ];
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

  void showPopup(Offset offset, context) {
    PopupMenu menu = PopupMenu(
        // backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        maxColumn: 3,
        items: [
          MenuItem(title: 'Edit', image: Icon(Icons.mail, color: Colors.white)),
          MenuItem(
              title: 'Delete',
              image: Icon(Icons.book_online_rounded, color: Colors.white)),
          MenuItem(
              title: 'Power',
              image: Icon(
                Icons.power,
                color: Colors.white,
              )),
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    menu.show(rect: Rect.fromPoints(offset, offset));
  }

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  void onClickMenu(MenuItemProvider item) {
    print('Click menu -> ${item.menuTitle}');
    if (item.menuTitle == "Edit") {
      var deleteID = wordList[MenuSelect]["word_ID"];
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditWordPage(wordCardID: wordCardID, deleteID: deleteID)),
      );
    } else if (item.menuTitle == "Delete") {
      var deleteID = wordList[MenuSelect]["word_ID"];
      List<Map<String, dynamic>>.from(wordList).removeAt(MenuSelect);
      MenuSelect = 0;
      var blank = dbHelper.deleteWordData(deleteID, wordCardID);
    }
  }

  void onDismiss() {
    print('Menu is dismiss');
  }


  @override
  void initState() {
    getWordCardData();
    getWordList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$wordCardName',
          style: TextStyle(fontSize: 30,fontFamily: 'Kanit-Light'),
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
                    "  Words",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,fontFamily: 'Kanit-Light'),
                  ),
                ),
                Spacer(),
                Container(
                  child: Text(
                    "Meaning ",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,fontFamily: 'Kanit-Light'),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[50],
              child: Column(children: [
                FutureBuilder(
                  future: getWordList(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      print(wordList);
                      // return Center(
                      //   child: ListTile(
                      //     title: Text('${wordList[0]['word_word']} (${wordList[0]['word_']})'),
                      //   )
                      // );
                      return Container(
                        height: 709,
                        child: ListView.builder(
                          itemCount: wordList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return MaterialButton(
                                child: GestureDetector(
                              onLongPressEnd: (LongPressEndDetails details) {
                                MenuSelect = index;
                                showPopup(details.globalPosition, context);
                              },
                              child: Column(
                                children: [
                                  ListTile(
                                    title:
                                        Text('${wordList[index]['word_word']}', style: TextStyle( fontWeight: FontWeight.bold,fontFamily: 'Kanit-Light',fontSize: 20)),
                                    subtitle: Text(
                                        '(${wordList[index]['word_pronunce']})', style: TextStyle( fontWeight: FontWeight.bold,fontFamily: 'Kanit-Light')),
                                    trailing: Text(
                                        '${wordList[index]['word_meaning']}', style: TextStyle( fontWeight: FontWeight.bold,fontFamily: 'Kanit-Light',fontSize: 20)),
                                  ),
                                  Divider(
                                    thickness: 3,
                                  )
                                ],
                              ),
                            ));

                            // return Column(
                            //   children: [
                            //     ListTile(
                            //       title:
                            //           Text('${wordList[index]['word_word']}'),
                            //       subtitle: Text(
                            //           '(${wordList[index]['word_pronunce']})'),
                            //       trailing: Text(
                            //           '${wordList[index]['word_meaning']}'),

                            //     ),
                            //     Divider(
                            //       thickness: 3,
                            //     )
                            //   ],
                            // );
                          },
                        ),
                      );
                    } else {
                      return Center(
                        child: Text('No Word Found', style: TextStyle( fontWeight: FontWeight.bold,fontFamily: 'Kanit-Light')),
                      );
                    }
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          primarySwatch: Palette.kToDark,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          items: bottomNavBarItems,
          unselectedItemColor: Colors.lime[900],
          type: BottomNavigationBarType.fixed,
          onTap: (int index) async {
          if (index == 0) {
            // await Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => WordCardPage()),
            // );
          } else if (index == 1) {
            // await Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => ProfileInfoPage()),
            // );
          } else if (index == 3) {
            // await Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => WordTestPage(wordCardID: wordCardID, wordList: wordList, randomQuestion: true)),
            // );
            if (wordList.length < 3) {
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {  showCupertinoModalBottomSheet(
              duration: Duration(milliseconds: 250), //popup speed
              context: context,
              builder: (context) => AddNewWordPage(wordCardID: wordCardID),
            );},
        child: Icon(
          Icons.add,
          size: 36,
        ),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

}

class Palette {
  static const MaterialColor kToDark = const MaterialColor(
    0xff827715, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff827715), //10%
      100: const Color(0xff827715), //20%
      200: const Color(0xff827715), //30%
      300: const Color(0xff827715), //40%
      400: const Color(0xff827715), //50%
      500: const Color(0xff00FF00), //60%
      600: const Color(0xff00FF00), //70%
      700: const Color(0xff808080), //80%
      800: const Color(0xff808080), //90%
      900: const Color(0xff808080), //100%
    },
  );
}
