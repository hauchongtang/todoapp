import 'package:flutter/material.dart';
import 'package:todoapp/database_impl.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/screens/infoscreen.dart';
import 'package:todoapp/screens/tasks.dart';
import 'package:todoapp/widgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

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
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 32.0,
                      bottom: 32.0,
                    ),
                    child: Image(
                      image: AssetImage(
                        'assets/icons8-exam-96.png',
                      ),
                      height: 64,
                      width: 64,
                    ),
                  ),
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
                bottom: 24.0,
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
              Positioned(
                bottom: 96.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InfoPage())
                    );
                  },
                  child: Container(
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                      color: Colors.deepOrangeAccent,
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Image(
                      height: 48.0,
                      width: 48.0,
                      image: AssetImage(
                        "assets/icons8-question-mark-24.png"
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
