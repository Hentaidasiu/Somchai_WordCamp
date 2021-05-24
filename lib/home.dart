import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  //ตัวแปลที่จะมารับค่า
  final Map<String, dynamic> myWeightRecord;

  //สร่้าง constructor สำหรับตัวแปล
  HomePage({Key key, this.myWeightRecord}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> cateName = ["All", "Fav1", "Fav2", "Fav3", "Fav4", "Fav5"];
  List<String> wordCardName = [
    "English1",
    "CAL1",
    "SCI2",
    "THAI1",
    "JAPAN2",
    "Russian5"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
  title: Center(child: Text("App Bar without Back Button")),
  automaticallyImplyLeading: false,
),
        body: getbody(),
        bottomNavigationBar: bottom() );
        
  }
}

Widget test() {
  return ListView.builder(
    itemCount: 5,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text("D555555555555"),
      );
    },
  );
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
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: [ Icon(
                  Icons.supervised_user_circle,
                  size: 20,
                ),Text("${cateName[1]}")]),
              color: Colors.teal[100],
            ),
           Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: [ Icon(
                  Icons.supervised_user_circle,
                  size: 20,
                ),Text("${cateName[1]}")]),
              color: Colors.teal[100],
            ),
           Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: [ Icon(
                  Icons.supervised_user_circle,
                  size: 20,
                ),Text("${cateName[1]}")]),
              color: Colors.teal[100],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: [ Icon(
                  Icons.supervised_user_circle,
                  size: 20,
                ),Text("${cateName[1]}")]),
              color: Colors.teal[100],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: [ Icon(
                  Icons.supervised_user_circle,
                  size: 20,
                ),Text("${cateName[1]}")]),
              color: Colors.teal[100],
            ),
           Container(
              padding: const EdgeInsets.all(8),
              child: Column(children: [ Icon(
                  Icons.supervised_user_circle,
                  size: 20,
                ),Text("${cateName[1]}")]),
              color: Colors.teal[100],
            ),
          ],
        )),
    Expanded(
        flex: 8,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text("D555555555555"),
            );
          },
        )),
  
  ]);
}

Widget bottom(){
  return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          backgroundColor: Colors.red,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Business',
          backgroundColor: Colors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'School',
          backgroundColor: Colors.purple,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
          backgroundColor: Colors.pink,
        ),
      ],
     
      selectedItemColor: Colors.amber[800],

    );
}

List<String> userInfo = [
  "Username5",
  "50",
  "250",
];

  List<String> cateName = ["All", "Fav1", "Fav2", "Fav3", "Fav4", "Fav5"];