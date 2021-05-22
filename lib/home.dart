import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  //ตัวแปลที่จะมารับค่า
  final Map<String, dynamic> myWeightRecord;

  //สร่้าง constructor สำหรับตัวแปล
  HomePage({Key key, this.myWeightRecord}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: Center(),
    );
  }
}