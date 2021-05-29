import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:popup_menu/popup_menu.dart';

//Database
import 'database/database.dart';

//Page
import 'profile.dart';
import 'game.dart';
import 'bottomsheet/wordcardInput.dart';
import 'bottomsheet/wordcardEdit.dart';
import 'WordCard.dart';

class HomePage extends StatefulWidget {
  //Value
  final Map<String, dynamic> userData;

  //Constructer
  HomePage({Key key, this.userData}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(userData);
}

class _HomePageState extends State<HomePage> {
  //Constructer
  _HomePageState(this.userData) {
    username = userData['user_name'];
    usercoin = userData['user_coin'];
    userlevel = userData['user_level'];
  }

  //Database
  final dbHelper = DatabaseHelper.instance;

  //Value
  Map<String, dynamic> userData = {};
  List<String> cateName = ["All", "FAV1", "FAV2", "FAV3", "FAV4", "FAV5"];
  int MenuSelect;
  List<Map<String, dynamic>> wordcardInfo = [];
  int categorySelect = 0;
  String categoryText = 'All';
  String username = 'Username';
  int usercoin = 0;
  int userlevel = 0;
  int selectedCard = -1;

  //Function
  Future<void> getUserData() async {
    userData = await dbHelper.queryUserData();

    setState(() {
      username = userData['user_name'];
      usercoin = userData['user_coin'];
      userlevel = userData['user_level'];
    });
  }

  Future<bool> getWordCardData(int value) async {
    if (value == 0) {
      wordcardInfo = await dbHelper.queryWordCardData();
    } else {
      wordcardInfo = await dbHelper.queryCategoryData(value);
    }

    setState(() {
      wordcardInfo = wordcardInfo;
      if (value == 0) {
        categoryText = 'All';
      } else {
        categoryText = 'FAV' + value.toString();
      }
    });

    return true;
  }

  Future<bool> getCategoryData(int e) async {
    wordcardInfo = await dbHelper.queryCategoryData(e);

    setState(() {
      wordcardInfo = wordcardInfo;
    });

    return true;
  }

  Future<bool> deleteWordCardData(int value) async {
    int id = await dbHelper.deleteWordCardData(value);
    print(id);

    return true;
  }

  Future<void> refreshData() async {
    setState(() async {
      wordcardInfo = await dbHelper.queryWordCardData();
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(username.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
          title: Text("ADD", style: TextStyle(color: Colors.white))),
      BottomNavigationBarItem(
          icon: Icon(Icons.add),
          title: Text("ADD",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      BottomNavigationBarItem(
          icon: Icon(Icons.message),
          title: Text("GAME",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text("PROFILE",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
    ];
  }

  void showPopup(Offset offset, context) {
    PopupMenu menu = PopupMenu(
        // backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        maxColumn: 2,
        items: [
          MenuItem(
              title: 'Edit',
              textStyle: TextStyle(fontSize: 12.0, color: Colors.lime),
              image: Icon(Icons.edit, color: Colors.lime)),
          MenuItem(
              title: 'Delete',
              textStyle: TextStyle(fontSize: 12.0, color: Colors.lime),
              image: Icon(Icons.delete, color: Colors.lime)),
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
      var deleteID = wordcardInfo[MenuSelect]["wordcard_ID"];
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WordCardEditFormPage(deleteID: deleteID)),
      );
    } else if (item.menuTitle == "Delete") {
      var deleteID = wordcardInfo[MenuSelect]["wordcard_ID"];
      List<Map<String, dynamic>>.from(wordcardInfo).removeAt(MenuSelect);
      MenuSelect = 0;
      var blank = dbHelper.deleteWordCardData(deleteID);
    }
  }

  void onDismiss() {
    print('Menu is dismiss');
  }

  void setData() async {
    await getUserData();
    await getWordCardData(categorySelect);
    await bottomNavSet();
  }

  @override
  void initState() {
    // getUserData();
    getWordCardData(categorySelect);
    bottomNavSet();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Somchai WordCard "  ,style : TextStyle(fontFamily: 'Kanit-Light'))),
        automaticallyImplyLeading: false,
        // actions: <Widget>[
        //   GestureDetector(
        //     onTap: () {},
        //     child: Icon(Icons.add, size: 35.0),
        //   )
        // ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: getbody(),
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
              if (index == 2) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WordCardInputFormPage()),
                );
              } else if (index == 3) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GameNNPage()),
                );
              } else if (index == 4) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileInfoPage()),
                );
              }
              await setData();
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WordCardInputFormPage()),
          );
        },
        child: Icon(
          Icons.add,
          size: 36,
        ),
        backgroundColor: Colors.lime,
        foregroundColor: Colors.black,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget getbody() {
    return Column(children: [
      Expanded(
          flex: -1,
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(2),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            crossAxisCount: 6,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    categorySelect = 0;
                    selectedCard = 0;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(children: [
                    Icon(Icons.supervised_user_circle, size: 24),
                    Text(
                      "${cateName[0].toUpperCase()}",
                      style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Kanit-Light'),
                
                    )
                  ]),
                  color: selectedCard == 0 ? Colors.lime : Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    categorySelect = 1;
                    selectedCard = 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(children: [
                    Icon(Icons.star_rate_rounded, size: 24,color: Color(0xFFFF3377)),
                    Text(
                      "${cateName[1].toUpperCase()}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,fontFamily: 'Kanit-Light'
                      ),
                    )
                  ]),
                  color: selectedCard == 1 ? Colors.lime : Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    categorySelect = 2;
                    selectedCard = 2;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(children: [
                    Icon(
                      Icons.star_rate_rounded,
                       color: Color(0xFFE53344),
                      size: 24,
                    ),
                    Text("${cateName[2].toUpperCase()}",
                        style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Kanit-Light'),
                        overflow: TextOverflow.fade,
                        maxLines: 3,
                        softWrap: false)
                  ]),
                  color: selectedCard == 2 ? Colors.lime : Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    categorySelect = 3;
                    selectedCard = 3;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(children: [
                    Icon(
                      Icons.star_rate_rounded,
                       color: Color(0xFF33DDAA)
                      ,
                      size: 24,
                    ),
                    Text("${cateName[3].toUpperCase()}",
                        style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Kanit-Light'),
                        overflow: TextOverflow.fade,
                        maxLines: 3,
                        softWrap: false)
                  ]),
                  color: selectedCard == 3 ? Colors.lime : Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    categorySelect = 4;
                    selectedCard = 4;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(children: [
                    Icon(
                      Icons.star_rate_rounded,
                       color: Color(0xFF3344AA),
                      size: 24,
                    ),
                    Text("${cateName[4].toUpperCase()}",
                        style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Kanit-Light'),
                        overflow: TextOverflow.fade,
                        maxLines: 3,
                        softWrap: false)
                  ]),
                  color: selectedCard == 4 ? Colors.lime : Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    categorySelect = 5;
                    selectedCard = 5;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Column(children: [
                    Icon(
                      Icons.star_rate_rounded, color: Color(0xFFFFDD00),
                      size: 24,
                    ),
                    Text("${cateName[5].toUpperCase()}",
                        style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Kanit-Light'),
                        overflow: TextOverflow.fade,
                        maxLines: 3,
                        softWrap: false)
                  ]),
                  color: selectedCard == 5 ? Colors.lime : Colors.white,
                ),
              ),
            ],
          )),
      Container(
        padding: EdgeInsets.only(top: 12),
        // child: Text('CATEGORY: ${categoryText.toUpperCase()}',

        //     style: TextStyle(fontSize: 14))
      ),
      Expanded(
        flex: 8,
        child: FutureBuilder(
          future: getWordCardData(categorySelect),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: wordcardInfo.length,
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WordCardDetailPage(
                                        wordCardID: wordcardInfo[index]
                                            ['wordcard_ID'],
                                        wordCardName: wordcardInfo[index]
                                            ['wordcard_name'],
                                            username: username,
                                            usercoin: usercoin.toString(),
                                            userlevel: userlevel.toString(),
                                      ),
                                    ),
                                  );
                                },
                                leading: Icon(Icons.book_rounded, size: 36),
                                title: Text(
                                  wordcardInfo[index]['wordcard_name']
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Kanit-Light'
                                  ),
                                ),
                                subtitle: Text(
                                  wordcardInfo[index]['wordcard_topic']
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.lime[800],
                                    fontFamily: 'Kanit-Light'
                                  ),
                                ),
                                trailing: Text(
                                  '${wordcardInfo[index]['wordcard_word'].toString()} WORD', style: TextStyle(fontFamily: 'Kanit-Light'),
                                ),
                              ),
                              Divider(
                                thickness: 3,
                              ),
                            ],
                          )));
                },
              );
            } else {
              return Center(
                child: Text('No WordCard Created ', style: TextStyle(fontFamily: 'Kanit-Light')),
              );
            }
          },
        ),
      ),
    ]);
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
