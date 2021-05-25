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

  //Function
  Future<bool> readUserData() async {
    userData = await dbHelper.queryUserData();
    return true;
  }

  Future<void> updateUsername() async {
    Map<String, dynamic> newUserData = {
      'user_name': user_name_update
    };

    int i = await dbHelper.updateUserData(1, newUserData);
    print(i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
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
            SizedBox(height: 8),
            Text('Update Username:'),
            TextField(
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              onChanged: (text) {
                setState(() {
                  user_name_update = text;
                });
              },
            ),
            Text('$user_name_update'),
            SizedBox(height: 16),
            ElevatedButton.icon(
                onPressed: () {
                  updateUsername();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Your username change to ''$user_name_update''.'),
                  ));
                  Navigator.pop(context);
                },
                icon: Icon(Icons.save),
                label: Text('Save'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green.shade600,
                  padding: EdgeInsets.symmetric(horizontal: 55, vertical: 15),
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
      ),
    );
  }
}
