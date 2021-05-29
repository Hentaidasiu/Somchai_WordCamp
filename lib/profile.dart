import 'package:flutter/material.dart';

//Database
import 'database/database.dart';

class ProfileInfoPage extends StatefulWidget {



  
  @override
  ProfileInfoPageState createState() => ProfileInfoPageState();
}

class ProfileInfoPageState extends State<ProfileInfoPage> {
  //Database
  final dbHelper = DatabaseHelper.instance;

  //Value
  Map<String, dynamic> userData;
    int percent, level, nextlevel, levelCap, exp;
  String user_name_update = '';
  List list = ["UserName"];
  String username;
  int usercoin = 0;
  int userlevel = 0;
  double levelCurve;
  int getXP;

  //Function
   


  Future<void> getUserData() async {
    userData = await dbHelper.queryUserData();
    print(userData);
    setState(() {
      username = userData['user_name'];
      usercoin = userData['user_coin'];
      userlevel = userData['user_level'];
      levelCap = dbHelper.levelCap(userlevel);
      getXP=userData['user_exp'];
    });
   
  }

 
  //  Future<void> giveReward() async {
  //   int wcID = await dbHelper.updateWordCardDetail(wordCardID, fullScore, getScore);
  //   bool coinAdd = await dbHelper.updateCoinUser(getCoin);
  //   userLevel = await dbHelper.updateXPUserData(getXP);

  //   await getUserData();

  //   setState((){
  //     exp = userLevel['user_exp'];
  //     level = userLevel['user_level'];
  //     levelCap = dbHelper.levelCap(level);
  //     levelCurve = userLevel['user_exp'] / levelCap;
  //     nextlevel = level + 1;
  //     // print(userLevel);
  //   });
  // }



  Future<bool> readUserData() async {
    userData = await dbHelper.queryUserData();
    return true;
  }

  Future<void> updateUsername() async {
    Map<String, dynamic> newUserData = {'user_name': user_name_update};

    int i = await dbHelper.updateUserData(1, newUserData);
    print(i);
  }
    void setData() async {
    await getUserData();

  }
  @override
  void initState() {
    // getUserData();
  setData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
        ),
        body: Column(children: [
          
          Expanded(
            flex: 2,
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return MaterialButton(
                      child: GestureDetector(
                    onLongPressEnd: (LongPressEndDetails details) {},
                    child: Column(
                      children: [
                        ListTile(
                            onTap: () {},
                            title: Column(
                              children: [
                                ClipRRect(
                                  child: Image(
                                    image: NetworkImage(
                                        'https://blog.cpanel.com/wp-content/uploads/2019/08/user-01.png'),
                                  ),
                                  borderRadius: BorderRadius.circular(500),
                                ),
                                  LinearProgressIndicator(
                  value: levelCurve,
                  minHeight: 10,
                  backgroundColor: Colors.green.shade100,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                Text('+$getXP XP ($exp/$levelCap)', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold),),
                                Row(
                                  children: <Widget>[
                                    Expanded(child: Text("${list[index]}")),
                                    Expanded(
                                      flex: 2,
                                      child: TextField(
                                     
                                        decoration: new InputDecoration(
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey, width: 1.0),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                          ),
                                          hintText: '$username',
                                        ),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontFamily: 'Kanit-Light'),
                                        onChanged: (text) {
                                          setState(() { user_name_update = text;});
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
                        ListTile(
                            title: Row(
                          children: [
                            Expanded(flex: 0, child: Text("LV")),
                            Expanded(flex: 3, child: Text("$userlevel")),
                            Expanded(flex: 0, child: Icon(Icons.money)),
                            Expanded(flex: 1, child: Text("$usercoin")),
                          ],
                        )),
                        Center(
                            child: FutureBuilder(
                                future: readUserData(),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Text("");
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                })),
               
                        ElevatedButton.icon(
                          onPressed: () {
                            updateUsername();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Your username change to '
                                  '$user_name_update'
                                  '.'),
                            ));
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.save),
                          label: Text('Save'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lime,
                            padding: EdgeInsets.symmetric(
                                horizontal: 55, vertical: 15),
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
                  ));
                }),
          )
        ])
       
        );
  }
}
