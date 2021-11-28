import 'package:flutter/material.dart';
import 'package:todoapp/database_impl.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/screens/infoscreen.dart';
import 'package:todoapp/screens/tasks.dart';
import 'package:todoapp/widgets.dart';

import 'homescreen.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final DataBaseImpl _dbHelper = DataBaseImpl();
  int _selectedIdx = 0;

  List<Widget> pages = <Widget>[
    const Home(),
    const InfoPage()
  ];

  void _onItemTapped(int? index) {
    setState(() {
      _selectedIdx = index!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("To Do"),
        backgroundColor: Colors.indigoAccent,
      ),
      body: pages[_selectedIdx],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.indigoAccent,
        currentIndex: _selectedIdx,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem> [
          const BottomNavigationBarItem(icon: Icon(
            Icons.home,
          ),
              label: "Home"),
          const BottomNavigationBarItem(icon: Icon(
              Icons.info
          ),
              label: "About")
        ],
      ),
    );
  }
}
