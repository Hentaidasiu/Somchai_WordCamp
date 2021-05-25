import 'package:flutter/material.dart';
import 'package:somchai_wordcamp/bottomsheet/AddNewWord.dart';
import 'package:somchai_wordcamp/bottomsheet/wordcardInput.dart';
import 'package:somchai_wordcamp/profile.dart';

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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  //padding: EdgeInsets.fromLTRB(left, top, right, bottom),
                  child: Text(
                    "Words",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Container(
                  child: Text(
                    "Meaning",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey[600],
              thickness: 3,
            ),
            Container(
              width: double.infinity,
              color: Colors.grey[50],
              child: ListTile(
                title: Text('Understand'),
                subtitle: Text('un der sa tan'),
                trailing: Text('เข้าใจ'),
                onLongPress: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(0, 0, 0, 0),
                    items: [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text('Edit'),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text('Delete'),
                      ),
                    ],
                  );
                  // return ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text('Weight Record Deleted')));
                },
                // onTap: (){
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => DetailWeightPage(
                //         myWeightRecord: allRecords[index],))
                //   );
                // },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey[600],
        selectedItemColor: Colors.red[300],
        backgroundColor: Colors.grey[400],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership_rounded),
            label: 'Card',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye_outlined),
            label: 'View statistic',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play_rounded),
            label: 'Test',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Add word',
          ),
        ],
        onTap: (int index) async {
          if (index == 0) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WordCardPage()),
            );
          }
          if (index == 1) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WordCardInputFormPage()),
            );
          }
          if (index == 2) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileInfoPage()),
            );
          }
          if (index == 3) {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNewWordPage()),
            );
          }
        },
      ),
    );
  }
}
