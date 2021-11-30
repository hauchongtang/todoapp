import 'package:flutter/material.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/screens/tasks.dart';

import '../database_impl.dart';
import '../widgets.dart';
import 'infoscreen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DataBaseImpl _dbHelper = DataBaseImpl();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.indigoAccent,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: FutureBuilder(
                          initialData: List<TaskModel>.empty(),
                          future: _dbHelper.getTasks(),
                          builder: (context,
                              AsyncSnapshot<List<TaskModel>> snapshot) {
                            // print("Length: $snapshot.data?.length");
                            int length = snapshot.data!.length;
                            return ListView.builder(
                              itemCount: length.isNaN ? 0 : length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Tasks(
                                              task: snapshot.data?[index],
                                            )
                                        )
                                    ).then((value) => {
                                      setState(() {})
                                    });
                                  },
                                  child: TaskCardWidget(
                                    title: snapshot.data?[index].title,
                                    description: snapshot.data?[index].description,
                                  ),
                                );
                              },
                            );
                          },
                        )
                    )
                  ],
                ),
                Positioned(
                  bottom: 8.0,
                  right: 0.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Tasks(task: null,)
                          )
                      ).then((value) => {
                        setState(() {
                          // print("added to state!");
                        })
                      });
                    },
                    child: Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      child: Image(
                        image: AssetImage(
                            "assets/add_icon.png"
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}
