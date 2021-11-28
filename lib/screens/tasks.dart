import "package:flutter/material.dart";
import 'package:todoapp/database_impl.dart';
import 'package:todoapp/models/task_model.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/widgets.dart';

class Tasks extends StatefulWidget {
  final TaskModel? task;
  const Tasks({required this.task});

  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  String? _taskTitle = "";
  String? _taskDescription = "";
  int? _taskId = 0;
  final DataBaseImpl _dbHelper = DataBaseImpl();
  bool? _contentVisible = false;

  FocusNode _titleFocus = FocusNode();
  FocusNode _descFocus = FocusNode();
  FocusNode _todoFocus = FocusNode();

  @override
  void initState() {
    if (widget.task != null) {
      _taskTitle = widget.task?.title;
      _taskId = widget.task?.id;
      _taskDescription = widget.task?.description;
      _contentVisible = true;
    }
    // print("ID: ${widget.task?.id}");
    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        actions: [
          IconButton(
            onPressed: () async {
              if (_taskId != 0) {
                // await _dbHelper.deleteTask(_taskId);
                // Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: const Text("Please confirm"),
                      content: const Text("Do you want to remove the Task?"),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              await _dbHelper.deleteTask(_taskId);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: const Text("Yes")
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("No")
                        ),
                      ],
                    );
                  }
                );
              }
            },
            icon: const Icon(
              Icons.delete_rounded,
            )
          )
        ],
      ),
        body: SafeArea(
            child: Container(
                child: Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 24.0,
                bottom: 4.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.0
                      ),
                      child: TextField(
                        // ENTER TASK MAIN FIELD
                        focusNode: _titleFocus,
                        onSubmitted: (value) async {
                          print("Field value: $value");

                          if (value.isNotEmpty) {
                            if (widget.task == null && _taskId == 0) {
                              DataBaseImpl _dbHelper = DataBaseImpl();
                              TaskModel _newTask = TaskModel(title: value);
                              _taskId = await _dbHelper.insertTask(_newTask);
                              setState(() {
                                _contentVisible = true;
                                _taskTitle = value;
                              });
                              print("Created! id: $_taskId");
                            } else {
                              // TaskModel _newTask = TaskModel(title: value);
                              await _dbHelper.updateTaskTitle(_taskId, value);

                              setState(() {
                                _contentVisible = true;
                                _taskTitle = value;
                              });
                              print("Update existing task");
                            }

                            // focus to desc field
                            _descFocus.requestFocus();
                          }
                        },
                        controller: TextEditingController()..text = _taskTitle!,
                        decoration: InputDecoration(
                          hintText: "Enter Task Title",
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: _contentVisible!,
              child: Padding(
                // ENTER DESCRIPTION
                padding: EdgeInsets.only(
                  bottom: 12.0,
                ),
                child: TextField(
                  focusNode: _descFocus,
                  onSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      if (_taskId != 0) {
                        await _dbHelper.updateTaskDesc(_taskId, value);
                        _taskDescription = value;
                        print("desc updated!");
                      }
                    }
                    _todoFocus.requestFocus();
                  },
                  controller: TextEditingController()
                    ..text = _taskDescription == null
                        ? ""
                        : _taskDescription.toString(),
                  decoration: InputDecoration(
                      hintText: "Enter description",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 24.0)),
                ),
              ),
            ),
            Visibility(
              visible: _contentVisible!,
              child: FutureBuilder(
                initialData: List<TodoModel>.empty(),
                future: _dbHelper.getTodo(_taskId),
                builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
                  int length = snapshot.data!.length;
                  // deep copy
                  List<TodoModel>? checkList = [...snapshot.data!];
                  TodoModel? tempStore = null;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: length.isNaN ? 0 : length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: InkWell(
                            child: CheckListWidget(
                              text: checkList[index].title,
                              isDone:
                                  checkList[index].isDone == 0 ? false : true,
                            ),
                            onTap: () async {
                              if (checkList[index].isDone == 0) {
                                await _dbHelper.updateIsDone(
                                    checkList[index].id, 1);
                              } else {
                                await _dbHelper.updateIsDone(
                                    checkList[index].id, 0);
                              }
                              setState(() {});
                            },
                            onLongPress: () async {
                              tempStore = checkList[index];
                              // await _dbHelper
                              //     .deleteCheckListItem(checkList[index].id);
                              // ScaffoldMessenger.of(context)
                              //     .showSnackBar(
                              //     SnackBar(
                              //       content: Text("Task Deleted"),
                              //       action: SnackBarAction(
                              //         label: "Undo",
                              //         onPressed: () async {
                              //           _dbHelper.insertTodo(tempStore!);
                              //           tempStore = null;
                              //           setState(() {});
                              //         },
                              //       ),
                              //     )
                              // );
                              showDialog(
                                  context: context,
                                  builder: (BuildContext ctx) {
                                    return AlertDialog(
                                      title: const Text("Please confirm"),
                                      content: const Text("Remove check list?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              await _dbHelper.deleteCheckListItem(checkList[index].id);
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text("Task Deleted"),
                                                  action: SnackBarAction(
                                                    label: "Undo",
                                                    onPressed: () async {
                                                      _dbHelper.insertTodo(tempStore!);
                                                      tempStore = null;
                                                      setState(() {});
                                                    },
                                                  ),
                                                )
                                              );
                                              setState(() {});
                                            },
                                            child: const Text("Yes")
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("No")
                                        ),
                                      ],
                                    );
                                  }
                              );
                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: _contentVisible!,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Container(
                          // CHECKBOX
                          width: 20.0,
                          height: 20.0,
                          margin: EdgeInsets.only(right: 10.0),

                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: Colors.black45, width: 1.5)),
                          child: Image(
                            image: AssetImage("assets/check_icon.png"),
                          ),
                        ),
                        Expanded(
                          // ENTER ITEM
                          child: TextField(
                            focusNode: _todoFocus,
                            controller: TextEditingController()..text = "",
                            onSubmitted: (value) async {
                              if (value.isNotEmpty) {
                                if (_taskId != 0) {
                                  DataBaseImpl _dbHelper = DataBaseImpl();
                                  TodoModel _newTodo = TodoModel(
                                    title: value,
                                    isDone: 0,
                                    taskId: _taskId,
                                  );

                                  await _dbHelper.insertTodo(_newTodo);
                                  setState(() {});
                                  _todoFocus.requestFocus();
                                } else {
                                  print("Task dont exist");
                                }
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Enter the item",
                              border: InputBorder.none,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    ))));
  }
}
