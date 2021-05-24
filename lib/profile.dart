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

  //Function
  Future<bool> readUserData() async {
    userData = await dbHelper.queryUserData();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: FutureBuilder(
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
        ),
      ),
    );
  }
}
