import 'package:flutter/material.dart';

//Database
import 'database/database.dart';

//Class
import 'object/wordtest.dart';

class WordTestPage extends StatefulWidget {
  final List<Map<String, dynamic>> wordList;
  final bool isTime, isShowAnswer, isRandom;
  final int wordCardID, questionTotal;

  WordTestPage(
      {Key key,
      this.wordCardID,
      this.wordList,
      this.questionTotal,
      this.isTime,
      this.isShowAnswer,
      this.isRandom})
      : super(key: key);

  @override
  WordTestPageState createState() => WordTestPageState(
      wordCardID, wordList, questionTotal, isTime, isShowAnswer, isRandom);
}

class WordTestPageState extends State<WordTestPage> {
  //Constructer
  WordTestPageState(this.wordCardID, this.wordList, this.questionTotal,
      this.isTime, this.isShowAnswer, this.isRandom) {
    createdWordTest = new WordTest(wordList, questionTotal, isRandom);
  }

  //Value
  List<Map<String, dynamic>> wordList = [];
  List<String> questionList = [];
  List<List<String>> answerList = [];
  List<int> trueanswerList = [];
  bool isTime, isShowAnswer, isRandom;
  int wordCardID, questionTotal;

  WordTest createdWordTest;

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
        title: Text(
          'Test Page',
          style: TextStyle(fontSize: 30),
        ),
      ),
      // body: Column(children: [
      //   Text(questionList.toString()),
      //   Text(answerList.toString()),
      //   Text(trueanswerList.toString()),
      //   Text(questionTotal.toString()),
      //])
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                children: [
                  Expanded(
                      child: Center(
                          child: Text(
                    'Times left',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ))),
                  Expanded(
                      child: Center(
                          child: Text(
                    '1/10',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Center(
                        child: Icon(
                          Icons.timer,
                          size: 100,
                        ),
                      )),
                  Expanded(
                      child: Center(
                          child: Text(
                    'Buy time',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ))),
                  Expanded(
                      child: Center(
                          child: Text(
                    'Hint',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ))),
                  Expanded(
                      child: Center(
                          child: Text(
                    'Skip',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ))),
                ],
              ),
            ),
            getQuestion(),
          ],
        ),
      ),
    );
  }
}

Widget getQuestion() {
  return Container(
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(0, 55, 0, 55),
          child: Text(
            '1. qwertyuiopasdfg',
            style: TextStyle(fontSize: 40),
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
                            child: Text('กำไดใครก่อ', style: TextStyle(fontSize: 20),)),
                            color: Colors.green[300],
                            padding: EdgeInsets.fromLTRB(0, 90, 0, 90),
                        ),
                        onTap: (){
                          
                        },
                      )
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          child: Center(
                            child: Text('กำไดใครก่อ', style: TextStyle(fontSize: 20),)),
                            color: Colors.red[300],
                            padding: EdgeInsets.fromLTRB(0, 90, 0, 90),
                        ),
                        onTap: (){

                        },
                      )
                    )
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
                            child: Text('กำไดใครก่อ', style: TextStyle(fontSize: 20),)),
                            color: Colors.blue[300],
                            padding: EdgeInsets.fromLTRB(0, 90, 0, 90),
                        ),
                        onTap: (){

                        },
                      )
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          child: Center(
                            child: Text('กำไดใครก่อ', style: TextStyle(fontSize: 20),)),
                            color: Colors.yellow[300],
                            padding: EdgeInsets.fromLTRB(0, 90, 0, 90),
                        ),
                        onTap: (){

                        },
                      )
                    )
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
