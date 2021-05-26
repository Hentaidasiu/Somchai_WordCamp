import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//Page
import '../test.dart';

//Database
import '../database/database.dart';

class TestOptionPage extends StatefulWidget {
  final int wordCardID;
  final List<Map<String, dynamic>> wordList;

  TestOptionPage({Key key, this.wordCardID, this.wordList}) : super(key: key);

  @override
  TestOptionPageState createState() =>
      TestOptionPageState(wordCardID, wordList);
}

class TestOptionPageState extends State<TestOptionPage> {
  //Constructer
  TestOptionPageState(this.wordCardID, this.wordList);

  //Database
  final dbHelper = DatabaseHelper.instance;

  //Value
  List<Map<String, dynamic>> wordList;
  List<bool> groupSelected = [false, false, false];
  bool isTime = false;
  bool isShowAnswer = false;
  bool isRandom = false;
  int wordCardID;

  //Function

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: 480,
        padding: EdgeInsets.fromLTRB(0, 35, 0, 35),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Text(
              'Test Settings',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Total of Question:'),
                    trailing: ToggleButtons(
                      children: <Widget>[
                        Text('10'),
                        Text('30'),
                        Text('All'),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          if (index == 0) {
                            groupSelected[0] = !groupSelected[0];
                            groupSelected[1] = false;
                            groupSelected[2] = false;
                            if (wordList.length < 10) {
                              isRandom = true;
                            }
                          } else if (index == 1) {
                            groupSelected[1] = !groupSelected[1];
                            groupSelected[0] = false;
                            groupSelected[2] = false;
                            if (wordList.length < 30) {
                              isRandom = true;
                            }
                          } else if (index == 2) {
                            groupSelected[2] = !groupSelected[2];
                            groupSelected[0] = false;
                            groupSelected[1] = false;
                          }
                        });
                      },
                      isSelected: groupSelected,
                    ),
                  ),
                  ListTile(
                    title: Text('Time:'),
                    trailing: Switch(
                      value: isTime,
                      onChanged: (value) {
                        setState(() {
                          isTime = value;
                        });
                      },
                      // activeTrackColor: Colors.yellow,
                      // activeColor: Colors.orangeAccent,
                    ),
                  ),
                  ListTile(
                    title: Text('Show Answer:'),
                    trailing: Switch(
                      value: isShowAnswer,
                      onChanged: (value) {
                        setState(() {
                          isShowAnswer = value;
                        });
                      },
                      // activeTrackColor: Colors.yellow,
                      // activeColor: Colors.orangeAccent,
                    ),
                  ),
                  ListTile(
                    title: Text('Random Word:'),
                    trailing: Switch(
                      value: isRandom,
                      onChanged: (value) {
                        setState(() {
                          if (groupSelected[0] == true && wordList.length < 10) {
                            isRandom = true;
                          } else if (groupSelected[1] == true && wordList.length < 30) {
                            isRandom = true;
                          } else {
                            isRandom = value;
                          }
                          
                        });
                      },
                      // activeTrackColor: Colors.yellow,
                      // activeColor: Colors.orangeAccent,
                    ),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                if (groupSelected[0] || groupSelected[1] || groupSelected[2]) {
                  int qTotal = (groupSelected[2]) ? wordList.length : ((groupSelected[1]) ? 30 : 10 );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WordTestPage(
                            wordCardID: wordCardID,
                            wordList: wordList,
                            questionTotal: qTotal,
                            isTime: isTime,
                            isShowAnswer: isShowAnswer,
                            isRandom: isRandom)),
                  );
                }
              },
              icon: Icon(Icons.save),
              label: Text('Start Test'),
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
