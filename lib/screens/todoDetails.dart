import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/utils/appLang.dart';
import 'package:todo_app/utils/appLocals.dart';
import 'package:todo_app/utils/dbHelper.dart';
import 'package:intl/intl.dart' as intl;

DbHelper helper = DbHelper();

class TodoDetails extends StatefulWidget {
  final Todo todo;
  TodoDetails(this.todo);

  @override
  _TodoDetailsState createState() => _TodoDetailsState(todo);
}

class _TodoDetailsState extends State<TodoDetails> {
  Todo todo;
  _TodoDetailsState(this.todo);
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  FocusNode titleFocusNode;
  FocusNode descriptionFocusNode;
  Color borderColor = Colors.white38;

  @override
  void initState() {
    titleFocusNode = new FocusNode();
    descriptionFocusNode = new FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appLocale = AppLocalizations.of(context);
    var appLang = Provider.of<AppLanguage>(context);
    // ignore: unused_local_variable
    String _priority = appLocale.translateMore("todoPriority", "low");
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.subtitle1;
    final _priorities = [
      appLocale.translateMore("todoPriority", "high"),
      appLocale.translateMore("todoPriority", "medium"),
      appLocale.translateMore("todoPriority", "low"),
    ];

    void save() {
      todo.date = intl.DateFormat.yMd(
        appLang.appLocal.languageCode,
      ).add_jm().format(DateTime.now());
      if (todo.id != null) {
        helper.updateTodo(todo);
      } else {
        helper.insertTodo(todo);
      }
      Navigator.pop(context, true);
    }

    void updatePriority(String value) {
      if (value == appLocale.translateMore("todoPriority", "high")) {
        todo.priority = 1;
      } else if (value == appLocale.translateMore("todoPriority", "medium")) {
        todo.priority = 2;
      } else if (value == appLocale.translateMore("todoPriority", "low")) {
        todo.priority = 3;
      } else {
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
      } else {
        print("Can't be saved");
      }
    }

    TextDirection textDir() {
      if (appLang.appLocal == Locale("ar")) {
        return TextDirection.rtl;
      } else if (appLang.appLocal == Locale("en")) {
        return TextDirection.ltr;
      } else {
        return TextDirection.ltr;
      }
    }

    titleController.text = todo.title;
    descriptionController.text = todo.description;

    return GestureDetector(
      ///* To unfocus from any TextField when user click anywhere
      ///* outside the TextFields
      onTap: () {
        setState(() {
          borderColor = Colors.white38;
        });
        FocusScope.of(context).requestFocus(
          new FocusNode(),
        );
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          onPressed: () {
            save();
          },
          icon: Icon(Icons.save),
          label: Text(
            appLocale.translateMore("options", "save"),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: Text(todo.title),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        appLocale.translate("todoTitle"),
                        style: textStyle,
                      ),
                    ),
                    TextField(
                      textDirection: textDir(),
                      onChanged: (val) {
                        updateTitle();
                      },
                      controller: titleController,
                      focusNode: titleFocusNode,
                      style: textStyle,
                      onEditingComplete: () {
                        titleFocusNode.unfocus();
                        updateTitle();
                        descriptionFocusNode.requestFocus();
                      },
                      decoration: InputDecoration(
                        hintText: appLocale.translate("todoTitle"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        appLocale.translate("todoDescrip"),
                        style: textStyle,
                      ),
                    ),
                    TextField(
                      textDirection: textDir(),
                      onChanged: (val) {
                        updateDescription();
                      },
                      controller: descriptionController,
                      style: textStyle,
                      focusNode: descriptionFocusNode,
                      onEditingComplete: () {
                        updateDescription();
                        descriptionFocusNode.unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: appLocale.translate("todoDescrip"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          appLocale.translateMore(
                            "todoPriority",
                            "priorityTitle",
                          ),
                          style: textStyle,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: borderColor,
                          ),
                        ),
                        child: DropdownButton<String>(
                          underline: SizedBox(
                            width: 0.0,
                          ),
                          onTap: () {
                            setState(() {
                              borderColor = Colors.white;
                            });
                          },
                          items: _priorities.map(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                          style: textStyle,
                          value: retrievePriority(todo.priority),
                          onChanged: (value) {
                            updatePriority(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
