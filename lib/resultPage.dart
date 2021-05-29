import 'package:flutter/material.dart';

//Database
import 'database/database.dart';

//Page
import 'home.dart';


class ResultPage extends StatefulWidget {
  final int wordCardID, fullScore, getScore, getXP, getCoin;
  final String wordCardName;

  ResultPage({
    Key key,
    this.wordCardName,
    this.wordCardID,
    this.fullScore,
    this.getScore,
    this.getXP,
    this.getCoin,
  }) : super(key: key);

  @override
  ResultPageState createState() => ResultPageState(
      wordCardName, wordCardID, fullScore, getScore, getXP, getCoin);
}

class ResultPageState extends State<ResultPage> {
  //Constructer
  ResultPageState(
    this.wordCardName,
    this.wordCardID,
    this.fullScore,
    this.getScore,
    this.getXP,
    this.getCoin,
  ) {
    percent = ((getScore / fullScore) * 100).toInt();
  }

  //Database
  final dbHelper = DatabaseHelper.instance;

  //Value
  int wordCardID, fullScore, getScore, getXP, getCoin;
  int percent, level, nextlevel, levelCap, exp;
  double levelCurve;
  String wordCardName;
  Map<String, dynamic> userData = {};
  Map<String, dynamic> userLevel = {};

  //Function
  Future<void> getUserData() async {
    userData = await dbHelper.queryUserData();
  }

  Future<void> giveReward() async {
    int wcID = await dbHelper.updateWordCardDetail(wordCardID, fullScore, getScore);
    bool coinAdd = await dbHelper.updateCoinUser(getCoin);
    userLevel = await dbHelper.updateXPUserData(getXP);

    await getUserData();
    print('User');
    print(userData);

    setState((){
      exp = userLevel['user_exp'];
      level = userLevel['user_level'];
      levelCap = dbHelper.levelCap(level);
      levelCurve = userLevel['user_exp'] / levelCap;
      nextlevel = level + 1;
      // print(userLevel);
    });
  }

  @override
  void initState() {
    giveReward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Result Page',
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Center(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
                        child: Image.asset(
                          'assets/reward-cup-realPNG.png',
                          scale: 3,
                        ))),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text(
                      'Very good!',
                      style: TextStyle(fontSize: 40),
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: Text(
                      '${percent.toString()}% ($getScore/$fullScore)',
                      style: TextStyle(fontSize: 24),
                    )),
                progressBar(),
                Center(
                  child: Row(children: [     Container( 
                      child: Image.asset(
                    'assets/coin-icon.png',
                    scale: 7,
                  )),Container(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: Text(
                      'Congrat You have earn $getCoin coins!',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),]),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                  child: IconButton(
                    iconSize: 50,
                    icon: Icon(Icons.arrow_back_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            userData: userData
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget progressBar() {
    return Container(
      color: Colors.grey[200],
      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Row(
        children: [
          Expanded(
            child: Center(
                child: Text(
              'LV ${level}',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            flex: 1,
          ),
          Expanded(
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: levelCurve,
                  minHeight: 10,
                  backgroundColor: Colors.green.shade100,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                Text('+$getXP XP ($exp/$levelCap)', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
            flex: 3,
          ),
          Expanded(
            child: Center(
                child: Text(
              'LV $nextlevel',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
