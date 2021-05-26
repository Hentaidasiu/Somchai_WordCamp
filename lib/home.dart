import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//Database
import 'database/database.dart';

//Page
import 'profile.dart';
import 'bottomsheet/wordcardInput.dart';
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
  List<String> cateName = ["All", "Fav1", "Fav2", "Fav3", "Fav4", "Fav5"];
  List<String> wordCardName = [
    "English1",
    "CAL1",
    "SCI2",
    "THAI1",
    "JAPAN2",
    "Russian5"
  ];
  List<Map<String, dynamic>> wordcardInfo = [];
  int categorySelect = 0;
  String categoryText = 'All';

  //Function
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("App Bar without Back Button")),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Icon(Icons.add, size: 35.0),
            )
          ],
        ),
        body: getbody(),
        bottomNavigationBar: bottom(context));
  }

  Widget getbody() {
    return Column(children: [
      Expanded(
          flex: -1,
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
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
                    Text("${cateName[1]}")
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
                    Icon(
                      Icons.supervised_user_circle,
                      size: 20,
                    ),
                    Text("${cateName[1]}")
                  ]),
                  color: Colors.teal[100],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  Icon(
                    Icons.supervised_user_circle,
                    size: 20,
                  ),
                  Text("${cateName[1]}")
                ]),
                color: Colors.teal[100],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  Icon(
                    Icons.supervised_user_circle,
                    size: 20,
                  ),
                  Text("${cateName[1]}")
                ]),
                color: Colors.teal[100],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  Icon(
                    Icons.supervised_user_circle,
                    size: 20,
                  ),
                  Text("${cateName[1]}")
                ]),
                color: Colors.teal[100],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  Icon(
                    Icons.supervised_user_circle,
                    size: 20,
                  ),
                  Text("${cateName[1]}")
                ]),
                color: Colors.teal[100],
              ),
            ],
          )),
      Text('Category: $categoryText', style: TextStyle(fontSize: 14)),
      Expanded(
        flex: 8,
        child: FutureBuilder(
          future: getWordCardData(categorySelect),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: wordcardInfo.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
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
                      wordcardInfo[index]['wordcard_name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      wordcardInfo[index]['wordcard_topic'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade800,
                      ),
                    ),
                    trailing: Text(
                      '${wordcardInfo[index]['wordcard_word'].toString()} word',
                    ),
                  );
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
        if (index == 1) {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WordCardInputFormPage()),
          );
        } else if (index == 2) {
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
