import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//Database
import '../database/database.dart';

class AddNewWordPage extends StatefulWidget {
  final int wordCardID;

  AddNewWordPage({Key key, this.wordCardID}) : super(key: key);

  @override
  _AddNewWordPageState createState() => _AddNewWordPageState(wordCardID);
}

class _AddNewWordPageState extends State<AddNewWordPage> {
  //Constructer
  _AddNewWordPageState(this.wordCardID);

  //Database
  final dbHelper = DatabaseHelper.instance;

  //Value
  String wordName = '';
  String wordPronunce = '';
  String wordMeaning = '';
  int wordCardID;

  //Function
  Future<void> insertWord() async {
    Map<String, dynamic> row = {
      'wordcard_ID': wordCardID,
      'word_word': wordName,
      'word_pronunce': wordPronunce,
      'word_meaning': wordMeaning
    };

    final id = await dbHelper.wordInsert(row, wordCardID);
    print('Row ID: $id $row');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 480,
        padding: EdgeInsets.fromLTRB(0, 15.0, 0, 35.0),
        color: Colors.grey[200],
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Add New Word',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Kanit-Light'
                ),
              ),
              SizedBox(height: 16),
              TextField(
                      decoration: new InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.all(
            Radius.circular(10.0)),
                        ),
                        
                        hintText: 'Enter The Word',
                      ),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Kanit-Light'),
                onChanged: (text) {
                  setState(() {
                    wordName = text;
                  });
                },
              ),
              SizedBox(height: 15),
           
              TextField(
                      decoration: new InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.all(
            Radius.circular(10.0)),
                        ),
                        
                        hintText: 'Enter the Pronunciation',
                      ),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Kanit-Light'),
                onChanged: (text) {
                  setState(() {
                    wordPronunce = text;
                  });
                },
              ),
              SizedBox(height: 15),
            
              TextField(
                      decoration: new InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.all(
            Radius.circular(10.0)),
                        ),
                        
                        hintText: 'Enter The Meaning',
                      ),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Kanit-Light'),
                onChanged: (text) {
                  setState(() {
                    wordMeaning = text;
                  });
                },
              ),
              SizedBox(height: 25),
              ElevatedButton.icon(
                onPressed: () {
                  if (wordName != '' && wordMeaning != '') {
                    insertWord();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Add new word complete.'),
                    ));
                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.save),
                label: Text('Save'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.lime,
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
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   unselectedItemColor: Colors.grey[600],
      //   selectedItemColor: Colors.red[300],
      //   backgroundColor: Colors.grey[400],
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.card_membership_rounded),
      //       label: 'Card',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.remove_red_eye_outlined),
      //       label: 'View statistic',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.playlist_play_rounded),
      //       label: 'Test',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add_box_outlined),
      //       label: 'Add word',
      //     ),
      //   ],
      //   onTap: (int index) async {
      //     if (index == 0) {
      //       await Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => WordCardPage()),
      //       );
      //     }
      //     if (index == 1) {
      //       await Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => WordCardInputFormPage()),
      //       );
      //     }
      //     if (index == 2) {
      //       await Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => ProfileInfoPage()),
      //       );
      //     }
      //     if (index == 3) {
      //       await Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => AddNewWordPage()),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
