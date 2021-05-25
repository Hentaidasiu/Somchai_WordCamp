import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:date_format/date_format.dart';

//Database
import '../database/database.dart';

class WordCardInputFormPage extends StatefulWidget {
  @override
  WordCardInputFormPageState createState() => WordCardInputFormPageState();
}

class WordCardInputFormPageState extends State<WordCardInputFormPage> {
  //Database
  final dbHelper = DatabaseHelper.instance;

  //Value
  List<bool> groupSelected = [false, false, false, false, false];
  String wordCardName = '';
  String wordCardTopic = '';

  //Function
  void insertWordCard() async {
    Map<String, dynamic> row = {
      'wordcard_name': wordCardName,
      'wordcard_topic': wordCardTopic
    };

    Map<String, dynamic> favorite = {
      'favorite_group1': (groupSelected[0]) ? 1 : 0,
      'favorite_group2': (groupSelected[1]) ? 1 : 0,
      'favorite_group3': (groupSelected[2]) ? 1 : 0,
      'favorite_group4': (groupSelected[3]) ? 1 : 0,
      'favorite_group5': (groupSelected[4]) ? 1 : 0,
    };

    final id = await dbHelper.wordcardInsert(row, favorite);
    print('Row ID: $id $row');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ADD NEW WORDCARD'),
      ),
      body: Material(
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 35, 0, 35),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Text(
                'Create new WordCard',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Create your new WordCard for storage your word.',
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
              SizedBox(height: 8),
              Text(
                  '----------------------------------------------------------------'),
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                    Text('Favorite Group:'),
                    SizedBox(height: 8),
                    ToggleButtons(
                      children: <Widget>[
                        Icon(Icons.star_rate_rounded,
                            color: Color(0xFFFF3377), size: 30),
                        Icon(Icons.star_rate_rounded,
                            color: Color(0xFFE53344), size: 30),
                        Icon(Icons.star_rate_rounded,
                            color: Color(0xFF33DDAA), size: 30),
                        Icon(Icons.star_rate_rounded,
                            color: Color(0xFF3344AA), size: 30),
                        Icon(Icons.star_rate_rounded,
                            color: Color(0xFFFFDD00), size: 30),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          groupSelected[index] = !groupSelected[index];

                          print(groupSelected);
                        });
                      },
                      isSelected: groupSelected,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  if (wordCardName != '' && wordCardTopic != '') {
                    insertWordCard();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Congret! You have $wordCardName as a new WordCard.'),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
