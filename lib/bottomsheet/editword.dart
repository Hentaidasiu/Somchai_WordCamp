import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//Database
import '../database/database.dart';

class EditWordPage extends StatefulWidget {
  final int wordCardID;
  final int deleteID;
  EditWordPage({Key key, this.wordCardID,this.deleteID}) : super(key: key);

  @override
  _EditWordPageState createState() => _EditWordPageState(wordCardID,deleteID);
}

class _EditWordPageState extends State<EditWordPage> {
  //Constructer
  _EditWordPageState(this.wordCardID,this.deleteID);

  //Database
  final dbHelper = DatabaseHelper.instance;

  //Value
  String wordName = '';
  String wordPronunce = '';
  String wordMeaning = '';
  int wordCardID;
  int deleteID;

  //Function
  Future<void> insertWord() async {
    Map<String, dynamic> row = {
      'word_word': wordName,
      'word_pronunce': wordPronunce,
      'word_meaning': wordMeaning
    };

    final id = await dbHelper.updateWordData( deleteID,row);
    print('Row ID: $id $row');
    print('WWWWWWWWWWWWWWWWWWWWW');
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 480,
        padding: EdgeInsets.fromLTRB(0, 35.0, 0, 35.0),
        color: Colors.grey[200],
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Edit Word',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text('Word:'),
              TextField(
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                onChanged: (text) {
                  setState(() {
                    wordName = text;
                  });
                },
              ),
              SizedBox(height: 8),
              Text('Pronunce:'),
              TextField(
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                onChanged: (text) {
                  setState(() {
                    wordPronunce = text;
                  });
                },
              ),
              SizedBox(height: 8),
              Text('Meaning:'),
              TextField(
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                onChanged: (text) {
                  setState(() {
                    wordMeaning = text;
                  });
                },
              ),
              SizedBox(height: 16),
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
      //         MaterialPageRoute(builder: (context) => EditWordPage()),
      //       );
      //     }
      //   },
      // ),
    );
  }
}
