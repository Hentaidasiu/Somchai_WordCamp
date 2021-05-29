import 'package:flutter/material.dart';

//Database
import 'database/database.dart';

class ProfileInfoPage extends StatefulWidget {
  @override
  ProfileInfoPageState createState() => ProfileInfoPageState();
}

class ProfileInfoPageState extends State<ProfileInfoPage> {
  //Database
  final dbHelper = DatabaseHelper.instance;

  //Value
  Map<String, dynamic> userData;
  String user_name_update = '';
  List list = ["UserName"];

  //Function
  Future<bool> readUserData() async {
    userData = await dbHelper.queryUserData();
    return true;
  }

  Future<void> updateUsername() async {
    Map<String, dynamic> newUserData = {'user_name': user_name_update};

    int i = await dbHelper.updateUserData(1, newUserData);
    print(i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Column(children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return MaterialButton(
                      child: GestureDetector(
                    onLongPressEnd: (LongPressEndDetails details) {},
                    child: Column(
                      children: [
                        ListTile(
                            onTap: () {},
                            title: Column(
                              children: [
                                ClipRRect(
                                  child: Image(
                                    image: NetworkImage(
                                        'https://blog.cpanel.com/wp-content/uploads/2019/08/user-01.png'),
                                  ),
                                  borderRadius: BorderRadius.circular(500),
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(child: Text("${list[index]}")),
                                    Expanded(
                                      flex: 2,
                                      child: TextField(
                                        decoration: new InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          hintText: 'Enter your WordCard Name',
                                        ),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: 'Kanit-Light'),
                                        onChanged: (text) {
                                          setState(() { user_name_update = text;});
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
                        ListTile(
                            title: Row(
                          children: [
                            Expanded(flex: 0, child: Text("LV")),
                            Expanded(flex: 3, child: Text("500")),
                            Expanded(flex: 0, child: Icon(Icons.money)),
                            Expanded(flex: 1, child: Text("77")),
                          ],
                        )),
                        Center(
                            child: FutureBuilder(
                                future: readUserData(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(userData.toString());
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                })),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            updateUsername();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Your username change to '
                                  '$user_name_update'
                                  '.'),
                            ));
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.save),
                          label: Text('Save'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lime,
                            padding: EdgeInsets.symmetric(
                                horizontal: 55, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
                }),
          )
        ]));
  }
}
