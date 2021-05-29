import 'package:flutter/material.dart';

//Database
import 'database/database.dart';

//Class
import 'object/wordtest.dart';

//Page
import './resultPage.dart';

class WordTestPage extends StatefulWidget {
  final List<Map<String, dynamic>> wordList;
  final String wordCardName;
  final bool isTime, isShowAnswer, isRandom;
  final int wordCardID, questionTotal;

  WordTestPage(
      {Key key,
      this.wordCardName,
      this.wordCardID,
      this.wordList,
      this.questionTotal,
      this.isTime,
      this.isShowAnswer,
      this.isRandom})
      : super(key: key);

  @override
  WordTestPageState createState() => WordTestPageState(
      wordCardName, wordCardID, wordList, questionTotal, isTime, isShowAnswer, isRandom);
}

class WordTestPageState extends State<WordTestPage> {
  //Constructer
  WordTestPageState(this.wordCardName, this.wordCardID, this.wordList, this.questionTotal,
      this.isTime, this.isShowAnswer, this.isRandom) {
    createdWordTest = new WordTest(wordList, questionTotal, isRandom);
  }

  //Value
  List<Map<String, dynamic>> wordList = [];
  List<String> questionList = [];
  List<List<String>> answerList = [];
  List<int> trueanswerList = [];
  List<int> myanswerList = [];
  String wordCardName;
  bool isTime, isShowAnswer, isRandom;
  int wordCardID, questionTotal;
  int questionI = 0;
  int score = 0;
  int coin = 0;
  int xp = 0;

  WordTest createdWordTest;

  //Function
  void answer(int choice) {
    if (choice == trueanswerList[questionI]) {
      score = score + 1;
      xp = xp + 5;
      coin = coin + 3;
    } else {
      xp = xp + 3;
      coin = coin + 1;
    }

    if (questionI + 1 == questionTotal) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ResultPage(wordCardName: wordCardName, wordCardID: wordCardID, fullScore: questionTotal, getScore: score, getXP: xp, getCoin: coin)),
      );
    } else {
      setState(() {
        questionI = questionI + 1;
      });
    }
  }

  @override
  void initState() {
    wordList = createdWordTest.getwordList();
    questionList = createdWordTest.getQuestion();
    answerList = createdWordTest.getAnswer();
    trueanswerList = createdWordTest.getTrueAnswer();
    questionTotal = questionList.length;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Flexible(
                      child: Text(
              '$wordCardName''s Test',
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      ' ${questionI + 1}/$questionTotal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Row(children: [Icon(Icons.more_time) ,Text(
                          'TIME',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )],
                       
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Row(children: [Icon(Icons.lightbulb) ,Text(
                          'Hint',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )],
                       
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child:  Row(children: [Icon(Icons.skip_next) ,Text(
                          'SKIP',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )],
                       
                      ),
                    ),
                  ),
                ],
              ),
            ),
            getQuestion(context),
          ],
        ),
      ),
    );
  }

  Widget getQuestion(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 80, 0, 80),
            child: Expanded(
              flex: 10,
              child: Container(
                child: Text(
                  '${questionI + 1}. ${questionList[questionI]}',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            child: LinearProgressIndicator(
              value: 0.4,
              minHeight: 10,
              backgroundColor: Colors.white,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        child: Container(
                          child: Center(
                              child: Flexible(
                            child: Text(
                              '${answerList[questionI][0]}',
                            ),
                          )),
                          color: Colors.green[300],
                          padding: EdgeInsets.fromLTRB(0, 64, 0, 64),
                        ),
                        onTap: () {
                          answer(0);
                        },
                      )),
                      Expanded(
                          child: GestureDetector(
                        child: Container(
                          child: Center(
                              child: Flexible(
                            child: Text(
                              '${answerList[questionI][1]}',
                            ),
                          )),
                          color: Colors.red[300],
                          padding: EdgeInsets.fromLTRB(0, 64, 0, 64),
                        ),
                        onTap: () {
                          answer(1);
                        },
                      ))
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        child: Container(
                          child: Center(
                              child: Flexible(
                            child: Text(
                              '${answerList[questionI][2]}',
                            ),
                          )),
                          color: Colors.blue[300],
                          padding: EdgeInsets.fromLTRB(0, 64, 0, 64),
                        ),
                        onTap: () {
                          answer(2);
                        },
                      )),
                      Expanded(
                          child: GestureDetector(
                        child: Container(
                          child: Center(
                              child: Flexible(
                            child: Text(
                              '${answerList[questionI][3]}',
                            ),
                          )),
                          color: Colors.yellow[300],
                          padding: EdgeInsets.fromLTRB(0, 64, 0, 64),
                        ),
                        onTap: () {
                          answer(3);
                        },
                      ))
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
