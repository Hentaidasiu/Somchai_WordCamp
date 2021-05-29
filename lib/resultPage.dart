import 'package:flutter/material.dart';

//Database
import 'database/database.dart';

//Class
import 'object/wordtest.dart';

class ResultPage extends StatefulWidget {

  @override
  ResultPageState createState() => ResultPageState();
}

class ResultPageState extends State<ResultPage> {

  //Value
  List<Map<String, dynamic>> wordList = [];
  List<String> questionList = [];
  List<List<String>> answerList = [];
  List<int> trueanswerList = [];
  bool isTime, isShowAnswer, isRandom;
  int wordCardID, questionTotal;

  WordTest createdWordTest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Result Page',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Center(
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
                child: Image.asset('assets/reward-cup-realPNG.png', scale: 3,)
              )
            ),
            Container(
              child: Text('Very good!', style: TextStyle(fontSize: 40),)
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: Text('90%', style: TextStyle(fontSize: 40),)
            ),
            progressBar(),
            Container(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
              child: Text('You have earn 10 coins!', style: TextStyle(fontSize: 25),),
            ),
            Container(
              child: Image.asset('assets/coin-icon.png', scale: 5,)
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: IconButton(
                iconSize: 50,
                icon: Icon(Icons.arrow_back_outlined),
                onPressed: (){

                },
              ),
            )
          ],
        ),
      )
    );
  }
}

Widget progressBar() {
  return Container(
    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
    child: Row(
      children: [
        Expanded(child: Center(child: Text('LV 17')), flex: 1,),
        Expanded(child: Center(child: LinearProgressIndicator(value: 0.9, minHeight: 10,)), flex: 3,),
        Expanded(child: Center(child: Text('LV 18')), flex: 1,),
      ],
    ),
  );
}
