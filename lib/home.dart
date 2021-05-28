

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:popup_menu/popup_menu.dart';
//Database
import 'database/database.dart';

//Page
import 'profile.dart';
import 'bottomsheet/wordcardInput.dart';
import 'bottomsheet/wordcardEdit.dart';
import 'WordCard.dart';

class HomePage extends StatefulWidget {
  //Value
  final Map<String, dynamic> myWeightRecord;

  //Constructer
  HomePage({Key key, this.myWeightRecord}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Database
  final dbHelper = DatabaseHelper.instance;
  
  //Value
  Map<String, dynamic> userData = {};
  List<String> cateName = ["All", "FAV1", "FAV2", "FAV3", "FAV4", "FAV5"];
  int MenuSelect ;
  List<Map<String, dynamic>> wordcardInfo = [];
  int categorySelect = 0;
  String categoryText = 'All';
  String username = 'Username';
  int usercoin = 0;
  int userlevel = 0;

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
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(username.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
      BottomNavigationBarItem(icon: Icon(Icons.add), title: Text("ADD")),
      BottomNavigationBarItem(icon: Icon(Icons.message), title: Text("GAME")),
      BottomNavigationBarItem(icon: Icon(Icons.person), title: Text("PROFILE")),
    ];
  }

  void showPopup(Offset offset ,context ) {
    PopupMenu menu = PopupMenu(
        // backgroundColor: Colors.teal,
        // lineColor: Colors.tealAccent,
        maxColumn: 3,
        items: [
          MenuItem(title: 'Edit', image: Icon(Icons.mail, color: Colors.white)),
          MenuItem(title: 'Delete', image: Icon(Icons.book_online_rounded, color: Colors.white)),
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
      if(item.menuTitle == "Edit"){
      var deleteID = wordcardInfo[MenuSelect]["wordcard_ID"];
      Navigator.push(context,MaterialPageRoute(builder: (context) => WordCardEditFormPage(deleteID : deleteID)),);
      }
      else if (item.menuTitle == "Delete"){
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
    getUserData();
    getWordCardData(categorySelect);
    bottomNavSet();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Somchai WordCard")),
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
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
            items: bottomNavBarItems,
            type: BottomNavigationBarType.fixed,
            onTap: (int index) async {
              if (index == 2) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WordCardInputFormPage()),
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
        backgroundColor: Colors.yellow,
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
            padding: const EdgeInsets.all(4),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            shrinkWrap: true,
            crossAxisCount: 6,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    categorySelect = 0;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(children: [
                    Icon(
                      Icons.supervised_user_circle,
                      size: 20,
                    ),
                    Text(
                      "${cateName[0].toUpperCase()}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ]),
                  color: Colors.teal[100],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    categorySelect = 1;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(children: [
                    Icon(Icons.star_rate_rounded,
                        color: Color(0xFFFF3377), size: 24),
                    Text(
                      "${cateName[1].toUpperCase()}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFFFF3377)),
                    )
                  ]),
                  color: Colors.teal[100],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    categorySelect = 2;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(children: [
                    Icon(
                      Icons.supervised_user_circle,
                      size: 20,
                    ),
                    Text("${cateName[2].toUpperCase()}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                        maxLines: 3,
                        softWrap: false)
                  ]),
                  color: Colors.teal[100],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    categorySelect = 3;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(children: [
                    Icon(
                      Icons.supervised_user_circle,
                      size: 20,
                    ),
                    Text("${cateName[3].toUpperCase()}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                        maxLines: 3,
                        softWrap: false)
                  ]),
                  color: Colors.teal[100],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    categorySelect = 4;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(children: [
                    Icon(
                      Icons.supervised_user_circle,
                      size: 20,
                    ),
                    Text("${cateName[4].toUpperCase()}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                        maxLines: 3,
                        softWrap: false)
                  ]),
                  color: Colors.teal[100],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    categorySelect = 5;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(children: [
                    Icon(
                      Icons.supervised_user_circle,
                      size: 20,
                    ),
                    Text("${cateName[5].toUpperCase()}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                        maxLines: 3,
                        softWrap: false)
                  ]),
                  color: Colors.teal[100],
                ),
              ),
            ],
          )),
      Container(
          padding: EdgeInsets.only(top: 12),
          child: Text('CATEGORY: ${categoryText.toUpperCase()}',
              style: TextStyle(fontSize: 14))),
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
                      showPopup(details.globalPosition,context );
                    },
                    child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WordCardDetailPage(
                            wordCardID: wordcardInfo[index]['wordcard_ID'],
                          ),
                        ),
                      );
                    },
                    
                    leading: Icon(Icons.book_rounded, size: 36),
                    title: Text(
                      wordcardInfo[index]['wordcard_name'].toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      wordcardInfo[index]['wordcard_topic'].toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade800,
                      ),
                    ),
                    trailing: Text(
                      '${wordcardInfo[index]['wordcard_word'].toString()} WORD',
                    ),
                  )
                  ));
                },
              );
            } else {
              return Center(
                child: Text('No WordCard Created'),
              );
            }
          },
        ),
      ),
    ]);
  }

  Widget bottom(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home\ndasdsa',
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Business',
          backgroundColor: Colors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
          backgroundColor: Colors.purple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
          backgroundColor: Colors.pink,
        ),
      ],
      selectedItemColor: Colors.amber[800],
      onTap: (int index) async {
        if (index == 3) {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WordCardInputFormPage()),
          );
        } else if (index == 4) {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileInfoPage()),
          );
        }
        getWordCardData(categorySelect);
      },
    );
  }

  List<String> userInfo = [
    "Username5",
    "50",
    "250",
  ];
}



