import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

//Database
import 'database/database.dart';

//Class
import 'object/wordtest.dart';

//Page
import './resultPage.dart';

class GameNNPage extends StatefulWidget {
  @override
  GameNNPageState createState() => GameNNPageState();
}

class GameNNPageState extends State<GameNNPage> {
  //Value
  Random random = new Random();

  List<int> answerList = [0, 0, 0, 0];
  List<String> mode = [];
  String modeSelect;
  String questionText;
  int question, questionCount;
  int score;
  int coin = 0;
  int xp = 0;
  int timeCount;
  bool gamelose;
  double timeCurve = 0;

  WordTest createdWordTest;

  Timer _timer;

  //Function
  void _startTimer() {
    timeCount = 7;

    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeCount > 0) {
          timeCount = timeCount - 1;
        } else {
          answer(9);
        }
        timeCurve = (7 - timeCount) / 7;
      });
    });
  }

  void createQuestion() async {
    int i = question;
    while (i == question) {
      i = await random.nextInt(4) + 1;
    }
    question = i;

    int modeRandom = random.nextInt(mode.length);
    modeSelect = mode[modeRandom];

    setState(() {
      if (modeSelect == 'Normal') {
        questionText = question.toString();
      } else if (modeSelect == '1NOT') {
        questionText = 'NOT ' + question.toString();
      } else if (modeSelect == '2NOT') {
        questionText = 'NOT NOT ' + question.toString();
      } else if (modeSelect == '3NOT') {
        questionText = 'NOT NOT NOT ' + question.toString();
      } else if (modeSelect == 'NOTHING') {
        questionText = '9';
      } else if (modeSelect == 'NOT NOTHING') {
        questionText = 'NOT 9';
      }
    });
  }

  void answer(int choice) {
    _timer.cancel();
    if (!gamelose) {
      if (modeSelect == 'Normal' && choice == question) {
        score = score + 1;
        xp = xp + 3;
        coin = coin + 1;
      } else if (modeSelect == '1NOT' && choice != question) {
        score = score + 1;
        xp = xp + 3;
        coin = coin + 1;
      } else if (modeSelect == '2NOT' && choice == question) {
        score = score + 1;
        xp = xp + 3;
        coin = coin + 1;
      } else if (modeSelect == '3NOT' && choice != question) {
        score = score + 1;
        xp = xp + 3;
        coin = coin + 1;
      } else if (modeSelect == 'NOTHING' && choice == 9) {
        score = score + 1;
        xp = xp + 3;
        coin = coin + 1;
      } else if (modeSelect == 'NOT NOTHING' && choice != 9) {
        score = score + 1;
        xp = xp + 3;
        coin = coin + 1;
      } else {
        setState(() {
          questionText = 'You Lose.';
        });
        gamelose = true;
      }
    }

    if (!gamelose) {
      if (score == 10) {
        mode.add('1NOT');
      } else if (score == 20) {
        mode.add('2NOT');
      } else if (score == 30) {
        mode.add('3NOT');
      } else if (score == 15) {
        mode.add('NOTHING');
      } else if (score == 25) {
        mode.add('NOT NOTHING');
      }

      setState(() {
        createQuestion();
      });
      _startTimer();
    }
  }

  @override
  void initState() {
    score = 0;
    gamelose = false;
    mode.add('Normal');
    createQuestion();
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Flexible(
            child: Text(
              'Not Not Game',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // automaticallyImplyLeading: false,
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
                    flex: 10,
                    child: Text(
                      'Score: $score',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            (!gamelose)
                ? getQuestion(context)
                : Container(
                    padding: EdgeInsets.fromLTRB(0, 80, 0, 80),
                    child: Expanded(
                      flex: 10,
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              'You Lose',
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Final Score: $score',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                  '${questionText}',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            child: LinearProgressIndicator(
              value: timeCurve,
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
                              '1',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          )),
                          color: Colors.green[300],
                          padding: EdgeInsets.fromLTRB(0, 56, 0, 56),
                        ),
                        onTap: () {
                          answer(1);
                        },
                      )),
                      Expanded(
                          child: GestureDetector(
                        child: Container(
                          child: Center(
                              child: Flexible(
                            child: Text(
                              '2',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          )),
                          color: Colors.red[300],
                          padding: EdgeInsets.fromLTRB(0, 56, 0, 56),
                        ),
                        onTap: () {
                          answer(2);
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
                              '3',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          )),
                          color: Colors.blue[300],
                          padding: EdgeInsets.fromLTRB(0, 56, 0, 56),
                        ),
                        onTap: () {
                          answer(3);
                        },
                      )),
                      Expanded(
                          child: GestureDetector(
                        child: Container(
                          child: Center(
                              child: Flexible(
                            child: Text(
                              '4',
                              style: TextStyle(
                                  fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          )),
                          color: Colors.yellow[300],
                          padding: EdgeInsets.fromLTRB(0, 56, 0, 56),
                        ),
                        onTap: () {
                          answer(4);
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
