import 'package:flutter/material.dart';
import 'package:todoapp/database_impl.dart';
import 'package:todoapp/screens/infoscreen.dart';
import 'package:todoapp/screens/timerpage.dart';
import 'homescreen.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIdx = 0;
  DataBaseImpl _dbHelper = DataBaseImpl();
  int _time = 0;

  List<Widget> pages = <Widget>[
    const Home(),
    const TimerPage(),
    const InfoPage(),
  ];

  void _onItemTapped(int? index) {
    setState(() {
      _selectedIdx = index!;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentWidget = pages[_selectedIdx];
    List<Widget> actionList = [
      IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    title: const Text("Change break time ?"),
                    content: const Text("Please choose"),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            await _dbHelper.insertBreakTime(300);
                            setState(() {
                              _time = 5;
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text("5 min")),
                      TextButton(
                          onPressed: () async {
                            await _dbHelper.insertBreakTime(600);
                            setState(() {
                              _time = 10;
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text("10 min")),
                      TextButton(
                          onPressed: () async {
                            await _dbHelper.insertBreakTime(900);
                            setState(() {
                              _time = 15;
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text("15 min")),
                      TextButton(
                          onPressed: () async {
                            await _dbHelper.insertBreakTime(0);
                            setState(() {
                              _time = 0;
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text("What is rest?"))
                    ],
                  );
                });
          })
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIdx % pages.length != 1
            ? "To Do"
            : "Rest time: " + _time.toString() + " mins"),
        backgroundColor: Colors.indigoAccent,
        actions: actionList,
      ),
      body: currentWidget,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.indigoAccent,
        currentIndex: _selectedIdx % pages.length,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.timer), label: "Pomodoro"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "About")
        ],
      ),
    );
  }
}
