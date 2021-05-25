import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AddNewWordPage extends StatefulWidget{
  @override
  _AddNewWordPageState createState()=> _AddNewWordPageState();
}

class _AddNewWordPageState extends State<AddNewWordPage>{
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Words'),
      ),
      body: Center(
        child: Text('BMI page'),
      )
    );
  }
}