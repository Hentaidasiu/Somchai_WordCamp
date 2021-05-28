import 'package:flutter/material.dart';
import 'package:somchai_wordcamp/WordCard.dart';
import 'package:somchai_wordcamp/home.dart';
import 'package:flutter_overboard/flutter_overboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Somchai_WordCamp',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(title: 'Somchai words camp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Value
  final pages = [
    PageModel(
        color: const Color(0xFF0097A7),
        imageAssetPath: 'assets/landing/a01.png',
        title: 'SOMCHAI WORDCAMP',
        body: 'App that can improve your memory skill.',
        doAnimateImage: true),
    PageModel(
        color: const Color(0xFF536DFE),
        imageAssetPath: 'assets/landing/a02.png',
        title: 'WordCard Storage',
        body: 'Storage words in many WordCard.',
        doAnimateImage: true),
    PageModel(
        color: const Color(0xFF9B90BC),
        imageAssetPath: 'assets/landing/a03.png',
        title: 'Test your memory.',
        body: 'Get a test by using word in WordCard.',
        doAnimateImage: true),
  ];

  //Function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OverBoard(
        pages: pages,
        showBullets: true,
        skipCallback: () {
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   content: Text('Skipped.'),
          // ));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        finishCallback: () {
          //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //     content: Text('Finished.'),
          //   ));
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        },
      ),
    );
  }
}
