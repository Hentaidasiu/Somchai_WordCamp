import 'package:flutter/material.dart';

//Database
import 'database/database.dart';

//Class
import 'object/wordtest.dart';

class WordTestPage extends StatefulWidget {
  final List<Map<String, dynamic>> wordList;
  final bool isTime, isShowAnswer, isRandom;
  final int wordCardID, questionTotal;

  WordTestPage({Key key, this.wordCardID, this.wordList, this.questionTotal, this.isTime, this.isShowAnswer, this.isRandom}) : super(key: key);

  @override
  WordTestPageState createState() => WordTestPageState(wordCardID, wordList, questionTotal, isTime, isShowAnswer, isRandom);
}

class WordTestPageState extends State<WordTestPage> {
  //Constructer
  WordTestPageState(this.wordCardID, this.wordList, this.questionTotal, this.isTime, this.isShowAnswer, this.isRandom) {
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
      body: Column(
        children: [
          Text(questionList.toString()),
          Text(answerList.toString()),
          Text(trueanswerList.toString()),
          Text(questionTotal.toString()),
        ]
      )
    );
  }
}