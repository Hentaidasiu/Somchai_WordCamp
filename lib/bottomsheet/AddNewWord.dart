import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../database/database.dart';

class AddNewWordPage extends StatefulWidget{
  @override
  _AddNewWordPageState createState()=> _AddNewWordPageState();
}

class _AddNewWordPageState extends State<AddNewWordPage>{

  final dbHelper = DatabaseHelper.instance;
  String wordCardName = '';
  String wordCardTopic = '';
  void insertWordCard() async {
    Map<String, dynamic> row = {
      'wordcard_name': wordCardName,
      'wordcard_topic': wordCardTopic
    };

    //final id = await dbHelper.wordcardInsert(row);
    //print('Row ID: $id $row');
  }

  @override 
  Widget build(BuildContext context){
    return Material(
      child: Container(
        height: 500,
        padding:  EdgeInsets.fromLTRB(0, 35.0, 0, 35.0),
        color: Colors.grey[200],
        child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text('WordCard Name:'),
                    TextField(
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      onChanged: (text) {
                        setState(() {
                          wordCardName = text;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Text('WordCard Topic:'),
                    TextField(
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      onChanged: (text) {
                        setState(() {
                          wordCardTopic = text;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Text('WordCard Topic:'),
                    TextField(
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      onChanged: (text) {
                        setState(() {
                          wordCardTopic = text;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        insertWordCard();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Congret! You have $wordCardName as a new WordCard.'),
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