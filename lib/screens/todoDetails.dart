import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/utils/dbHelper.dart';
import 'package:intl/intl.dart';

DbHelper helper = DbHelper();
final List<String> choices = const <String>["Save Todo & Back", "Back to List"];

const menuSave = "Save Todo & Back";
const menuBack = "Back to List";

class TodoDetails extends StatefulWidget {
  final Todo todo;
  TodoDetails(this.todo);

  @override
  _TodoDetailsState createState() => _TodoDetailsState(todo);
}

class _TodoDetailsState extends State<TodoDetails> {
  Todo todo;
  _TodoDetailsState(this.todo);
  final _priorities = ["High", "Medium", "Low"];
  // ignore: unused_field
  String _priority = "Low";
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.headline6;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(todo.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: select,
            itemBuilder: (BuildContext context) {
              return choices.map(
                (String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                },
              ).toList();
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 35.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    this.updateTitle();
                  },
                  controller: titleController,
                  style: textStyle,
                  decoration: InputDecoration(
                    labelStyle: textStyle,
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    onChanged: (value) {
                      this.updateDescription();
                    },
                    controller: descriptionController,
                    style: textStyle,
                    decoration: InputDecoration(
                      labelStyle: textStyle,
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  title: DropdownButton<String>(
                    items: _priorities.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    style: textStyle,
                    value: retrievePriority(todo.priority),
                    onChanged: (value) {
                      updatePriority(value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void select(String value) async {
    switch (value) {
      case menuSave:
        save();
        break;
      case menuBack:
        Navigator.pop(context, true);
        break;
    }
  }

  void save() {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if (todo.id != null) {
      helper.updateTodo(todo);
    } else {
      helper.insertTodo(todo);
    }
    Navigator.pop(context, true);
  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;
      default:
        todo.priority = 3;
    }
    setState(() {
      _priority = value;
    });
  }

  String retrievePriority(int value) {
    return _priorities[value - 1];
  }

  void updateTitle() {
    String newTitle = titleController.text;
    if (newTitle != null && newTitle != "") {
      todo.title = newTitle;
    }
  }

  void updateDescription() {
    String newDescription = descriptionController.text;
    if (newDescription != null && newDescription != "") {
      todo.description = newDescription;
    }
  }
}
