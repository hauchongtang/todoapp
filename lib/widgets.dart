import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String? title;
  final String? description;
  const TaskCardWidget({this.title, this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: 32.0,
          horizontal: 24.0,
        ),
        margin: EdgeInsets.only(
          bottom: 20.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? "NoName",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
              Text(
                description ?? "No description given",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  color: Color(0xFF86829D),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 4.0
                ),
                child: Icon(
                  Icons.insert_emoticon_rounded,
                ),
              )
            ]
        )
    );
  }
}

class CheckListWidget extends StatelessWidget {
  final String? text;
  final bool? isDone;
  CheckListWidget({this.text, @required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 8.0
        ),
        child: Row(
          children: [
            Container(
              width: 20.0,
              height: 20.0,
              margin: EdgeInsets.only(
                right: 10.0
              ),

              decoration: BoxDecoration(
                color: isDone == true ? Colors.indigo : Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
                border: isDone == true ? null : Border.all(
                  color: Colors.black45,
                  width: 1.5
                )
              ),
              child: Image(
                image: AssetImage(
                  "assets/check_icon.png"
                ),
              ),
            ),
            Flexible(
              child: Text(
                text ?? "(Unspecified)",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DeleteUndoBar extends StatelessWidget {
  const DeleteUndoBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SnackBar(
        content: Text("Task Deleted"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {},
        ),
      ),
    );
  }
}

