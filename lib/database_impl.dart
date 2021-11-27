import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todoapp/models/todo_model.dart';

import 'models/task_model.dart';

class DataBaseImpl {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'data1.db'),
        onCreate: (db, version) async {
          await db.execute(
            "CREATE TABLE taskTable(id INTEGER PRIMARY KEY, title TEXT, description TEXT)",
          );
          await db.execute(
            "CREATE TABLE todoTable(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)"
          );
        },
      version: 1,
    );
  }

  Future<int> insertTask(TaskModel taskModel) async {
    int taskId = 0;
    Database _db = await database();
    await _db
        .insert('taskTable', taskModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) => {
          taskId = value
    });
    return taskId;
  }

  Future<void> updateTaskTitle(int? id, String? title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE taskTable SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTaskDesc(int? id, String? desc) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE taskTable SET description = '$desc' WHERE id = '$id'");
  }

  Future<void> updateIsDone(int? id, int? isDone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todoTable SET isDone = '$isDone' WHERE id = '$id'");
  }

  Future<void> insertTodo(TodoModel todoModel) async {
    Database _db = await database();
    await _db.insert('todoTable', todoModel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteTask(int? id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM taskTable WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todoTable WHERE taskId = '$id'");
  }

  Future<List<TaskModel>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query("taskTable");
    return List.generate(taskMap.length, (index) {
      return TaskModel(id: taskMap[index]['id'],
          title: taskMap[index]['title'],
        description: taskMap[index]['description']
      );
    });
  }

  Future<List<TodoModel>> getTodo(int? taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
      await _db.rawQuery("SELECT * FROM todoTable WHERE taskId = $taskId");
    return List.generate(todoMap.length, (index) {
      return TodoModel(
          id: todoMap[index]['id'],
          taskId: todoMap[index]['taskId'],
          title: todoMap[index]['title'],
          isDone: todoMap[index]['isDone']
      );
    });
  }
}
