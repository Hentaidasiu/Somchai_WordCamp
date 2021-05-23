import 'package:flutter/material.dart';

class WordCardPage extends StatefulWidget {
  @override
  _WordCardPageState createState() => _WordCardPageState();
}

class _WordCardPageState extends State<WordCardPage> {
  // //อ่านข้อมูล
  // Future<bool> readWeightRecorderDB() async{
  //   allRecords = await dbHelper.queryAllRows();
  //   print(allRecords);
  //   return true;
  // }

  // //ลบข้อลูล
  // Future<int> deleteWeightRecorderDB(int id) async{
  //   var numberOfDeleteItem = await dbHelper.delete(id);
  //   print('Delete Weight Record ID = $id');
  //   return numberOfDeleteItem;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'English Word',
            style: TextStyle(fontSize: 30),
          ),
        ),
        body: Container(
          color: Colors.grey[400],
          width: double.infinity,
          height: 50,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Words",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "Meaning",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
                thickness: 2,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          child: Container(
            height: 100,
            //padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            color: Colors.purple[400],
          ),
        ));
  }
}
